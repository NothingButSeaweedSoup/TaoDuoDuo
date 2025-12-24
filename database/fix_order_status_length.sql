-- 修复订单状态字段长度问题
-- 执行日期：2025-12-25
-- 描述：扩展 order_status 字段长度以支持所有状态值

-- 1. 检查当前字段定义
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE, 
    COLUMN_DEFAULT, 
    COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'order' 
    AND COLUMN_NAME = 'order_status';

-- 2. 扩展 order_status 字段长度
-- 从当前长度扩展到 VARCHAR(30) 以支持所有状态值
ALTER TABLE `order` 
MODIFY COLUMN `order_status` VARCHAR(30) DEFAULT 'unpaid' COMMENT '订单状态：unpaid-未支付，paid_pending_shipment-已支付待发货，shipped_pending_receipt-待收货，completed-已完成，cancelled-已取消';

-- 3. 验证修改结果
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE, 
    COLUMN_DEFAULT, 
    COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'order' 
    AND COLUMN_NAME = 'order_status';

-- 4. 检查现有数据是否有问题
SELECT 
    order_status, 
    LENGTH(order_status) as status_length,
    COUNT(*) as count
FROM `order` 
GROUP BY order_status, LENGTH(order_status)
ORDER BY status_length DESC;

-- 5. 显示所有可能的状态值及其长度（用于验证）
/*
状态值及长度：
- unpaid: 6 字符
- paid_pending_shipment: 21 字符  ← 最长的状态
- shipped_pending_receipt: 22 字符  ← 最长的状态
- completed: 9 字符
- cancelled: 9 字符

建议字段长度：VARCHAR(30) 足够容纳所有状态
*/

COMMIT;