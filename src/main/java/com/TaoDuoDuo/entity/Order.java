package com.TaoDuoDuo.entity;

import java.time.LocalDateTime;

public class Order {
    private int order_id;
    private int user_id;
    private int shop_id;
    private String order_status;
    private double order_amount;
    private LocalDateTime create_time;
    private LocalDateTime update_time;

    public Order() {
    }

    public Order(int user_id, int shop_id, String order_status, double order_amount, LocalDateTime create_time, LocalDateTime update_time) {
        this.user_id = user_id;
        this.shop_id = shop_id;
        this.order_status = order_status;
        this.order_amount = order_amount;
        this.create_time = create_time;
        this.update_time = update_time;
    }

    public Order(int user_id, int shop_id, String order_status, double order_amount) {
        this.user_id = user_id;
        this.shop_id = shop_id;
        this.order_status = order_status;
        this.order_amount = order_amount;
    }

    public Order(int order_id, int user_id, int shop_id, String order_status, double order_amount, LocalDateTime create_time, LocalDateTime update_time) {
        this.order_id = order_id;
        this.user_id = user_id;
        this.shop_id = shop_id;
        this.order_status = order_status;
        this.order_amount = order_amount;
        this.create_time = create_time;
        this.update_time = update_time;
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

    public double getOrder_amount() {
        return order_amount;
    }

    public void setOrder_amount(double order_amount) {
        this.order_amount = order_amount;
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
}
