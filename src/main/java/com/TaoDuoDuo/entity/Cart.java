package com.TaoDuoDuo.entity;

import java.time.LocalDateTime;

public class Cart {
    private int cart_id;
    private int user_id;
    private int product_id;
    private int quantity;
    private LocalDateTime add_time;

    public Cart() {
    }

    public Cart(int user_id, int product_id, int quantity) {
        this.user_id = user_id;
        this.product_id = product_id;
        this.quantity = quantity;
    }

    public Cart(int user_id, int product_id, LocalDateTime add_time, int quantity) {
        this.user_id = user_id;
        this.product_id = product_id;
        this.add_time = add_time;
        this.quantity = quantity;
    }

    public Cart(int cart_id, int user_id, int product_id, int quantity, LocalDateTime add_time) {
        this.user_id = user_id;
        this.product_id = product_id;
        this.quantity = quantity;
        this.cart_id = cart_id;
        this.add_time = add_time;
    }

    public int getCart_id() {
        return cart_id;
    }

    public void setCart_id(int cart_id) {
        this.cart_id = cart_id;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public int getProduct_id() {
        return product_id;
    }

    public void setProduct_id(int product_id) {
        this.product_id = product_id;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public LocalDateTime getAdd_time() {
        return add_time;
    }

    public void setAdd_time(LocalDateTime add_time) {
        this.add_time = add_time;
    }
}
