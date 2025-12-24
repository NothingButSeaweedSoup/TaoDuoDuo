package com.TaoDuoDuo.service;

import com.TaoDuoDuo.dao.*;
import com.TaoDuoDuo.entity.*;

import java.util.List;
import java.util.Optional;

public class ProductDetailService {
    public Optional<Product> getProductDetail(int product_id) {
        ProductDao productDao = new ProductDao();
        return productDao.getProductById(product_id);
    }

    public Optional<List<Review>> getProductReviews(int product_id) {
        ReviewDao reviewDao = new ReviewDao();

        try {
            // 直接通过商品ID查询评论
            return reviewDao.getReviewsByProductId(product_id);
        } catch (Exception e) {
            System.err.println("查询商品评论异常: " + e.getMessage());
            e.printStackTrace();
            return Optional.empty();
        }
    }

    public boolean checkStock(int product_id, int quantity) {
        ProductDao productDao = new ProductDao();
        Optional<Product> productOpt = productDao.getProductById(product_id);
        if (productOpt.isEmpty()) {
            return false;
        }
        Product product = productOpt.get();

        // 检查商品是否上架
        if (!product.isProduct_listing()) {
            return false; // 商品已下架，不能购买
        }

        return product.getStock() >= quantity;
    }

    public boolean addToCart(int user_id, int product_id, int quantity) {
        // 先检查商品是否可以购买（上架且有库存）
        if (!checkStock(product_id, quantity)) {
            return false; // 商品下架或库存不足
        }

        CartDao cartDao = new CartDao();
        return cartDao.addCart(new Cart(user_id, product_id, quantity));
    }
}
