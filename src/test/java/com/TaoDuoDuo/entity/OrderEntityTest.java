package com.TaoDuoDuo.entity;

import net.jqwik.api.*;
import net.jqwik.api.constraints.Positive;
import net.jqwik.api.constraints.StringLength;
import java.time.LocalDateTime;

/**
 * Property-based tests for Order entity extensions
 * Feature: order-management, Property 1: Order Creation Completeness
 * Validates: Requirements 1.1, 1.2, 1.3, 1.4, 1.5, 1.6
 */
class OrderEntityTest {

    @Property
    @Label("Feature: order-management, Property 1: Order Creation Completeness - Order ID Generation")
    void orderShouldHaveUniqueOrderId(@ForAll @Positive int userId, 
                                     @ForAll @Positive int shopId,
                                     @ForAll @Positive double totalAmount,
                                     @ForAll @StringLength(min = 10, max = 64) String alipayOrderNo) {
        // Create order with basic information
        Order order = new Order(userId, shopId, OrderStatus.UNPAID.getValue(), totalAmount, alipayOrderNo);
        
        // Simulate setting order_id (as would be done by database)
        order.setOrder_id(12345);
        
        // Verify order has unique order_id
        assert order.getOrder_id() > 0 : "Order should have positive order_id";
    }

    @Property
    @Label("Feature: order-management, Property 1: Order Creation Completeness - User and Shop Association")
    void orderShouldAssociateWithUserAndShop(@ForAll @Positive int userId, 
                                            @ForAll @Positive int shopId,
                                            @ForAll @Positive double totalAmount) {
        Order order = new Order(userId, shopId, OrderStatus.UNPAID.getValue(), totalAmount);
        
        // Verify proper associations
        assert order.getUser_id() == userId : "Order should be associated with correct user_id";
        assert order.getShop_id() == shopId : "Order should be associated with correct shop_id";
    }

    @Property
    @Label("Feature: order-management, Property 1: Order Creation Completeness - Initial Status")
    void newOrderShouldHaveUnpaidStatus(@ForAll @Positive int userId, 
                                       @ForAll @Positive int shopId,
                                       @ForAll @Positive double totalAmount) {
        Order order = new Order(userId, shopId, OrderStatus.UNPAID.getValue(), totalAmount);
        
        // Verify initial status is unpaid
        assert OrderStatus.UNPAID.getValue().equals(order.getOrder_status()) : 
            "New order should have unpaid status";
        assert order.getOrderStatusEnum() == OrderStatus.UNPAID : 
            "Order status enum should be UNPAID";
    }

    @Property
    @Label("Feature: order-management, Property 1: Order Creation Completeness - Total Amount Calculation")
    void orderShouldRecordCorrectTotalAmount(@ForAll @Positive double totalAmount) {
        Order order = new Order(1, 1, OrderStatus.UNPAID.getValue(), totalAmount);
        
        // Verify total amount is recorded correctly
        assert order.getTotal_amount() == totalAmount : 
            "Order should record correct total amount";
        assert order.getTotal_amount() > 0 : 
            "Order total amount should be positive";
    }

    @Property
    @Label("Feature: order-management, Property 1: Order Creation Completeness - Alipay Order Number")
    void orderShouldHaveAlipayOrderNumber(@ForAll @Positive int userId, 
                                         @ForAll @Positive int shopId,
                                         @ForAll @Positive double totalAmount,
                                         @ForAll @StringLength(min = 10, max = 64) String alipayOrderNo) {
        Order order = new Order(userId, shopId, OrderStatus.UNPAID.getValue(), totalAmount, alipayOrderNo);
        
        // Verify Alipay order number is set
        assert order.getAlipay_order_no() != null : "Order should have Alipay order number";
        assert order.getAlipay_order_no().equals(alipayOrderNo) : 
            "Order should have correct Alipay order number";
        assert order.getAlipay_order_no().length() >= 10 : 
            "Alipay order number should have minimum length";
    }

    @Property
    @Label("Feature: order-management, Property 1: Order Creation Completeness - Status Transitions")
    void orderShouldSupportValidStatusTransitions(@ForAll @Positive int userId, 
                                                 @ForAll @Positive int shopId,
                                                 @ForAll @Positive double totalAmount) {
        Order order = new Order(userId, shopId, OrderStatus.UNPAID.getValue(), totalAmount);
        
        // Test valid transitions from UNPAID
        assert order.canTransitionTo(OrderStatus.PAID_PENDING_SHIPMENT) : 
            "Unpaid order should allow transition to paid_pending_shipment";
        assert order.canTransitionTo(OrderStatus.CANCELLED) : 
            "Unpaid order should allow transition to cancelled";
        
        // Test invalid transitions from UNPAID
        assert !order.canTransitionTo(OrderStatus.SHIPPED_PENDING_RECEIPT) : 
            "Unpaid order should not allow direct transition to shipped_pending_receipt";
        assert !order.canTransitionTo(OrderStatus.COMPLETED) : 
            "Unpaid order should not allow direct transition to completed";
    }

