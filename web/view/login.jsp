<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>登录 - 淘多多</title>
        <style>
            * {
                box-sizing: border-box;
            }

            html {
                width: 100%;
                height: 100%;
            }

            body {
                width: 100%;
                height: 100%;
                margin: 0;
                padding: 0;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Microsoft YaHei", sans-serif;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            /* 登录容器 */
            .login-container {
                width: 450px;
                background: rgba(255, 255, 255, 0.95);
                border-radius: 30px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
                padding: 50px 45px;
                backdrop-filter: blur(10px);
                animation: slideIn 0.5s ease-out;
            }

            @keyframes slideIn {
                from {
                    opacity: 0;
                    transform: translateY(-30px);
                }

                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Logo区域 */
            .login-logo {
                text-align: center;
                margin-bottom: 40px;
            }

            .login-logo-icon {
                width: 120px;
                height: auto;
                margin-bottom: 20px;
                animation: bounce 2s ease-in-out infinite;
            }

            @keyframes bounce {

                0%,
                100% {
                    transform: translateY(0);
                }

                50% {
                    transform: translateY(-10px);
                }
            }

            .login-subtitle {
                font-size: 16px;
                color: #8c8c8c;
                margin-top: 15px;
            }

            /* 表单 */
            .login-form {
                margin-top: 30px;
            }

            .form-group {
                margin-bottom: 25px;
                position: relative;
            }

            .form-label {
                display: block;
                font-size: 14px;
                font-weight: 600;
                color: #595959;
                margin-bottom: 10px;
                padding-left: 5px;
            }

            .form-input {
                width: 100%;
                height: 50px;
                padding: 0 20px;
                border: 2px solid #e8e8e8;
                border-radius: 15px;
                font-size: 15px;
                transition: all 0.3s;
                background-color: #f8f9fa;
            }

            .form-input:focus {
                outline: none;
                border-color: #667eea;
                background-color: #fff;
                box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
            }

            .form-input::placeholder {
                color: #bfbfbf;
            }



            /* 登录按钮 */
            .login-button {
                width: 100%;
                height: 55px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: #fff;
                border: none;
                border-radius: 15px;
                font-size: 18px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s;
                box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
            }

            .login-button:hover {
                background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
                box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
                transform: translateY(-2px);
            }

            .login-button:active {
                transform: translateY(0);
            }

            /* 注册链接 */
            .register-link {
                text-align: center;
                font-size: 15px;
                color: #595959;
                margin-top: 25px;
                padding-top: 25px;
                border-top: 1px solid #e8e8e8;
            }

            .register-link a {
                color: #667eea;
                text-decoration: none;
                font-weight: 700;
                margin-left: 5px;
                transition: all 0.3s;
            }

            .register-link a:hover {
                color: #764ba2;
                text-decoration: underline;
            }

            /* 错误提示 */
            .error-message {
                background-color: #fff2f0;
                border: 1px solid #ffccc7;
                border-radius: 10px;
                padding: 12px 15px;
                margin-bottom: 20px;
                color: #ff4d4f;
                font-size: 14px;
                display: none;
            }

            .error-message.show {
                display: block;
                animation: shake 0.5s;
            }

            @keyframes shake {

                0%,
                100% {
                    transform: translateX(0);
                }

                25% {
                    transform: translateX(-10px);
                }

                75% {
                    transform: translateX(10px);
                }
            }

            /* 返回首页 */
            .back-home {
                position: absolute;
                top: 30px;
                left: 30px;
                display: flex;
                align-items: center;
                gap: 8px;
                color: #fff;
                text-decoration: none;
                font-size: 16px;
                font-weight: 600;
                padding: 10px 20px;
                border-radius: 25px;
                background-color: rgba(255, 255, 255, 0.2);
                backdrop-filter: blur(10px);
                transition: all 0.3s;
            }

            .back-home:hover {
                background-color: rgba(255, 255, 255, 0.3);
                transform: translateX(-5px);
            }
        </style>
    </head>

    <body>
        <!-- 返回首页 -->
        <a href="${pageContext.request.contextPath}/index.jsp" class="back-home">
            <span>←</span>
            <span>返回首页</span>
        </a>

        <!-- 登录容器 -->
        <div class="login-container">
            <!-- Logo -->
            <div class="login-logo">
                <img src="${pageContext.request.contextPath}/icon/logo-orange.png" alt="淘多多" class="login-logo-icon">
                <div class="login-subtitle">欢迎回来，开始购物之旅</div>
            </div>

            <!-- 错误提示 -->
            <div class="error-message" id="errorMessage">
                账号或密码错误，请重试
            </div>

            <!-- 登录表单 -->
            <form class="login-form" id="loginForm" method="post"
                action="${pageContext.request.contextPath}/LoginServlet">
                <!-- 账号 -->
                <div class="form-group">
                    <label class="form-label" for="username">账号</label>
                    <input type="text" class="form-input" id="username" name="username" placeholder="请输入手机号/邮箱"
                        required>
                </div>

                <!-- 密码 -->
                <div class="form-group">
                    <label class="form-label" for="password">密码</label>
                    <input type="password" class="form-input" id="password" name="password" placeholder="请输入密码"
                        required>
                </div>

                <!-- 登录按钮 -->
                <button type="submit" class="login-button">登录</button>

                <!-- 注册链接 -->
                <div class="register-link">
                    还没有账号？<a href="${pageContext.request.contextPath}/view/register.jsp">立即注册</a>
                </div>
            </form>
        </div>

        <script>
            // 表单验证
            document.getElementById('loginForm').addEventListener('submit', function (e) {
                const username = document.getElementById('username').value.trim();
                const password = document.getElementById('password').value.trim();

                if (!username || !password) {
                    e.preventDefault();
                    showError('请填写完整的登录信息');
                    return false;
                }

                if (password.length < 6) {
                    e.preventDefault();
                    showError('密码至少需要6个字符');
                    return false;
                }
            });

            // 显示错误信息
            function showError(message) {
                const errorDiv = document.getElementById('errorMessage');
                errorDiv.textContent = message;
                errorDiv.classList.add('show');

                setTimeout(function () {
                    errorDiv.classList.remove('show');
                }, 3000);
            }

            // 检查URL参数中的错误信息
            window.addEventListener('DOMContentLoaded', function () {
                const urlParams = new URLSearchParams(window.location.search);
                const error = urlParams.get('error');

                if (error === 'invalid') {
                    showError('账号或密码错误');
                } else if (error === 'required') {
                    showError('请先登录');
                } else if (error === 'empty') {
                    showError('账号和密码不能为空');
                } else if (success === 'true') {
                    showSuccess('注册成功！请登录');
                }
            });

            // 输入框焦点效果
            document.querySelectorAll('.form-input').forEach(function (input) {
                input.addEventListener('focus', function () {
                    this.parentElement.classList.add('focused');
                });

                input.addEventListener('blur', function () {
                    this.parentElement.classList.remove('focused');
                });
            });
        </script>
    </body>

    </html>