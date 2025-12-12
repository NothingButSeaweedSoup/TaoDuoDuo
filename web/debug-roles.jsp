<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.TaoDuoDuo.entity.UserRole" %>
        <%@ page import="com.TaoDuoDuo.service.UserRoleService" %>
            <%@ page import="java.util.List" %>
                <%@ page import="java.util.Optional" %>
                    <!DOCTYPE html>
                    <html lang="zh-CN">

                    <head>
                        <meta charset="UTF-8">
                        <title>角色调试页面</title>
                        <style>
                            body {
                                font-family: Arial, sans-serif;
                                margin: 20px;
                            }

                            .debug-info {
                                background: #f8f9fa;
                                padding: 15px;
                                margin: 10px 0;
                                border-radius: 5px;
                                border-left: 4px solid #007bff;
                            }

                            .error {
                                border-left-color: #dc3545;
                                background: #f8d7da;
                            }

                            .success {
                                border-left-color: #28a745;
                                background: #d4edda;
                            }
                        </style>
                    </head>

                    <body>
                        <h1>角色调试页面</h1>

                        <% Integer userId=(Integer) session.getAttribute("userId"); Integer currentRole=(Integer)
                            session.getAttribute("role"); String username=(String) session.getAttribute("username"); if
                            (userId==null) { %>
                            <div class="debug-info error">
                                <h3>错误：用户未登录</h3>
                                <p>请先<a href="view/login.jsp">登录</a></p>
                            </div>
                            <% } else { %>
                                <div class="debug-info success">
                                    <h3>Session信息</h3>
                                    <p>用户ID: <%= userId %>
                                    </p>
                                    <p>用户名: <%= username %>
                                    </p>
                                    <p>当前角色: <%= currentRole %> (<%= currentRole==1 ? "用户" : currentRole==2 ? "商家" :
                                                currentRole==3 ? "管理员" : "未知" %>)</p>
                                </div>

                                <% UserRoleService userRoleService=new UserRoleService(); int
                                    roleCount=userRoleService.getUserRoleCount(userId); Optional<List<UserRole>>
                                    userRolesOpt = userRoleService.getUserRoles(userId);
                                    List<UserRole> userRoles = userRolesOpt.orElse(null);
                                        %>

                                        <div class="debug-info">
                                            <h3>角色统计</h3>
                                            <p>角色数量: <%= roleCount %>
                                            </p>
                                            <p>可以切换角色: <%= roleCount>= 2 ? "是" : "否" %></p>
                                        </div>

                                        <div class="debug-info">
                                            <h3>用户拥有的角色详情</h3>
                                            <% if (userRoles !=null && !userRoles.isEmpty()) { %>
                                                <ul>
                                                    <% for (UserRole ur : userRoles) { int roleId=ur.getRole_id();
                                                        String roleName="" ; switch (roleId) { case 1: roleName="用户" ;
                                                        break; case 2: roleName="商家" ; break; case 3: roleName="管理员" ;
                                                        break; default: roleName="未知" ; break; } %>
                                                        <li>角色ID: <%= roleId %> - <%= roleName %>
                                                                    <%= currentRole==roleId ? "(当前)" : "" %>
                                                        </li>
                                                        <% } %>
                                                </ul>
                                                <% } else { %>
                                                    <p style="color: red;">没有找到用户角色数据！</p>
                                                    <% } %>
                                        </div>

                                        <div class="debug-info">
                                            <h3>角色权限检查</h3>
                                            <p>拥有用户角色: <%= userRoleService.hasRole(userId, 1) ? "是" : "否" %>
                                            </p>
                                            <p>拥有商家角色: <%= userRoleService.hasRole(userId, 2) ? "是" : "否" %>
                                            </p>
                                            <p>拥有管理员角色: <%= userRoleService.hasRole(userId, 3) ? "是" : "否" %>
                                            </p>
                                        </div>

                                        <div class="debug-info">
                                            <h3>测试链接</h3>
                                            <p><a href="ProfileServlet">查看个人中心</a></p>
                                            <p><a href="TestRoleServlet">角色管理测试</a></p>
                                        </div>
                                        <% } %>
                    </body>

                    </html>