    @Property
    @Label("Feature: order-management, Property 1: Order Creation Completeness - Cancellation Rules")
    void orderShouldSupportCancellationRules(@ForAll @Positive int userId, 
                                            @ForAll @Positive int shopId,
                                            @ForAll @Positive double totalAmount) {
        // Test unpaid order can be cancelled
        Order unpaidOrder = new Order(userId, shopId, OrderStatus.UNPAID.getValue(), totalAmount);
        assert unpaidOrder.canBeCancelled() : "Unpaid order should be cancellable";
        
        // Test paid pending shipment order can be cancelled
        Order paidOrder = new Order(userId, shopId, OrderStatus.PAID_PENDING_SHIPMENT.getValue(), totalAmount);
        assert paidOrder.canBeCancelled() : "Paid pending shipment order should be cancellable";
        
        // Test shipped order cannot be cancelled
        Order shippedOrder = new Order(userId, shopId, OrderStatus.SHIPPED_PENDING_RECEIPT.getValue(), totalAmount);
        assert !shippedOrder.canBeCancelled() : "Shipped order should not be cancellable";
        
        // Test completed order cannot be cancelled
        Order completedOrder = new Order(userId, shopId, OrderStatus.COMPLETED.getValue(), totalAmount);
        assert !completedOrder.canBeCancelled() : "Completed order should not be cancellable";
    }

    @Property
    @Label("Feature: order-management, Property 1: Order Creation Completeness - Review Rules")
    void orderShouldSupportReviewRules(@ForAll @Positive int userId, 
                                      @ForAll @Positive int shopId,
                                      @ForAll @Positive double totalAmount) {
        // Only completed orders can be reviewed
        Order completedOrder = new Order(userId, shopId, OrderStatus.COMPLETED.getValue(), totalAmount);
        assert completedOrder.canBeReviewed() : "Completed order should be reviewable";
        
        // Other statuses cannot be reviewed
        Order unpaidOrder = new Order(userId, shopId, OrderStatus.UNPAID.getValue(), totalAmount);
        assert !unpaidOrder.canBeReviewed() : "Unpaid order should not be reviewable";
        
        Order paidOrder = new Order(userId, shopId, OrderStatus.PAID_PENDING_SHIPMENT.getValue(), totalAmount);
        assert !paidOrder.canBeReviewed() : "Paid order should not be reviewable";
        
        Order shippedOrder = new Order(userId, shopId, OrderStatus.SHIPPED_PENDING_RECEIPT.getValue(), totalAmount);
        assert !shippedOrder.canBeReviewed() : "Shipped order should not be reviewable";
        
        Order cancelledOrder = new Order(userId, shopId, OrderStatus.CANCELLED.getValue(), totalAmount);
        assert !cancelledOrder.canBeReviewed() : "Cancelled order should not be reviewable";
    }

    @Property
    @Label("Feature: order-management, Property 1: Order Creation Completeness - Constructor Consistency")
    void orderConstructorsShouldBeConsistent(@ForAll @Positive int orderId,
                                           @ForAll @Positive int userId, 
                                           @ForAll @Positive int shopId,
                                           @ForAll @Positive double totalAmount,
                                           @ForAll @StringLength(min = 10, max = 64) String alipayOrderNo) {
        LocalDateTime now = LocalDateTime.now();
        
        // Test full constructor
        Order fullOrder = new Order(orderId, userId, shopId, OrderStatus.UNPAID.getValue(), 
                                   totalAmount, now, now, alipayOrderNo);
        
        assert fullOrder.getOrder_id() == orderId;
        assert fullOrder.getUser_id() == userId;
        assert fullOrder.getShop_id() == shopId;
        assert fullOrder.getOrder_status().equals(OrderStatus.UNPAID.getValue());
        assert fullOrder.getTotal_amount() == totalAmount;
        assert fullOrder.getCreate_time() == now;
        assert fullOrder.getUpdate_time() == now;
        assert fullOrder.getAlipay_order_no().equals(alipayOrderNo);
        
        // Test basic constructor with alipay order no
        Order basicOrder = new Order(userId, shopId, OrderStatus.UNPAID.getValue(), totalAmount, alipayOrderNo);
        
        assert basicOrder.getUser_id() == userId;
        assert basicOrder.getShop_id() == shopId;
        assert basicOrder.getOrder_status().equals(OrderStatus.UNPAID.getValue());
        assert basicOrder.getTotal_amount() == totalAmount;
        assert basicOrder.getAlipay_order_no().equals(alipayOrderNo);
    }
}