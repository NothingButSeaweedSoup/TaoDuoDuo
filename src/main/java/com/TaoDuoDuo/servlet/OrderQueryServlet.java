package com.TaoDuoDuo.servlet;

import com.TaoDuoDuo.dao.OrderDao;
import com.TaoDuoDuo.dao.OrderDetailDao;
import com.TaoDuoDuo.entity.Order;
import com.TaoDuoDuo.entity.OrderDetail;
import com.TaoDuoDuo.entity.OrderStatus;
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
 * 订单查询Servlet
 * 处理用户、商家、管理员的订单查询请求
 */
@WebServlet("/OrderQueryServlet")
public class OrderQueryServlet extends HttpServlet {
    
    private OrderDao orderDao;
    private OrderDetailDao orderDetailDao;
    private ReviewService reviewService;
    
    @Override
    public void init() throws ServletException {
        orderDao = new OrderDao();
        orderDetailDao = new OrderDetailDao();
        reviewService = new ReviewService();
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
        
        try {
            String action = request.getParameter("action");
            String statusFilter = request.getParameter("status");
            
            if ("detail".equals(action)) {
                // 查看订单详情
                handleOrderDetail(request, response, userId, userRole);
            } else {
                // 查看订单列表
                handleOrderList(request, response, userId, userRole, statusFilter);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "查询订单时发生错误：" + e.getMessage());
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        }
    }
    
    /**
     * 处理订单列表查询
     */
    private void handleOrderList(HttpServletRequest request, HttpServletResponse response,
                                int userId, int userRole, String statusFilter) 
            throws ServletException, IOException {
        
        Optional<List<Order>> ordersOpt = Optional.empty();
        
        try {
            // 根据用户角色查询订单
            if (userRole == 1) { // 普通用户
                if (statusFilter != null && !statusFilter.isEmpty()) {
                    ordersOpt = orderDao.getOrderByUserId(userId, statusFilter);
                } else {
                    ordersOpt = orderDao.getOrderByUserId(userId);
                }
            } else if (userRole == 2) { // 商家
                // 商家需要查询他们拥有的所有店铺的订单
                // 这里简化处理，实际应该查询用户拥有的所有店铺ID
                if (statusFilter != null && !statusFilter.isEmpty()) {
                    ordersOpt = orderDao.getOrderByUserId(userId, statusFilter); // 临时实现
                } else {
                    ordersOpt = orderDao.getOrderByUserId(userId); // 临时实现
                }
            } else if (userRole == 3) { // 管理员
                // 管理员查看所有订单（这里需要扩展OrderDao）
                ordersOpt = orderDao.getOrderByUserId(userId); // 临时实现
            }
            
            if (ordersOpt.isPresent()) {
                List<Order> orders = ordersOpt.get();
                request.setAttribute("orders", orders);
                request.setAttribute("userRole", userRole);
                request.setAttribute("statusFilter", statusFilter);
                
                // 为每个订单添加状态显示名称
                for (Order order : orders) {
                    OrderStatus status = OrderStatus.fromValue(order.getOrder_status());
                    if (status != null) {
                        // 可以在JSP中使用
                    }
                }
            } else {
                request.setAttribute("orders", List.of());
                request.setAttribute("message", "暂无订单数据");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "查询订单列表失败：" + e.getMessage());
        }
        
        // 转发到订单列表页面
        request.getRequestDispatcher("/view/order-list.jsp").forward(request, response);
    }
    
    /**
     * 处理订单详情查询
     */
    private void handleOrderDetail(HttpServletRequest request, HttpServletResponse response,
                                  int userId, int userRole) 
            throws ServletException, IOException {
        
        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null || orderIdStr.isEmpty()) {
            request.setAttribute("error", "订单ID不能为空");
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
            return;
        }
        
        try {
            int orderId = Integer.parseInt(orderIdStr);
            
            // 查询订单信息
            Optional<Order> orderOpt = orderDao.getOrderById(orderId);
            if (!orderOpt.isPresent()) {
                request.setAttribute("error", "订单不存在");
                request.getRequestDispatcher("/view/error.jsp").forward(request, response);
                return;
            }
            
            Order order = orderOpt.get();
            
            // 权限检查：用户只能查看自己的订单，商家只能查看自己店铺的订单
            if (userRole == 1 && order.getUser_id() != userId) {
                request.setAttribute("error", "无权查看此订单");
                request.getRequestDispatcher("/view/error.jsp").forward(request, response);
                return;
            } else if (userRole == 2) {
                // 商家权限检查：这里简化处理，实际应该检查用户是否拥有该订单所属的店铺
                // 临时允许商家查看所有订单
            }
            
            // 查询订单详情
            Optional<List<OrderDetail>> detailsOpt = orderDetailDao.getOrderDetailsByOrderId(orderId);
            List<OrderDetail> orderDetails = detailsOpt.orElse(List.of());
            
            // 查询订单评价（如果存在）
            Optional<Review> reviewOpt = reviewService.getReviewByOrderId(orderId);
            
            request.setAttribute("order", order);
            request.setAttribute("orderDetails", orderDetails);
            request.setAttribute("userRole", userRole);
            
            // 如果有评价，设置到request中
            if (reviewOpt.isPresent()) {
                request.setAttribute("orderReview", reviewOpt.get());
            }
            
            // 转发到订单详情页面
            request.getRequestDispatcher("/view/order-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "订单ID格式错误");
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}