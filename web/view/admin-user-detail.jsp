<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="zh-CN">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>用户详情 - 管理员控制台</title>
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

                .user-header {
                    background: white;
                    padding: 25px;
                    border-radius: 12px;
                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                    margin-bottom: 20px;
                }

                .user-title {
                    font-size: 24px;
                    font-weight: 600;
                    color: #333;
                    margin-bottom: 15px;
                }

                .user-info {
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

                    .user-info {
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
                        <a href="${pageContext.request.contextPath}/AdminDashboardServlet?action=users">用户管理</a> > 用户详情
                    </div>

                    <!-- 用户基本信息 -->
                    <div class="user-header">
                        <div class="user-title">用户详情 - ${user.username}</div>
                        <div class="user-info">
                            <div class="info-item">
                                <div class="info-label">用户ID</div>
                                <div class="info-value">${user.user_id}</div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">用户名</div>
                                <div class="info-value">${user.username}</div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">邮箱</div>
                                <div class="info-value">${user.email}</div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">手机号</div>
                                <div class="info-value">${user.phone}</div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">注册时间</div>
                                <div class="info-value">${user.create_time}</div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">最后更新</div>
                                <div class="info-value">${user.update_time}</div>
                            </div>
                        </div>
                    </div>

                    <!-- 统计信息 -->
                    <div class="stats-grid">
                        <div class="stat-card">
                            <div class="stat-number">${userOrders.size()}</div>
                            <div class="stat-label">总订单数</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-number">${completedOrders}</div>
                            <div class="stat-label">已完成订单</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-number">¥${totalSpent}</div>
                            <div class="stat-label">总消费金额</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-number">${userShops.size()}</div>
                            <div class="stat-label">拥有商铺数</div>
                        </div>
                    </div>

                    <!-- 用户订单 -->
                    <div class="section">
                        <div class="section-header">用户订单 (${userOrders.size()} 个)</div>
                        <c:choose>
                            <c:when test="${not empty userOrders}">
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th>订单ID</th>
                                            <th>商铺ID</th>
                                            <th>订单金额</th>
                                            <th>订单状态</th>
                                            <th>创建时间</th>
                                            <th>操作</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="order" items="${userOrders}">
                                            <tr>
                                                <td>${order.order_id}</td>
                                                <td>${order.shop_id}</td>
                                                <td>¥${order.total_amount}</td>
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
                                <div class="empty-state">该用户暂无订单</div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- 用户商铺 -->
                    <div class="section">
                        <div class="section-header">用户商铺 (${userShops.size()} 个)</div>
                        <c:choose>
                            <c:when test="${not empty userShops}">
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th>商铺ID</th>
                                            <th>商铺名称</th>
                                            <th>创建时间</th>
                                            <th>更新时间</th>
                                            <th>操作</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="shop" items="${userShops}">
                                            <tr>
                                                <td>${shop.shop_id}</td>
                                                <td>${shop.shop_name}</td>
                                                <td>${shop.create_time}</td>
                                                <td>${shop.update_time}</td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/AdminShopDetailServlet?shopId=${shop.shop_id}"
                                                        class="btn btn-secondary" target="_blank">查看详情</a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">该用户暂无商铺</div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- 返回按钮 -->
                    <div style="margin-top: 20px; text-align: center;">
                        <a href="${pageContext.request.contextPath}/AdminDashboardServlet?action=users"
                            class="btn btn-secondary">返回用户管理</a>
                    </div>
                </div>
        </body>

        </html>