package com.TaoDuoDuo.service;

import com.TaoDuoDuo.dao.OrderDao;
import com.TaoDuoDuo.dao.ReviewDao;
import com.TaoDuoDuo.dao.OrderDetailDao;
import com.TaoDuoDuo.entity.Order;
import com.TaoDuoDuo.entity.Review;
import com.TaoDuoDuo.entity.OrderDetail;
import com.TaoDuoDuo.entity.OrderStatus;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * 评价服务类
 * 处理评价创建、查询等核心业务逻辑
 */
public class ReviewService {
    
    private ReviewDao reviewDao;
    private OrderDao orderDao;
    private OrderDetailDao orderDetailDao;
    
    public ReviewService() {
        this.reviewDao = new ReviewDao();
        this.orderDao = new OrderDao();
        this.orderDetailDao = new OrderDetailDao();
    }
    
    /**
     * 创建评价
     * @param orderId 订单ID
     * @param userId 用户ID
     * @param content 评价内容
     * @param rating 评分 (1-5)
     * @return 创建结果
     */
    public ReviewCreationResult createReview(int orderId, int userId, String content, int rating) {
        try {
            // 1. 验证参数
            if (content == null || content.trim().isEmpty()) {
                return new ReviewCreationResult(false, "评价内容不能为空");
            }
            
            if (rating < 1 || rating > 5) {
                return new ReviewCreationResult(false, "评分必须在1-5之间");
            }
            
            // 2. 验证订单存在
            Optional<Order> orderOpt = orderDao.getOrderById(orderId);
            if (!orderOpt.isPresent()) {
                return new ReviewCreationResult(false, "订单不存在");
            }
            
            Order order = orderOpt.get();
            
            // 3. 验证订单所有权
            if (order.getUser_id() != userId) {
                return new ReviewCreationResult(false, "无权限评价此订单");
            }
            
            // 4. 验证订单状态（只有已完成的订单才能评价）
            if (!OrderStatus.COMPLETED.getValue().equals(order.getOrder_status())) {
                return new ReviewCreationResult(false, "只有已完成的订单才能评价");
            }
            
            // 5. 检查是否已经评价过
            Optional<Review> existingReview = reviewDao.getReviewByOrderId(orderId);
            if (existingReview.isPresent()) {
                return new ReviewCreationResult(false, "该订单已经评价过了");
            }
            
            // 6. 创建评价
            Review review = new Review(orderId, userId, content.trim(), rating);
            review.setCreate_time(LocalDateTime.now());
            
            boolean created = reviewDao.addReview(review);
            if (created) {
                return new ReviewCreationResult(true, "评价创建成功", review);
            } else {
                return new ReviewCreationResult(false, "评价创建失败");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            return new ReviewCreationResult(false, "评价创建异常：" + e.getMessage());
        }
    }
    
    /**
     * 根据订单ID获取评价
     * @param orderId 订单ID
     * @return 评价信息
     */
    public Optional<Review> getReviewByOrderId(int orderId) {
        return reviewDao.getReviewByOrderId(orderId);
    }
    
    /**
     * 根据用户ID获取用户的所有评价
     * @param userId 用户ID
     * @return 评价列表
     */
    public Optional<List<Review>> getReviewsByUserId(int userId) {
        return reviewDao.getReviewsByUserId(userId);
    }
    
    /**
     * 根据商品ID获取商品的所有评价
     * 需要通过订单详情表关联查询
     * @param productId 商品ID
     * @return 评价列表
     */
    public Optional<List<ReviewWithOrderInfo>> getReviewsByProductId(int productId) {
        try {
            // 这里需要扩展 ReviewDao 来支持按商品查询
            // 暂时返回空，后续可以扩展
            return Optional.empty();
        } catch (Exception e) {
            e.printStackTrace();
            return Optional.empty();
        }
    }
    
    /**
     * 检查订单是否可以评价
     * @param orderId 订单ID
     * @param userId 用户ID
     * @return 检查结果
     */
    public ReviewEligibilityResult checkReviewEligibility(int orderId, int userId) {
        try {
            // 1. 验证订单存在
            Optional<Order> orderOpt = orderDao.getOrderById(orderId);
            if (!orderOpt.isPresent()) {
                return new ReviewEligibilityResult(false, "订单不存在");
            }
            
            Order order = orderOpt.get();
            
            // 2. 验证订单所有权
            if (order.getUser_id() != userId) {
                return new ReviewEligibilityResult(false, "无权限评价此订单");
            }
            
            // 3. 验证订单状态
            if (!OrderStatus.COMPLETED.getValue().equals(order.getOrder_status())) {
                return new ReviewEligibilityResult(false, "只有已完成的订单才能评价");
            }
            
            // 4. 检查是否已经评价过
            Optional<Review> existingReview = reviewDao.getReviewByOrderId(orderId);
            if (existingReview.isPresent()) {
                return new ReviewEligibilityResult(false, "该订单已经评价过了");
            }
            
            return new ReviewEligibilityResult(true, "可以评价");
            
        } catch (Exception e) {
            e.printStackTrace();
            return new ReviewEligibilityResult(false, "检查评价资格异常：" + e.getMessage());
        }
    }
    
    /**
     * 评价创建结果类
     */
    public static class ReviewCreationResult {
        private final boolean success;
        private final String message;
        private final Review review;
        
        public ReviewCreationResult(boolean success, String message) {
            this(success, message, null);
        }
        
        public ReviewCreationResult(boolean success, String message, Review review) {
            this.success = success;
            this.message = message;
            this.review = review;
        }
        
        public boolean isSuccess() {
            return success;
        }
        
        public String getMessage() {
            return message;
        }
        
        public Review getReview() {
            return review;
        }
    }
    
    /**
     * 评价资格检查结果类
     */
    public static class ReviewEligibilityResult {
        private final boolean eligible;
        private final String message;
        
        public ReviewEligibilityResult(boolean eligible, String message) {
            this.eligible = eligible;
            this.message = message;
        }
        
        public boolean isEligible() {
            return eligible;
        }
        
        public String getMessage() {
            return message;
        }
    }
    
    /**
     * 带订单信息的评价类（用于商品评价查询）
     */
    public static class ReviewWithOrderInfo {
        private final Review review;
        private final Order order;
        
        public ReviewWithOrderInfo(Review review, Order order) {
            this.review = review;
            this.order = order;
        }
        
        public Review getReview() {
            return review;
        }
        
        public Order getOrder() {
            return order;
        }
    }
}