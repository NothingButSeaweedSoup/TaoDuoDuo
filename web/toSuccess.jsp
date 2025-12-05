<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>支付成功</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Microsoft YaHei", sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
                padding: 20px;
            }

            .success-container {
                background: white;
                border-radius: 20px;
                padding: 60px 40px;
                text-align: center;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
                max-width: 500px;
                width: 100%;
                animation: slideUp 0.5s ease-out;
            }

            @keyframes slideUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }

                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .success-icon {
                width: 80px;
                height: 80px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 30px;
                animation: scaleIn 0.5s ease-out 0.2s both;
            }

            @keyframes scaleIn {
                from {
                    transform: scale(0);
                }

                to {
                    transform: scale(1);
                }
            }

            .success-icon::after {
                content: '✓';
                color: white;
                font-size: 50px;
                font-weight: bold;
            }

            h1 {
                color: #333;
                font-size: 32px;
                margin-bottom: 15px;
                font-weight: 600;
            }

            .message {
                color: #666;
                font-size: 16px;
                line-height: 1.6;
                margin-bottom: 40px;
            }

            .order-info {
                background: #f8f9fa;
                border-radius: 12px;
                padding: 20px;
                margin-bottom: 30px;
                text-align: left;
            }

            .order-info-item {
                display: flex;
                justify-content: space-between;
                padding: 10px 0;
                border-bottom: 1px solid #e9ecef;
            }

            .order-info-item:last-child {
                border-bottom: none;
            }

            .order-info-label {
                color: #666;
                font-size: 14px;
            }

            .order-info-value {
                color: #333;
                font-size: 14px;
                font-weight: 500;
            }

            .btn-group {
                display: flex;
                gap: 15px;
                justify-content: center;
            }

            .btn {
                padding: 14px 30px;
                border-radius: 10px;
                font-size: 16px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s;
                text-decoration: none;
                display: inline-block;
                border: none;
            }

            .btn-primary {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
            }

            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 20px rgba(102, 126, 234, 0.4);
            }

            .btn-secondary {
                background: white;
                color: #667eea;
                border: 2px solid #667eea;
            }

            .btn-secondary:hover {
                background: #f8f9fa;
            }
        </style>
    </head>

    <body>
        <div class="success-container">
            <div class="success-icon"></div>
            <h1>支付成功！</h1>
            <p class="message">感谢您的购买，您的订单已支付成功</p>

            <% String outTradeNo=request.getParameter("out_trade_no"); String tradeNo=request.getParameter("trade_no");
                String totalAmount=request.getParameter("total_amount"); if (outTradeNo !=null || tradeNo !=null) { %>
                <div class="order-info">
                    <% if (outTradeNo !=null) { %>
                        <div class="order-info-item">
                            <span class="order-info-label">订单号：</span>
                            <span class="order-info-value">
                                <%= outTradeNo %>
                            </span>
                        </div>
                        <% } %>
                            <% if (tradeNo !=null) { %>
                                <div class="order-info-item">
                                    <span class="order-info-label">交易号：</span>
                                    <span class="order-info-value">
                                        <%= tradeNo %>
                                    </span>
                                </div>
                                <% } %>
                                    <% if (totalAmount !=null) { %>
                                        <div class="order-info-item">
                                            <span class="order-info-label">支付金额：</span>
                                            <span class="order-info-value">¥<%= totalAmount %></span>
                                        </div>
                                        <% } %>
                </div>
                <% } %>

                    <div class="btn-group">
                        <a href="<%= request.getContextPath() %>/index.jsp" class="btn btn-primary">返回首页</a>
                        <a href="<%= request.getContextPath() %>/ProductDetailServlet?id=1"
                            class="btn btn-secondary">继续购物</a>
                    </div>
        </div>
    </body>

    </html>