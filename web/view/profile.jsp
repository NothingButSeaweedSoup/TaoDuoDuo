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

                        /* 商家入驻特殊样式 */
                        .merchant-notice {
                            background: #f8f9fa;
                            border-radius: 8px;
                            padding: 20px;
                            margin-bottom: 25px;
                            border-left: 4px solid #667eea;
                        }

                        .merchant-notice h3 {
                            margin: 0 0 15px 0;
                            color: #262626;
                            font-size: 16px;
                            display: flex;
                            align-items: center;
                        }

                        .merchant-notice ul {
                            margin: 0;
                            padding-left: 20px;
                            color: #595959;
                            font-size: 14px;
                            line-height: 1.6;
                        }

                        .merchant-success {
                            background: #f6ffed;
                            border: 1px solid #b7eb8f;
                            border-radius: 8px;
                            padding: 20px;
                            margin-bottom: 25px;
                            color: #52c41a;
                            text-align: center;
                        }

                        .merchant-already {
                            text-align: center;
                            padding: 40px 0;
                            color: #52c41a;
                        }

                        .merchant-form-container {
                            max-width: 500px;
                            margin: 0 auto;
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

                                    <!-- 消息显示 -->
                                    <% String profileSuccess=(String) request.getAttribute("success"); String
                                        profileError=(String) request.getAttribute("error"); %>
                                        <% if (profileSuccess !=null) { %>
                                            <div
                                                style="background: #f6ffed; border: 1px solid #b7eb8f; border-radius: 8px; padding: 15px; margin-bottom: 20px; color: #52c41a;">
                                                ✓ <%= profileSuccess %>
                                            </div>
                                            <% } %>

                                                <% if (profileError !=null) { %>
                                                    <div
                                                        style="background: #fff2f0; border: 1px solid #ffccc7; border-radius: 8px; padding: 15px; margin-bottom: 20px; color: #ff4d4f;">
                                                        ✗ <%= profileError %>
                                                    </div>
                                                    <% } %>

                                                        <form id="profileForm" method="post"
                                                            action="${pageContext.request.contextPath}/UpdateProfileServlet">
                                                            <div class="form-group clearfix">
                                                                <label class="form-label">用户ID:</label>
                                                                <div class="form-input-wrapper">
                                                                    <input type="text" class="form-input"
                                                                        value="<%= request.getAttribute("profileUserId") !=null ?
                                                                        request.getAttribute("profileUserId") :
                                                                        session.getAttribute("userId") %>"
                                                                    disabled placeholder="用户ID，不可修改">
                                                                </div>
                                                            </div>

                                                            <div class="form-group clearfix">
                                                                <label class="form-label">用户名:</label>
                                                                <div class="form-input-wrapper">
                                                                    <input type="text" name="username"
                                                                        class="form-input" value="<%= username %>"
                                                                        placeholder="请输入用户名">
                                                                </div>
                                                            </div>

                                                            <div class="form-group clearfix">
                                                                <label class="form-label">旧密码:</label>
                                                                <div class="form-input-wrapper">
                                                                    <input type="password" name="oldPassword"
                                                                        class="form-input"
                                                                        placeholder="留空，若提交时为空则不修改密码">
                                                                </div>
                                                            </div>

                                                            <div class="form-group clearfix">
                                                                <label class="form-label">新密码:</label>
                                                                <div class="form-input-wrapper">
                                                                    <input type="password" name="newPassword"
                                                                        id="newPassword" class="form-input"
                                                                        placeholder="留空，若提交时为空则不修改密码">
                                                                </div>
                                                            </div>

                                                            <div class="form-group clearfix">
                                                                <label class="form-label">确认新密码:</label>
                                                                <div class="form-input-wrapper">
                                                                    <input type="password" name="confirmPassword"
                                                                        id="confirmPassword" class="form-input"
                                                                        placeholder="请再次输入新密码">
                                                                </div>
                                                            </div>

                                                            <div class="form-group clearfix">
                                                                <label class="form-label">邮箱:</label>
                                                                <div class="form-input-wrapper">
                                                                    <% User user=(User)
                                                                        request.getAttribute("profileUser"); if
                                                                        (user==null) user=(User)
                                                                        session.getAttribute("user"); %>
                                                                        <input type="email" name="email"
                                                                            class="form-input"
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
                                                                <button type="submit" class="btn btn-primary">✓
                                                                    提交修改</button>
                                                                <button type="reset"
                                                                    class="btn btn-secondary">重置</button>
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

                                    <!-- 消息显示 -->
                                    <% String merchantSuccess = (String) request.getAttribute("success");
                                       String merchantError = (String) request.getAttribute("error");
                                       String shopName = (String) request.getAttribute("shopName");
                                    %>
                                    
                                    <% if (merchantSuccess != null && "merchant_application_success".equals(merchantSuccess)) { %>
                                        <div class="merchant-success">
                                            <div style="font-size: 24px; margin-bottom: 10px;">🎉</div>
                                            <div style="font-size: 18px; font-weight: 600; margin-bottom: 8px;">恭喜！商家入驻申请成功</div>
                                            <div style="font-size: 14px;">店铺名称：<%= shopName %></div>
                                            <div style="font-size: 14px; margin-top: 5px; color: #389e0d;">您已自动获得商家角色，可以开始管理您的店铺了</div>
                                        </div>
                                    <% } %>

                                    <% if (merchantError != null) { %>
                                        <div style="background: #fff2f0; border: 1px solid #ffccc7; border-radius: 8px; padding: 15px; margin-bottom: 20px; color: #ff4d4f;">
                                            ✗ <%= merchantError %>
                                        </div>
                                    <% } %>

                                    <% if (userRole != null && userRole == 2) { %>
                                        <!-- 已经是商家，可以创建新店铺 -->
                                        <div style="background: #f6ffed; border: 1px solid #b7eb8f; border-radius: 8px; padding: 20px; margin-bottom: 25px; color: #52c41a; text-align: center;">
                                            <div style="font-size: 24px; margin-bottom: 10px;">✅</div>
                                            <div style="font-size: 18px; font-weight: 600; margin-bottom: 8px;">您已经是商家</div>
                                            <div style="font-size: 14px; color: #389e0d;">您可以创建新的店铺或在商铺管理中管理现有店铺</div>
                                        </div>
                                        
                                        <!-- 创建新店铺表单 -->
                                        <div class="merchant-form-container">
                                            <div class="merchant-notice">
                                                <h3>🏪 创建新店铺</h3>
                                                <ul>
                                                    <li>您可以创建多个店铺</li>
                                                    <li>店铺名称可以在商铺管理中修改</li>
                                                    <li>店铺名称长度需在2-50个字符之间</li>
                                                    <li>店铺名称不能与现有店铺重复</li>
                                                </ul>
                                            </div>

                                            <form id="merchantForm" method="post" action="${pageContext.request.contextPath}/MerchantApplicationServlet">
                                                <div class="form-group clearfix">
                                                    <label class="form-label">用户ID:</label>
                                                    <div class="form-input-wrapper">
                                                        <input type="text" class="form-input" 
                                                               value="<%= session.getAttribute("userId") %>" 
                                                               disabled placeholder="自动关联当前用户">
                                                    </div>
                                                </div>

                                                <div class="form-group clearfix">
                                                    <label class="form-label">店铺名称:</label>
                                                    <div class="form-input-wrapper">
                                                        <input type="text" name="shopName" class="form-input" 
                                                               placeholder="请输入新店铺的名称" required 
                                                               maxlength="50" minlength="2">
                                                    </div>
                                                </div>

                                                <div class="form-actions">
                                                    <button type="submit" class="btn btn-primary">🏪 创建新店铺</button>
                                                    <button type="reset" class="btn btn-secondary">重置</button>
                                                </div>
                                            </form>
                                        </div>
                                    <% } else { %>
                                        <!-- 商家入驻申请表单 -->
                                        <div class="merchant-form-container">
                                            <div class="merchant-notice">
                                                <h3>📋 入驻须知</h3>
                                                <ul>
                                                    <li>提交申请后将自动获得商家角色</li>
                                                    <li>店铺名称可以在商铺管理中修改</li>
                                                    <li>店铺名称长度需在2-50个字符之间</li>
                                                    <li>店铺名称不能与现有店铺重复</li>
                                                </ul>
                                            </div>

                                            <form id="merchantForm" method="post" action="${pageContext.request.contextPath}/MerchantApplicationServlet">
                                                <div class="form-group clearfix">
                                                    <label class="form-label">用户ID:</label>
                                                    <div class="form-input-wrapper">
                                                        <input type="text" class="form-input" 
                                                               value="<%= session.getAttribute("userId") %>" 
                                                               disabled placeholder="自动关联当前用户">
                                                    </div>
                                                </div>

                                                <div class="form-group clearfix">
                                                    <label class="form-label">店铺名称:</label>
                                                    <div class="form-input-wrapper">
                                                        <input type="text" name="shopName" class="form-input" 
                                                               placeholder="请输入您的店铺名称" required 
                                                               maxlength="50" minlength="2">
                                                    </div>
                                                </div>

                                                <div class="form-actions">
                                                    <button type="submit" class="btn btn-primary">🏪 申请入驻</button>
                                                    <button type="reset" class="btn btn-secondary">重置</button>
                                                </div>
                                            </form>
                                        </div>
                                    <% } %>
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

                            // 密码实时验证
                            function validatePasswords() {
                                const newPassword = document.getElementById('newPassword').value;
                                const confirmPassword = document.getElementById('confirmPassword').value;
                                const confirmInput = document.getElementById('confirmPassword');

                                if (confirmPassword && newPassword !== confirmPassword) {
                                    confirmInput.style.borderColor = '#ff4d4f';
                                    confirmInput.style.boxShadow = '0 0 0 2px rgba(255, 77, 79, 0.1)';
                                } else if (confirmPassword) {
                                    confirmInput.style.borderColor = '#52c41a';
                                    confirmInput.style.boxShadow = '0 0 0 2px rgba(82, 196, 26, 0.1)';
                                } else {
                                    confirmInput.style.borderColor = '#d9d9d9';
                                    confirmInput.style.boxShadow = 'none';
                                }
                            }

                            // 为密码字段添加实时验证
                            document.getElementById('newPassword').addEventListener('input', validatePasswords);
                            document.getElementById('confirmPassword').addEventListener('input', validatePasswords);

                            // 表单提交处理
                            document.getElementById('profileForm').addEventListener('submit', function (e) {
                                const newPassword = document.getElementById('newPassword').value;
                                const confirmPassword = document.getElementById('confirmPassword').value;

                                // 如果输入了新密码，检查确认密码
                                if (newPassword || confirmPassword) {
                                    if (newPassword !== confirmPassword) {
                                        e.preventDefault();
                                        alert('新密码和确认密码不一致，请重新输入！');
                                        return false;
                                    }

                                    if (newPassword.length < 6) {
                                        e.preventDefault();
                                        alert('新密码长度不能少于6位！');
                                        return false;
                                    }
                                }

                                // 验证通过，允许表单提交
                                return true;
                            });

                            // 商家入驻表单验证
                            const merchantForm = document.getElementById('merchantForm');
                            if (merchantForm) {
                                merchantForm.addEventListener('submit', function (e) {
                                    const shopName = document.querySelector('input[name="shopName"]').value.trim();
                                    
                                    if (!shopName) {
                                        e.preventDefault();
                                        alert('请输入店铺名称！');
                                        return false;
                                    }
                                    
                                    if (shopName.length < 2) {
                                        e.preventDefault();
                                        alert('店铺名称长度不能少于2个字符！');
                                        return false;
                                    }
                                    
                                    if (shopName.length > 50) {
                                        e.preventDefault();
                                        alert('店铺名称长度不能超过50个字符！');
                                        return false;
                                    }
                                    
                                    // 检查当前用户角色，显示不同的确认对话框
                                    const userRole = <%= userRole != null ? userRole : 0 %>;
                                    let confirmMessage;
                                    
                                    if (userRole == 2) {
                                        // 已经是商家，创建新店铺
                                        confirmMessage = '确定要创建新店铺吗？\n店铺名称：' + shopName + '\n\n您可以在商铺管理中修改店铺名称';
                                    } else {
                                        // 申请入驻商家
                                        confirmMessage = '确定要申请入驻商家吗？\n店铺名称：' + shopName + '\n\n申请成功后可在商铺管理中修改店铺名称';
                                    }
                                    
                                    if (!confirm(confirmMessage)) {
                                        e.preventDefault();
                                        return false;
                                    }
                                    
                                    return true;
                                });
                            }
                        </script>
                </body>

                </html>