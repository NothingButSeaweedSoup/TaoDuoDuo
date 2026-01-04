# 淘多多电商平台

## 项目简介
基于Java Web的电商平台，支持用户购物、商家管理和平台管理功能。

## 主要功能

### 用户功能
- 商品浏览和搜索
- 购物车管理
- 订单管理
- 商品评价

### 商家功能
- 商铺管理
- 商品管理
- 订单处理

### 管理员功能
- 平台数据统计
- 商铺管理
- 商品管理
- 订单管理
- 用户管理

## 技术栈
- **后端**: Java, Servlet, JSP
- **数据库**: MySQL
- **前端**: HTML, CSS, JavaScript
- **服务器**: Tomcat

## 管理员设置

管理员权限需要通过数据库直接设置：

```sql
-- 为用户ID为1的用户添加管理员权限
INSERT INTO user_role (user_id, role_id) VALUES (1, 3);
```

## 项目结构
```
src/main/java/com/TaoDuoDuo/
├── dao/          # 数据访问层
├── entity/       # 实体类
├── service/      # 业务逻辑层
├── servlet/      # 控制层
└── util/         # 工具类

web/
├── view/         # JSP页面
├── icon/         # 图标资源
└── images/       # 图片资源
```

## 部署
修改alipay.properties文件，将支付宝的app_id、private_key、public_key替换为自己的。
开启内网穿透，将alipay.notify.url和alipay.return.url内的链接替换为内网穿透后的链接。（调用支付宝接口时需要使用公网地址）
修改db.properties文件，将数据库的连接信息替换为自己的。
运行tdd_db.sql文件，创建数据库和表。