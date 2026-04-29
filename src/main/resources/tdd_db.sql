-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: tdd_db
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart` (
  `cart_id` int NOT NULL AUTO_INCREMENT COMMENT '购物车ID',
  `user_id` int NOT NULL COMMENT '用户ID',
  `product_id` int NOT NULL COMMENT '商品ID',
  `quantity` int NOT NULL COMMENT '商品数量',
  `add_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  PRIMARY KEY (`cart_id`),
  UNIQUE KEY `user_product` (`user_id`,`product_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='购物车表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
INSERT INTO `cart` VALUES (8,3,3,1,'2025-12-09 21:52:09'),(10,3,6,1,'2025-12-09 21:52:33'),(11,3,2,20,'2025-12-10 00:41:13'),(13,5,3,1,'2025-12-24 19:10:45'),(15,9,15,2,'2025-12-24 20:54:59'),(17,9,7,1,'2025-12-24 20:55:36'),(61,15,24,8,'2026-01-04 01:19:42'),(62,15,30,1,'2026-01-04 01:20:42'),(63,15,25,1,'2026-01-04 01:20:46'),(64,15,2,1,'2026-01-04 01:29:59');
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `MaxQuantity` BEFORE UPDATE ON `cart` FOR EACH ROW begin
    declare max_quantity int;
    select stock into max_quantity from product where product_id = new.product_id;
    if new.quantity > max_quantity then
        set new.quantity = max_quantity;
    end if;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `category_id` int NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `category_name` varchar(50) NOT NULL COMMENT '分类名称',
  `parent_id` int DEFAULT '0' COMMENT '父级分类ID',
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `category_name` (`category_name`),
  KEY `parent_id` (`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='分类表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (3,'毛绒玩具',0),(4,'食品',0),(5,'数码',0),(6,'电脑',0),(7,'电脑配件',6),(8,'其他',0);
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order`
--

DROP TABLE IF EXISTS `order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order` (
  `order_id` int NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `user_id` int NOT NULL COMMENT '用户ID',
  `shop_id` int NOT NULL COMMENT '店铺ID',
  `order_status` varchar(30) DEFAULT 'unpaid' COMMENT '订单状态：unpaid-未支付，paid_pending_shipment-已支付待发货，shipped_pending_receipt-待收货，completed-已完成，cancelled-已取消',
  `total_amount` decimal(10,2) NOT NULL COMMENT '订单总金额',
  `alipay_order_no` varchar(64) DEFAULT NULL COMMENT '支付宝订单号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_id`),
  UNIQUE KEY `uk_alipay_order_no` (`alipay_order_no`),
  KEY `idx_user_status_time` (`user_id`,`order_status`,`create_time` DESC),
  KEY `idx_shop_status_time` (`shop_id`,`order_status`,`create_time` DESC),
  KEY `idx_status_time` (`order_status`,`create_time` DESC),
  CONSTRAINT `order_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  CONSTRAINT `order_ibfk_2` FOREIGN KEY (`shop_id`) REFERENCES `shop` (`shop_id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order`
--

LOCK TABLES `order` WRITE;
/*!40000 ALTER TABLE `order` DISABLE KEYS */;
INSERT INTO `order` VALUES (6,7,1,'cancelled',817.00,'2025122501042963712','2025-12-25 01:04:18','2025-12-25 01:06:39'),(7,7,7,'cancelled',49.80,NULL,'2025-12-25 01:04:18','2025-12-25 01:06:41'),(8,7,10,'cancelled',4.00,'2025122501052587088','2025-12-25 01:04:18','2025-12-25 01:06:43'),(9,7,1,'cancelled',119.00,'2025122501065498755','2025-12-25 01:06:54','2025-12-25 01:13:18'),(10,7,1,'cancelled',119.00,'20251225011325107552','2025-12-25 01:13:25','2025-12-25 01:14:17'),(11,7,1,'cancelled',119.00,'20251225011427118658','2025-12-25 01:14:27','2025-12-25 01:20:09'),(12,7,1,'completed',119.00,'20251225012015126534','2025-12-25 01:20:15','2025-12-25 01:35:40'),(13,7,10,'paid_pending_shipment',17.60,'20251225012209139746','2025-12-25 01:22:09','2025-12-25 01:22:24'),(14,7,7,'completed',5003.82,'20251225015342149947','2025-12-25 01:53:35','2025-12-25 01:56:01'),(15,7,9,'paid_pending_shipment',156.00,'20251225015418158328','2025-12-25 01:53:35','2025-12-25 01:54:37'),(16,7,1,'completed',209.00,'20251225082045165220','2025-12-25 08:20:40','2025-12-25 08:22:38'),(17,7,1,'cancelled',119.00,'20251225090308177893','2025-12-25 09:03:08','2025-12-25 09:04:59'),(18,1,7,'completed',59.70,'20251225092248187117','2025-12-25 09:22:48','2026-01-04 13:18:00'),(19,6,9,'cancelled',4536.00,'20251225092755197189','2025-12-25 09:27:55','2025-12-25 09:29:43'),(20,6,9,'paid_pending_shipment',4536.00,'2025122509281020106','2025-12-25 09:28:05','2025-12-25 09:28:37'),(21,6,7,'cancelled',20.23,NULL,'2025-12-25 09:29:27','2025-12-25 09:29:41'),(22,7,1,'paid_pending_shipment',119.00,'20260103231349224435','2026-01-03 23:13:49','2026-01-03 23:14:43'),(23,15,1,'completed',218.00,'20260104005258237399','2026-01-04 00:43:05','2026-01-04 01:00:16'),(24,7,4,'unpaid',1399.00,'20260104005207241446','2026-01-04 00:52:07','2026-01-04 00:52:07'),(25,15,10,'cancelled',31.50,NULL,'2026-01-04 01:12:15','2026-01-04 01:16:29'),(26,15,7,'cancelled',3.97,'20260104011431264945','2026-01-04 01:14:31','2026-01-04 01:16:27'),(27,15,7,'unpaid',3.97,'20260104011633277135','2026-01-04 01:16:06','2026-01-04 01:16:33'),(28,15,11,'cancelled',10.00,NULL,'2026-01-04 01:16:06','2026-01-04 01:16:24'),(29,1,4,'cancelled',1399.00,'20260104132249293336','2026-01-04 13:22:49','2026-01-04 13:24:25'),(30,1,4,'paid_pending_shipment',1399.00,'20260104132430303655','2026-01-04 13:24:28','2026-01-04 13:25:14'),(31,1,9,'paid_pending_shipment',52.00,'20260104132542317339','2026-01-04 13:25:42','2026-01-04 13:26:07');
/*!40000 ALTER TABLE `order` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `DeleteOrder` BEFORE DELETE ON `order` FOR EACH ROW BEGIN
    DELETE FROM order_detail WHERE order_id = OLD.order_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `order_detail`
--

DROP TABLE IF EXISTS `order_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_detail` (
  `order_detail_id` int NOT NULL AUTO_INCREMENT COMMENT '订单详情ID',
  `order_id` int NOT NULL COMMENT '订单ID',
  `product_id` int NOT NULL COMMENT '商品ID',
  `quantity` int NOT NULL COMMENT '商品数量',
  `price` decimal(10,2) NOT NULL COMMENT '商品单价',
  `payment_order_no` varchar(64) DEFAULT NULL COMMENT '支付宝订单号',
  PRIMARY KEY (`order_detail_id`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_product_id` (`product_id`),
  KEY `idx_payment_order_no` (`payment_order_no`),
  CONSTRAINT `order_detail_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `order` (`order_id`),
  CONSTRAINT `order_detail_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单详情表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_detail`
--

LOCK TABLES `order_detail` WRITE;
/*!40000 ALTER TABLE `order_detail` DISABLE KEYS */;
INSERT INTO `order_detail` VALUES (6,6,20,2,209.00,'ALIPAY_1766595858076_7_562E7A92'),(7,7,12,1,49.80,'ALIPAY_1766595858095_7_BF5F9ABF'),(8,8,26,1,4.00,'ALIPAY_1766595858100_7_A879F9BF'),(9,9,7,1,119.00,'2025122501065498755'),(10,10,7,1,119.00,'20251225011325107552'),(11,11,7,1,119.00,'20251225011427118658'),(12,12,7,1,119.00,'20251225012015126534'),(13,13,24,1,17.60,'20251225012209139746'),(14,14,12,100,49.80,'ALIPAY_1766598815403_7_B81D8CCA'),(15,14,22,6,3.97,'ALIPAY_1766598815403_7_B81D8CCA'),(16,15,19,3,52.00,'ALIPAY_1766598815425_7_F8974019'),(17,16,20,1,209.00,'ALIPAY_1766622040805_7_26F9CFDE'),(18,17,7,1,119.00,'20251225090308177893'),(19,18,14,3,19.90,'20251225092248187117'),(20,19,32,7,648.00,'20251225092755197189'),(21,20,32,7,648.00,'ALIPAY_1766626085739_6_636C347D'),(22,21,21,7,2.89,'ALIPAY_1766626167146_6_AA8E6245'),(23,22,7,1,119.00,'20260103231349224435'),(24,23,2,2,109.00,'ALIPAY_1767458585538_15_F8ABE968'),(25,24,6,1,1399.00,'20260104005207241446'),(26,25,25,5,6.30,'ALIPAY_1767460335728_15_35C6AB67'),(27,26,22,1,3.97,'20260104011431264945'),(28,27,22,1,3.97,'ALIPAY_1767460566087_15_B83FAA45'),(29,28,28,1,10.00,'ALIPAY_1767460566100_15_1D78E256'),(30,29,6,1,1399.00,'20260104132249293336'),(31,30,6,1,1399.00,'ALIPAY_1767504268189_1_9C3242E6'),(32,31,19,1,52.00,'20260104132542317339');
/*!40000 ALTER TABLE `order_detail` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `DeleteReview` BEFORE DELETE ON `order_detail` FOR EACH ROW begin
    delete from review where review.order_id = old.order_id;
    end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `product_id` int NOT NULL AUTO_INCREMENT COMMENT '商品ID',
  `product_name` varchar(50) NOT NULL COMMENT '商品名称',
  `description` text NOT NULL COMMENT '商品描述',
  `price` decimal(10,2) NOT NULL COMMENT '商品价格',
  `stock` int NOT NULL COMMENT '商品库存数量',
  `category_id` int NOT NULL COMMENT '商品分类ID',
  `shop_id` int NOT NULL COMMENT '店铺ID',
  `product_listing` tinyint(1) NOT NULL DEFAULT '0' COMMENT '商品上架',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`product_id`),
  KEY `category_id` (`category_id`),
  KEY `shop_id` (`shop_id`),
  CONSTRAINT `product_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`),
  CONSTRAINT `product_ibfk_2` FOREIGN KEY (`shop_id`) REFERENCES `shop` (`shop_id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (2,'现货 世嘉初音未来公式服fufu正版毛绒玩偶公仔玩具','世嘉(SEGA)推出的豆豆眼坐姿毛绒玩偶系列，软乎乎毛绒玩偶，被爱好者简称为\"fufu\"。',109.00,23,3,1,1,'2025-12-04 20:45:52','2026-01-04 00:53:30'),(3,'九阳豆浆哈基米南北绿豆浆限量发售150g','品名：九阳豆浆哈基米南北绿豆浆\n系列：哈基米南北绿豆\n核心植物成分：绿豆\n口味：绿豆',19.90,100,4,2,1,'2025-12-09 08:23:48','2025-12-10 13:38:06'),(6,'致态Ti600【2TB】Ti600系列 PCIe 4.0','品牌\r\n致态（ZhiTai）\r\n商品编号\r\n10108746566106\r\n店铺\r\n秦汉DIY装机小店\r\n货号\r\n致态固态硬盘\r\n闪存类型\r\nTLC\r\n缓存\r\n无缓存\r\n接口\r\nM.2接口(NVMe协议)\r\nNVMe协议\r\nPCIe 4.0\r\n容量\r\n2TB',1399.00,49,7,4,1,'2025-12-09 20:18:43','2026-01-04 13:25:14'),(7,'现货 白葱','一只白葱',119.00,-1,3,1,1,'2025-12-24 12:23:59','2026-01-04 01:21:03'),(8,'黑龙歼灭刀','铁刀了😭天上天下天地无双刀了😭超采掘十字镐了😭狱刀龙骨了😭冰灵芒刃了😭真苍星的太刀舞龙了😭飞龙刀月了😭暴君柱头了😭行云流水和光了😭鬼神薙刀了😭碎光之晓刀了😭漆黑爪终焉了😭黑龙歼灭刀了😋总而言之就是太刀了😭​',399.00,1000,8,5,1,'2025-12-24 19:12:43','2025-12-25 02:15:57'),(11,'萝播动漫 双马尾大蟑螂 粤式重型多功能载具 超大蠊拼装模型','尺寸\r\n全长约14cm\r\n材质\r\n塑胶\r\n比例\r\n无比例\r\n官方价\r\n69元\r\n发售日\r\n2026-02\r\n产地\r\n中国大陆\r\n年龄\r\n15周岁以上',69.00,80,8,7,1,'2025-12-24 19:59:23','2025-12-25 02:15:57'),(12,'脆升升薯条小包零食休闲宿舍352g薯条宿舍囤货住校必备开学小零食','脆升升薯条小包零食休闲宿舍352g薯条宿舍囤货住校必备开学小零食',49.80,400,8,7,1,'2025-12-24 20:10:25','2025-12-25 02:15:57'),(13,'劲仔 正品 批发湖南特产即食香辣麻辣味小鱼仔卤味鱼干零食小吃鱼','劲仔 正品 批发湖南特产即食香辣麻辣味小鱼仔卤味鱼干零食小吃鱼',19.90,325,8,7,1,'2025-12-24 20:11:35','2025-12-25 02:15:57'),(14,'蒙娜丽莎的微笑奶龙梵高油画艺术相框挂画桌面摆台创意卧室客厅','蒙娜丽莎的微笑奶龙梵高油画艺术相框挂画桌面摆台创意卧室客厅',19.90,57,8,7,1,'2025-12-24 20:12:09','2025-12-25 09:23:12'),(15,'明日方舟周边海猫络合物摸摸券漫展无料小卡卡片收藏送礼物朋友','明日方舟周边海猫络合物摸摸券漫展无料小卡卡片收藏送礼物朋友',2.32,114514,8,7,1,'2025-12-24 20:16:22','2025-12-25 02:15:57'),(16,'魔法Zc目录 舰长礼物 流沙麻将','魔法Zc目录 舰长礼物 流沙麻将',325.00,325,8,7,1,'2025-12-24 20:45:46','2025-12-25 02:15:57'),(17,'新款华仔通信证方舟魔改刘德华抽象应援演唱会明星亚克力背包挂件','新款华仔通信证方舟魔改刘德华抽象应援演唱会明星亚克力背包挂件',2.33,600,8,7,1,'2025-12-24 20:46:16','2025-12-25 02:15:57'),(19,'苹果乐','这是蕾缪乐 她很可爱',52.00,96,8,9,1,'2025-12-24 21:03:21','2026-01-04 13:26:07'),(20,'GSC 魔女之旅 伊蕾娜 毛绒玩偶','GSC 魔女之旅 伊蕾娜 毛绒玩偶',209.00,19,3,1,1,'2025-12-24 21:14:51','2025-12-25 08:21:30'),(21,'2026高雅人士企鹅马年新年透明静电玻璃贴春节装饰卡通窗花贴纸','2026高雅人士企鹅马年新年透明静电玻璃贴春节装饰卡通窗花贴纸',2.89,999,8,7,1,'2025-12-24 21:15:30','2025-12-25 02:15:57'),(22,'尼禄圣诞歌语音挂件padoru发声玩偶圣诞节礼物定制FATE可爱捏周边','尼禄圣诞歌语音挂件padoru发声玩偶圣诞节礼物定制FATE可爱捏周边',3.97,19,8,7,1,'2025-12-24 21:16:08','2025-12-25 02:15:57'),(23,'怪物猎人飞龙刀武器装备','雄火龙太刀血色版cos道具剑橡胶儿童玩具',38.20,999,8,5,1,'2025-12-24 21:21:21','2025-12-25 02:15:57'),(24,'牢大飞行棋','魔改版科比抽象桌游网红玩具二次元盒装2-4人搞笑爆款',17.60,824,8,10,1,'2025-12-24 21:25:30','2025-12-25 02:15:57'),(25,'苦命鸳鸯抱枕董卓抽象爆款梗图创意抱枕装饰午休睡枕送生日礼物','苦命鸳鸯抱枕董卓抽象爆款梗图创意抱枕装饰午休睡枕送生日礼物',6.30,350234,8,10,1,'2025-12-24 21:27:42','2025-12-25 02:15:57'),(26,'勒乐佛孙笑川肖像画挂画笑川佛祖漫展装饰画抽象艺术相框宿舍摆台','勒乐佛孙笑川肖像画挂画笑川佛祖漫展装饰画抽象艺术相框宿舍摆台',4.00,999,8,10,1,'2025-12-24 21:30:51','2025-12-25 02:15:57'),(27,'蘑菇','会在潮湿的树丛等等地方遍布生长',10.00,10,8,11,1,'2025-12-24 22:40:55','2025-12-25 02:15:57'),(28,'毒霉蘑菇','能在腐败的土地发现',10.00,10,8,11,1,'2025-12-24 22:43:20','2025-12-25 02:15:57'),(29,'稠液蘑菇','能在永恒之城，或是城附近发现',10.00,10,8,11,1,'2025-12-24 22:44:46','2025-12-25 02:15:57'),(30,'红肉蘑菇','能在幽影之地各处轻易取得',10.00,10,8,11,1,'2025-12-24 22:56:09','2025-12-25 02:15:57'),(31,'白肉蘑菇','能在幽影之地各处轻易取得',10.00,10,8,11,1,'2025-12-24 22:56:39','2025-12-25 02:15:57'),(32,'原石','原石（英语：primogems）是游戏《原神》及其衍生作品中的虚拟道具，被设定为\"由无主的梦想与希望凝结而成的辉光\"，主要用于角色与武器卡池抽取及体力资源补充 [5]。作为游戏内主要付费道具，可通过充值1:1兑换创世结晶获取，也可通过任务、探索和活动等免费途径积累。玩家每消耗160原石可兑换祈愿道具进行抽卡，每日最多消耗800原石兑换6次体力 [1]。系统提供\"空月祝福\"月卡服务，购买后可立即获得300创世结晶，并每日领取90原石持续30天，总计2700原石 [2] [6]。免费获取渠道包括每日委托（总计60原石/天）、魔神任务、宝箱探索、秘境挑战及版本活动奖励，其中开放世界探索与主线进程为长期稳定来源 [3-4]。原石还可用于提升珍珠纪行等级及在特定商店兑换高阶道具。',648.00,99992,8,9,1,'2025-12-24 22:58:27','2025-12-25 09:28:37'),(33,'无线耳机','无线耳机',128.00,100,8,9,1,'2026-01-01 10:11:31','2026-01-01 10:11:31');
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `DeleteProduct` BEFORE DELETE ON `product` FOR EACH ROW BEGIN
    -- 删除直接相关的数据
    DELETE FROM product_image WHERE product_image.product_id = OLD.product_id;
    DELETE FROM cart WHERE cart.product_id = OLD.product_id;
    DELETE FROM `order` WHERE `order`.product_id = OLD.product_id;

    -- 注意：不删除订单，避免复杂的关联查询
    -- 订单可以保留或者在应用层处理
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `product_image`
--

