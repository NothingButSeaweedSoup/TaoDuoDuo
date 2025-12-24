package com.TaoDuoDuo.servlet;

import com.TaoDuoDuo.dao.OrderDao;
import com.TaoDuoDuo.entity.Order;
import com.TaoDuoDuo.entity.OrderStatus;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.util.Optional;

/**
 * 支付测试工具 - 用于手动更新订单状态（仅用于测试）
 */
@WebServlet(name = "PaymentTestServlet", value = "/PaymentTestServlet")
public class PaymentTestServlet extends HttpServlet {
    
    private OrderDao orderDao;
    
    @Override
    public void init() throws ServletException {
        orderDao = new OrderDao();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        String action = request.getParameter("action");
        String orderIdStr = request.getParameter("orderId");
        
        out.println("<html><head><title>支付测试工具</title></head><body>");
        out.println("<h2>支付测试工具</h2>");
        
        if ("updateStatus".equals(action) && orderIdStr != null) {
            try {
                int orderId = Integer.parseInt(orderIdStr);
                
                // 获取订单
                Optional<Order> orderOpt = orderDao.getOrderById(orderId);
                if (!orderOpt.isPresent()) {
                    out.println("<p style='color: red;'>订单不存在: " + orderId + "</p>");
                } else {
                    Order order = orderOpt.get();
                    
                    if ("unpaid".equals(order.getOrder_status())) {
                        // 更新订单状态为已支付
                        order.setOrder_status(OrderStatus.PAID_PENDING_SHIPMENT.getValue());
                        order.setUpdate_time(LocalDateTime.now());
                        
                        boolean updated = orderDao.updateOrder(order);
                        if (updated) {
                            out.println("<p style='color: green;'>订单 " + orderId + " 状态已更新为已支付待发货</p>");
                        } else {
                            out.println("<p style='color: red;'>更新订单状态失败</p>");
                        }
                    } else {
                        out.println("<p style='color: orange;'>订单状态已经不是未支付: " + order.getOrder_status() + "</p>");
                    }
                }
                
            } catch (NumberFormatException e) {
                out.println("<p style='color: red;'>订单ID格式错误</p>");
            }
        }
        
        // 显示表单
        out.println("<form method='get'>");
        out.println("<input type='hidden' name='action' value='updateStatus'>");
        out.println("<label>订单ID: <input type='number' name='orderId' required></label>");
        out.println("<button type='submit'>手动更新为已支付</button>");
        out.println("</form>");
        
        out.println("<hr>");
        out.println("<h3>最近的未支付订单:</h3>");
        
        try {
            // 显示一些未支付订单供参考
            Integer userId = (Integer) request.getSession().getAttribute("userId");
            if (userId != null) {
                var ordersOpt = orderDao.getOrderByUserId(userId, "unpaid");
                if (ordersOpt.isPresent() && !ordersOpt.get().isEmpty()) {
                    out.println("<ul>");
                    for (Order order : ordersOpt.get()) {
                        out.println("<li>订单ID: " + order.getOrder_id() + 
                                   ", 金额: ¥" + order.getTotal_amount() + 
                                   ", 支付宝订单号: " + order.getAlipay_order_no() + 
                                   " <a href='?action=updateStatus&orderId=" + order.getOrder_id() + "'>更新状态</a></li>");
                    }
                    out.println("</ul>");
                } else {
                    out.println("<p>没有未支付订单</p>");
                }
            } else {
                out.println("<p>请先登录</p>");
            }
        } catch (Exception e) {
            out.println("<p style='color: red;'>查询订单失败: " + e.getMessage() + "</p>");
        }
        
        out.println("<hr>");
        out.println("<p><a href='" + request.getContextPath() + "/OrderQueryServlet'>返回订单列表</a></p>");
        out.println("</body></html>");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}