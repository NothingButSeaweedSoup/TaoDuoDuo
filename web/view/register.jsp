<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>注册 - 淘多多</title>
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

            /* 注册容器 */
            .register-container {
                width: 450px;
                background: rgba(255, 255, 255, 0.95);
                border-radius: 30px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
                padding: 40px 40px;
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
            .register-logo {
                text-align: center;
                margin-bottom: 25px;
            }

            .register-logo-icon {
                width: 90px;
                height: auto;
                margin-bottom: 10px;
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

            .register-subtitle {
                font-size: 15px;
                color: #8c8c8c;
                margin-top: 10px;
            }

            /* 表单 */
            .register-form {
                margin-top: 25px;
            }

            .form-group {
                margin-bottom: 16px;
                position: relative;
            }

            .form-label {
                display: block;
                font-size: 13px;
                font-weight: 600;
                color: #595959;
                margin-bottom: 8px;
                padding-left: 5px;
            }

            .form-input {
                width: 100%;
                height: 46px;
                padding: 0 18px;
                border: 2px solid #e8e8e8;
                border-radius: 12px;
                font-size: 14px;
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

            /* 密码强度提示 */
            .password-strength {
                margin-top: 8px;
                font-size: 12px;
                color: #8c8c8c;
                display: none;
            }

            .password-strength.show {
                display: block;
            }

            .password-strength.weak {
                color: #ff4d4f;
            }

            .password-strength.medium {
                color: #faad14;
            }

            .password-strength.strong {
                color: #52c41a;
            }

            /* 注册按钮 */
            .register-button {
                width: 100%;
                height: 50px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: #fff;
                border: none;
                border-radius: 12px;
                font-size: 17px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s;
                box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
                margin-top: 8px;
            }

            .register-button:hover {
                background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
                box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
                transform: translateY(-2px);
            }

            .register-button:active {
                transform: translateY(0);
            }

            /* 登录链接 */
            .login-link {
                text-align: center;
                font-size: 14px;
                color: #595959;
                margin-top: 20px;
                padding-top: 20px;
                border-top: 1px solid #e8e8e8;
            }

            .login-link a {
                color: #667eea;
                text-decoration: none;
                font-weight: 700;
                margin-left: 5px;
                transition: all 0.3s;
            }

            .login-link a:hover {
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

            /* 成功提示 */
            .success-message {
                background-color: #f6ffed;
                border: 1px solid #b7eb8f;
                border-radius: 10px;
                padding: 12px 15px;
                margin-bottom: 20px;
                color: #52c41a;
                font-size: 14px;
                display: none;
            }

            .success-message.show {
                display: block;
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

        <!-- 注册容器 -->
        <div class="register-container">
            <!-- Logo -->
            <div class="register-logo">
                <img src="${pageContext.request.contextPath}/icon/logo-orange.png" alt="淘多多" class="register-logo-icon">
                <div class="register-subtitle">创建账号，开启购物之旅</div>
            </div>

            <!-- 成功提示 -->
            <div class="success-message" id="successMessage">
                注册成功！即将跳转到登录页面...
            </div>

            <!-- 错误提示 -->
            <div class="error-message" id="errorMessage">
                注册失败，请重试
            </div>

            <!-- 注册表单 -->
            <form class="register-form" id="registerForm" method="post"
                action="${pageContext.request.contextPath}/RegisterServlet">
                <!-- 用户名 -->
                <div class="form-group">
                    <label class="form-label" for="username">用户名</label>
                    <input type="text" class="form-input" id="username" name="username" placeholder="请输入用户名（3-20个字符）"
                        required>
                </div>

                <!-- 手机号 -->
                <div class="form-group">
                    <label class="form-label" for="phone">手机号</label>
                    <input type="tel" class="form-input" id="phone" name="phone" placeholder="请输入11位手机号" required>
                </div>

                <!-- 邮箱 -->
                <div class="form-group">
                    <label class="form-label" for="email">邮箱</label>
                    <input type="email" class="form-input" id="email" name="email" placeholder="请输入邮箱地址" required>
                </div>

                <!-- 密码 -->
                <div class="form-group">
                    <label class="form-label" for="password">密码</label>
                    <input type="password" class="form-input" id="password" name="password" placeholder="请输入密码（至少6个字符）"
                        required>
                    <div class="password-strength" id="passwordStrength"></div>
                </div>

                <!-- 确认密码 -->
                <div class="form-group">
                    <label class="form-label" for="confirmPassword">确认密码</label>
                    <input type="password" class="form-input" id="confirmPassword" name="confirmPassword"
                        placeholder="请再次输入密码" required>
                </div>

                <!-- 注册按钮 -->
                <button type="submit" class="register-button">注册</button>

                <!-- 登录链接 -->
                <div class="login-link">
                    已有账号？<a href="${pageContext.request.contextPath}/view/login.jsp">立即登录</a>
                </div>
            </form>
        </div>

        <script>
            // 表单验证
            document.getElementById('registerForm').addEventListener('submit', function (e) {
                const username = document.getElementById('username').value.trim();
                const phone = document.getElementById('phone').value.trim();
                const email = document.getElementById('email').value.trim();
                const password = document.getElementById('password').value;
                const confirmPassword = document.getElementById('confirmPassword').value;

                // 验证用户名
                if (username.length < 3 || username.length > 20) {
                    e.preventDefault();
                    showError('用户名长度应在3-20个字符之间');
                    return false;
                }

                // 验证手机号格式
                const phoneRegex = /^1[3-9]\d{9}$/;
                if (!phoneRegex.test(phone)) {
                    e.preventDefault();
                    showError('请输入有效的11位手机号');
                    return false;
                }

                // 验证邮箱格式
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(email)) {
                    e.preventDefault();
                    showError('请输入有效的邮箱地址');
                    return false;
                }

                // 验证密码
                if (password.length < 6) {
                    e.preventDefault();
                    showError('密码至少需要6个字符');
                    return false;
                }

                // 验证密码一致性
                if (password !== confirmPassword) {
                    e.preventDefault();
                    showError('两次输入的密码不一致');
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

            // 显示成功信息
            function showSuccess(message) {
                const successDiv = document.getElementById('successMessage');
                successDiv.textContent = message;
                successDiv.classList.add('show');
            }

            // 密码强度检测
            document.getElementById('password').addEventListener('input', function () {
                const password = this.value;
                const strengthDiv = document.getElementById('passwordStrength');

                if (password.length === 0) {
                    strengthDiv.classList.remove('show');
                    return;
                }

                strengthDiv.classList.add('show');

                let strength = 0;
                if (password.length >= 6) strength++;
                if (password.length >= 10) strength++;
                if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
                if (/\d/.test(password)) strength++;
                if (/[^a-zA-Z0-9]/.test(password)) strength++;

                strengthDiv.classList.remove('weak', 'medium', 'strong');

                if (strength <= 2) {
                    strengthDiv.textContent = '密码强度：弱';
                    strengthDiv.classList.add('weak');
                } else if (strength <= 3) {
                    strengthDiv.textContent = '密码强度：中';
                    strengthDiv.classList.add('medium');
                } else {
                    strengthDiv.textContent = '密码强度：强';
                    strengthDiv.classList.add('strong');
                }
            });

            // 检查URL参数中的错误信息
            window.addEventListener('DOMContentLoaded', function () {
                const urlParams = new URLSearchParams(window.location.search);
                const error = urlParams.get('error');
                const success = urlParams.get('success');

                if (error === 'exists') {
                    showError('用户名或邮箱已存在');
                } else if (error === 'failed') {
                    showError('注册失败，请重试');
                } else if (success === 'true') {
                    showSuccess('注册成功！即将跳转到登录页面...');
                    setTimeout(function () {
                        window.location.href = '${pageContext.request.contextPath}/view/login.jsp';
                    }, 2000);
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