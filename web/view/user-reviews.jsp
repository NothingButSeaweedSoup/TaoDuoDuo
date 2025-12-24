<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的评价 - 淘多多</title>
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
            margin-bottom: 10px;
        }

        .page-subtitle {
            font-size: 14px;
            color: #666;
        }

        .reviews-container {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .review-card {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .review-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .review-header {
            background: #f8f9fa;
            padding: 15px 20px;
            border-bottom: 1px solid #e9ecef;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .review-meta {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .order-info {
            font-size: 14px;
            color: #333;
            font-weight: 500;
        }

        .review-date {
            font-size: 12px;
            color: #666;
        }

        .rating-display {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .stars {
            display: flex;
            gap: 2px;
        }

        .star {
            font-size: 14px;
            color: #ddd;
        }

        .star.filled {
            color: #ffc107;
        }

        .rating-text {
            font-size: 12px;
            color: #666;
        }

        .review-body {
            padding: 20px;
        }

        .review-content {
            font-size: 14px;
            color: #333;
            line-height: 1.6;
        }

        .empty-state {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            padding: 60px 20px;
            text-align: center;
        }

        .empty-icon {
            font-size: 48px;
            color: #ddd;
            margin-bottom: 20px;
        }

        .empty-title {
            font-size: 18px;
            color: #666;
            margin-bottom: 10px;
        }

        .empty-subtitle {
            font-size: 14px;
            color: #999;
        }

        @media (max-width: 768px) {
            .container {
                padding: 10px;
            }

            .review-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
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

        <div class="page-header">
            <h1 class="page-title">我的评价</h1>
            <p class="page-subtitle">查看您的所有评价记录</p>
        </div>

        <div class="reviews-container">
            <c:choose>
                <c:when test="${empty reviews}">
                    <div class="empty-state">
                        <div class="empty-icon">📝</div>
                        <div class="empty-title">暂无评价记录</div>
                        <div class="empty-subtitle">完成订单后可以进行评价</div>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="review" items="${reviews}">
                        <div class="review-card">
                            <div class="review-header">
                                <div class="review-meta">
                                    <div class="order-info">订单号：${review.order_id}</div>
                                    <div class="review-date">评价时间：${review.create_time}</div>
                                </div>
                                <div class="rating-display">
                                    <div class="stars">
                                        <c:forEach begin="1" end="5" var="i">
                                            <span class="star ${i <= review.rating ? 'filled' : ''}">★</span>
                                        </c:forEach>
                                    </div>
                                    <span class="rating-text">
                                        <c:choose>
                                            <c:when test="${review.rating == 1}">很差</c:when>
                                            <c:when test="${review.rating == 2}">较差</c:when>
                                            <c:when test="${review.rating == 3}">一般</c:when>
                                            <c:when test="${review.rating == 4}">满意</c:when>
                                            <c:when test="${review.rating == 5}">非常满意</c:when>
                                            <c:otherwise>${review.rating}分</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>
                            <div class="review-body">
                                <div class="review-content">${review.content}</div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>