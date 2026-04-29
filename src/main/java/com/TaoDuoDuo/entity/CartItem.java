package com.TaoDuoDuo.entity;

public class CartItem {
    private Cart cart;
    private Product product;
    private String productImage;

    public CartItem() {
    }

    public CartItem(Cart cart, Product product, String productImage) {
        this.cart = cart;
        this.product = product;
        this.productImage = productImage;
    }

    public Cart getCart() {
        return cart;
    }

    public void setCart(Cart cart) {
        this.cart = cart;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public String getProductImage() {
        return productImage;
    }

    public void setProductImage(String productImage) {
        this.productImage = productImage;
    }

    public double getSubtotal() {
        if (product != null && cart != null) {
            return product.getPrice() * cart.getQuantity();
        }
        return 0.0;
    }
}
