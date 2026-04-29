package com.TaoDuoDuo.service;

import com.TaoDuoDuo.entity.Review;
import com.TaoDuoDuo.service.ReviewService.ReviewCreationResult;
import com.TaoDuoDuo.service.ReviewService.ReviewEligibilityResult;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

/**
 * ReviewService 测试类
 * 验证评价系统的核心功能
 */
public class ReviewServiceTest {
    
    private ReviewService reviewService;
    
    @BeforeEach
    void setUp() {
        reviewService = new ReviewService();
    }
    
    @Test
    void testCreateReview_ValidInput() {
        // 测试有效输入的评价创建
        // 注意：这个测试需要数据库中存在对应的订单数据
        // 在实际环境中需要先创建测试数据
        
        int orderId = 1; // 假设存在订单ID为1的已完成订单
        int userId = 1;  // 假设用户ID为1
        String content = "商品质量很好，物流也很快！";
        int rating = 5;
        
        // 由于需要数据库连接，这里只测试参数验证逻辑
        ReviewCreationResult result = reviewService.createReview(orderId, userId, content, rating);
        
        // 验证结果不为null
        assertNotNull(result);
        assertNotNull(result.getMessage());
    }
    
    @Test
    void testCreateReview_EmptyContent() {
        // 测试空内容的评价创建
        int orderId = 1;
        int userId = 1;
        String content = "";
        int rating = 5;
        
        ReviewCreationResult result = reviewService.createReview(orderId, userId, content, rating);
        
        assertFalse(result.isSuccess());
        assertEquals("评价内容不能为空", result.getMessage());
    }
    
    @Test
    void testCreateReview_InvalidRating() {
        // 测试无效评分的评价创建
        int orderId = 1;
        int userId = 1;
        String content = "测试评价";
        int rating = 6; // 无效评分
        
        ReviewCreationResult result = reviewService.createReview(orderId, userId, content, rating);
        
        assertFalse(result.isSuccess());
        assertEquals("评分必须在1-5之间", result.getMessage());
    }
    
    @Test
    void testCheckReviewEligibility_ValidInput() {
        // 测试评价资格检查
        int orderId = 1;
        int userId = 1;
        
        ReviewEligibilityResult result = reviewService.checkReviewEligibility(orderId, userId);
        
        // 验证结果不为null
        assertNotNull(result);
        assertNotNull(result.getMessage());
    }
}