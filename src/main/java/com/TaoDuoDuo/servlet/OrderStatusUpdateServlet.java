package com.TaoDuoDuo.servlet;

import com.TaoDuoDuo.entity.OrderStatus;
import com.TaoDuoDuo.service.OrderManagementService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * 订单状态更新Servlet
 * 处理订单状态转换（发货、确认收货等）
 */
@WebServlet("/OrderStatusUpdateServlet")
public class OrderStatusUpdateServlet extends HttpServlet {
    
    private OrderManagementService orderService;
    
    @Override
    public void init() throws ServletException {
        orderService = new OrderManagementService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        Integer userRole = (Integer) session.getAttribute("role");
        
        // 检查用户是否登录
        if (userId == null || userRole == null) {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp");
            return;
        }
        
        String orderIdStr = request.getParameter("orderId");
        String statusStr = request.getParameter("status");
        
        if (orderIdStr == null || statusStr == null) {
            response.sendRedirect(request.getContextPath() + "/OrderQueryServlet?error=" +
                    java.net.URLEncoder.encode("参数错误", "UTF-8"));
            return;
        }
        
        try {
            int orderId = Integer.parseInt(orderIdStr);
            OrderStatus newStatus = OrderStatus.fromValue(statusStr);
            
            if (newStatus == null) {
                response.sendRedirect(request.getContextPath() + "/OrderQueryServlet?error=" +
                        java.net.URLEncoder.encode("无效的订单状态", "UTF-8"));
                return;
            }
            
            // 更新订单状态
            boolean success = orderService.updateOrderStatus(orderId, newStatus, userId, userRole);
            
            if (success) {
                String message = getStatusUpdateMessage(newStatus);
                response.sendRedirect(request.getContextPath() + "/OrderQueryServlet?message=" +
                        java.net.URLEncoder.encode(message, "UTF-8"));
            } else {
                response.sendRedirect(request.getContextPath() + "/OrderQueryServlet?error=" +
                        java.net.URLEncoder.encode("更新订单状态失败", "UTF-8"));
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/OrderQueryServlet?error=" +
                    java.net.URLEncoder.encode("订单ID格式错误", "UTF-8"));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/OrderQueryServlet?error=" +
                    java.net.URLEncoder.encode("操作失败：" + e.getMessage(), "UTF-8"));
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    /**
     * 获取状态更新成功消息
     */
    private String getStatusUpdateMessage(OrderStatus status) {
        switch (status) {
            case PAID_PENDING_SHIPMENT:
                return "支付成功，等待发货";
            case SHIPPED_PENDING_RECEIPT:
                return "已发货，等待收货";
            case COMPLETED:
                return "订单已完成";
            case CANCELLED:
                return "订单已取消";
            default:
                return "订单状态已更新";
        }
    }
}