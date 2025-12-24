<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.TaoDuoDuo.entity.OrderStatus" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的订单 - 淘多多</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background-color: #f5f5f5;
            padding-top: 70px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .page-header {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        .page-title {
            font-size: 24px;
            font-weight: 600;
            color: #333;
            margin-bottom: 15px;
        }

        .filter-tabs {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .filter-tab {
            padding: 8px 16px;
            border: 1px solid #ddd;
            border-radius: 20px;
            background: #fff;
            color: #666;
            text-decoration: none;
            transition: all 0.3s;
            font-size: 14px;
        }

        .filter-tab:hover {
            border-color: #667eea;
            color: #667eea;
        }

        .filter-tab.active {
            background: #667eea;
            border-color: #667eea;
            color: #fff;
        }

        .orders-container {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .order-item {
            border-bottom: 1px solid #f0f0f0;
            padding: 20px;
            transition: background-color 0.3s;
        }

        .order-item:hover {
            background-color: #f9f9f9;
        }

        .order-item:last-child {
            border-bottom: none;
        }

        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .order-info {
            display: flex;
            gap: 20px;
            align-items: center;
        }

        .order-id {
            font-weight: 600;
            color: #333;
        }

        .order-time {
            color: #666;
            font-size: 14px;
        }

        .order-status {
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }

        .status-unpaid {
            background: #fff3cd;
            color: #856404;
        }

        .status-paid_pending_shipment {
            background: #d4edda;
            color: #155724;
        }

        .status-shipped_pending_receipt {
            background: #cce7ff;
            color: #004085;
        }

        .status-completed {
            background: #d1ecf1;
            color: #0c5460;
        }

        .status-cancelled {
            background: #f8d7da;
            color: #721c24;
        }

        .order-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .order-details {
            flex: 1;
        }

        .order-amount {
            font-size: 18px;
            font-weight: 600;
            color: #ff6b35;
        }

        .order-actions {
            display: flex;
            gap: 10px;
        }

        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
            transition: all 0.3s;
            display: inline-block;
        }

        .btn-primary {
            background: #667eea;
            color: #fff;
        }

        .btn-primary:hover {
            background: #5a6fd8;
        }

        .btn-secondary {
            background: #6c757d;
            color: #fff;
        }

        .btn-secondary:hover {
            background: #5a6268;
        }

        .btn-danger {
            background: #dc3545;
            color: #fff;
        }

        .btn-danger:hover {
            background: #c82333;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }

        .empty-icon {
            font-size: 48px;
            margin-bottom: 20px;
            opacity: 0.5;
        }

        .error-message {
            background: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
        }

        .success-message {
            background: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
        }

        @media (max-width: 768px) {
            .order-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }

            .order-content {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }

            .order-actions {
                width: 100%;
                justify-content: flex-end;
            }
        }
    </style>
</head>
<body>
    <!-- 导航栏 -->
    <%@ include file="head.jsp" %>

    <div class="container">
        <!-- 页面头部 -->
        <div class="page-header">
            <h1 class="page-title">
                <c:choose>
                    <c:when test="${userRole == 1}">我的订单</c:when>
                    <c:when test="${userRole == 2}">店铺订单</c:when>
                    <c:when test="${userRole == 3}">订单管理</c:when>
                    <c:otherwise>订单列表</c:otherwise>
                </c:choose>
            </h1>
            
            <!-- 状态筛选 -->
            <div class="filter-tabs">
                <a href="${pageContext.request.contextPath}/OrderQueryServlet" 
                   class="filter-tab ${empty statusFilter ? 'active' : ''}">全部</a>
                <a href="${pageContext.request.contextPath}/OrderQueryServlet?status=unpaid" 
                   class="filter-tab ${'unpaid' eq statusFilter ? 'active' : ''}">未支付</a>
                <a href="${pageContext.request.contextPath}/OrderQueryServlet?status=paid_pending_shipment" 
                   class="filter-tab ${'paid_pending_shipment' eq statusFilter ? 'active' : ''}">待发货</a>
                <a href="${pageContext.request.contextPath}/OrderQueryServlet?status=shipped_pending_receipt" 
                   class="filter-tab ${'shipped_pending_receipt' eq statusFilter ? 'active' : ''}">待收货</a>
                <a href="${pageContext.request.contextPath}/OrderQueryServlet?status=completed" 
                   class="filter-tab ${'completed' eq statusFilter ? 'active' : ''}">已完成</a>
                <a href="${pageContext.request.contextPath}/OrderQueryServlet?status=cancelled" 
                   class="filter-tab ${'cancelled' eq statusFilter ? 'active' : ''}">已取消</a>
            </div>
        </div>

        <!-- 错误消息 -->
        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>

        <!-- 成功消息 -->
        <c:if test="${not empty message}">
            <div class="success-message">${message}</div>
        </c:if>

        <!-- 订单列表 -->
        <div class="orders-container">
            <c:choose>
                <c:when test="${empty orders}">
                    <div class="empty-state">
                        <div class="empty-icon">
                            <img src="${pageContext.request.contextPath}/icon/NoRecord.png"
                                 alt="无记录"
                                 style="width: 64px; height: 64px;">
                        </div>
                        <h3>暂无订单</h3>
                        <p>您还没有任何订单，快去购物吧！</p>
                        <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-primary" style="margin-top: 20px;">
                            去购物
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="order" items="${orders}">
                        <div class="order-item">
                            <div class="order-header">
                                <div class="order-info">
                                    <span class="order-id">订单号：${order.order_id}</span>
                                    <span class="order-time">${order.create_time}</span>
                                </div>
                                <div class="order-status status-${order.order_status}">
                                    <c:choose>
                                        <c:when test="${order.order_status == 'unpaid'}">未支付</c:when>
                                        <c:when test="${order.order_status == 'paid_pending_shipment'}">待发货</c:when>
                                        <c:when test="${order.order_status == 'shipped_pending_receipt'}">待收货</c:when>
                                        <c:when test="${order.order_status == 'completed'}">已完成</c:when>
                                        <c:when test="${order.order_status == 'cancelled'}">已取消</c:when>
                                        <c:otherwise>${order.order_status}</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            
                            <div class="order-content">
                                <div class="order-details">
                                    <div class="order-amount">¥${order.total_amount}</div>
                                </div>
                                
                                <div class="order-actions">
                                    <a href="${pageContext.request.contextPath}/OrderQueryServlet?action=detail&orderId=${order.order_id}" 
                                       class="btn btn-secondary">查看详情</a>
                                    
                                    <!-- 根据订单状态和用户角色显示不同操作 -->
                                    <c:if test="${order.order_status == 'unpaid'}">
                                        <a href="${pageContext.request.contextPath}/PaymentServlet?orderId=${order.order_id}" 
                                           class="btn btn-primary">去支付</a>
                                        <a href="${pageContext.request.contextPath}/OrderCancelServlet?orderId=${order.order_id}" 
                                           class="btn btn-danger" onclick="return confirm('确定要取消这个订单吗？')">取消订单</a>
                                    </c:if>
                                    
                                    <c:if test="${order.order_status == 'paid_pending_shipment' && userRole == 2}">
                                        <a href="${pageContext.request.contextPath}/OrderStatusUpdateServlet?orderId=${order.order_id}&status=shipped_pending_receipt" 
                                           class="btn btn-primary" onclick="return confirm('确定要发货吗？')">确认发货</a>
                                        <a href="${pageContext.request.contextPath}/OrderCancelServlet?orderId=${order.order_id}" 
                                           class="btn btn-danger" onclick="return confirm('确定要取消这个订单吗？')">取消订单</a>
                                    </c:if>
                                    
                                    <c:if test="${order.order_status == 'shipped_pending_receipt' && userRole == 1}">
                                        <a href="${pageContext.request.contextPath}/OrderStatusUpdateServlet?orderId=${order.order_id}&status=completed" 
                                           class="btn btn-primary" onclick="return confirm('确定已收到货物吗？')">确认收货</a>
                                    </c:if>
                                    
                                    <c:if test="${order.order_status == 'completed' && userRole == 1}">
                                        <a href="${pageContext.request.contextPath}/ReviewCreateServlet?orderId=${order.order_id}" 
                                           class="btn btn-primary">写评价</a>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>