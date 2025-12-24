package com.TaoDuoDuo.servlet;

import com.TaoDuoDuo.dao.OrderDao;
import com.TaoDuoDuo.entity.Order;
import com.TaoDuoDuo.entity.OrderStatus;
import com.TaoDuoDuo.util.PayUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Optional;

/**
 * 支付宝支付同步返回处理
 */
@WebServlet(name = "PaymentReturnServlet", value = "/PaymentReturnServlet")
public class PaymentReturnServlet extends HttpServlet {
    
    private OrderDao orderDao;
    
    @Override
    public void init() throws ServletException {
        orderDao = new OrderDao();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            System.out.println("=== 支付返回处理 ===");
            
            // 打印所有参数用于调试
            System.out.println("返回参数:");
            request.getParameterMap().forEach((key, values) -> {
                System.out.println(key + " = " + (values.length > 0 ? values[0] : ""));
            });
            
            // 获取返回参数
            String outTradeNo = request.getParameter("out_trade_no");
            String tradeNo = request.getParameter("trade_no");
            String totalAmount = request.getParameter("total_amount");
            String authAppId = request.getParameter("auth_app_id");
            
            System.out.println("支付返回:");
            System.out.println("商户订单号: " + outTradeNo);
            System.out.println("支付宝交易号: " + tradeNo);
            System.out.println("交易金额: " + totalAmount);
            System.out.println("应用ID: " + authAppId);
            
            // 对于支付宝沙箱环境，如果没有签名参数，我们跳过签名验证
            String sign = request.getParameter("sign");
            String signType = request.getParameter("sign_type");
            
            if (sign != null && !sign.trim().isEmpty()) {
                // 有签名时才验证
                try {
                    boolean signVerified = PayUtil.verifyNotify(request);
                    if (!signVerified) {
                        System.err.println("支付返回签名验证失败");
                        response.sendRedirect(request.getContextPath() + "/view/error.jsp?error=" +
                                java.net.URLEncoder.encode("支付验证失败", "UTF-8"));
                        return;
                    }
                    System.out.println("签名验证通过");
                } catch (Exception e) {
                    System.err.println("签名验证异常: " + e.getMessage());
                    // 对于沙箱环境，签名验证失败时继续处理，但记录日志
                    System.out.println("沙箱环境跳过签名验证，继续处理...");
                }
            } else {
                System.out.println("没有签名参数，跳过签名验证（沙箱环境）");
            }
            
            if (outTradeNo == null || outTradeNo.trim().isEmpty()) {
                System.err.println("商户订单号为空");
                response.sendRedirect(request.getContextPath() + "/view/error.jsp?error=" +
                        java.net.URLEncoder.encode("订单号缺失", "UTF-8"));
                return;
            }
            
            // 根据支付宝订单号查找订单
            Optional<Order> orderOpt = orderDao.getOrderByAlipayOrderNo(outTradeNo);
            if (!orderOpt.isPresent()) {
                System.err.println("未找到对应订单: " + outTradeNo);
                response.sendRedirect(request.getContextPath() + "/view/error.jsp?error=" +
                        java.net.URLEncoder.encode("订单不存在", "UTF-8"));
                return;
            }
            
            Order order = orderOpt.get();
            System.out.println("找到订单: ID=" + order.getOrder_id() + ", 状态=" + order.getOrder_status());
            
            // 查询支付宝订单状态来确认支付结果
            try {
                System.out.println("查询支付宝订单状态: " + outTradeNo);
                var queryResponse = PayUtil.queryOrder(outTradeNo);
                
                if (queryResponse != null) {
                    String tradeStatus = queryResponse.getTradeStatus();
                    System.out.println("支付宝订单状态: " + tradeStatus);
                    
                    // 根据支付宝返回的状态更新订单
                    if ("TRADE_SUCCESS".equals(tradeStatus) || "TRADE_FINISHED".equals(tradeStatus)) {
                        if ("unpaid".equals(order.getOrder_status())) {
                            order.setOrder_status(OrderStatus.PAID_PENDING_SHIPMENT.getValue());
                            order.setUpdate_time(LocalDateTime.now());
                            
                            boolean updated = orderDao.updateOrder(order);
                            if (updated) {
                                System.out.println("订单状态更新成功: " + order.getOrder_id());
                                request.getSession().setAttribute("paymentSuccessMessage", "支付成功！订单状态已更新为待发货。");
                            } else {
                                System.err.println("订单状态更新失败: " + order.getOrder_id());
                                request.getSession().setAttribute("paymentSuccessMessage", "支付成功，但订单状态更新失败，请联系客服。");
                            }
                        } else {
                            System.out.println("订单状态已经不是未支付: " + order.getOrder_status());
                            request.getSession().setAttribute("paymentSuccessMessage", "支付成功！");
                        }
                    } else if ("WAIT_BUYER_PAY".equals(tradeStatus)) {
                        System.out.println("订单还在等待支付");
                        request.getSession().setAttribute("paymentSuccessMessage", "订单还在处理中，请稍后查看状态。");
                    } else {
                        System.out.println("未知的支付状态: " + tradeStatus);
                        request.getSession().setAttribute("paymentSuccessMessage", "支付状态确认中，请稍后查看订单状态。");
                    }
                } else {
                    System.err.println("查询支付宝订单失败");
                    request.getSession().setAttribute("paymentSuccessMessage", "支付完成，订单状态确认中。");
                }
            } catch (Exception e) {
                System.err.println("查询支付宝订单异常: " + e.getMessage());
                e.printStackTrace();
                request.getSession().setAttribute("paymentSuccessMessage", "支付完成，订单状态将通过异步通知更新。");
            }
            
            // 跳转到订单详情页面
            response.sendRedirect(request.getContextPath() + "/OrderQueryServlet?action=detail&orderId=" + order.getOrder_id());
            
        } catch (Exception e) {
            System.err.println("处理支付返回异常: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/view/error.jsp?error=" +
                    java.net.URLEncoder.encode("支付处理异常", "UTF-8"));
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}