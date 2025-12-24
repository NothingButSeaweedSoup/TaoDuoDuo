<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>写评价 - 淘多多</title>
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

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            font-size: 14px;
            font-weight: 500;
            color: #333;
            margin-bottom: 8px;
        }

        .form-control {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            transition: border-color 0.3s;
        }

        .form-control:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.1);
        }

        textarea.form-control {
            resize: vertical;
            min-height: 120px;
        }

        .rating-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .rating-stars {
            display: flex;
            gap: 5px;
        }

        .star {
            font-size: 24px;
            color: #ddd;
            cursor: pointer;
            transition: color 0.2s;
        }

        .star:hover,
        .star.active {
            color: #ffc107;
        }

        .rating-text {
            font-size: 14px;
            color: #666;
            margin-left: 10px;
        }

        .error-message {
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
            padding: 12px;
            border-radius: 4px;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .form-actions {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 30px;
        }

        .btn {
            padding: 12px 24px;
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

        @media (max-width: 768px) {
            .container {
                padding: 10px;
            }

            .form-actions {
                flex-direction: column;
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
                <h2 class="card-title">写评价</h2>
                <p class="card-subtitle">订单号：${orderId}</p>
            </div>

            <div class="card-body">
                <!-- 错误消息 -->
                <c:if test="${not empty errorMessage}">
                    <div class="error-message">
                        ${errorMessage}
                    </div>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/ReviewCreateServlet">
                    <input type="hidden" name="orderId" value="${orderId}">

                    <!-- 评分 -->
                    <div class="form-group">
                        <label class="form-label">评分 *</label>
                        <div class="rating-group">
                            <div class="rating-stars" id="ratingStars">
                                <span class="star" data-rating="1">★</span>
                                <span class="star" data-rating="2">★</span>
                                <span class="star" data-rating="3">★</span>
                                <span class="star" data-rating="4">★</span>
                                <span class="star" data-rating="5">★</span>
                            </div>
                            <span class="rating-text" id="ratingText">请选择评分</span>
                        </div>
                        <input type="hidden" name="rating" id="ratingInput" value="${rating}">
                    </div>

                    <!-- 评价内容 -->
                    <div class="form-group">
                        <label for="content" class="form-label">评价内容 *</label>
                        <textarea 
                            id="content" 
                            name="content" 
                            class="form-control" 
                            placeholder="请写下您对此次购物的评价..."
                            required>${content}</textarea>
                    </div>

                    <!-- 操作按钮 -->
                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/OrderQueryServlet?action=detail&orderId=${orderId}" 
                           class="btn btn-secondary">取消</a>
                        <button type="submit" class="btn btn-primary">提交评价</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        // 评分功能
        const stars = document.querySelectorAll('.star');
        const ratingInput = document.getElementById('ratingInput');
        const ratingText = document.getElementById('ratingText');
        
        const ratingTexts = {
            1: '很差',
            2: '较差', 
            3: '一般',
            4: '满意',
            5: '非常满意'
        };

        // 初始化评分显示
        const initialRating = ratingInput.value;
        if (initialRating) {
            updateStars(parseInt(initialRating));
        }

        stars.forEach(star => {
            star.addEventListener('click', function() {
                const rating = parseInt(this.dataset.rating);
                ratingInput.value = rating;
                updateStars(rating);
            });

            star.addEventListener('mouseover', function() {
                const rating = parseInt(this.dataset.rating);
                highlightStars(rating);
            });
        });

        document.getElementById('ratingStars').addEventListener('mouseleave', function() {
            const currentRating = parseInt(ratingInput.value) || 0;
            updateStars(currentRating);
        });

        function updateStars(rating) {
            stars.forEach((star, index) => {
                if (index < rating) {
                    star.classList.add('active');
                } else {
                    star.classList.remove('active');
                }
            });
            
            if (rating > 0) {
                ratingText.textContent = ratingTexts[rating];
            } else {
                ratingText.textContent = '请选择评分';
            }
        }

        function highlightStars(rating) {
            stars.forEach((star, index) => {
                if (index < rating) {
                    star.classList.add('active');
                } else {
                    star.classList.remove('active');
                }
            });
            ratingText.textContent = ratingTexts[rating];
        }
    </script>
</body>
</html>