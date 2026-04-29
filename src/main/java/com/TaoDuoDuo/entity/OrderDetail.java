package com.TaoDuoDuo.entity;

public class OrderDetail {
    private int order_detail_id;
    private int order_id;
    private int product_id;
    private int quantity;
    private double price;
    private String payment_order_no; // 支付宝订单号

    public OrderDetail() {
    }

    public OrderDetail(int order_id, int product_id, int quantity, double price) {
        this.order_id = order_id;
        this.product_id = product_id;
        this.quantity = quantity;
        this.price = price;
    }

    public OrderDetail(int order_id, int product_id, int quantity, double price, String payment_order_no) {
        this.order_id = order_id;
        this.product_id = product_id;
        this.quantity = quantity;
        this.price = price;
        this.payment_order_no = payment_order_no;
    }

    public OrderDetail(int order_detail_id, int order_id, int product_id, int quantity, double price) {
        this.order_detail_id = order_detail_id;
        this.order_id = order_id;
        this.product_id = product_id;
        this.quantity = quantity;
        this.price = price;
    }

    public OrderDetail(int order_detail_id, int order_id, int product_id, int quantity, double price,
            String payment_order_no) {
        this.order_detail_id = order_detail_id;
        this.order_id = order_id;
        this.product_id = product_id;
        this.quantity = quantity;
        this.price = price;
        this.payment_order_no = payment_order_no;
    }

    public int getOrder_id() {
        return order_id;
    }

    public void setOrder_id(int order_id) {
        this.order_id = order_id;
    }

    public int getOrder_detail_id() {
        return order_detail_id;
    }

    public void setOrder_detail_id(int order_detail_id) {
        this.order_detail_id = order_detail_id;
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

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getPayment_order_no() {
        return payment_order_no;
    }

    public void setPayment_order_no(String payment_order_no) {
        this.payment_order_no = payment_order_no;
    }
}
