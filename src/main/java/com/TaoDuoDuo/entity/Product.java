package com.TaoDuoDuo.entity;

import java.time.LocalDateTime;

public class Product {
    private int product_id;
    private String product_name;
    private String description;
    private double price;
    private int stock;
    private int category_id;
    private int shop_id;
    private LocalDateTime create_time;
    private LocalDateTime update_time;

    public Product(String product_name, String description, double price, int stock, int category_id, int shop_id) {
        this.product_name = product_name;
        this.description = description;
        this.price = price;
        this.stock = stock;
        this.category_id = category_id;
        this.shop_id = shop_id;
    }

    public Product(String product_name, String description, double price, int stock, int category_id, int shop_id, LocalDateTime create_time, LocalDateTime update_time) {
        this.product_name = product_name;
        this.description = description;
        this.price = price;
        this.stock = stock;
        this.category_id = category_id;
        this.shop_id = shop_id;
        this.create_time = create_time;
        this.update_time = update_time;
    }

    public Product(int product_id, String product_name, String description, double price, int stock, int category_id, int shop_id, LocalDateTime create_time, LocalDateTime update_time) {
        this.product_id = product_id;
        this.product_name = product_name;
        this.description = description;
        this.price = price;
        this.stock = stock;
        this.category_id = category_id;
        this.shop_id = shop_id;
        this.create_time = create_time;
        this.update_time = update_time;
    }

    public Product() {
    }

    public int getProduct_id() {
        return product_id;
    }

    public void setProduct_id(int product_id) {
        this.product_id = product_id;
    }

    public String getProduct_name() {
        return product_name;
    }

    public void setProduct_name(String product_name) {
        this.product_name = product_name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public int getCategory_id() {
        return category_id;
    }

    public void setCategory_id(int category_id) {
        this.category_id = category_id;
    }

    public int getShop_id() {
        return shop_id;
    }

    public void setShop_id(int shop_id) {
        this.shop_id = shop_id;
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
