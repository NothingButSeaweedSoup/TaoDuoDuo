package com.TaoDuoDuo.servlet;

import com.TaoDuoDuo.service.ReviewService;
import com.TaoDuoDuo.service.ReviewService.ReviewCreationResult;
import com.TaoDuoDuo.service.ReviewService.ReviewEligibilityResult;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * 评价创建Servlet
 * 处理评价表单显示和评价提交
 */
@WebServlet("/ReviewCreateServlet")
public class ReviewCreateServlet extends HttpServlet {
    
    private ReviewService reviewService;
    
    @Override
    public void init() throws ServletException {
        reviewService = new ReviewService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        // 检查用户登录状态
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp");
            return;
        }
        
        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "订单ID不能为空");
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
            return;
        }
        
        try {
            int orderId = Integer.parseInt(orderIdStr);
            
            // 检查评价资格
            ReviewEligibilityResult eligibilityResult = reviewService.checkReviewEligibility(orderId, userId);
            
            if (!eligibilityResult.isEligible()) {
                request.setAttribute("errorMessage", eligibilityResult.getMessage());
                request.getRequestDispatcher("/view/error.jsp").forward(request, response);
                return;
            }
            
            // 设置订单ID并转发到评价表单页面
            request.setAttribute("orderId", orderId);
            request.getRequestDispatcher("/view/review-form.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "订单ID格式错误");
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        // 检查用户登录状态
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp");
            return;
        }
        
        String orderIdStr = request.getParameter("orderId");
        String content = request.getParameter("content");
        String ratingStr = request.getParameter("rating");
        
        // 参数验证
        if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "订单ID不能为空");
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
            return;
        }
        
        if (content == null || content.trim().isEmpty()) {
            request.setAttribute("errorMessage", "评价内容不能为空");
            request.setAttribute("orderId", orderIdStr);
            request.getRequestDispatcher("/view/review-form.jsp").forward(request, response);
            return;
        }
        
        if (ratingStr == null || ratingStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "请选择评分");
            request.setAttribute("orderId", orderIdStr);
            request.setAttribute("content", content);
            request.getRequestDispatcher("/view/review-form.jsp").forward(request, response);
            return;
        }
        
        try {
            int orderId = Integer.parseInt(orderIdStr);
            int rating = Integer.parseInt(ratingStr);
            
            // 创建评价
            ReviewCreationResult result = reviewService.createReview(orderId, userId, content, rating);
            
            if (result.isSuccess()) {
                // 评价创建成功，重定向到订单详情页面并显示成功消息
                session.setAttribute("reviewSuccessMessage", "评价提交成功！");
                response.sendRedirect(request.getContextPath() + "/OrderQueryServlet?action=detail&orderId=" + orderId);
            } else {
                // 评价创建失败，返回表单页面并显示错误消息
                request.setAttribute("errorMessage", result.getMessage());
                request.setAttribute("orderId", orderId);
                request.setAttribute("content", content);
                request.setAttribute("rating", rating);
                request.getRequestDispatcher("/view/review-form.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "参数格式错误");
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        }
    }
}