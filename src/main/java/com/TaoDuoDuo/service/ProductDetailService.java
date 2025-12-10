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
        OrderDetailDao orderDetailDao = new OrderDetailDao();

        // 1. 先查询订单详情
        Optional<List<OrderDetail>> orderDetailsOpt = orderDetailDao.getOrderDetailByProductId(product_id);

        // 2. 检查是否有订单数据
        if (orderDetailsOpt.isEmpty() || orderDetailsOpt.get().isEmpty()) {
            System.out.println("商品ID: " + product_id + " 暂无订单记录，无法查询评价");
            return Optional.empty(); // 返回空Optional而不是抛出异常
        }

        // 3. 安全地获取第一个订单ID
        int orderId = orderDetailsOpt.get().get(0).getOrder_id();
        Optional<List<Review>> reviews = reviewDao.getReviewsByUserId(orderId);

        return reviews;
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
