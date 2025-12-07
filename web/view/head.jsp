<%@ page contentType="text/html;charset=UTF-8" language="java" %>

    <style>
        .navbar {
            width: 100%;
            height: 70px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            position: fixed;
            top: 0;
            left: 0;
            z-index: 1000;
        }

        .navbar-container {
            max-width: 1440px;
            height: 100%;
            margin: 0 auto;
            padding: 0 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .navbar-left {
            display: flex;
            align-items: center;
            gap: 50px;
        }

        .navbar-logo {
            font-size: 28px;
            font-weight: 800;
            color: #fff;
            text-decoration: none;
            letter-spacing: 1px;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: transform 0.3s;
        }

        .navbar-logo:hover {
            transform: scale(1.05);
        }

        .navbar-logo::before {
            content: '🛒';
            font-size: 32px;
        }

        .navbar-menu {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .navbar-menu a {
            font-size: 16px;
            font-weight: 500;
            color: rgba(255, 255, 255, 0.9);
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 8px;
            transition: all 0.3s;
            position: relative;
        }

        .navbar-menu a:hover {
            background-color: rgba(255, 255, 255, 0.2);
            color: #fff;
        }

        .navbar-right {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .navbar-btn {
            font-size: 15px;
            font-weight: 600;
            text-decoration: none;
            padding: 10px 24px;
            border-radius: 25px;
            transition: all 0.3s;
            border: 2px solid transparent;
            display: inline-block;
        }

        .navbar-btn.login {
            color: #fff;
            border-color: rgba(255, 255, 255, 0.5);
        }

        .navbar-btn.login:hover {
            background-color: rgba(255, 255, 255, 0.15);
            border-color: #fff;
        }

        .navbar-btn.register {
            background-color: #fff;
            color: #667eea;
        }

        .navbar-btn.register:hover {
            background-color: #f0f0f0;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }
    </style>

    <nav class="navbar">
        <div class="navbar-container">
            <!-- 左侧：Logo 和导航 -->
            <div class="navbar-left">
                <a href="#" class="navbar-logo">淘多多</a>
                <div class="navbar-menu">
                    <a href="#">首页</a>
                    <a href="#">分类</a>
                </div>
            </div>

            <!-- 右侧：未登录状态 -->
            <div class="navbar-right">
                <a href="#" class="navbar-btn login">登录</a>
                <a href="#" class="navbar-btn register">注册</a>
            </div>
        </div>
    </nav>