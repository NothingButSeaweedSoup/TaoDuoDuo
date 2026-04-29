package com.TaoDuoDuo.servlet;

import com.TaoDuoDuo.service.OrderManagementService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * 订单取消Servlet
 * 处理订单取消请求
 */
@WebServlet("/OrderCancelServlet")
public class OrderCancelServlet extends HttpServlet {
    
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
        
        if (orderIdStr == null || orderIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/OrderQueryServlet?error=" +
                    java.net.URLEncoder.encode("订单ID不能为空", "UTF-8"));
            return;
        }
        
        try {
            int orderId = Integer.parseInt(orderIdStr);
            
            // 取消订单
            boolean success = orderService.cancelOrder(orderId, userId, userRole);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/OrderQueryServlet?message=" +
                        java.net.URLEncoder.encode("订单已成功取消", "UTF-8"));
            } else {
                response.sendRedirect(request.getContextPath() + "/OrderQueryServlet?error=" +
                        java.net.URLEncoder.encode("取消订单失败", "UTF-8"));
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/OrderQueryServlet?error=" +
                    java.net.URLEncoder.encode("订单ID格式错误", "UTF-8"));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/OrderQueryServlet?error=" +
                    java.net.URLEncoder.encode("取消订单失败：" + e.getMessage(), "UTF-8"));
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}