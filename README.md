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

## 环境配置

### 数据库配置
1. 复制 `src/main/resources/db.properties.example` 为 `src/main/resources/db.properties`
2. 修改数据库连接信息：
   ```properties
   db.url=jdbc:mysql://localhost:3306/your_database_name?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
   db.user=your_username
   db.password=your_password
   ```
3. 运行 `src/main/resources/tdd_db.sql` 创建数据库和表

### 支付宝沙箱配置
1. 复制 `src/main/resources/alipay.properties.example` 为 `src/main/resources/alipay.properties`
2. 在[支付宝开放平台](https://open.alipay.com/)申请沙箱应用
3. 修改支付宝配置信息：
   ```properties
   alipay.app.id=你的应用ID
   alipay.app.private.key=你的应用私钥
   alipay.public.key=支付宝公钥
   alipay.notify.url=http://你的域名:端口/TaoDuoDuo_war_exploded/notify
   alipay.return.url=http://你的域名:端口/TaoDuoDuo_war_exploded/toSuccess.jsp
   ```
4. 如需测试支付功能，请配置内网穿透工具（如ngrok）获取公网地址

### 注意事项
- 配置文件包含敏感信息，请勿提交到版本控制系统
- 生产环境请使用正式的支付宝应用配置
- 确保数据库用户具有足够的权限

## 部署