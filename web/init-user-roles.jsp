<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.TaoDuoDuo.service.UserRoleService" %>
        <%@ page import="com.TaoDuoDuo.dao.UserRoleDao" %>
            <%@ page import="com.TaoDuoDuo.entity.UserRole" %>
                <%@ page import="java.util.List" %>
                    <%@ page import="java.util.Optional" %>
                        <!DOCTYPE html>
                        <html lang="zh-CN">

                        <head>
                            <meta charset="UTF-8">
                            <title>初始化用户角色</title>
                            <style>
                                body {
                                    font-family: Arial, sans-serif;
                                    margin: 20px;
                                }

                                .info {
                                    background: #d4edda;
                                    padding: 15px;
                                    margin: 10px 0;
                                    border-radius: 5px;
                                    border-left: 4px solid #28a745;
                                }

                                .warning {
                                    background: #fff3cd;
                                    padding: 15px;
                                    margin: 10px 0;
                                    border-radius: 5px;
                                    border-left: 4px solid #ffc107;
                                }

                                .error {
                                    background: #f8d7da;
                                    padding: 15px;
                                    margin: 10px 0;
                                    border-radius: 5px;
                                    border-left: 4px solid #dc3545;
                                }

                                .btn {
                                    padding: 10px 20px;
                                    background: #007bff;
                                    color: white;
                                    text-decoration: none;
                                    border-radius: 4px;
                                    display: inline-block;
                                    margin: 5px;
                                }

                                .btn:hover {
                                    background: #0056b3;
                                }
                            </style>
                        </head>

                        <body>
                            <h1>用户角色初始化页面</h1>

                            <% Integer userId=(Integer) session.getAttribute("userId"); String username=(String)
                                session.getAttribute("username"); if (userId==null) { %>
                                <div class="error">
                                    <h3>错误：用户未登录</h3>
                                    <p>请先<a href="view/login.jsp">登录</a></p>
                                </div>
                                <% } else { UserRoleService userRoleService=new UserRoleService(); // 检查当前用户的角色 int
                                    roleCount=userRoleService.getUserRoleCount(userId); Optional<List<UserRole>>
                                    userRolesOpt = userRoleService.getUserRoles(userId);
                                    List<UserRole> userRoles = userRolesOpt.orElse(null);

                                        String action = request.getParameter("action");

                                        if ("init".equals(action)) {
                                        // 初始化用户角色
                                        boolean success = false;
                                        if (!userRoleService.hasRole(userId, 1)) {
                                        success = userRoleService.addUserRole(userId, 1);
                                        if (success) {
                                        %>
                                        <div class="info">
                                            <p>✓ 成功为用户添加"用户"角色</p>
                                        </div>
                                        <% } else { %>
                                            <div class="error">
                                                <p>✗ 添加"用户"角色失败</p>
                                            </div>
                                            <% } } else { %>
                                                <div class="warning">
                                                    <p>用户已经拥有"用户"角色，无需重复添加</p>
                                                </div>
                                                <% } // 重新获取角色数据 roleCount=userRoleService.getUserRoleCount(userId);
                                                    userRolesOpt=userRoleService.getUserRoles(userId);
                                                    userRoles=userRolesOpt.orElse(null); } %>

                                                    <div class="info">
                                                        <h3>当前用户信息</h3>
                                                        <p>用户ID: <%= userId %>
                                                        </p>
                                                        <p>用户名: <%= username %>
                                                        </p>
                                                        <p>角色数量: <%= roleCount %>
                                                        </p>
                                                    </div>

                                                    <div class="info">
                                                        <h3>用户拥有的角色</h3>
                                                        <% if (userRoles !=null && !userRoles.isEmpty()) { %>
                                                            <ul>
                                                                <% for (UserRole ur : userRoles) { int
                                                                    roleId=ur.getRole_id(); String roleName="" ; switch
                                                                    (roleId) { case 1: roleName="用户" ; break; case 2:
                                                                    roleName="商家" ; break; case 3: roleName="管理员" ;
                                                                    break; default: roleName="未知" ; break; } %>
                                                                    <li>角色ID: <%= roleId %> - <%= roleName %>
                                                                    </li>
                                                                    <% } %>
                                                            </ul>
                                                            <% } else { %>
                                                                <div class="warning">
                                                                    <p>⚠️ 用户没有任何角色！这可能会导致角色切换功能无法正常工作。</p>
                                                                    <a href="?action=init" class="btn">初始化用户角色</a>
                                                                </div>
                                                                <% } %>
                                                    </div>

                                                    <div class="info">
                                                        <h3>角色权限检查</h3>
                                                        <p>拥有用户角色: <%= userRoleService.hasRole(userId, 1) ? "✓ 是"
                                                                : "✗ 否" %>
                                                        </p>
                                                        <p>拥有商家角色: <%= userRoleService.hasRole(userId, 2) ? "✓ 是"
                                                                : "✗ 否" %>
                                                        </p>
                                                        <p>拥有管理员角色: <%= userRoleService.hasRole(userId, 3) ? "✓ 是"
                                                                : "✗ 否" %>
                                                        </p>
                                                    </div>

                                                    <div class="info">
                                                        <h3>操作</h3>
                                                        <a href="?action=init" class="btn">重新初始化角色</a>
                                                        <a href="ProfileServlet" class="btn">查看个人中心</a>
                                                        <a href="TestRoleServlet" class="btn">角色管理测试</a>
                                                        <a href="debug-roles.jsp" class="btn">调试页面</a>
                                                    </div>
                                                    <% } %>
                        </body>

                        </html>