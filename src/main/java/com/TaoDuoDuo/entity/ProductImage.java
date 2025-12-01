package com.TaoDuoDuo.entity;

public class ProductImage {
    private int image_id;
    private int product_id;
    private String image_url;
    private int sort_order;

    public ProductImage() {
    }

    public ProductImage(int product_id, String image_url, int sort_order) {
        this.product_id = product_id;
        this.image_url = image_url;
        this.sort_order = sort_order;
    }

    public int getImage_id() {
        return image_id;
    }

    public void setImage_id(int image_id) {
        this.image_id = image_id;
    }

    public int getProduct_id() {
        return product_id;
    }

    public void setProduct_id(int product_id) {
        this.product_id = product_id;
    }

    public String getImage_url() {
        return image_url;
    }

    public void setImage_url(String image_url) {
        this.image_url = image_url;
    }

    public int getSort_order() {
        return sort_order;
    }

    public void setSort_order(int sort_order) {
        this.sort_order = sort_order;
    }
}
