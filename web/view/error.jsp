<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>操作失败 - 淘多多</title>
        <style>
            * {
                box-sizing: border-box;
            }

            body {
                margin: 0;
                padding: 110px 20px 40px;
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Microsoft YaHei", sans-serif;
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .error-container {
                max-width: 600px;
                background: white;
                border-radius: 16px;
                padding: 40px;
                box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
                text-align: center;
            }

            .error-icon {
                font-size: 80px;
                margin-bottom: 20px;
                color: #ff6b6b;
            }

            .error-title {
                font-size: 24px;
                font-weight: 700;
                color: #262626;
                margin-bottom: 15px;
            }

            .error-message {
                font-size: 16px;
                color: #595959;
                line-height: 1.6;
                margin-bottom: 30px;
            }

            .error-actions {
                display: flex;
                gap: 15px;
                justify-content: center;
                flex-wrap: wrap;
            }

            .btn {
                padding: 12px 24px;
                border: none;
                border-radius: 8px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                text-decoration: none;
                display: inline-block;
                transition: all 0.3s;
            }

            .btn-primary {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
            }

            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
            }

            .btn-secondary {
                background: #f5f5f5;
                color: #595959;
                border: 1px solid #d9d9d9;
            }

            .btn-secondary:hover {
                background: #e8e8e8;
                border-color: #bfbfbf;
            }
        </style>
    </head>

    <body>
        <%@ include file="head.jsp" %>

            <div class="error-container">
                <div class="error-icon">
                    <img src="${pageContext.request.contextPath}/icon/Success.png"
                         alt="成功"
                         style="width: 14px; height: 14px; vertical-align: middle; margin-right: 4px;">
                </div>
                <div class="error-title">操作失败</div>
                <div class="error-message">
                    <% String errorMsg=request.getParameter("error"); if (errorMsg !=null && !errorMsg.isEmpty()) {
                        out.print(errorMsg); } else { out.print("抱歉，操作失败，请重试。"); } %>
                </div>
                <div class="error-actions">
                    <a href="javascript:history.back()" class="btn btn-secondary">返回上页</a>
                    <a href="<%= request.getContextPath() %>/index.jsp" class="btn btn-primary">返回首页</a>
                </div>
            </div>
    </body>

    </html>