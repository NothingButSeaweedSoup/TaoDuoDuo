<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="zh-CN">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>订单详情 - 管理员控制台</title>
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

                    .order-header {
                        background: white;
                        padding: 25px;
                        border-radius: 12px;
                        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                        margin-bottom: 20px;
                    }

                    .order-title {
                        font-size: 24px;
                        font-weight: 600;
                        color: #333;
                        margin-bottom: 15px;
                    }

                    .order-info {
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

                    .section-content {
                        padding: 20px 25px;
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

                    .customer-info {
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                        gap: 15px;
                    }

                    .shop-info {
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                        gap: 15px;
                    }

                    .order-summary {
                        background: #f8fafc;
                        padding: 20px;
                        border-radius: 8px;
                        margin-top: 20px;
                    }

                    .summary-row {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        margin-bottom: 10px;
                    }

                    .summary-label {
                        font-size: 14px;
                        color: #666;
                    }

                    .summary-value {
                        font-size: 14px;
                        color: #333;
                        font-weight: 500;
                    }

                    .total-row {
                        font-size: 18px;
                        font-weight: 700;
                        color: #e53e3e;
                        border-top: 1px solid #e2e8f0;
                        padding-top: 10px;
                        margin-top: 10px;
                    }

                    .btn {
                        padding: 10px 20px;
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

                        .order-info,
                        .customer-info,
                        .shop-info {
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
                            <a href="${pageContext.request.contextPath}/AdminDashboardServlet?action=orders">订单管理</a> >
                            订单详情
                        </div>

                        <!-- 订单基本信息 -->
                        <div class="order-header">
                            <div class="order-title">订单详情 - #${order.order_id}</div>
                            <div class="order-info">
                                <div class="info-item">
                                    <div class="info-label">订单ID</div>
                                    <div class="info-value">${order.order_id}</div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">下单时间</div>
                                    <div class="info-value">${order.create_time}</div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">更新时间</div>
                                    <div class="info-value">${order.update_time}</div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">订单状态</div>
                                    <div class="info-value">
                                        <span class="status-badge status-${order.order_status}">
                                            <c:choose>
                                                <c:when test="${order.order_status == 'unpaid'}">未支付</c:when>
                                                <c:when test="${order.order_status == 'paid_pending_shipment'}">待发货
                                                </c:when>
                                                <c:when test="${order.order_status == 'shipped_pending_receipt'}">待收货
                                                </c:when>
                                                <c:when test="${order.order_status == 'completed'}">已完成</c:when>
                                                <c:when test="${order.order_status == 'cancelled'}">已取消</c:when>
                                                <c:otherwise>${order.order_status}</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">订单金额</div>
                                    <div class="info-value" style="color: #e53e3e; font-weight: 600;">
                                        ¥${order.total_amount}</div>
                                </div>
                                <c:if test="${not empty order.alipay_order_no}">
                                    <div class="info-item">
                                        <div class="info-label">支付宝订单号</div>
                                        <div class="info-value">${order.alipay_order_no}</div>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <!-- 客户信息 -->
                        <div class="section">
                            <div class="section-header">客户信息</div>
                            <div class="section-content">
                                <c:choose>
                                    <c:when test="${not empty orderUser}">
                                        <div class="customer-info">
                                            <div class="info-item">
                                                <div class="info-label">用户ID</div>
                                                <div class="info-value">${orderUser.user_id}</div>
                                            </div>
                                            <div class="info-item">
                                                <div class="info-label">用户名</div>
                                                <div class="info-value">${orderUser.username}</div>
                                            </div>
                                            <div class="info-item">
                                                <div class="info-label">邮箱</div>
                                                <div class="info-value">${orderUser.email}</div>
                                            </div>
                                            <div class="info-item">
                                                <div class="info-label">手机号</div>
                                                <div class="info-value">${orderUser.phone}</div>
                                            </div>
                                        </div>
                                        <div style="margin-top: 15px;">
                                            <a href="${pageContext.request.contextPath}/AdminUserDetailServlet?userId=${orderUser.user_id}"
                                                class="btn btn-secondary" target="_blank">查看用户详情</a>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="empty-state">用户信息不可用</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- 商铺信息 -->
                        <div class="section">
                            <div class="section-header">商铺信息</div>
                            <div class="section-content">
                                <c:choose>
                                    <c:when test="${not empty shop}">
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
                                            <div class="info-item">
                                                <div class="info-label">创建时间</div>
                                                <div class="info-value">${shop.create_time}</div>
                                            </div>
                                        </div>
                                        <div style="margin-top: 15px;">
                                            <a href="${pageContext.request.contextPath}/AdminShopDetailServlet?shopId=${shop.shop_id}"
                                                class="btn btn-secondary" target="_blank">查看商铺详情</a>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="empty-state">商铺信息不可用</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- 订单商品详情 -->
                        <div class="section">
                            <div class="section-header">订单商品 (${orderDetails.size()} 个商品)</div>
                            <c:choose>
                                <c:when test="${not empty orderDetails}">
                                    <table class="data-table">
                                        <thead>
                                            <tr>
                                                <th>详情ID</th>
                                                <th>商品ID</th>
                                                <th>数量</th>
                                                <th>单价</th>
                                                <th>小计</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="detail" items="${orderDetails}">
                                                <tr>
                                                    <td>${detail.order_detail_id}</td>
                                                    <td>${detail.product_id}</td>
                                                    <td>${detail.quantity}</td>
                                                    <td>¥${detail.price}</td>
                                                    <td style="font-weight: 600; color: #e53e3e;">¥
                                                        <fmt:formatNumber value="${detail.price * detail.quantity}"
                                                            pattern="#0.00" />
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>

                                    <!-- 订单汇总 -->
                                    <div class="order-summary">
                                        <div class="summary-row total-row">
                                            <span class="summary-label">订单总额：</span>
                                            <span class="summary-value">¥
                                                <fmt:formatNumber value="${order.total_amount}" pattern="#0.00" />
                                            </span>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state">暂无商品详情</div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- 返回按钮 -->
                        <div style="margin-top: 20px; text-align: center;">
                            <a href="${pageContext.request.contextPath}/AdminDashboardServlet?action=orders"
                                class="btn btn-secondary">返回订单管理</a>
                        </div>
                    </div>
            </body>

            </html>