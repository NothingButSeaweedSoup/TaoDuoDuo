package com.TaoDuoDuo.service;

import com.TaoDuoDuo.dao.OrderDao;
import com.TaoDuoDuo.dao.OrderDetailDao;
import com.TaoDuoDuo.entity.Order;
import com.TaoDuoDuo.entity.OrderDetail;
import com.TaoDuoDuo.entity.OrderStatus;
import com.TaoDuoDuo.entity.CartItem;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

/**
 * 订单管理服务类
 * 处理订单创建、状态更新等核心业务逻辑
 */
public class OrderManagementService {
    
    private OrderDao orderDao;
    private OrderDetailDao orderDetailDao;
    
    public OrderManagementService() {
        this.orderDao = new OrderDao();
        this.orderDetailDao = new OrderDetailDao();
    }
    
    /**
     * 从购物车创建订单
     * @param userId 用户ID
     * @param shopId 店铺ID
     * @param cartItems 购物车商品列表
     * @return 创建的订单，如果失败返回null
     */
    public Order createOrderFromCart(int userId, int shopId, List<CartItem> cartItems) {
        if (cartItems == null || cartItems.isEmpty()) {
            throw new IllegalArgumentException("购物车商品列表不能为空");
        }
        
        try {
            // 计算订单总金额
            double totalAmount = 0.0;
            for (CartItem item : cartItems) {
                totalAmount += item.getSubtotal();
            }
            
            // 生成支付宝订单号
            String alipayOrderNo = generateAlipayOrderNo(userId);
            
            // 创建订单
            Order order = new Order(userId, shopId, OrderStatus.UNPAID.getValue(), totalAmount, alipayOrderNo);
            
            // 保存订单到数据库
            boolean orderCreated = orderDao.addOrder(order);
            if (!orderCreated) {
                throw new RuntimeException("创建订单失败");
            }
            
            // 创建订单详情
            for (CartItem item : cartItems) {
                OrderDetail detail = new OrderDetail(
                    order.getOrder_id(),
                    item.getProduct().getProduct_id(),
                    item.getCart().getQuantity(),
                    item.getProduct().getPrice(),
                    alipayOrderNo
                );
                
                boolean detailCreated = orderDetailDao.addOrderDetail(detail);
                if (!detailCreated) {
                    // 如果订单详情创建失败，应该回滚订单创建
                    // 这里简化处理，实际应该使用事务
                    throw new RuntimeException("创建订单详情失败");
                }
            }
            
            return order;
            
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("创建订单时发生错误：" + e.getMessage());
        }
    }
    
    /**
     * 生成支付宝订单号
     * @param userId 用户ID
     * @return 支付宝订单号
     */
    private String generateAlipayOrderNo(int userId) {
        return "ALIPAY_" + System.currentTimeMillis() + "_" + userId + "_" + 
               UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }
    
    /**
     * 更新订单状态
     * @param orderId 订单ID
     * @param newStatus 新状态
     * @param operatorId 操作者ID
     * @param operatorRole 操作者角色
     * @return 是否更新成功
     */
    public boolean updateOrderStatus(int orderId, OrderStatus newStatus, int operatorId, int operatorRole) {
        try {
            // 获取当前订单
            var orderOpt = orderDao.getOrderById(orderId);
            if (!orderOpt.isPresent()) {
                throw new IllegalArgumentException("订单不存在");
            }
            
            Order order = orderOpt.get();
            
            // 权限检查
            if (!hasPermissionToUpdateOrder(order, operatorId, operatorRole)) {
                throw new SecurityException("无权限操作此订单");
            }
            
            // 状态转换检查
            if (!order.canTransitionTo(newStatus)) {
                throw new IllegalStateException("无效的状态转换");
            }
            
            // 更新订单状态
            order.setOrderStatus(newStatus);
            order.setUpdate_time(LocalDateTime.now());
            
            return orderDao.updateOrder(order);
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 检查是否有权限操作订单
     * @param order 订单
     * @param operatorId 操作者ID
     * @param operatorRole 操作者角色
     * @return 是否有权限
     */
    private boolean hasPermissionToUpdateOrder(Order order, int operatorId, int operatorRole) {
        // 用户只能操作自己的订单
        if (operatorRole == 1) {
            return order.getUser_id() == operatorId;
        }
        // 商家只能操作自己店铺的订单
        else if (operatorRole == 2) {
            // 这里需要根据operatorId查询shop_id，简化处理
            return true; // 临时允许
        }
        // 管理员可以操作所有订单
        else if (operatorRole == 3) {
            return true;
        }
        
        return false;
    }
    
    /**
     * 取消订单
     * @param orderId 订单ID
     * @param operatorId 操作者ID
     * @param operatorRole 操作者角色
     * @return 是否取消成功
     */
    public boolean cancelOrder(int orderId, int operatorId, int operatorRole) {
        try {
            // 获取当前订单
            var orderOpt = orderDao.getOrderById(orderId);
            if (!orderOpt.isPresent()) {
                throw new IllegalArgumentException("订单不存在");
            }
            
            Order order = orderOpt.get();
            
            // 权限检查
            if (!hasPermissionToUpdateOrder(order, operatorId, operatorRole)) {
                throw new SecurityException("无权限操作此订单");
            }
            
            // 检查是否可以取消
            if (!order.canBeCancelled()) {
                throw new IllegalStateException("当前状态不允许取消订单");
            }
            
            // 更新订单状态为已取消
            order.setOrderStatus(OrderStatus.CANCELLED);
            order.setUpdate_time(LocalDateTime.now());
            
            boolean result = orderDao.updateOrder(order);
            
            // TODO: 恢复商品库存
            // 这里应该调用商品服务来恢复库存
            
            return result;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}