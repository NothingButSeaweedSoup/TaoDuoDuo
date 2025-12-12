<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.TaoDuoDuo.entity.User" %>
        <%@ page import="com.TaoDuoDuo.entity.UserRole" %>
            <%@ page import="java.util.List" %>
                <!DOCTYPE html>
                <html lang="zh-CN">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>个人中心 - 淘多多</title>
                    <style>
                        * {
                            box-sizing: border-box;
                        }

                        body {
                            margin: 0;
                            padding: 110px 20px 40px;
                            background-color: #f5f5f5;
                            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Microsoft YaHei", sans-serif;
                            min-height: 100vh;
                        }

                        .profile-container {
                            max-width: 1200px;
                            margin: 0 auto;
                            display: flex;
                            gap: 30px;
                        }

                        /* 左侧边栏 */
                        .sidebar {
                            width: 280px;
                            background: white;
                            border-radius: 12px;
                            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
                            overflow: hidden;
                        }

                        .user-info {
                            padding: 30px 20px;
                            text-align: center;
                            border-bottom: 1px solid #f0f0f0;
                        }

                        .user-avatar {
                            width: 80px;
                            height: 80px;
                            border-radius: 50%;
                            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            margin: 0 auto 15px;
                            color: white;
                            font-size: 32px;
                            font-weight: 600;
                        }

                        .user-name {
                            font-size: 18px;
                            font-weight: 600;
                            color: #262626;
                            margin-bottom: 5px;
                        }

                        .user-id {
                            font-size: 14px;
                            color: #8c8c8c;
                            margin-bottom: 5px;
                        }

                        .user-role {
                            font-size: 12px;
                            color: #595959;
                        }

                        .menu-list {
                            list-style: none;
                            padding: 0;
                            margin: 0;
                        }

                        .menu-item {
                            border-bottom: 1px solid #f0f0f0;
                        }

                        .menu-item:last-child {
                            border-bottom: none;
                        }

                        .menu-link {
                            display: flex;
                            align-items: center;
                            padding: 18px 20px;
                            text-decoration: none;
                            color: #595959;
                            font-size: 15px;
                            transition: all 0.3s;
                        }

                        .menu-link:hover {
                            background-color: #f8f9fa;
                            color: #667eea;
                        }

                        .menu-link.active {
                            background-color: #667eea;
                            color: white;
                        }

                        .menu-icon {
                            width: 20px;
                            height: 20px;
                            margin-right: 12px;
                            font-size: 16px;
                        }

                        /* 右侧内容区 */
                        .content-area {
                            flex: 1;
                            background: white;
                            border-radius: 12px;
                            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
                            padding: 40px;
                        }

                        .content-title {
                            font-size: 24px;
                            font-weight: 600;
                            color: #262626;
                            margin-bottom: 30px;
                            text-align: center;
                        }

                        .form-group {
                            margin-bottom: 25px;
                        }

                        .form-label {
                            display: block;
                            font-size: 15px;
                            font-weight: 500;
                            color: #262626;
                            margin-bottom: 8px;
                            text-align: right;
                            width: 100px;
                            float: left;
                            line-height: 45px;
                        }

                        .form-input-wrapper {
                            margin-left: 120px;
                        }

                        .form-input {
                            width: 100%;
                            max-width: 300px;
                            height: 45px;
                            padding: 0 15px;
                            border: 1px solid #d9d9d9;
                            border-radius: 8px;
                            font-size: 15px;
                            transition: all 0.3s;
                        }

                        .form-input:focus {
                            outline: none;
                            border-color: #667eea;
                            box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.1);
                        }

                        .form-input:disabled {
                            background-color: #f5f5f5;
                            color: #8c8c8c;
                            cursor: not-allowed;
                        }

                        .form-input::placeholder {
                            color: #bfbfbf;
                        }

                        .form-actions {
                            text-align: center;
                            margin-top: 40px;
                        }

                        .btn {
                            padding: 12px 30px;
                            border: none;
                            border-radius: 25px;
                            font-size: 16px;
                            font-weight: 600;
                            cursor: pointer;
                            text-decoration: none;
                            display: inline-block;
                            transition: all 0.3s;
                            margin: 0 10px;
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

                        .role-switch {
                            background: #fff2e8;
                            border: 1px solid #ffd591;
                            border-radius: 8px;
                            padding: 15px;
                            margin-bottom: 25px;
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

                        .clearfix::after {
                            content: "";
                            display: table;
                            clear: both;
                        }

                        /* 响应式设计 */
                        @media (max-width: 768px) {
                            .profile-container {
                                flex-direction: column;
                            }

                            .sidebar {
                                width: 100%;
                            }

                            .form-label {
                                float: none;
                                text-align: left;
                                width: auto;
                                line-height: normal;
                                margin-bottom: 5px;
                            }

                            .form-input-wrapper {
                                margin-left: 0;
                            }
                        }
                    </style>
                </head>

                <body>
                    <%@ include file="head.jsp" %>

                        <div class="profile-container">
                            <!-- 左侧边栏 -->
                            <div class="sidebar">
                                <div class="user-info">
                                    <div class="user-avatar">
                                        <% String username=(String) request.getAttribute("profileUsername"); if
                                            (username==null) username=(String) session.getAttribute("username"); Integer
                                            userRole=(Integer) request.getAttribute("profileUserRole"); if
                                            (userRole==null) userRole=(Integer) session.getAttribute("role"); Boolean
                                            canSwitchRole=(Boolean) request.getAttribute("canSwitchRole"); Integer
                                            roleCount=(Integer) request.getAttribute("roleCount"); %>
                                            <%= username !=null ? username.substring(0, 1).toUpperCase() : "U" %>
                                    </div>
                                    <div class="user-name">
                                        <%= username %>
                                    </div>
                                    <div class="user-id">
                                        ID: <%= request.getAttribute("profileUserId") !=null ?
                                            request.getAttribute("profileUserId") : session.getAttribute("userId") %>
                                    </div>
                                    <div class="user-role">
                                        <%= userRole==1 ? "用户" : userRole==2 ? "商家" : userRole==3 ? "管理员" : "未知" %>
                                    </div>
                                </div>

                                <ul class="menu-list">
                                    <li class="menu-item">
                                        <a href="#" class="menu-link active" onclick="showContent('personal-info')">
                                            <span class="menu-icon">👤</span>
                                            个人信息
                                        </a>
                                    </li>
                                    <li class="menu-item">
                                        <a href="#" class="menu-link" onclick="showContent('orders')">
                                            <span class="menu-icon">📋</span>
                                            账单
                                        </a>
                                    </li>
                                    <% if (userRole !=null && userRole==1) { %>
                                        <li class="menu-item">
                                            <a href="${pageContext.request.contextPath}/CartServlet" class="menu-link">
                                                <span class="menu-icon">🛒</span>
                                                购物车
                                            </a>
                                        </li>
                                        <% } %>
                                            <% if (canSwitchRole !=null && canSwitchRole) { %>
                                                <li class="menu-item">
                                                    <a href="#" class="menu-link" onclick="showContent('role-switch')">
                                                        <span class="menu-icon">🔄</span>
                                                        角色切换
                                                    </a>
                                                </li>
                                                <% } %>
                                                    <li class="menu-item">
                                                        <a href="#" class="menu-link" onclick="showContent('merchant')">
                                                            <span class="menu-icon">🏪</span>
                                                            商家入驻
                                                        </a>
                                                    </li>
                                </ul>
                            </div>

                            <!-- 右侧内容区 -->
                            <div class="content-area">
                                <!-- 个人信息修改 -->
                                <div id="personal-info" class="content-section">
                                    <h2 class="content-title">个人信息修改</h2>

                                    <form id="profileForm" method="post"
                                        action="${pageContext.request.contextPath}/UpdateProfileServlet">
                                        <div class="form-group clearfix">
                                            <label class="form-label">用户ID:</label>
                                            <div class="form-input-wrapper">
                                                <input type="text" class="form-input" value="<%= request.getAttribute("profileUserId") !=null ? request.getAttribute("profileUserId") :
                                                    session.getAttribute("userId") %>"
                                                disabled placeholder="用户ID，不可修改">
                                            </div>
                                        </div>

                                        <div class="form-group clearfix">
                                            <label class="form-label">用户名:</label>
                                            <div class="form-input-wrapper">
                                                <input type="text" name="username" class="form-input"
                                                    value="<%= username %>" placeholder="请输入用户名">
                                            </div>
                                        </div>

                                        <div class="form-group clearfix">
                                            <label class="form-label">旧密码:</label>
                                            <div class="form-input-wrapper">
                                                <input type="password" name="oldPassword" class="form-input"
                                                    placeholder="留空，若提交时为空则不修改密码">
                                            </div>
                                        </div>

                                        <div class="form-group clearfix">
                                            <label class="form-label">新密码:</label>
                                            <div class="form-input-wrapper">
                                                <input type="password" name="newPassword" class="form-input"
                                                    placeholder="留空，若提交时为空则不修改密码">
                                            </div>
                                        </div>

                                        <div class="form-group clearfix">
                                            <label class="form-label">邮箱:</label>
                                            <div class="form-input-wrapper">
                                                <% User user=(User) request.getAttribute("profileUser"); if (user==null)
                                                    user=(User) session.getAttribute("user"); %>
                                                    <input type="email" name="email" class="form-input"
                                                        value="<%= user != null && user.getEmail() != null ? user.getEmail() : "" %>"
                                                        placeholder="请输入邮箱">
                                            </div>
                                        </div>

                                        <div class="form-group clearfix">
                                            <label class="form-label">手机:</label>
                                            <div class="form-input-wrapper">
                                                <input type="tel" name="phone" class="form-input"
                                                    value="<%= user != null && user.getPhone() != null ? user.getPhone() : "" %>"
                                                    placeholder="请输入手机号">
                                            </div>
                                        </div>

                                        <div class="form-actions">
                                            <button type="submit" class="btn btn-primary">✓ 提交修改</button>
                                            <button type="reset" class="btn btn-secondary">重置</button>
                                        </div>
                                    </form>
                                </div>

                                <!-- 账单页面 -->
                                <div id="orders" class="content-section" style="display: none;">
                                    <h2 class="content-title">我的账单</h2>
                                    <div style="text-align: center; padding: 60px 0; color: #8c8c8c;">
                                        <div style="font-size: 48px; margin-bottom: 20px;">📋</div>
                                        <div>账单功能开发中...</div>
                                    </div>
                                </div>

                                <!-- 角色切换页面 -->
                                <div id="role-switch" class="content-section" style="display: none;">
                                    <h2 class="content-title">角色切换</h2>

                                    <% roleCount=(Integer) request.getAttribute("roleCount"); List<UserRole> userRoles =
                                        (List<UserRole>) request.getAttribute("userRoles");
                                            String success = (String) request.getAttribute("success");
                                            String error = (String) request.getAttribute("error");
                                            %>

                                            <!-- 消息显示 -->
                                            <% if (success !=null) { %>
                                                <div
                                                    style="background: #f6ffed; border: 1px solid #b7eb8f; border-radius: 8px; padding: 15px; margin-bottom: 20px; color: #52c41a;">
                                                    <% if ("role_switched".equals(success)) { %>
                                                        ✓ 角色切换成功！
                                                        <% } %>
                                                </div>
                                                <% } %>

                                                    <% if (error !=null) { %>
                                                        <div
                                                            style="background: #fff2f0; border: 1px solid #ffccc7; border-radius: 8px; padding: 15px; margin-bottom: 20px; color: #ff4d4f;">
                                                            <% if ("no_permission".equals(error)) { %>
                                                                ✗ 您没有权限切换到该角色！
                                                                <% } else if ("invalid_role".equals(error)) { %>
                                                                    ✗ 无效的角色参数！
                                                                    <% } else { %>
                                                                        ✗ 角色切换失败，请重试！
                                                                        <% } %>
                                                        </div>
                                                        <% } %>

                                                            <div class="role-switch">
                                                                <div class="role-switch-title">当前身份切换 (您拥有 <%= roleCount
                                                                        %> 个身份)</div>
                                                                <div class="role-options">
                                                                    <% if (userRoles !=null) { for (UserRole ur :
                                                                        userRoles) { int roleId=ur.getRole_id(); String
                                                                        roleName="" ; switch (roleId) { case 1:
                                                                        roleName="用户" ; break; case 2: roleName="商家" ;
                                                                        break; case 3: roleName="管理员" ; break; default:
                                                                        roleName="未知" ; break; } %>
                                                                        <div class="role-option <%= userRole == roleId ? "active" : "" %>" onclick="switchRole(<%=
                                                                                roleId %>)">
                                                                                <%= roleName %>
                                                                        </div>
                                                                        <% } } %>
                                                                </div>
                                                            </div>

                                                            <div
                                                                style="text-align: center; padding: 40px 0; color: #8c8c8c;">
                                                                <div style="font-size: 48px; margin-bottom: 20px;">🔄
                                                                </div>
                                                                <div>选择您要切换到的身份</div>
                                                                <div
                                                                    style="font-size: 14px; margin-top: 10px; color: #bfbfbf;">
                                                                    不同身份拥有不同的功能权限
                                                                </div>
                                                            </div>
                                </div>

                                <!-- 商家入驻页面 -->
                                <div id="merchant" class="content-section" style="display: none;">
                                    <h2 class="content-title">商家入驻</h2>

                                    <div style="text-align: center; padding: 60px 0; color: #8c8c8c;">
                                        <div style="font-size: 48px; margin-bottom: 20px;">🏪</div>
                                        <div>商家入驻功能开发中...</div>
                                        <div style="font-size: 14px; margin-top: 10px; color: #bfbfbf;">
                                            申请成为商家，开启您的电商之旅
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <script>
                            // 显示不同的内容区域
                            function showContent(sectionId) {
                                // 隐藏所有内容区域
                                const sections = document.querySelectorAll('.content-section');
                                sections.forEach(section => {
                                    section.style.display = 'none';
                                });

                                // 显示选中的内容区域
                                document.getElementById(sectionId).style.display = 'block';

                                // 更新菜单激活状态
                                const menuLinks = document.querySelectorAll('.menu-link');
                                menuLinks.forEach(link => {
                                    link.classList.remove('active');
                                });
                                event.target.closest('.menu-link').classList.add('active');
                            }

                            // 角色切换功能
                            function switchRole(role) {
                                // 确认切换
                                const roleName = role == 1 ? '用户' : role == 2 ? '商家' : '管理员';
                                if (confirm('确定要切换到 "' + roleName + '" 身份吗？')) {
                                    // 创建表单并提交
                                    const form = document.createElement('form');
                                    form.method = 'POST';
                                    form.action = '${pageContext.request.contextPath}/SwitchRoleServlet';

                                    const roleInput = document.createElement('input');
                                    roleInput.type = 'hidden';
                                    roleInput.name = 'roleId';
                                    roleInput.value = role;

                                    form.appendChild(roleInput);
                                    document.body.appendChild(form);
                                    form.submit();
                                }
                            }

                            // 表单提交处理
                            document.getElementById('profileForm').addEventListener('submit', function (e) {
                                e.preventDefault();
                                alert('个人信息修改功能开发中...');
                            });
                        </script>
                </body>

                </html>