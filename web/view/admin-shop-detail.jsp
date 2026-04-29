<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="zh-CN">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>商铺详情 - 管理员控制台</title>
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }

                body {
                    font-family: 'Microsoft YaHei', Arial, sans-serif;
                    background-color: #f5f7fa;
                    padding-top: 70px;
                }

                .container {
                    max-width: 1200px;
                    margin: 0 auto;
                    padding: 20px;
                }

                .breadcrumb {
                    margin-bottom: 20px;
                }

                .breadcrumb a {
                    color: #667eea;
                    text-decoration: none;
                }

                .breadcrumb a:hover {
                    text-decoration: underline;
                }

                .shop-header {
                    background: white;
                    padding: 25px;
                    border-radius: 12px;
                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                    margin-bottom: 20px;
                }

                .shop-title {
                    font-size: 24px;
                    font-weight: 600;
                    color: #333;
                    margin-bottom: 15px;
                }

                .shop-info {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                    gap: 20px;
                }

                .info-item {
                    display: flex;
                    flex-direction: column;
                }

                .info-label {
                    font-size: 14px;
                    color: #666;
                    margin-bottom: 5px;
                }

                .info-value {
                    font-size: 16px;
                    color: #333;
                    font-weight: 500;
                }

                .stats-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                    gap: 20px;
                    margin-bottom: 20px;
                }

                .stat-card {
                    background: white;
                    padding: 20px;
                    border-radius: 12px;
                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                    text-align: center;
                }

                .stat-number {
                    font-size: 24px;
                    font-weight: 700;
                    color: #667eea;
                    margin-bottom: 8px;
                }

                .stat-label {
                    font-size: 14px;
                    color: #666;
                }

                .section {
                    background: white;
                    border-radius: 12px;
                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                    overflow: hidden;
                    margin-bottom: 20px;
                }

                .section-header {
                    padding: 20px 25px;
                    border-bottom: 1px solid #e2e8f0;
                    font-size: 18px;
                    font-weight: 600;
                    color: #333;
                }

                .data-table {
                    width: 100%;
                    border-collapse: collapse;
                }

                .data-table th,
                .data-table td {
                    padding: 12px 15px;
                    text-align: left;
                    border-bottom: 1px solid #e2e8f0;
                }

                .data-table th {
                    background-color: #f8fafc;
                    font-weight: 600;
                    color: #4a5568;
                    font-size: 14px;
                }

                .data-table td {
                    color: #2d3748;
                }

                .data-table tr:hover {
                    background-color: #f7fafc;
                }

                .product-name {
                    font-weight: 500;
                    max-width: 200px;
                    overflow: hidden;
                    text-overflow: ellipsis;
                    white-space: nowrap;
                }

                .product-price {
                    font-weight: 600;
                    color: #e53e3e;
                }

                .status-badge {
                    padding: 4px 8px;
                    border-radius: 12px;
                    font-size: 12px;
                    font-weight: 500;
                }

                .status-unpaid {
                    background-color: #fed7d7;
                    color: #c53030;
                }

                .status-paid_pending_shipment {
                    background-color: #fef5e7;
                    color: #dd6b20;
                }

                .status-shipped_pending_receipt {
                    background-color: #e6fffa;
                    color: #319795;
                }

                .status-completed {
                    background-color: #f0fff4;
                    color: #38a169;
                }

                .status-cancelled {
                    background-color: #e2e8f0;
                    color: #718096;
                }

                .status-listed {
                    background-color: #f0fff4;
                    color: #38a169;
                }

                .status-unlisted {
                    background-color: #fed7d7;
                    color: #c53030;
                }

                .btn {
                    padding: 8px 16px;
                    border: none;
                    border-radius: 6px;
                    text-decoration: none;
                    font-size: 14px;
                    font-weight: 500;
                    cursor: pointer;
                    transition: all 0.3s;
                    display: inline-flex;
                    align-items: center;
                    gap: 5px;
                }

                .btn-secondary {
                    background-color: #e2e8f0;
                    color: #4a5568;
                }

                .btn-secondary:hover {
                    background-color: #cbd5e0;
                }

                .empty-state {
                    text-align: center;
                    padding: 40px;
                    color: #666;
                }

                @media (max-width: 768px) {
                    .container {
                        padding: 10px;
                    }

                    .shop-info {
                        grid-template-columns: 1fr;
                    }

                    .stats-grid {
                        grid-template-columns: 1fr;
                    }
                }
            </style>
        </head>

        <body>
            <!-- 导航栏 -->
            <%@ include file="head.jsp" %>

                <div class="container">
                    <!-- 面包屑导航 -->
                    <div class="breadcrumb">
                        <a href="${pageContext.request.contextPath}/AdminDashboardServlet">管理员控制台</a> >
                        <a href="${pageContext.request.contextPath}/AdminDashboardServlet?action=shops">商铺管理</a> > 商铺详情
                    </div>

                    <!-- 商铺基本信息 -->
                    <div class="shop-header">
                        <div class="shop-title">商铺详情 - ${shop.shop_name}</div>
                        <div class="shop-info">
                            <div class="info-item">
                                <div class="info-label">商铺ID</div>
                                <div class="info-value">${shop.shop_id}</div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">商铺名称</div>
                                <div class="info-value">${shop.shop_name}</div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">店主ID</div>
                                <div class="info-value">${shop.owner_id}</div>
                            </div>
                            <c:if test="${not empty owner}">
                                <div class="info-item">
                                    <div class="info-label">店主用户名</div>
                                    <div class="info-value">${owner.username}</div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">店主邮箱</div>
                                    <div class="info-value">${owner.email}</div>
                                </div>
                            </c:if>
                            <div class="info-item">
                                <div class="info-label">创建时间</div>
                                <div class="info-value">${shop.create_time}</div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">更新时间</div>
                                <div class="info-value">${shop.update_time}</div>
                            </div>
                        </div>
                    </div>

                    <!-- 统计信息 -->
                    <div class="stats-grid">
                        <div class="stat-card">
                            <div class="stat-number">${shopProducts.size()}</div>
                            <div class="stat-label">总商品数</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-number">${listedProducts}</div>
                            <div class="stat-label">已上架商品</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-number">${shopOrders.size()}</div>
                            <div class="stat-label">总订单数</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-number">¥${totalRevenue}</div>
                            <div class="stat-label">总销售额</div>
                        </div>
                    </div>

                    <!-- 商铺商品 -->
                    <div class="section">
                        <div class="section-header">商铺商品 (${shopProducts.size()} 个)</div>
                        <c:choose>
                            <c:when test="${not empty shopProducts}">
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th>商品ID</th>
                                            <th>商品名称</th>
                                            <th>价格</th>
                                            <th>库存</th>
                                            <th>状态</th>
                                            <th>创建时间</th>
                                            <th>操作</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="product" items="${shopProducts}">
                                            <tr>
                                                <td>${product.product_id}</td>
                                                <td class="product-name" title="${product.product_name}">
                                                    ${product.product_name}
                                                </td>
                                                <td class="product-price">¥${product.price}</td>
                                                <td>${product.stock}</td>
                                                <td>
                                                    <span
                                                        class="status-badge ${product.product_listing ? 'status-listed' : 'status-unlisted'}">
                                                        ${product.product_listing ? '已上架' : '已下架'}
                                                    </span>
                                                </td>
                                                <td>${product.create_time}</td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/ProductDetailServlet?id=${product.product_id}"
                                                        class="btn btn-secondary" target="_blank">查看详情</a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">该商铺暂无商品</div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- 商铺订单 -->
                    <div class="section">
                        <div class="section-header">商铺订单 (${shopOrders.size()} 个)</div>
                        <c:choose>
                            <c:when test="${not empty shopOrders}">
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th>订单ID</th>
                                            <th>用户ID</th>
                                            <th>订单金额</th>
                                            <th>订单状态</th>
                                            <th>创建时间</th>
                                            <th>操作</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="order" items="${shopOrders}">
                                            <tr>
                                                <td>${order.order_id}</td>
                                                <td>${order.user_id}</td>
                                                <td class="product-price">¥${order.total_amount}</td>
                                                <td>
                                                    <span class="status-badge status-${order.order_status}">
                                                        <c:choose>
                                                            <c:when test="${order.order_status == 'unpaid'}">未支付
                                                            </c:when>
                                                            <c:when
                                                                test="${order.order_status == 'paid_pending_shipment'}">
                                                                待发货</c:when>
                                                            <c:when
                                                                test="${order.order_status == 'shipped_pending_receipt'}">
                                                                待收货</c:when>
                                                            <c:when test="${order.order_status == 'completed'}">已完成
                                                            </c:when>
                                                            <c:when test="${order.order_status == 'cancelled'}">已取消
                                                            </c:when>
                                                            <c:otherwise>${order.order_status}</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </td>
                                                <td>${order.create_time}</td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/AdminOrderDetailServlet?orderId=${order.order_id}"
                                                        class="btn btn-secondary" target="_blank">查看详情</a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">该商铺暂无订单</div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- 返回按钮 -->
                    <div style="margin-top: 20px; text-align: center;">
                        <a href="${pageContext.request.contextPath}/AdminDashboardServlet?action=shops"
                            class="btn btn-secondary">返回商铺管理</a>
                    </div>
                </div>
        </body>

        </html>