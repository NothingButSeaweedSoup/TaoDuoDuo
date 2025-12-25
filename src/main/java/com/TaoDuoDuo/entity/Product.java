package com.TaoDuoDuo.entity;

import java.time.LocalDateTime;

/**
 * 商品实体类
 * 对应数据库中的product表
 */
public class Product {
    private int product_id; // 商品ID，主键
    private String product_name; // 商品名称
    private String description; // 商品描述
    private double price; // 商品价格
    private int stock; // 库存数量
    private int category_id; // 分类ID
    private int shop_id; // 店铺ID
    private boolean product_listing; // 是否上架
    private LocalDateTime create_time; // 创建时间
    private LocalDateTime update_time; // 更新时间

    // 创建商品用构造函数
    public Product(String product_name, String description, double price, int stock, int category_id, int shop_id) {
        this.product_name = product_name;
        this.description = description;
        this.price = price;
        this.stock = stock;
        this.category_id = category_id;
        this.shop_id = shop_id;
        this.product_listing = false; // 默认下架
    }

    // 创建商品用构造函数（包含时间）
    public Product(String product_name, String description, double price, int stock, int category_id, int shop_id,
            LocalDateTime create_time, LocalDateTime update_time) {
        this.product_name = product_name;
        this.description = description;
        this.price = price;
        this.stock = stock;
        this.category_id = category_id;
        this.shop_id = shop_id;
        this.product_listing = false; // 默认下架
        this.create_time = create_time;
        this.update_time = update_time;
    }

    // 完整构造函数
    public Product(int product_id, String product_name, String description, double price, int stock, int category_id,
            int shop_id, boolean product_listing, LocalDateTime create_time, LocalDateTime update_time) {
        this.product_id = product_id;
        this.product_name = product_name;
        this.description = description;
        this.price = price;
        this.stock = stock;
        this.category_id = category_id;
        this.shop_id = shop_id;
        this.product_listing = product_listing;
        this.create_time = create_time;
        this.update_time = update_time;
    }

    // 默认构造函数
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

    public boolean isProduct_listing() {
        return product_listing;
    }

    public void setProduct_listing(boolean product_listing) {
        this.product_listing = product_listing;
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
