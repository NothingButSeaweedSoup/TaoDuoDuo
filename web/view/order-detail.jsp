<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>订单详情 - 淘多多</title>
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
            max-width: 1000px;
            margin: 0 auto;
            padding: 20px;
        }

        .back-link {
            display: inline-block;
            margin-bottom: 20px;
            color: #667eea;
            text-decoration: none;
            font-size: 14px;
        }

        .back-link:hover {
            text-decoration: underline;
        }

        .order-card {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            margin-bottom: 20px;
        }

        .card-header {
            background: #f8f9fa;
            padding: 20px;
            border-bottom: 1px solid #e9ecef;
        }

        .card-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
        }

        .order-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }

        .info-item {
            display: flex;
            flex-direction: column;
        }

        .info-label {
            font-size: 12px;
            color: #666;
            margin-bottom: 4px;
        }

        .info-value {
            font-size: 14px;
            color: #333;
            font-weight: 500;
        }

        .order-status {
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
            display: inline-block;
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

        .card-body {
            padding: 20px;
        }

        .order-items {
            margin-bottom: 20px;
        }

        .item-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #f0f0f0;
            font-weight: 600;
            color: #666;
            font-size: 14px;
        }

        .order-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #f8f9fa;
        }

        .order-item:last-child {
            border-bottom: none;
        }

        .item-info {
            flex: 1;
        }

        .item-name {
            font-size: 14px;
            color: #333;
            margin-bottom: 5px;
        }

        .item-id {
            font-size: 12px;
            color: #666;
        }

        .item-quantity {
            font-size: 14px;
            color: #666;
            min-width: 80px;
            text-align: center;
        }

        .item-price {
            font-size: 14px;
            color: #333;
            min-width: 100px;
            text-align: right;
        }

        .item-total {
            font-size: 14px;
            font-weight: 600;
            color: #ff6b35;
            min-width: 100px;
            text-align: right;
        }

        .order-summary {
            border-top: 2px solid #f0f0f0;
            padding-top: 20px;
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
        }

        .total-row {
            font-size: 16px;
            font-weight: 600;
            color: #ff6b35;
            border-top: 1px solid #f0f0f0;
            padding-top: 10px;
            margin-top: 10px;
        }

        .order-actions {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 20px;
        }

        .btn {
            padding: 10px 20px;
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

        .btn-danger {
            background: #dc3545;
            color: #fff;
        }

        .btn-danger:hover {
            background: #c82333;
        }

        .btn-secondary {
            background: #6c757d;
            color: #fff;
        }

        .btn-secondary:hover {
            background: #5a6268;
        }

        @media (max-width: 768px) {
            .order-info {
                grid-template-columns: 1fr;
            }

            .item-header,
            .order-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }

            .order-actions {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <!-- 导航栏 -->
    <%@ include file="head.jsp" %>

    <div class="container">
        <a href="${pageContext.request.contextPath}/OrderQueryServlet" class="back-link">
            ← 返回订单列表
        </a>

        <!-- 支付成功消息 -->
        <c:if test="${not empty sessionScope.paymentSuccessMessage}">
            <div style="background: #d4edda; border: 1px solid #c3e6cb; color: #155724; padding: 15px; border-radius: 4px; margin-bottom: 20px;">
                <strong>✅ ${sessionScope.paymentSuccessMessage}</strong>
            </div>
            <c:remove var="paymentSuccessMessage" scope="session"/>
        </c:if>

        <!-- 评价成功消息 -->
        <c:if test="${not empty sessionScope.reviewSuccessMessage}">
            <div style="background: #d4edda; border: 1px solid #c3e6cb; color: #155724; padding: 15px; border-radius: 4px; margin-bottom: 20px;">
                <strong>✅ ${sessionScope.reviewSuccessMessage}</strong>
            </div>
            <c:remove var="reviewSuccessMessage" scope="session"/>
        </c:if>

        <!-- 订单基本信息 -->
        <div class="order-card">
            <div class="card-header">
                <h2 class="card-title">订单详情</h2>
                <div class="order-info">
                    <div class="info-item">
                        <span class="info-label">订单号</span>
                        <span class="info-value">${order.order_id}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">下单时间</span>
                        <span class="info-value">${order.create_time}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">订单状态</span>
                        <span class="info-value">
                            <span class="order-status status-${order.order_status}">
                                <c:choose>
                                    <c:when test="${order.order_status == 'unpaid'}">未支付</c:when>
                                    <c:when test="${order.order_status == 'paid_pending_shipment'}">待发货</c:when>
                                    <c:when test="${order.order_status == 'shipped_pending_receipt'}">待收货</c:when>
                                    <c:when test="${order.order_status == 'completed'}">已完成</c:when>
                                    <c:when test="${order.order_status == 'cancelled'}">已取消</c:when>
                                    <c:otherwise>${order.order_status}</c:otherwise>
                                </c:choose>
                            </span>
                        </span>
                    </div>
                    <c:if test="${not empty order.alipay_order_no}">
                        <div class="info-item">
                            <span class="info-label">支付宝订单号</span>
                            <span class="info-value">${order.alipay_order_no}</span>
                        </div>
                    </c:if>
                </div>
            </div>

            <div class="card-body">
                <!-- 订单商品列表 -->
                <div class="order-items">
                    <div class="item-header">
                        <span style="flex: 1;">商品信息</span>
                        <span style="min-width: 80px; text-align: center;">数量</span>
                        <span style="min-width: 100px; text-align: right;">单价</span>
                        <span style="min-width: 100px; text-align: right;">小计</span>
                    </div>

                    <c:choose>
                        <c:when test="${empty orderDetails}">
                            <div style="text-align: center; padding: 40px; color: #666;">
                                暂无商品详情
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="detail" items="${orderDetails}">
                                <div class="order-item">
                                    <div class="item-info">
                                        <div class="item-name">商品ID: ${detail.product_id}</div>
                                        <div class="item-id">详情ID: ${detail.order_detail_id}</div>
                                    </div>
                                    <div class="item-quantity">${detail.quantity}</div>
                                    <div class="item-price">¥${detail.price}</div>
                                    <div class="item-total">¥${detail.price * detail.quantity}</div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- 订单汇总 -->
                <div class="order-summary">
                    <div class="summary-row total-row">
                        <span class="summary-label">订单总额：</span>
                        <span class="summary-value">¥${order.total_amount}</span>
                    </div>
                </div>

                <!-- 操作按钮 -->
                <div class="order-actions">
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
                        <c:choose>
                            <c:when test="${not empty orderReview}">
                                <a href="${pageContext.request.contextPath}/ReviewQueryServlet?action=byOrder&orderId=${order.order_id}" 
                                   class="btn btn-secondary">查看评价</a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/ReviewCreateServlet?orderId=${order.order_id}" 
                                   class="btn btn-primary">写评价</a>
                            </c:otherwise>
                        </c:choose>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</body>
</html>