<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.TaoDuoDuo.entity.UserRole" %>
        <%@ page import="java.util.List" %>
            <!DOCTYPE html>
            <html lang="zh-CN">

            <head>
                <meta charset="UTF-8">
                <title>角色切换测试</title>
                <style>
                    body {
                        font-family: Arial, sans-serif;
                        margin: 20px;
                    }

                    .role-info {
                        background: #f5f5f5;
                        padding: 15px;
                        margin: 10px 0;
                        border-radius: 5px;
                    }

                    .role-option {
                        display: inline-block;
                        padding: 8px 16px;
                        margin: 5px;
                        background: #007bff;
                        color: white;
                        text-decoration: none;
                        border-radius: 4px;
                    }

                    .role-option:hover {
                        background: #0056b3;
                    }

                    .active {
                        background: #28a745 !important;
                    }
                </style>
            </head>

            <body>
                <h1>角色切换功能测试</h1>

                <% Integer userId=(Integer) session.getAttribute("userId"); Integer currentRole=(Integer)
                    session.getAttribute("role"); String username=(String) session.getAttribute("username"); if
                    (userId==null) { %>
                    <p>请先<a href="view/login.jsp">登录</a></p>
                    <% } else { %>
                        <div class="role-info">
                            <h3>当前用户信息</h3>
                            <p>用户ID: <%= userId %>
                            </p>
                            <p>用户名: <%= username %>
                            </p>
                            <p>当前角色: <%= currentRole==1 ? "用户" : currentRole==2 ? "商家" : currentRole==3 ? "管理员" : "未知"
                                    %>
                            </p>
                        </div>

                        <h3>可用角色（仅显示您拥有的角色）</h3>
                        <p>这里应该只显示您实际拥有的角色，而不是所有角色。</p>

                        <div>
                            <a href="ProfileServlet" class="role-option">查看个人中心</a>
                            <a href="TestRoleServlet" class="role-option">角色管理测试</a>
                        </div>
                        <% } %>

                            <hr>
                            <h3>功能说明</h3>
                            <ul>
                                <li>修改后的角色切换功能只会显示用户实际拥有的角色</li>
                                <li>如果用户只有"用户"角色，则只显示"用户"选项</li>
                                <li>如果用户同时拥有"用户"和"商家"角色，则显示这两个选项</li>
                                <li>管理员角色同样只在用户拥有时才显示</li>
                            </ul>
            </body>

            </html>