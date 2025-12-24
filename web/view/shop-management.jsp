<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.TaoDuoDuo.entity.Shop" %>
        <%@ page import="java.util.List" %>
            <%@ page import="java.time.format.DateTimeFormatter" %>
                <!DOCTYPE html>
                <html lang="zh-CN">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>商铺管理 - 淘多多</title>
                    <style>
                        * {
                            box-sizing: border-box;
                        }

                        body {
                            margin: 0;
                            padding: 110px 20px 40px;
                            background-color: #f5f5f5;
                            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Microsoft YaHei", sans-serif;
                            min-height: 100vh;
                        }

                        .container {
                            max-width: 1200px;
                            margin: 0 auto;
                        }

                        .page-header {
                            background: white;
                            border-radius: 12px;
                            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
                            padding: 30px;
                            margin-bottom: 30px;
                            text-align: center;
                        }

                        .page-title {
                            font-size: 28px;
                            font-weight: 600;
                            color: #262626;
                            margin: 0 0 10px 0;
                        }

                        .page-subtitle {
                            font-size: 16px;
                            color: #8c8c8c;
                            margin: 0;
                        }

                        .content-card {
                            background: white;
                            border-radius: 12px;
                            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
                            padding: 30px;
                            margin-bottom: 30px;
                        }

                        .message {
                            padding: 15px 20px;
                            border-radius: 8px;
                            margin-bottom: 20px;
                            font-size: 15px;
                        }

                        .message.success {
                            background: #f6ffed;
                            border: 1px solid #b7eb8f;
                            color: #52c41a;
                        }

                        .message.error {
                            background: #fff2f0;
                            border: 1px solid #ffccc7;
                            color: #ff4d4f;
                        }

                        .shop-list {
                            display: grid;
                            gap: 20px;
                        }

                        .shop-item {
                            border: 1px solid #f0f0f0;
                            border-radius: 12px;
                            padding: 25px;
                            transition: all 0.3s;
                            background: #fafafa;
                        }

                        .shop-item:hover {
                            border-color: #667eea;
                            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.1);
                        }

                        .shop-header {
                            display: flex;
                            justify-content: space-between;
                            align-items: flex-start;
                            margin-bottom: 20px;
                        }

                        .shop-info h3 {
                            font-size: 20px;
                            font-weight: 600;
                            color: #262626;
                            margin: 0 0 8px 0;
                        }

                        .shop-meta {
                            font-size: 14px;
                            color: #8c8c8c;
                            line-height: 1.5;
                        }

                        .shop-actions {
                            display: flex;
                            gap: 10px;
                        }

                        .btn {
                            padding: 8px 20px;
                            border: none;
                            border-radius: 6px;
                            font-size: 14px;
                            font-weight: 500;
                            cursor: pointer;
                            text-decoration: none;
                            display: inline-block;
                            transition: all 0.3s;
                        }

                        .btn-primary {
                            background: #667eea;
                            color: white;
                        }

                        .btn-primary:hover {
                            background: #5a67d8;
                            transform: translateY(-1px);
                        }

                        .btn-secondary {
                            background: #f5f5f5;
                            color: #595959;
                            border: 1px solid #d9d9d9;
                        }

                        .btn-secondary:hover {
                            background: #e8e8e8;
                            border-color: #bfbfbf;
                        }

                        .empty-state {
                            text-align: center;
                            padding: 60px 20px;
                            color: #8c8c8c;
                        }

                        .empty-state .icon {
                            font-size: 64px;
                            margin-bottom: 20px;
                        }

                        .empty-state h3 {
                            font-size: 18px;
                            margin: 0 0 10px 0;
                            color: #595959;
                        }

                        .empty-state p {
                            font-size: 14px;
                            margin: 0 0 20px 0;
                        }

                        .back-link {
                            display: inline-flex;
                            align-items: center;
                            gap: 8px;
                            color: #667eea;
                            text-decoration: none;
                            font-size: 14px;
                            margin-bottom: 20px;
                            transition: all 0.3s;
                        }

                        .back-link:hover {
                            color: #5a67d8;
                        }

                        /* 响应式设计 */
                        @media (max-width: 768px) {
                            .shop-header {
                                flex-direction: column;
                                gap: 15px;
                            }

                            .shop-actions {
                                align-self: flex-start;
                            }

                            .form-input {
                                max-width: 100%;
                            }
                        }
                    </style>
                </head>

                <body>
                    <%@ include file="head.jsp" %>

                        <div class="container">
                            <!-- 页面头部 -->
                            <div class="page-header">
                                <h1 class="page-title">
                                    <img src="${pageContext.request.contextPath}/icon/Shop.png" alt="商铺管理"
                                        style="width: 32px; height: 32px; vertical-align: middle; margin-right: 10px;">
                                    商铺管理
                                </h1>
                                <p class="page-subtitle">管理您的店铺信息，修改店铺名称</p>
                            </div>

                            <!-- 返回链接 -->
                            <a href="${pageContext.request.contextPath}/ProfileServlet" class="back-link">
                                ← 返回个人中心
                            </a>

                            <div class="content-card">
                                <!-- 消息显示 -->
                                <% String success=(String) request.getAttribute("success"); String error=(String)
                                    request.getAttribute("error"); String shopName=request.getParameter("shopName"); %>

                                    <% if (success !=null) { %>
                                        <div class="message success">
                                            <% if ("shop_updated".equals(success)) { %>
                                                ✓ 店铺信息更新成功！新店铺名称：<%= shopName !=null ? shopName : "" %>
                                                    <% } else { %>
                                                        ✓ 操作成功！
                                                        <% } %>
                                        </div>
                                        <% } %>

                                            <% if (error !=null) { %>
                                                <div class="message error">
                                                    ✗
                                                    <% if ("no_permission".equals(error)) { %>
                                                        您没有权限执行此操作
                                                        <% } else if ("invalid_params".equals(error)) { %>
                                                            参数错误，请检查输入
                                                            <% } else if ("name_length".equals(error)) { %>
                                                                店铺名称长度必须在2-50个字符之间
                                                                <% } else if ("shop_not_found".equals(error)) { %>
                                                                    店铺不存在
                                                                    <% } else if ("name_exists".equals(error)) { %>
                                                                        店铺名称已被使用，请更换其他名称
                                                                        <% } else if ("invalid_shop_id".equals(error)) {
                                                                            %>
                                                                            无效的店铺ID
                                                                            <% } else if ("system_error".equals(error))
                                                                                { %>
                                                                                系统错误，请稍后重试
                                                                                <% } else { %>
                                                                                    操作失败，请重试
                                                                                    <% } %>
                                                </div>
                                                <% } %>

                                                    <!-- 店铺列表 -->
                                                    <% Boolean hasShops=(Boolean) request.getAttribute("hasShops");
                                                        List<Shop> userShops = (List<Shop>)
                                                            request.getAttribute("userShops");
                                                            %>

                                                            <% if (hasShops !=null && hasShops && userShops !=null) { %>
                                                                <div class="shop-list">
                                                                    <% for (Shop shop : userShops) { %>
                                                                        <div class="shop-item">
                                                                            <div class="shop-header">
                                                                                <div class="shop-info">
                                                                                    <h3>
                                                                                        <%= shop.getShop_name() %>
                                                                                    </h3>
                                                                                    <div class="shop-meta">
                                                                                        <div>店铺ID: <%= shop.getShop_id()
                                                                                                %>
                                                                                        </div>
                                                                                        <div>创建时间: <%=
                                                                                                shop.getCreate_time()
                                                                                                !=null ?
                                                                                                shop.getCreate_time().format(DateTimeFormatter.ofPattern("yyyy-MM-ddHH:mm:ss")) : "未知" %>
                                                                                        </div>
                                                                                        <% if (shop.getUpdate_time()
                                                                                            !=null &&
                                                                                            !shop.getUpdate_time().equals(shop.getCreate_time()))
                                                                                            { %>
                                                                                            <div>更新时间: <%=
                                                                                                    shop.getUpdate_time().format(DateTimeFormatter.ofPattern("yyyy-MM-ddHH:mm:ss")) %>
                                                                                            </div>
                                                                                            <% } %>
                                                                                    </div>
                                                                                </div>
                                                                                <div class="shop-actions">
                                                                                    <a href="${pageContext.request.contextPath}/ShopDetailServlet?shopId=<%= shop.getShop_id() %>"
                                                                                        class="btn btn-primary">
                                                                                        <img src="${pageContext.request.contextPath}/icon/ProductManaging.png"
                                                                                            alt="管理"
                                                                                            style="width: 16px; height: 16px; vertical-align: middle; margin-right: 5px;">
                                                                                        管理店铺
                                                                                    </a>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                        <% } %>
                                                                </div>
                                                                <% } else { %>
                                                                    <!-- 空状态 -->
                                                                    <div class="empty-state">
                                                                        <div class="icon">🏪</div>
                                                                        <h3>暂无店铺</h3>
                                                                        <p>您还没有创建任何店铺，请先申请商家入驻</p>
                                                                        <a href="${pageContext.request.contextPath}/ProfileServlet"
                                                                            class="btn btn-primary">
                                                                            前往申请入驻
                                                                        </a>
                                                                    </div>
                                                                    <% } %>
                            </div>
                        </div>

                </body>

                </html>