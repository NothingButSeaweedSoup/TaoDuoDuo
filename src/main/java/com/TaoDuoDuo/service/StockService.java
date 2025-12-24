package com.TaoDuoDuo.service;

import com.TaoDuoDuo.dao.ProductDao;
import com.TaoDuoDuo.dao.OrderDetailDao;
import com.TaoDuoDuo.entity.OrderDetail;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * 库存管理服务类
 * 处理库存扣除、恢复等核心业务逻辑
 */
public class StockService {

    private ProductDao productDao;
    private OrderDetailDao orderDetailDao;

    public StockService() {
        this.productDao = new ProductDao();
        this.orderDetailDao = new OrderDetailDao();
    }

    /**
     * 支付成功后扣除订单库存
     * 
     * @param orderId 订单ID
     * @return 库存扣除结果
     */
    public StockProcessResult processPaymentSuccess(int orderId) {
        try {
            // 1. 获取订单详情
            Optional<List<OrderDetail>> orderDetailsOpt = orderDetailDao.getOrderDetailsByOrderId(orderId);
            if (!orderDetailsOpt.isPresent() || orderDetailsOpt.get().isEmpty()) {
                return new StockProcessResult(false, "订单详情不存在", orderId);
            }

            List<OrderDetail> orderDetails = orderDetailsOpt.get();

            // 2. 构建库存更新列表
            List<ProductDao.StockUpdate> stockUpdates = new ArrayList<>();
            for (OrderDetail detail : orderDetails) {
                stockUpdates.add(new ProductDao.StockUpdate(detail.getProduct_id(), detail.getQuantity()));
            }

            // 3. 批量扣除库存
            ProductDao.BatchStockUpdateResult batchResult = productDao.batchDecreaseStock(stockUpdates);

            if (batchResult.isOverallSuccess()) {
                return new StockProcessResult(true, "库存扣除成功", orderId);
            } else {
                return new StockProcessResult(false, "库存扣除失败：" + batchResult.getErrorMessage(), orderId);
            }

        } catch (Exception e) {
            e.printStackTrace();
            return new StockProcessResult(false, "库存扣除异常：" + e.getMessage(), orderId);
        }
    }

    /**
     * 订单取消后恢复库存
     * 
     * @param orderId 订单ID
     * @return 库存恢复结果
     */
    public StockProcessResult processOrderCancel(int orderId) {
        try {
            // 1. 获取订单详情
            Optional<List<OrderDetail>> orderDetailsOpt = orderDetailDao.getOrderDetailsByOrderId(orderId);
            if (!orderDetailsOpt.isPresent() || orderDetailsOpt.get().isEmpty()) {
                return new StockProcessResult(false, "订单详情不存在", orderId);
            }

            List<OrderDetail> orderDetails = orderDetailsOpt.get();

            // 2. 逐个恢复库存
            for (OrderDetail detail : orderDetails) {
                ProductDao.StockUpdateResult result = productDao.increaseStock(detail.getProduct_id(),
                        detail.getQuantity());
                if (!result.isSuccess()) {
                    // 记录日志但不中断流程，因为库存恢复失败不应该阻止订单取消
                    System.err.println("恢复库存失败 - 商品ID: " + detail.getProduct_id() +
                            ", 数量: " + detail.getQuantity() +
                            ", 原因: " + result.getMessage());
                }
            }

            return new StockProcessResult(true, "库存恢复完成", orderId);

        } catch (Exception e) {
            e.printStackTrace();
            return new StockProcessResult(false, "库存恢复异常：" + e.getMessage(), orderId);
        }
    }

    /**
     * 单个商品库存扣除
     * 
     * @param productId 商品ID
     * @param quantity  扣除数量
     * @return 库存扣除结果
     */
    public ProductDao.StockUpdateResult decreaseStock(int productId, int quantity) {
        return productDao.decreaseStock(productId, quantity);
    }

    /**
     * 单个商品库存恢复
     * 
     * @param productId 商品ID
     * @param quantity  恢复数量
     * @return 库存恢复结果
     */
    public ProductDao.StockUpdateResult increaseStock(int productId, int quantity) {
        return productDao.increaseStock(productId, quantity);
    }

    /**
     * 检查订单库存是否充足
     * 
     * @param orderId 订单ID
     * @return 库存检查结果
     */
    public StockCheckResult checkOrderStock(int orderId) {
        try {
            Optional<List<OrderDetail>> orderDetailsOpt = orderDetailDao.getOrderDetailsByOrderId(orderId);
            if (!orderDetailsOpt.isPresent() || orderDetailsOpt.get().isEmpty()) {
                return new StockCheckResult(false, "订单详情不存在");
            }

            List<OrderDetail> orderDetails = orderDetailsOpt.get();
            StringBuilder errors = new StringBuilder();
            boolean allAvailable = true;

            for (OrderDetail detail : orderDetails) {
                Optional<com.TaoDuoDuo.entity.Product> productOpt = productDao.getProductById(detail.getProduct_id());
                if (!productOpt.isPresent()) {
                    allAvailable = false;
                    errors.append("商品ID ").append(detail.getProduct_id()).append(" 不存在；");
                    continue;
                }

                com.TaoDuoDuo.entity.Product product = productOpt.get();
                if (!product.isProduct_listing()) {
                    allAvailable = false;
                    errors.append("商品 ").append(product.getProduct_name()).append(" 已下架；");
                    continue;
                }

                if (product.getStock() < detail.getQuantity()) {
                    allAvailable = false;
                    errors.append("商品 ").append(product.getProduct_name())
                            .append(" 库存不足（需要：").append(detail.getQuantity())
                            .append("，当前：").append(product.getStock()).append("）；");
                }
            }

            if (allAvailable) {
                return new StockCheckResult(true, "库存充足");
            } else {
                return new StockCheckResult(false, errors.toString());
            }

        } catch (Exception e) {
            e.printStackTrace();
            return new StockCheckResult(false, "库存检查异常：" + e.getMessage());
        }
    }

    /**
     * 库存处理结果类
     */
    public static class StockProcessResult {
        private final boolean success;
        private final String message;
        private final int orderId;

        public StockProcessResult(boolean success, String message, int orderId) {
            this.success = success;
            this.message = message;
            this.orderId = orderId;
        }

        public boolean isSuccess() {
            return success;
        }

        public String getMessage() {
            return message;
        }

        public int getOrderId() {
            return orderId;
        }
    }

    /**
     * 库存检查结果类
     */
    public static class StockCheckResult {
        private final boolean available;
        private final String message;

        public StockCheckResult(boolean available, String message) {
            this.available = available;
            this.message = message;
        }

        public boolean isAvailable() {
            return available;
        }

        public String getMessage() {
            return message;
        }
    }
}