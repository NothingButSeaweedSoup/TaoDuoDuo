<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>评价详情 - 淘多多</title>
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
            max-width: 600px;
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

        .review-card {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            overflow: hidden;
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
            margin-bottom: 5px;
        }

        .card-subtitle {
            font-size: 14px;
            color: #666;
        }

        .card-body {
            padding: 20px;
        }

        .review-info {
            margin-bottom: 20px;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .info-label {
            font-size: 14px;
            color: #666;
            font-weight: 500;
        }

        .info-value {
            font-size: 14px;
            color: #333;
        }

        .rating-display {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .stars {
            display: flex;
            gap: 2px;
        }

        .star {
            font-size: 16px;
            color: #ddd;
        }

        .star.filled {
            color: #ffc107;
        }

        .rating-text {
            font-size: 14px;
            color: #666;
        }

        .review-content {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 4px;
            border-left: 4px solid #667eea;
        }

        .content-label {
            font-size: 14px;
            color: #666;
            font-weight: 500;
            margin-bottom: 8px;
        }

        .content-text {
            font-size: 14px;
            color: #333;
            line-height: 1.6;
        }

        .review-meta {
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #e9ecef;
            font-size: 12px;
            color: #666;
        }

        @media (max-width: 768px) {
            .container {
                padding: 10px;
            }

            .info-row {
                flex-direction: column;
                align-items: flex-start;
                gap: 5px;
            }
        }
    </style>
</head>
<body>
    <!-- 导航栏 -->
    <%@ include file="head.jsp" %>

    <div class="container">
        <a href="${pageContext.request.contextPath}/OrderQueryServlet?action=detail&orderId=${orderId}" class="back-link">
            ← 返回订单详情
        </a>

        <div class="review-card">
            <div class="card-header">
                <h2 class="card-title">评价详情</h2>
                <p class="card-subtitle">订单号：${orderId}</p>
            </div>

            <div class="card-body">
                <div class="review-info">
                    <div class="info-row">
                        <span class="info-label">评价ID：</span>
                        <span class="info-value">${review.review_id}</span>
                    </div>
                    
                    <div class="info-row">
                        <span class="info-label">评分：</span>
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
                </div>

                <div class="review-content">
                    <div class="content-label">评价内容：</div>
                    <div class="content-text">${review.content}</div>
                    
                    <div class="review-meta">
                        评价时间：${review.create_time}
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>