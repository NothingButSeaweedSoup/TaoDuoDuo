<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.TaoDuoDuo.entity.UserRole" %>
        <%@ page import="com.TaoDuoDuo.service.UserRoleService" %>
            <%@ page import="java.util.List" %>
                <%@ page import="java.util.Optional" %>
                    <!DOCTYPE html>
                    <html lang="zh-CN">

                    <head>
                        <meta charset="UTF-8">
                        <title>角色显示测试</title>
                        <style>
                            body {
                                font-family: Arial, sans-serif;
                                margin: 20px;
                            }

                            .role-switch {
                                background: #fff2e8;
                                border: 1px solid #ffd591;
                                border-radius: 8px;
                                padding: 15px;
                                margin: 20px 0;
                            }

                            .role-switch-title {
                                font-size: 14px;
                                font-weight: 600;
                                color: #d46b08;
                                margin-bottom: 10px;
                            }

                            .role-options {
                                display: flex;
                                gap: 10px;
                            }

                            .role-option {
                                padding: 8px 16px;
                                border: 1px solid #ffd591;
                                border-radius: 6px;
                                background: white;
                                color: #d46b08;
                                font-size: 14px;
                                cursor: pointer;
                                transition: all 0.3s;
                            }

                            .role-option:hover {
                                background: #ffd591;
                                color: white;
                            }

                            .role-option.active {
                                background: #fa8c16;
                                color: white;
                                border-color: #fa8c16;
                            }

                            .info {
                                background: #f8f9fa;
                                padding: 15px;
                                margin: 10px 0;
                                border-radius: 5px;
                            }
                        </style>
                    </head>

                    <body>
                        <h1>角色切换显示测试</h1>

                        <% Integer userId=(Integer) session.getAttribute("userId"); Integer currentRole=(Integer)
                            session.getAttribute("role"); String username=(String) session.getAttribute("username"); if
                            (userId==null) { %>
                            <div class="info">
                                <p>请先<a href="view/login.jsp">登录</a></p>
                            </div>
                            <% } else { UserRoleService userRoleService=new UserRoleService(); int
                                roleCount=userRoleService.getUserRoleCount(userId); Optional<List<UserRole>>
                                userRolesOpt = userRoleService.getUserRoles(userId);
                                List<UserRole> userRoles = userRolesOpt.orElse(null);
                                    %>

                                    <div class="info">
                                        <h3>当前用户信息</h3>
                                        <p>用户ID: <%= userId %>
                                        </p>
                                        <p>用户名: <%= username %>
                                        </p>
                                        <p>当前角色: <%= currentRole %> (<%= currentRole==1 ? "用户" : currentRole==2 ? "商家" :
                                                    currentRole==3 ? "管理员" : "未知" %>)</p>
                                        <p>角色数量: <%= roleCount %>
                                        </p>
                                    </div>

                                    <h3>角色切换测试（模拟个人中心的显示效果）</h3>

                                    <div class="role-switch">
                                        <div class="role-switch-title">当前身份切换 (您拥有 <%= roleCount %> 个身份)</div>
                                        <div class="role-options">
                                            <% if (userRoles !=null) { for (UserRole ur : userRoles) { int
                                                roleId=ur.getRole_id(); String roleName="" ; switch (roleId) { case 1:
                                                roleName="用户" ; break; case 2: roleName="商家" ; break; case 3:
                                                roleName="管理员" ; break; default: roleName="未知" ; break; } %>
                                                <div class="role-option <%= currentRole == roleId ? " active" : "" %>"
                                                    onclick="switchRole(<%= roleId %>)">
                                                        <%= roleName %>
                                                </div>
                                                <% } } else { %>
                                                    <p style="color: red;">没有找到用户角色数据！</p>
                                                    <% } %>
                                        </div>
                                    </div>

                                    <div class="info">
                                        <h3>调试信息</h3>
                                        <p>userRoles 是否为 null: <%= userRoles==null ? "是" : "否" %>
                                        </p>
                                        <% if (userRoles !=null) { %>
                                            <p>userRoles 大小: <%= userRoles.size() %>
                                            </p>
                                            <p>角色详情:</p>
                                            <ul>
                                                <% for (UserRole ur : userRoles) { %>
                                                    <li>ID: <%= ur.getUser_role_id() %>, 用户ID: <%= ur.getUser_id() %>,
                                                                角色ID: <%= ur.getRole_id() %>
                                                    </li>
                                                    <% } %>
                                            </ul>
                                            <% } %>
                                    </div>

                                    <div class="info">
                                        <h3>操作链接</h3>
                                        <p><a href="ProfileServlet">查看个人中心</a></p>
                                        <p><a href="init-user-roles.jsp">初始化用户角色</a></p>
                                        <p><a href="TestRoleServlet">角色管理测试</a></p>
                                    </div>
                                    <% } %>

                                        <script>
                                            function switchRole(role) {
                                                const roleName = role == 1 ? '用户' : role == 2 ? '商家' : '管理员';
                                                if (confirm('确定要切换到 "' + roleName + '" 身份吗？')) {
                                                    const form = document.createElement('form');
                                                    form.method = 'POST';
                                                    form.action = 'SwitchRoleServlet';

                                                    const roleInput = document.createElement('input');
                                                    roleInput.type = 'hidden';
                                                    roleInput.name = 'roleId';
                                                    roleInput.value = role;

                                                    form.appendChild(roleInput);
                                                    document.body.appendChild(form);
                                                    form.submit();
                                                }
                                            }
                                        </script>
                    </body>

                    </html>