package com.TaoDuoDuo.entity;

import java.time.LocalDateTime;

public class Order {
    private int order_id;
    private int user_id;
    private int shop_id;
    private String order_status;
    private double total_amount;
    private LocalDateTime create_time;
    private LocalDateTime update_time;
    private String alipay_order_no; // 支付宝订单号

    public Order() {
    }

    public Order(int user_id, int shop_id, String order_status, double total_amount, LocalDateTime create_time, LocalDateTime update_time) {
        this.user_id = user_id;
        this.shop_id = shop_id;
        this.order_status = order_status;
        this.total_amount = total_amount;
        this.create_time = create_time;
        this.update_time = update_time;
    }

    public Order(int user_id, int shop_id, String order_status, double total_amount) {
        this.user_id = user_id;
        this.shop_id = shop_id;
        this.order_status = order_status;
        this.total_amount = total_amount;
    }

    public Order(int order_id, int user_id, int shop_id, String order_status, double total_amount, LocalDateTime create_time, LocalDateTime update_time) {
        this.order_id = order_id;
        this.user_id = user_id;
        this.shop_id = shop_id;
        this.order_status = order_status;
        this.total_amount = total_amount;
        this.create_time = create_time;
        this.update_time = update_time;
    }

    // 新增构造函数，包含支付宝订单号
    public Order(int user_id, int shop_id, String order_status, double total_amount, String alipay_order_no) {
        this.user_id = user_id;
        this.shop_id = shop_id;
        this.order_status = order_status;
        this.total_amount = total_amount;
        this.alipay_order_no = alipay_order_no;
    }

    public Order(int order_id, int user_id, int shop_id, String order_status, double total_amount, 
                 LocalDateTime create_time, LocalDateTime update_time, String alipay_order_no) {
        this.order_id = order_id;
        this.user_id = user_id;
        this.shop_id = shop_id;
        this.order_status = order_status;
        this.total_amount = total_amount;
        this.create_time = create_time;
        this.update_time = update_time;
        this.alipay_order_no = alipay_order_no;
    }

    public int getOrder_id() {
        return order_id;
    }

    public void setOrder_id(int order_id) {
        this.order_id = order_id;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public int getShop_id() {
        return shop_id;
    }

    public void setShop_id(int shop_id) {
        this.shop_id = shop_id;
    }

    public String getOrder_status() {
        return order_status;
    }

    public void setOrder_status(String order_status) {
        this.order_status = order_status;
    }

    public double getTotal_amount() {
        return total_amount;
    }

    public void setTotal_amount(double total_amount) {
        this.total_amount = total_amount;
    }

    public LocalDateTime getCreate_time() {
        return create_time;
    }

    public void setCreate_time(LocalDateTime create_time) {
        this.create_time = create_time;
    }

    public LocalDateTime getUpdate_time() {
        return update_time;
    }

    public void setUpdate_time(LocalDateTime update_time) {
        this.update_time = update_time;
    }

    public String getAlipay_order_no() {
        return alipay_order_no;
    }

    public void setAlipay_order_no(String alipay_order_no) {
        this.alipay_order_no = alipay_order_no;
    }

    /**
     * 获取订单状态枚举
     * @return OrderStatus枚举，如果状态无效则返回null
     */
    public OrderStatus getOrderStatusEnum() {
        return OrderStatus.fromValue(this.order_status);
    }

    /**
     * 设置订单状态（使用枚举）
     * @param status OrderStatus枚举
     */
    public void setOrderStatus(OrderStatus status) {
        this.order_status = status != null ? status.getValue() : null;
    }

    /**
     * 检查订单是否可以转换到指定状态
     * @param targetStatus 目标状态
     * @return 如果可以转换返回true，否则返回false
     */
    public boolean canTransitionTo(OrderStatus targetStatus) {
        OrderStatus currentStatus = getOrderStatusEnum();
        return currentStatus != null && currentStatus.canTransitionTo(targetStatus);
    }

    /**
     * 检查订单是否可以取消
     * @return 如果可以取消返回true，否则返回false
     */
    public boolean canBeCancelled() {
        OrderStatus currentStatus = getOrderStatusEnum();
        return currentStatus != null && currentStatus.canBeCancelled();
    }

    /**
     * 检查订单是否可以评价
     * @return 如果可以评价返回true，否则返回false
     */
    public boolean canBeReviewed() {
        OrderStatus currentStatus = getOrderStatusEnum();
        return currentStatus != null && currentStatus.canBeReviewed();
    }
}