DROP TABLE IF EXISTS `product_image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_image` (
  `image_id` int NOT NULL AUTO_INCREMENT COMMENT '图片ID',
  `product_id` int NOT NULL COMMENT '商品ID',
  `image_url` varchar(255) NOT NULL COMMENT '图片URL',
  `sort_order` int NOT NULL COMMENT '排序顺序',
  PRIMARY KEY (`image_id`),
  UNIQUE KEY `product_sort` (`product_id`,`sort_order`),
  CONSTRAINT `product_image_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品图片表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_image`
--

LOCK TABLES `product_image` WRITE;
/*!40000 ALTER TABLE `product_image` DISABLE KEYS */;
INSERT INTO `product_image` VALUES (1,2,'/images/productImage/1/1.png',1),(2,2,'/images/productImage/1/2.png',2),(3,2,'/images/productImage/1/3.png',3),(4,2,'/images/productImage/1/4.png',4),(5,2,'/images/productImage/1/5.png',5),(6,2,'/images/productImage/1/6.png',6),(7,3,'/images/productImage/HachimiSoymilk/1.png',1),(8,3,'/images/productImage/HachimiSoymilk/2.png',2),(9,3,'/images/productImage/HachimiSoymilk/3.png',3),(10,3,'/images/productImage/HachimiSoymilk/4.png',4),(17,6,'/images/productImage/ZhiTaiTi600/1.png',1),(18,6,'/images/productImage/ZhiTaiTi600/2.png',2),(19,6,'/images/productImage/ZhiTaiTi600/3.png',3),(20,6,'/images/productImage/ZhiTaiTi600/4.png',4),(21,6,'/images/productImage/ZhiTaiTi600/5.png',5),(22,6,'/images/productImage/ZhiTaiTi600/6.png',6),(23,6,'/images/productImage/ZhiTaiTi600/7.png',7),(24,6,'/images/productImage/ZhiTaiTi600/8.png',8),(31,7,'/images/productImage/7/1.jpeg',1),(32,7,'/images/productImage/7/2.jpeg',2),(33,7,'/images/productImage/7/3.jpeg',3),(34,7,'/images/productImage/7/4.jpeg',4),(35,7,'/images/productImage/7/5.jpeg',5),(37,11,'/images/productImage/11/1.jpeg',1),(38,11,'/images/productImage/11/2.jpeg',2),(39,11,'/images/productImage/11/3.jpeg',3),(40,11,'/images/productImage/11/4.jpeg',4),(41,11,'/images/productImage/11/5.jpeg',5),(43,8,'/images/productImage/8/1.jpg',1),(45,12,'/images/productImage/12/1.jpg',1),(46,12,'/images/productImage/12/2.jpg',2),(47,12,'/images/productImage/12/3.jpg',3),(48,12,'/images/productImage/12/4.jpg',4),(49,12,'/images/productImage/12/5.jpg',5),(50,12,'/images/productImage/12/6.jpg',6),(51,12,'/images/productImage/12/7.jpg',7),(52,13,'/images/productImage/13/1.jpg',1),(53,13,'/images/productImage/13/2.jpg',2),(54,13,'/images/productImage/13/3.jpg',3),(55,13,'/images/productImage/13/4.jpg',4),(56,13,'/images/productImage/13/5.jpg',5),(57,13,'/images/productImage/13/6.jpg',6),(58,13,'/images/productImage/13/7.jpg',7),(59,14,'/images/productImage/14/1.jpg',1),(60,14,'/images/productImage/14/2.jpg',2),(61,14,'/images/productImage/14/3.jpg',3),(62,14,'/images/productImage/14/4.jpg',4),(63,14,'/images/productImage/14/5.jpg',5),(64,14,'/images/productImage/14/6.jpg',6),(65,15,'/images/productImage/15/1.jpg',1),(66,16,'/images/productImage/16/1.jpg',1),(67,17,'/images/productImage/17/1.jpg',1),(68,19,'/images/productImage/19/1.jpg',1),(69,20,'/images/productImage/20/1.jpeg',1),(70,20,'/images/productImage/20/2.jpeg',2),(71,20,'/images/productImage/20/3.jpeg',3),(72,21,'/images/productImage/21/1.jpg',1),(73,21,'/images/productImage/21/2.jpg',2),(74,21,'/images/productImage/21/3.jpg',3),(75,21,'/images/productImage/21/4.jpg',4),(76,22,'/images/productImage/22/1.jpg',1),(77,22,'/images/productImage/22/2.jpg',2),(78,23,'/images/productImage/23/1.webp',1),(79,23,'/images/productImage/23/2.jpeg',2),(80,23,'/images/productImage/23/3.jpeg',3),(81,24,'/images/productImage/24/1.jpeg',1),(82,24,'/images/productImage/24/2.jpeg',2),(83,24,'/images/productImage/24/3.jpeg',3),(84,24,'/images/productImage/24/4.jpeg',4),(85,25,'/images/productImage/25/1.jpeg',1),(86,25,'/images/productImage/25/2.jpeg',2),(87,26,'/images/productImage/26/1.jpeg',1),(88,26,'/images/productImage/26/2.jpeg',2),(89,26,'/images/productImage/26/3.jpeg',3),(90,26,'/images/productImage/26/4.jpeg',4),(91,26,'/images/productImage/26/5.jpeg',5),(92,27,'/images/productImage/27/1.jpg',1),(93,28,'/images/productImage/28/1.jpg',1),(94,29,'/images/productImage/29/1.jpg',1),(95,30,'/images/productImage/30/1.jpg',1),(96,31,'/images/productImage/31/1.jpg',1),(97,32,'/images/productImage/32/1.png',1);
/*!40000 ALTER TABLE `product_image` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review`
--

DROP TABLE IF EXISTS `review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review` (
  `review_id` int NOT NULL AUTO_INCREMENT COMMENT '评价ID',
  `order_id` int NOT NULL COMMENT '订单ID',
  `user_id` int NOT NULL COMMENT '用户ID',
  `content` text NOT NULL COMMENT '评价内容',
  `rating` tinyint NOT NULL COMMENT '评价等级',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`review_id`),
  UNIQUE KEY `order_id` (`order_id`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_user_id_time` (`user_id`,`create_time` DESC),
  KEY `idx_create_time` (`create_time` DESC),
  CONSTRAINT `review_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `order_detail` (`order_id`),
  CONSTRAINT `review_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='评价表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review`
--

LOCK TABLES `review` WRITE;
/*!40000 ALTER TABLE `review` DISABLE KEYS */;
INSERT INTO `review` VALUES (5,12,7,'很好的fufu',5,'2025-12-25 01:35:52'),(6,14,7,'1',5,'2025-12-25 01:57:43'),(7,16,7,'非常屑的魔女',5,'2025-12-25 08:22:58'),(8,23,15,'smz到此一游',5,'2026-01-04 01:00:34'),(9,18,1,'好！',5,'2026-01-04 13:18:07');
/*!40000 ALTER TABLE `review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role` (
  `role_id` int NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(50) NOT NULL COMMENT '角色名称',
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `role_name` (`role_name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES (2,'商家'),(1,'用户'),(3,'管理员');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shop`
--

DROP TABLE IF EXISTS `shop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shop` (
  `shop_id` int NOT NULL AUTO_INCREMENT COMMENT '店铺ID',
  `shop_name` varchar(50) NOT NULL COMMENT '店铺名称',
  `owner_id` int NOT NULL COMMENT '店主ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`shop_id`),
  UNIQUE KEY `shop_name` (`shop_name`),
  KEY `owner_id` (`owner_id`),
  CONSTRAINT `shop_ibfk_1` FOREIGN KEY (`owner_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='店铺表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shop`
--

LOCK TABLES `shop` WRITE;
/*!40000 ALTER TABLE `shop` DISABLE KEYS */;
INSERT INTO `shop` VALUES (1,'fufu贩卖',1,'2025-12-04 20:44:21','2025-12-04 20:44:21'),(2,'九阳豆浆',1,'2025-12-09 08:23:25','2025-12-09 08:23:25'),(4,'颂潮食品旗舰店',1,'2025-12-09 20:14:28','2025-12-09 20:14:28'),(5,'太刀虾聚集地',6,'2025-12-24 19:09:47','2025-12-24 19:09:47'),(6,'My shop',5,'2025-12-24 19:12:19','2025-12-24 19:12:19'),(7,'海菜汤杂货店',1,'2025-12-24 19:55:54','2025-12-24 19:55:54'),(9,'神人杂货铺',9,'2025-12-24 21:00:40','2025-12-24 23:02:01'),(10,'棒棒宝贝杂货店',6,'2025-12-24 21:23:57','2025-12-24 21:23:57'),(11,'蘑菇贩子的破屋',10,'2025-12-24 22:18:24','2025-12-24 22:18:24'),(12,'雨鹿烤菇大排档',6,'2025-12-25 08:25:30','2025-12-25 08:25:30');
/*!40000 ALTER TABLE `shop` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `InsertShopOwnerRole` AFTER INSERT ON `shop` FOR EACH ROW BEGIN
    -- 检查用户是否已经有商家角色，如果没有则添加
    IF NOT EXISTS (SELECT 1 FROM user_role WHERE user_id = NEW.owner_id AND role_id = 2) THEN
        INSERT INTO user_role (user_id, role_id) VALUES (NEW.owner_id, 2);
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `DeleteShop` BEFORE DELETE ON `shop` FOR EACH ROW BEGIN
    -- 只删除商品，让DeleteProduct触发器处理其余的
    DELETE FROM product WHERE shop_id = OLD.shop_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_id` int NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `password` varchar(255) NOT NULL COMMENT '密码',
  `email` varchar(255) NOT NULL COMMENT '邮箱',
  `phone` varchar(20) NOT NULL COMMENT '手机号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'海菜汤','$2a$10$kr.eFxgwZsHWgoFid/SRrO9ITOKXyCR1d5XLR9AXGDcWPt8i9s9NS','114514@qq.com','13811111111','2025-12-04 20:44:12','2025-12-12 21:03:42'),(3,'admin','$2a$10$TxZdTdfrcLJ8ONH3VnmBKesXVnzpCd5ytWqQxRyQp2AVjBwAGuqZa','1@qq.com','18125260731','2025-12-09 01:14:20','2025-12-09 13:07:03'),(4,'2333','$2a$10$1EVov4QguI809uhBr0rEH.FUDBHxwi5cY3D9F9j0.DKJm2OGGTK9.','114@qq.com','18100000000','2025-12-09 13:05:29','2025-12-09 13:05:29'),(5,'xiao_xuan','$2a$10$8XlBqR1dLilSWm/nMrKlAObjBat3nn0.biZjoGmxzyhV.gMGHZgAi','3213288127@qq.com','19876822631','2025-12-24 19:06:49','2025-12-24 19:06:49'),(6,'YingZi','$2a$10$P6yV4lTGxyHOdDQ3dus0nu8mTmX9qmblnojpAxQ3op.GI7OsCNRci','2426779167@qq.com','18998551892','2025-12-24 19:08:17','2025-12-24 19:08:17'),(7,'Laur','$2a$10$7PIMoziB2kHfU6dgvT0soODEcZqikqglyVb7ATOSUcT5cq5cKxouS','eev56mwgs815@nothingbuttojitasekai.xyz','13122222222','2025-12-24 19:52:31','2025-12-24 19:52:31'),(8,'qwert','$2a$10$ORuXt4u7vlt/4rlxbES2HOfvYdyw4QPO1h6KXuLLHe.IOMJ3ys0UW','1234567@qq.com','19012345678','2025-12-24 20:51:49','2025-12-24 20:51:49'),(9,'chen','$2a$10$zLfmkhabNPhRHQTXO8MJKOaBZSpK9Cyp53p9TuhhgNLL4S2giKl2W','3537945707@qq.com','13712345678','2025-12-24 20:54:38','2025-12-24 20:54:38'),(10,'菇比巴卜','$2a$10$mPAtGaUg3S7kaatvPqCeXeoFrrRav1/g3NBCI0QbCwKibYp9kBqKG','signor.mq829@qq.com','13660594404','2025-12-24 22:17:05','2025-12-24 22:17:05'),(11,'wfy','$2a$10$wUtLvJ69DC4PLNjmkYmXue/B4y3yyVb4L5fyaeP3VQyFm5Bhg4Wfy','3463033752@qq.com','18929781128','2025-12-25 08:37:35','2025-12-25 08:37:35'),(12,'133','$2a$10$kr.eFxgwZsHWgoFid/SRrO9ITOKXyCR1d5XLR9AXGDcWPt8i9s9NS','merchant001@qq.com','13922222222','2026-01-01 10:04:25','2026-01-01 10:04:25'),(15,'123','$2a$10$XXS/TroWmiGDqdEH.mwF5uKZ5.esOOKPwWnmUe3Uj.RPrAP90fpAK','123456@qq.com','13413901235','2026-01-04 00:36:20','2026-01-04 00:56:09');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `DefaultUserRole` AFTER INSERT ON `user` FOR EACH ROW begin
    insert into user_role (user_id, role_id) values (new.user_id, 1);
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `DeleteUser` BEFORE DELETE ON `user` FOR EACH ROW begin
        delete from shop where shop.owner_id = old.user_id;
        delete from user_role where user_role.user_id = old.user_id;
        delete from cart where cart.user_id = old.user_id;
        delete from `order` where `order`.user_id = old.user_id;
    end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `user_role`
--

DROP TABLE IF EXISTS `user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_role` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '用户角色关系ID',
  `user_id` int NOT NULL COMMENT '用户ID',
  `role_id` int NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_role` (`user_id`,`role_id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `user_role_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  CONSTRAINT `user_role_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `role` (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户角色关系表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_role`
--

LOCK TABLES `user_role` WRITE;
/*!40000 ALTER TABLE `user_role` DISABLE KEYS */;
INSERT INTO `user_role` VALUES (2,1,1),(3,1,2),(16,1,3),(1,3,1),(5,5,1),(8,5,2),(6,6,1),(7,6,2),(9,7,1),(10,8,1),(11,9,1),(12,9,2),(13,10,1),(14,10,2),(15,11,1),(17,12,1),(18,15,1);
/*!40000 ALTER TABLE `user_role` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-04 13:31:34
