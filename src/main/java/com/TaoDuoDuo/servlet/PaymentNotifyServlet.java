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
import java.util.Optional;

/**
 * 支付宝支付异步通知处理
 */
@WebServlet(name = "PaymentNotifyServlet", value = "/PaymentNotifyServlet")
public class PaymentNotifyServlet extends HttpServlet {

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

        response.setContentType("text/plain;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            System.out.println("=== 收到支付回调通知 ===");

            // 打印所有参数用于调试
            System.out.println("回调参数:");
            request.getParameterMap().forEach((key, values) -> {
                System.out.println(key + " = " + (values.length > 0 ? values[0] : ""));
            });

            // 验证签名
            boolean signVerified = false;
            try {
                signVerified = PayUtil.verifyNotify(request);
                System.out.println("签名验证结果: " + signVerified);
            } catch (Exception e) {
                System.err.println("签名验证异常: " + e.getMessage());
                e.printStackTrace();
            }

            if (!signVerified) {
                System.err.println("支付通知签名验证失败");
                out.print("failure");
                return;
            }

            // 获取通知参数
            String tradeStatus = request.getParameter("trade_status");
            String outTradeNo = request.getParameter("out_trade_no");
            String tradeNo = request.getParameter("trade_no");
            String totalAmount = request.getParameter("total_amount");

            System.out.println("收到支付通知:");
            System.out.println("交易状态: " + tradeStatus);
            System.out.println("商户订单号: " + outTradeNo);
            System.out.println("支付宝交易号: " + tradeNo);
            System.out.println("交易金额: " + totalAmount);

            if (outTradeNo == null || outTradeNo.trim().isEmpty()) {
                System.err.println("商户订单号为空");
                out.print("failure");
                return;
            }

            // 根据支付宝订单号查找订单
            Optional<Order> orderOpt = orderDao.getOrderByAlipayOrderNo(outTradeNo);
            if (!orderOpt.isPresent()) {
                System.err.println("未找到对应订单: " + outTradeNo);
                out.print("failure");
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
                        out.print("failure");
                        return;
                    }
                } catch (NumberFormatException e) {
                    System.err.println("金额格式错误: " + totalAmount);
                }
            }

            // 根据交易状态更新订单
            boolean updated = false;
            if ("TRADE_SUCCESS".equals(tradeStatus) || "TRADE_FINISHED".equals(tradeStatus)) {
                // 支付成功，更新订单状态为已支付待发货
                if ("unpaid".equals(order.getOrder_status())) {
                    // 使用新的更新方法，直接通过支付宝订单号更新状态
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

                        // 订单取消后恢复库存（如果之前已扣除）
                        StockService.StockProcessResult stockResult = stockService
                                .processOrderCancel(order.getOrder_id());
                        if (stockResult.isSuccess()) {
                            System.out.println("库存恢复成功，订单ID: " + order.getOrder_id());
                        } else {
                            System.err.println("库存恢复失败，订单ID: " + order.getOrder_id() +
                                    ", 原因: " + stockResult.getMessage());
                        }
                    } else {
                        System.err.println("取消订单失败，订单ID: " + order.getOrder_id());
                        // 尝试使用订单ID更新
                        updated = orderDao.updateOrderStatus(order.getOrder_id(), OrderStatus.CANCELLED.getValue());
                        if (updated) {
                            // 订单取消成功后恢复库存
                            StockService.StockProcessResult stockResult = stockService
                                    .processOrderCancel(order.getOrder_id());
                            if (stockResult.isSuccess()) {
                                System.out.println("库存恢复成功，订单ID: " + order.getOrder_id());
                            } else {
                                System.err.println("库存恢复失败，订单ID: " + order.getOrder_id() +
                                        ", 原因: " + stockResult.getMessage());
                            }
                        }
                    }
                } else {
                    updated = true; // 认为处理成功
                }
            } else {
                System.out.println("未处理的交易状态: " + tradeStatus + ", 订单ID: " + order.getOrder_id());
                updated = true; // 认为处理成功，避免重复通知
            }

            if (updated) {
                out.print("success");
                System.out.println("回调处理成功");
            } else {
                out.print("failure");
                System.out.println("回调处理失败");
            }

        } catch (Exception e) {
            System.err.println("处理支付通知异常: " + e.getMessage());
            e.printStackTrace();
            out.print("failure");
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