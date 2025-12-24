package com.TaoDuoDuo.entity;

/**
 * 订单状态枚举
 * 定义订单在整个生命周期中的各种状态
 */
public enum OrderStatus {
    UNPAID("unpaid", "未支付"),
    PAID_PENDING_SHIPMENT("paid_pending_shipment", "已支付待发货"),
    SHIPPED_PENDING_RECEIPT("shipped_pending_receipt", "待收货"),
    COMPLETED("completed", "已完成"),
    CANCELLED("cancelled", "已取消");
    
    private final String value;
    private final String displayName;
    
    OrderStatus(String value, String displayName) {
        this.value = value;
        this.displayName = displayName;
    }
    
    public String getValue() {
        return value;
    }
    
    public String getDisplayName() {
        return displayName;
    }
    
    /**
     * 根据字符串值获取对应的枚举
     * @param value 状态值
     * @return 对应的OrderStatus枚举，如果不存在则返回null
     */
    public static OrderStatus fromValue(String value) {
        if (value == null) {
            return null;
        }
        for (OrderStatus status : OrderStatus.values()) {
            if (status.value.equals(value)) {
                return status;
            }
        }
        return null;
    }
    
    /**
     * 检查是否可以从当前状态转换到目标状态
     * @param targetStatus 目标状态
     * @return 如果可以转换返回true，否则返回false
     */
    public boolean canTransitionTo(OrderStatus targetStatus) {
        if (targetStatus == null) {
            return false;
        }
        
        switch (this) {
            case UNPAID:
                return targetStatus == PAID_PENDING_SHIPMENT || targetStatus == CANCELLED;
            case PAID_PENDING_SHIPMENT:
                return targetStatus == SHIPPED_PENDING_RECEIPT || targetStatus == CANCELLED;
            case SHIPPED_PENDING_RECEIPT:
                return targetStatus == COMPLETED;
            case COMPLETED:
            case CANCELLED:
                return false; // 终态，不能再转换
            default:
                return false;
        }
    }
    
    /**
     * 检查当前状态是否允许取消
     * @return 如果可以取消返回true，否则返回false
     */
    public boolean canBeCancelled() {
        return this == UNPAID || this == PAID_PENDING_SHIPMENT;
    }
    
    /**
     * 检查当前状态是否为终态
     * @return 如果是终态返回true，否则返回false
     */
    public boolean isFinalState() {
        return this == COMPLETED || this == CANCELLED;
    }
    
    /**
     * 检查订单是否可以评价
     * @return 如果可以评价返回true，否则返回false
     */
    public boolean canBeReviewed() {
        return this == COMPLETED;
    }
}