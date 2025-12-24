-- 修复商家角色触发器，避免重复插入
-- 删除原有触发器
DROP TRIGGER IF EXISTS `InsertShopOwnerRole`;

-- 创建新的触发器，检查用户是否已经有商家角色
DELIMITER ;;
CREATE TRIGGER `InsertShopOwnerRole` AFTER INSERT ON `shop` FOR EACH ROW 
BEGIN
    -- 检查用户是否已经有商家角色，如果没有则添加
    IF NOT EXISTS (SELECT 1 FROM user_role WHERE user_id = NEW.owner_id AND role_id = 2) THEN
        INSERT INTO user_role (user_id, role_id) VALUES (NEW.owner_id, 2);
    END IF;
END;;
DELIMITER ;