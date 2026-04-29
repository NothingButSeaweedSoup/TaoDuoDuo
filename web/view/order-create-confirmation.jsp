<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>订单创建成功 - 淘多多</title>
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
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }

        .success-card {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            margin-bottom: 20px;
        }

        .success-header {
            background: linear-gradient(135deg, #52c41a 0%, #389e0d 100%);
            color: #fff;
            padding: 30px 20px;
            text-align: center;
        }

        .success-icon {
            font-size: 48px;
            margin-bottom: 15px;
        }

        .success-title {
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 10px;
        }

        .success-subtitle {
            font-size: 16px;
            opacity: 0.9;
        }

        .orders-section {
            padding: 20px;
        }

        .section-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
            padding-bottom: 10px;
        }

        .order-item {
            border: 1px solid #e9ecef;
            border-radius: 6px;
            margin-bottom: 15px;
            overflow: hidden;
        }

        .order-header {
            background: #f8f9fa;
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
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

        .order-status {
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
            background: #fff3cd;
            color: #856404;
        }

        .order-amount {
            font-size: 18px;
            font-weight: 600;
            color: #ff6b35;
        }

        .order-body {
            padding: 20px;
        }

        .alipay-info {
            background: #e6f7ff;
            border: 1px solid #91d5ff;
            border-radius: 4px;
            padding: 10px 15px;
            margin-bottom: 15px;
        }

        .alipay-label {
            font-size: 12px;
            color: #666;
            margin-bottom: 5px;
        }

        .alipay-no {
            font-family: 'Courier New', monospace;
            font-size: 14px;
            color: #1890ff;
            font-weight: 600;
        }

        .actions-section {
            padding: 20px;
            background: #f8f9fa;
            text-align: center;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            font-size: 16px;
            font-weight: 500;
            transition: all 0.3s;
            display: inline-block;
            margin: 0 10px;
        }

        .btn-primary {
            background: #667eea;
            color: #fff;
        }

        .btn-primary:hover {
            background: #5a6fd8;
            transform: translateY(-1px);
        }

        .btn-secondary {
            background: #6c757d;
            color: #fff;
        }

        .btn-secondary:hover {
            background: #5a6268;
        }

        .tips {
            background: #fff7e6;
            border: 1px solid #ffd591;
            border-radius: 4px;
            padding: 15px;
            margin-top: 20px;
        }

        .tips-title {
            font-size: 14px;
            font-weight: 600;
            color: #d46b08;
            margin-bottom: 8px;
        }

        .tips-content {
            font-size: 13px;
            color: #ad6800;
            line-height: 1.5;
        }

        @media (max-width: 768px) {
            .order-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }

            .btn {
                display: block;
                margin: 10px 0;
            }
        }
    </style>
</head>
<body>
    <!-- 导航栏 -->
    <%@ include file="head.jsp" %>

    <div class="container">
        <!-- 成功提示 -->
        <div class="success-card">
            <div class="success-header">
                <div class="success-icon">✅</div>
                <h1 class="success-title">订单创建成功！</h1>
                <p class="success-subtitle">您的订单已成功创建，请及时完成支付</p>
            </div>

            <!-- 订单列表 -->
            <div class="orders-section">
                <h2 class="section-title">订单详情</h2>
                
                <c:choose>
                    <c:when test="${not empty createdOrders}">
                        <!-- 多个订单的情况 -->
                        <c:forEach var="order" items="${createdOrders}" varStatus="status">
                            <div class="order-item">
                                <div class="order-header">
                                    <div class="order-info">
                                        <span class="order-id">订单号：${order.order_id}</span>
                                        <span class="order-status">未支付</span>
                                    </div>
                                    <div class="order-amount">¥${order.total_amount}</div>
                                </div>
                                
                                <div class="order-body">
                                    <c:if test="${not empty order.alipay_order_no}">
                                        <div class="alipay-info">
                                            <div class="alipay-label">支付宝订单号：</div>
                                            <div class="alipay-no">${order.alipay_order_no}</div>
                                        </div>
                                    </c:if>
                                    
                                    <p style="color: #666; font-size: 14px;">
                                        创建时间：${order.create_time}
                                    </p>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:when test="${not empty createdOrder}">
                        <!-- 单个订单的情况 -->
                        <div class="order-item">
                            <div class="order-header">
                                <div class="order-info">
                                    <span class="order-id">订单号：${createdOrder.order_id}</span>
                                    <span class="order-status">未支付</span>
                                </div>
                                <div class="order-amount">¥${createdOrder.total_amount}</div>
                            </div>
                            
                            <div class="order-body">
                                <c:if test="${not empty createdOrder.alipay_order_no}">
                                    <div class="alipay-info">
                                        <div class="alipay-label">支付宝订单号：</div>
                                        <div class="alipay-no">${createdOrder.alipay_order_no}</div>
                                    </div>
                                </c:if>
                                
                                <p style="color: #666; font-size: 14px;">
                                    创建时间：${createdOrder.create_time}
                                </p>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="text-align: center; padding: 40px; color: #666;">
                            <p>未找到订单信息</p>
                            <a href="${pageContext.request.contextPath}/CartServlet" class="btn btn-primary" style="margin-top: 20px;">
                                返回购物车
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- 操作按钮 -->
            <div class="actions-section">
                <c:choose>
                    <c:when test="${not empty createdOrders}">
                        <!-- 多个订单的情况 -->
                        <p style="margin-bottom: 15px; color: #666;">您有 ${createdOrders.size()} 个订单需要支付</p>
                        <c:forEach var="order" items="${createdOrders}" varStatus="status">
                            <a href="${pageContext.request.contextPath}/PaymentServlet?orderId=${order.order_id}" 
                               class="btn btn-primary">
                                支付订单 ${order.order_id} (¥${order.total_amount})
                            </a>
                        </c:forEach>
                    </c:when>
                    <c:when test="${not empty createdOrder}">
                        <!-- 单个订单的情况 -->
                        <a href="${pageContext.request.contextPath}/PaymentServlet?orderId=${createdOrder.order_id}" 
                           class="btn btn-primary">
                            立即支付
                        </a>
                    </c:when>
                </c:choose>
                
                <a href="${pageContext.request.contextPath}/OrderQueryServlet" class="btn btn-secondary">
                    查看我的订单
                </a>
                
                <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-secondary">
                    继续购物
                </a>
            </div>

            <!-- 温馨提示 -->
            <div class="tips">
                <div class="tips-title">温馨提示：</div>
                <div class="tips-content">
                    <c:choose>
                        <c:when test="${not empty createdOrders}">
                            • 您的购物车商品来自不同店铺，已为您创建 ${createdOrders.size()} 个订单<br>
                            • 每个订单需要单独支付，请逐一完成支付<br>
                            • 请在30分钟内完成支付，超时订单将自动取消<br>
                            • 支付完成后，各店铺会分别为您发货<br>
                            • 如有问题，请及时联系客服
                        </c:when>
                        <c:otherwise>
                            • 请在30分钟内完成支付，超时订单将自动取消<br>
                            • 支付完成后，商家会尽快为您发货<br>
                            • 如有问题，请及时联系客服
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</body>
</html>