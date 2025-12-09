<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>页面未找到 - 淘多多</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Microsoft YaHei", sans-serif;
                background: #f5f5f5;
                min-height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
                padding: 20px;
            }

            .notfound-container {
                display: flex;
                align-items: center;
                gap: 80px;
                max-width: 900px;
                animation: fadeIn 0.6s ease-out;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }

                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .notfound-image {
                flex-shrink: 0;
            }

            .notfound-image img {
                width: 320px;
                height: auto;
                display: block;
            }

            .notfound-content {
                flex: 1;
            }

            .notfound-title {
                font-size: 48px;
                font-weight: 700;
                color: #333;
                margin-bottom: 10px;
                letter-spacing: 2px;
            }

            .notfound-subtitle {
                font-size: 20px;
                color: #666;
                margin-bottom: 40px;
            }

            .btn-group {
                display: flex;
                gap: 15px;
            }

            .btn {
                padding: 12px 28px;
                border-radius: 8px;
                font-size: 15px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s;
                text-decoration: none;
                display: inline-block;
                border: none;
            }

            .btn-primary {
                background: #ff6b35;
                color: white;
            }

            .btn-primary:hover {
                background: #ff8c5a;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(255, 107, 53, 0.3);
            }

            .btn-secondary {
                background: white;
                color: #666;
                border: 1px solid #ddd;
            }

            .btn-secondary:hover {
                background: #f8f9fa;
                border-color: #ccc;
            }

            @media (max-width: 768px) {
                .notfound-container {
                    flex-direction: column;
                    gap: 40px;
                    text-align: center;
                }

                .notfound-image img {
                    width: 240px;
                }

                .notfound-title {
                    font-size: 36px;
                }

                .notfound-subtitle {
                    font-size: 16px;
                }

                .btn-group {
                    justify-content: center;
                }
            }
        </style>
    </head>

    <body>
        <div class="notfound-container">
            <div class="notfound-image">
                <img src="<%= request.getContextPath() %>/icon/NotFoundShark.png" alt="404 Not Found">
            </div>
            <div class="notfound-content">
                <div class="notfound-title">404NotFound</div>
                <div class="notfound-subtitle">也许写错了什么?</div>
                <div class="btn-group">
                    <a href="<%= request.getContextPath() %>/index.jsp" class="btn btn-primary">返回首页</a>
                    <a href="javascript:history.back()" class="btn btn-secondary">返回上一页</a>
                </div>
            </div>
        </div>
    </body>

    </html>