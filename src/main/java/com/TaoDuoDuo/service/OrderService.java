package com.TaoDuoDuo.service;

import com.TaoDuoDuo.entity.OrderDetail;
import com.TaoDuoDuo.entity.Product;

import java.util.List;

public class OrderService {
    private ProductService productService;

    public OrderService() {
        this.productService = new ProductService();
    }

    /**
     * 验证订单中的所有商品是否可以购买
     * 
     * @param orderDetails 订单详情列表
     * @return 验证结果，包含错误信息
     */
    public OrderValidationResult validateOrder(List<OrderDetail> orderDetails) {
        OrderValidationResult result = new OrderValidationResult();

        for (OrderDetail detail : orderDetails) {
            Product product = productService.getProductById(detail.getProduct_id());

            if (product == null) {
                result.addError("商品ID " + detail.getProduct_id() + " 不存在");
                continue;
            }

            // 检查商品是否上架
            if (!product.isProduct_listing()) {
                result.addError("商品 " + product.getProduct_name() + " 已下架，无法购买");
                continue;
            }

            // 检查库存
            if (product.getStock() < detail.getQuantity()) {
                result.addError("商品 " + product.getProduct_name() + " 库存不足（当前库存：" +
                        product.getStock() + "，需要：" + detail.getQuantity() + "）");
                continue;
            }
        }

        return result;
    }

    /**
     * 创建订单前的验证
     * 
     * @param userId    用户ID
     * @param productId 商品ID
     * @param quantity  购买数量
     * @return 验证结果
     */
    public OrderValidationResult validateSingleProductOrder(int userId, int productId, int quantity) {
        OrderValidationResult result = new OrderValidationResult();

        if (userId <= 0) {
            result.addError("用户ID无效");
            return result;
        }

        if (quantity <= 0) {
            result.addError("购买数量必须大于0");
            return result;
        }

        Product product = productService.getProductById(productId);
        if (product == null) {
            result.addError("商品不存在");
            return result;
        }

        // 检查商品是否上架
        if (!product.isProduct_listing()) {
            result.addError("商品已下架，无法购买");
            return result;
        }

        // 检查库存
        if (product.getStock() < quantity) {
            result.addError("库存不足（当前库存：" + product.getStock() + "）");
            return result;
        }

        return result;
    }

    /**
     * 订单验证结果类
     */
    public static class OrderValidationResult {
        private boolean valid = true;
        private StringBuilder errors = new StringBuilder();

        public void addError(String error) {
            this.valid = false;
            if (errors.length() > 0) {
                errors.append("；");
            }
            errors.append(error);
        }

        public boolean isValid() {
            return valid;
        }

        public String getErrorMessage() {
            return errors.toString();
        }
    }
}