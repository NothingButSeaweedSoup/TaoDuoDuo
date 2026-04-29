<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ page import="java.util.List" %>
            <%@ page import="com.TaoDuoDuo.entity.Order" %>
                <!DOCTYPE html>
                <html lang="zh-CN">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>管理员控制台 - 淘多多</title>
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

                        .dashboard-header {
                            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                            color: white;
                            padding: 30px;
                            border-radius: 12px;
                            margin-bottom: 30px;
                            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                        }

                        .dashboard-title {
                            font-size: 28px;
                            font-weight: 600;
                            margin-bottom: 10px;
                        }

                        .dashboard-subtitle {
                            font-size: 16px;
                            opacity: 0.9;
                        }

                        .stats-grid {
                            display: grid;
                            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                            gap: 20px;
                            margin-bottom: 30px;
                        }

                        .stat-card {
                            background: white;
                            padding: 25px;
                            border-radius: 12px;
                            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                            text-align: center;
                            transition: transform 0.3s, box-shadow 0.3s;
                        }

                        .stat-card:hover {
                            transform: translateY(-5px);
                            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
                        }

                        .stat-number {
                            font-size: 36px;
                            font-weight: 700;
                            color: #667eea;
                            margin-bottom: 10px;
                        }

                        .stat-label {
                            font-size: 16px;
                            color: #666;
                            margin-bottom: 15px;
                        }

                        .stat-link {
                            display: inline-block;
                            padding: 8px 16px;
                            background-color: #667eea;
                            color: white;
                            text-decoration: none;
                            border-radius: 6px;
                            font-size: 14px;
                            transition: background-color 0.3s;
                        }

                        .stat-link:hover {
                            background-color: #5a67d8;
                        }

                        .management-grid {
                            display: grid;
                            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                            gap: 20px;
                            margin-bottom: 30px;
                        }

                        .management-card {
                            background: white;
                            padding: 25px;
                            border-radius: 12px;
                            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                        }

                        .management-title {
                            font-size: 20px;
                            font-weight: 600;
                            color: #333;
                            margin-bottom: 15px;
                            display: flex;
                            align-items: center;
                            gap: 10px;
                        }

                        .management-icon {
                            width: 24px;
                            height: 24px;
                            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                            border-radius: 6px;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            color: white;
                            font-weight: bold;
                            padding: 4px;
                        }

                        .management-icon img {
                            width: 16px;
                            height: 16px;
                            filter: brightness(0) invert(1);
                        }

                        .management-description {
                            color: #666;
                            margin-bottom: 20px;
                            line-height: 1.6;
                        }

                        .management-actions {
                            display: flex;
                            gap: 10px;
                            flex-wrap: wrap;
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

                        .btn-primary {
                            background-color: #667eea;
                            color: white;
                        }

                        .btn-primary:hover {
                            background-color: #5a67d8;
                            transform: translateY(-1px);
                        }

                        .btn-secondary {
                            background-color: #e2e8f0;
                            color: #4a5568;
                        }

                        .btn-secondary:hover {
                            background-color: #cbd5e0;
                        }

                        .recent-orders {
                            background: white;
                            padding: 25px;
                            border-radius: 12px;
                            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                        }

                        .recent-orders-title {
                            font-size: 20px;
                            font-weight: 600;
                            color: #333;
                            margin-bottom: 20px;
                        }

                        .orders-table {
                            width: 100%;
                            border-collapse: collapse;
                        }

                        .orders-table th,
                        .orders-table td {
                            padding: 12px;
                            text-align: left;
                            border-bottom: 1px solid #e2e8f0;
                        }

                        .orders-table th {
                            background-color: #f8fafc;
                            font-weight: 600;
                            color: #4a5568;
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

                        .alert {
                            padding: 15px;
                            border-radius: 8px;
                            margin-bottom: 20px;
                        }

                        .alert-success {
                            background-color: #f0fff4;
                            border: 1px solid #9ae6b4;
                            color: #276749;
                        }

                        .alert-error {
                            background-color: #fed7d7;
                            border: 1px solid #feb2b2;
                            color: #c53030;
                        }

                        @media (max-width: 768px) {
                            .stats-grid {
                                grid-template-columns: 1fr;
                            }

                            .management-grid {
                                grid-template-columns: 1fr;
                            }

                            .management-actions {
                                flex-direction: column;
                            }
                        }
                    </style>
                </head>

                <body>
                    <!-- 导航栏 -->
                    <%@ include file="head.jsp" %>

                        <div class="container">
                            <!-- 控制台头部 -->
                            <div class="dashboard-header">
                                <div class="dashboard-title">管理员控制台</div>
                                <div class="dashboard-subtitle">欢迎使用淘多多管理系统，您可以在这里管理所有商铺、商品和订单</div>
                            </div>

                            <!-- 消息提示 -->
                            <c:if test="${not empty param.success}">
                                <div class="alert alert-success">
                                    <c:choose>
                                        <c:when test="${param.success == 'delete_success'}">删除成功！</c:when>
                                        <c:when test="${param.success == 'update_success'}">更新成功！</c:when>
                                        <c:when test="${param.success == 'toggle_success'}">操作成功！</c:when>
                                        <c:otherwise>操作成功！</c:otherwise>
                                    </c:choose>
                                </div>
                            </c:if>

                            <c:if test="${not empty param.error}">
                                <div class="alert alert-error">
                                    <c:choose>
                                        <c:when test="${param.error == 'delete_failed'}">删除失败，请重试！</c:when>
                                        <c:when test="${param.error == 'update_failed'}">更新失败，请重试！</c:when>
                                        <c:when test="${param.error == 'toggle_failed'}">操作失败，请重试！</c:when>
                                        <c:when test="${param.error == 'operation_failed'}">操作失败，请重试！</c:when>
                                        <c:otherwise>操作失败，请重试！</c:otherwise>
                                    </c:choose>
                                </div>
                            </c:if>

                            <!-- 统计数据 -->
                            <div class="stats-grid">
                                <div class="stat-card">
                                    <div class="stat-number">${totalShops}</div>
                                    <div class="stat-label">总商铺数</div>
                                    <a href="${pageContext.request.contextPath}/AdminDashboardServlet?action=shops"
                                        class="stat-link">管理商铺</a>
                                </div>
                                <div class="stat-card">
                                    <div class="stat-number">${totalProducts}</div>
                                    <div class="stat-label">总商品数</div>
                                    <a href="${pageContext.request.contextPath}/AdminDashboardServlet?action=products"
                                        class="stat-link">管理商品</a>
                                </div>
                                <div class="stat-card">
                                    <div class="stat-number">${totalUsers}</div>
                                    <div class="stat-label">总用户数</div>
                                    <a href="${pageContext.request.contextPath}/AdminDashboardServlet?action=users"
                                        class="stat-link">管理用户</a>
                                </div>
                            </div>

                            <!-- 管理功能 -->
                            <div class="management-grid">
                                <div class="management-card">
                                    <div class="management-title">
                                        <div class="management-icon">
                                            <img src="${pageContext.request.contextPath}/icon/Shop.png" alt="商铺">
                                        </div>
                                        商铺管理
                                    </div>
                                    <div class="management-description">
                                        管理平台上的所有商铺，包括查看商铺信息、编辑商铺详情、删除违规商铺等操作。
                                    </div>
                                    <div class="management-actions">
                                        <a href="${pageContext.request.contextPath}/AdminDashboardServlet?action=shops"
                                            class="btn btn-primary">
                                            管理商铺
                                        </a>
                                    </div>
                                </div>

                                <div class="management-card">
                                    <div class="management-title">
                                        <div class="management-icon">
                                            <img src="${pageContext.request.contextPath}/icon/ProductManaging.png"
                                                alt="商品">
                                        </div>
                                        商品管理
                                    </div>
                                    <div class="management-description">
                                        管理平台上的所有商品，包括查看商品详情、强制上架/下架商品、删除违规商品等操作。
                                    </div>
                                    <div class="management-actions">
                                        <a href="${pageContext.request.contextPath}/AdminDashboardServlet?action=products"
                                            class="btn btn-primary">
                                            管理商品
                                        </a>
                                    </div>
                                </div>

                                <div class="management-card">
                                    <div class="management-title">
                                        <div class="management-icon">
                                            <img src="${pageContext.request.contextPath}/icon/BillInquiry.png" alt="订单">
                                        </div>
                                        订单管理
                                    </div>
                                    <div class="management-description">
                                        查看和管理平台上的所有订单，包括订单状态跟踪、处理订单纠纷、查看订单统计等。
                                    </div>
                                    <div class="management-actions">
                                        <a href="${pageContext.request.contextPath}/AdminDashboardServlet?action=orders"
                                            class="btn btn-primary">
                                            管理订单
                                        </a>
                                    </div>
                                </div>

                                <div class="management-card">
                                    <div class="management-title">
                                        <div class="management-icon">
                                            <img src="${pageContext.request.contextPath}/icon/UserInfo.png" alt="用户">
                                        </div>
                                        用户管理
                                    </div>
                                    <div class="management-description">
                                        管理平台用户，包括查看用户信息、处理用户投诉、管理用户权限等操作。
                                    </div>
                                    <div class="management-actions">
                                        <a href="${pageContext.request.contextPath}/AdminDashboardServlet?action=users"
                                            class="btn btn-primary">
                                            管理用户
                                        </a>
                                    </div>
                                </div>
                            </div>

                            <!-- 最近订单 -->
                            <div class="recent-orders">
                                <div class="recent-orders-title">最近订单</div>
                                <c:choose>
                                    <c:when test="${not empty recentOrders}">
                                        <table class="orders-table">
                                            <thead>
                                                <tr>
                                                    <th>订单ID</th>
                                                    <th>用户ID</th>
                                                    <th>商铺ID</th>
                                                    <th>订单金额</th>
                                                    <th>订单状态</th>
                                                    <th>创建时间</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="order" items="${recentOrders}">
                                                    <tr>
                                                        <td>${order.order_id}</td>
                                                        <td>${order.user_id}</td>
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
                                                                    <c:when test="${order.order_status == 'completed'}">
                                                                        已完成</c:when>
                                                                    <c:when test="${order.order_status == 'cancelled'}">
                                                                        已取消</c:when>
                                                                    <c:otherwise>${order.order_status}</c:otherwise>
                                                                </c:choose>
                                                            </span>
                                                        </td>
                                                        <td>${order.create_time}</td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </c:when>
                                    <c:otherwise>
                                        <p style="text-align: center; color: #666; padding: 40px;">暂无订单数据</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                </body>

                </html>