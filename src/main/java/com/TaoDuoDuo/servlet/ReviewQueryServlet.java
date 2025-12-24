package com.TaoDuoDuo.servlet;

import com.TaoDuoDuo.entity.Review;
import com.TaoDuoDuo.service.ReviewService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

/**
 * 评价查询Servlet
 * 处理评价显示和查询
 */
@WebServlet("/ReviewQueryServlet")
public class ReviewQueryServlet extends HttpServlet {
    
    private ReviewService reviewService;
    
    @Override
    public void init() throws ServletException {
        reviewService = new ReviewService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("byOrder".equals(action)) {
            handleGetReviewByOrder(request, response);
        } else if ("byUser".equals(action)) {
            handleGetReviewsByUser(request, response);
        } else {
            request.setAttribute("errorMessage", "无效的操作");
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 根据订单ID获取评价
     */
    private void handleGetReviewByOrder(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "订单ID不能为空");
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
            return;
        }
        
        try {
            int orderId = Integer.parseInt(orderIdStr);
            Optional<Review> reviewOpt = reviewService.getReviewByOrderId(orderId);
            
            if (reviewOpt.isPresent()) {
                request.setAttribute("review", reviewOpt.get());
                request.setAttribute("orderId", orderId);
                request.getRequestDispatcher("/view/review-display.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "该订单暂无评价");
                request.getRequestDispatcher("/view/error.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "订单ID格式错误");
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 根据用户ID获取用户的所有评价
     */
    private void handleGetReviewsByUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        // 检查用户登录状态
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp");
            return;
        }
        
        Optional<List<Review>> reviewsOpt = reviewService.getReviewsByUserId(userId);
        
        if (reviewsOpt.isPresent()) {
            request.setAttribute("reviews", reviewsOpt.get());
            request.setAttribute("userId", userId);
            request.getRequestDispatcher("/view/user-reviews.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "获取评价列表失败");
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        }
    }
}