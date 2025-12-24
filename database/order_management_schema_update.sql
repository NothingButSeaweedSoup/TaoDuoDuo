-- 订单管理系统数据库架构更新脚本
-- 执行日期：2024年
-- 描述：为订单管理系统添加必要的字段和索引

-- 1. 为order表添加alipay_order_no字段
ALTER TABLE `order` 
ADD COLUMN `alipay_order_no` VARCHAR(64) NULL COMMENT '支付宝订单号' 
AFTER `total_amount`;

-- 2. 为alipay_order_no字段添加唯一索引（支持NULL值）
ALTER TABLE `order` 
ADD UNIQUE INDEX `uk_alipay_order_no` (`alipay_order_no`);

-- 3. 为order表添加性能优化索引
-- 用户订单查询索引
ALTER TABLE `order` 
ADD INDEX `idx_user_status_time` (`user_id`, `order_status`, `create_time` DESC);

-- 商家订单查询索引
ALTER TABLE `order` 
ADD INDEX `idx_shop_status_time` (`shop_id`, `order_status`, `create_time` DESC);

-- 订单状态查询索引
ALTER TABLE `order` 
ADD INDEX `idx_status_time` (`order_status`, `create_time` DESC);

-- 4. 为order_detail表添加性能优化索引
-- 订单详情查询索引
ALTER TABLE `order_detail` 
ADD INDEX `idx_order_id` (`order_id`);

-- 商品订单详情查询索引
ALTER TABLE `order_detail` 
ADD INDEX `idx_product_id` (`product_id`);

-- 支付订单号查询索引
ALTER TABLE `order_detail` 
ADD INDEX `idx_payment_order_no` (`payment_order_no`);

-- 5. 为review表添加性能优化索引（如果表存在）
-- 订单评价查询索引
ALTER TABLE `review` 
ADD INDEX `idx_order_id` (`order_id`);

-- 用户评价查询索引
ALTER TABLE `review` 
ADD INDEX `idx_user_id_time` (`user_id`, `create_time` DESC);

-- 商品评价查询索引（需要通过order_detail关联）
-- 这个索引在查询商品评价时会用到
ALTER TABLE `review` 
ADD INDEX `idx_create_time` (`create_time` DESC);

-- 6. 更新现有数据（如果需要）
-- 为现有订单生成支付宝订单号（可选）
-- UPDATE `order` 
-- SET `alipay_order_no` = CONCAT('ALIPAY_', UNIX_TIMESTAMP(create_time), '_', user_id, '_', SUBSTRING(MD5(RAND()), 1, 8))
-- WHERE `alipay_order_no` IS NULL AND `order_status` != 'unpaid';

-- 7. 验证更新结果
-- 检查alipay_order_no字段是否添加成功
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE, 
    COLUMN_DEFAULT, 
    COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'order' 
    AND COLUMN_NAME = 'alipay_order_no';

-- 检查索引是否创建成功
SHOW INDEX FROM `order` WHERE Key_name IN ('uk_alipay_order_no', 'idx_user_status_time', 'idx_shop_status_time', 'idx_status_time');

-- 检查order_detail表索引
SHOW INDEX FROM `order_detail` WHERE Key_name IN ('idx_order_id', 'idx_product_id', 'idx_payment_order_no');

-- 检查review表索引
SHOW INDEX FROM `review` WHERE Key_name IN ('idx_order_id', 'idx_user_id_time', 'idx_create_time');

-- 8. 性能测试查询示例
-- 测试用户订单查询性能
-- EXPLAIN SELECT * FROM `order` WHERE user_id = 1 AND order_status = 'completed' ORDER BY create_time DESC LIMIT 10;

-- 测试商家订单查询性能
-- EXPLAIN SELECT * FROM `order` WHERE shop_id = 1 AND order_status = 'paid_pending_shipment' ORDER BY create_time DESC LIMIT 10;

-- 测试订单详情查询性能
-- EXPLAIN SELECT * FROM `order_detail` WHERE order_id = 1;

-- 9. 备份建议
-- 在执行此脚本之前，建议备份相关表：
-- CREATE TABLE `order_backup` AS SELECT * FROM `order`;
-- CREATE TABLE `order_detail_backup` AS SELECT * FROM `order_detail`;
-- CREATE TABLE `review_backup` AS SELECT * FROM `review`;

COMMIT;