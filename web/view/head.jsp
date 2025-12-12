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
            display: flex;
            align-items: center;
            text-decoration: none;
            transition: transform 0.3s;
        }

        .navbar-logo:hover {
            transform: scale(1.05);
        }

        .navbar-logo-img {
            height: 50px;
            width: auto;
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

        .navbar-user {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .navbar-user-name {
            color: #fff;
            font-size: 15px;
            font-weight: 500;
        }

        .navbar-user-menu {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .navbar-user-menu a {
            font-size: 15px;
            font-weight: 500;
            color: rgba(255, 255, 255, 0.9);
            text-decoration: none;
            padding: 8px 18px;
            border-radius: 8px;
            transition: all 0.3s;
        }

        .navbar-user-menu a:hover {
            background-color: rgba(255, 255, 255, 0.2);
            color: #fff;
        }

        .navbar-btn.logout {
            color: #fff;
            border-color: rgba(255, 255, 255, 0.5);
            padding: 8px 20px;
        }

        .navbar-btn.logout:hover {
            background-color: rgba(255, 255, 255, 0.15);
            border-color: #fff;
        }
    </style>

    <nav class="navbar">
        <div class="navbar-container">
            <!-- 左侧：Logo 和导航 -->
            <div class="navbar-left">
                <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-logo">
                    <img src="${pageContext.request.contextPath}/icon/logo-white.png" alt="淘多多" class="navbar-logo-img">
                </a>
                <div class="navbar-menu">
                    <a href="${pageContext.request.contextPath}/index.jsp">首页</a>
                    <a href="#">分类</a>
                </div>
            </div>

            <!-- 右侧：根据登录状态显示 -->
            <div class="navbar-right">
                <% String navUsername=(String) session.getAttribute("username"); Integer navUserRole=(Integer)
                    session.getAttribute("role"); if (navUsername !=null && !navUsername.isEmpty()) { %>
                    <div class="navbar-user">
                        <span class="navbar-user-name">欢迎，<%= navUsername %>
                                <% if (navUserRole !=null) { %>
                                    <span style="font-size: 12px; opacity: 0.8;">
                                        (<%= navUserRole==1 ? "用户" : navUserRole==2 ? "商家" : navUserRole==3 ? "管理员"
                                            : "未知" %>)
                                    </span>
                                    <% } %>
                        </span>
                        <div class="navbar-user-menu">
                            <% if (navUserRole !=null && navUserRole==1) { %>
                                <a href="${pageContext.request.contextPath}/CartServlet">购物车</a>
                                <% } %>
                                    <a href="#">订单</a>
                                    <a href="${pageContext.request.contextPath}/ProfileServlet">个人中心</a>
                        </div>
                        <a href="${pageContext.request.contextPath}/LogoutServlet" class="navbar-btn logout">退出</a>
                    </div>
                    <% } else { %>
                        <a href="${pageContext.request.contextPath}/view/login.jsp" class="navbar-btn login">登录</a>
                        <a href="${pageContext.request.contextPath}/view/register.jsp"
                            class="navbar-btn register">注册</a>
                        <% } %>
            </div>
        </div>
    </nav>