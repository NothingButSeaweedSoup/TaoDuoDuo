package com.TaoDuoDuo.servlet;

import com.TaoDuoDuo.dao.OrderDao;
import com.TaoDuoDuo.entity.Order;
import com.TaoDuoDuo.entity.OrderStatus;
import com.TaoDuoDuo.service.StockService;
import com.TaoDuoDuo.util.PayUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

/**
 * 异步通知Servlet - 处理支付宝支付结果通知
 */
@WebServlet("/notify")
public class NotifyServlet extends HttpServlet {

    private OrderDao orderDao;
    private StockService stockService;

    @Override
    public void init() throws ServletException {
        orderDao = new OrderDao();
        stockService = new StockService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain;charset=UTF-8");

        PrintWriter out = response.getWriter();

        try {
            System.out.println("=== NotifyServlet 收到支付回调通知 ===");

            // 打印所有参数用于调试
            System.out.println("回调参数:");
            request.getParameterMap().forEach((key, values) -> {
                System.out.println(key + " = " + (values.length > 0 ? values[0] : ""));
            });

            // 验证签名
            boolean verifyResult = false;
            try {
                verifyResult = PayUtil.verifyNotify(request);
                System.out.println("签名验证结果: " + verifyResult);
            } catch (Exception e) {
                System.err.println("签名验证异常: " + e.getMessage());
                e.printStackTrace();
            }

            if (!verifyResult) {
                System.err.println("异步通知签名验证失败");
                out.println("fail");
                return;
            }

            // 获取通知参数
            Map<String, String> params = new HashMap<>();
            request.getParameterMap().forEach((key, values) -> {
                if (values != null && values.length > 0) {
                    params.put(key, values[0]);
                }
            });

            // 获取交易状态
            String tradeStatus = params.get("trade_status");
            String outTradeNo = params.get("out_trade_no");
            String tradeNo = params.get("trade_no");
            String totalAmount = params.get("total_amount");

            System.out.println("收到异步通知:");
            System.out.println("交易状态: " + tradeStatus);
            System.out.println("商户订单号: " + outTradeNo);
            System.out.println("支付宝交易号: " + tradeNo);
            System.out.println("交易金额: " + totalAmount);

            if (outTradeNo == null || outTradeNo.trim().isEmpty()) {
                System.err.println("商户订单号为空");
                out.println("fail");
                return;
            }

            // 根据支付宝订单号查找订单
            Optional<Order> orderOpt = orderDao.getOrderByAlipayOrderNo(outTradeNo);
            if (!orderOpt.isPresent()) {
                System.err.println("未找到对应订单: " + outTradeNo);
                out.println("fail");
                return;
            }

            Order order = orderOpt.get();
            System.out.println("找到订单: ID=" + order.getOrder_id() + ", 当前状态=" + order.getOrder_status());

            // 验证金额是否一致
            if (totalAmount != null && !totalAmount.trim().isEmpty()) {
                try {
                    double orderAmount = order.getTotal_amount();
                    double notifyAmount = Double.parseDouble(totalAmount);
                    if (Math.abs(orderAmount - notifyAmount) > 0.01) {
                        System.err.println("订单金额不匹配: 订单=" + orderAmount + ", 通知=" + notifyAmount);
                        out.println("fail");
                        return;
                    }
                } catch (NumberFormatException e) {
                    System.err.println("金额格式错误: " + totalAmount);
                }
            }

            // 处理业务逻辑
            boolean updated = false;
            if ("TRADE_SUCCESS".equals(tradeStatus) || "TRADE_FINISHED".equals(tradeStatus)) {
                // 支付成功，更新订单状态为已支付待发货
                if ("unpaid".equals(order.getOrder_status())) {
                    updated = orderDao.updateOrderStatusByAlipayOrderNo(outTradeNo,
                            OrderStatus.PAID_PENDING_SHIPMENT.getValue());

                    if (updated) {
                        System.out.println("订单支付成功，状态已更新为: " + OrderStatus.PAID_PENDING_SHIPMENT.getValue() +
                                ", 订单ID: " + order.getOrder_id());

                        // 支付成功后扣除库存
                        StockService.StockProcessResult stockResult = stockService
                                .processPaymentSuccess(order.getOrder_id());
                        if (stockResult.isSuccess()) {
                            System.out.println("库存扣除成功，订单ID: " + order.getOrder_id());
                        } else {
                            System.err.println("库存扣除失败，订单ID: " + order.getOrder_id() +
                                    ", 原因: " + stockResult.getMessage());
                            // 注意：库存扣除失败不影响支付回调的成功响应
                            // 可以通过后台任务或人工处理来解决库存问题
                        }
                    } else {
                        System.err.println("更新订单状态失败，订单ID: " + order.getOrder_id() +
                                ", 支付宝订单号: " + outTradeNo);
                        // 尝试使用订单ID更新
                        updated = orderDao.updateOrderStatus(order.getOrder_id(),
                                OrderStatus.PAID_PENDING_SHIPMENT.getValue());
                        if (updated) {
                            System.out.println("使用订单ID更新成功");

                            // 状态更新成功后扣除库存
                            StockService.StockProcessResult stockResult = stockService
                                    .processPaymentSuccess(order.getOrder_id());
                            if (stockResult.isSuccess()) {
                                System.out.println("库存扣除成功，订单ID: " + order.getOrder_id());
                            } else {
                                System.err.println("库存扣除失败，订单ID: " + order.getOrder_id() +
                                        ", 原因: " + stockResult.getMessage());
                            }
                        } else {
                            System.err.println("使用订单ID更新也失败");
                        }
                    }
                } else {
                    System.out.println("订单状态已经不是未支付，当前状态: " + order.getOrder_status() + ", 跳过更新");
                    updated = true; // 认为处理成功
                }
            } else if ("TRADE_CLOSED".equals(tradeStatus)) {
                // 交易关闭，可能需要取消订单
                if ("unpaid".equals(order.getOrder_status())) {
                    updated = orderDao.updateOrderStatusByAlipayOrderNo(outTradeNo, OrderStatus.CANCELLED.getValue());

                    if (updated) {
                        System.out.println("订单已取消，订单ID: " + order.getOrder_id());
                    } else {
                        System.err.println("取消订单失败，订单ID: " + order.getOrder_id());
                        // 尝试使用订单ID更新
                        updated = orderDao.updateOrderStatus(order.getOrder_id(), OrderStatus.CANCELLED.getValue());
                    }
                } else {
                    updated = true; // 认为处理成功
                }
            } else {
                System.out.println("未处理的交易状态: " + tradeStatus + ", 订单ID: " + order.getOrder_id());
                updated = true; // 认为处理成功，避免重复通知
            }

            if (updated) {
                out.println("success");
                System.out.println("NotifyServlet 回调处理成功");
            } else {
                out.println("fail");
                System.out.println("NotifyServlet 回调处理失败");
            }

        } catch (Exception e) {
            System.err.println("NotifyServlet 处理异步通知异常: " + e.getMessage());
            e.printStackTrace();
            out.println("fail");
        } finally {
            out.flush();
            out.close();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 支付宝异步通知使用POST方法，GET方法不处理
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "只支持POST方法");
    }
}
