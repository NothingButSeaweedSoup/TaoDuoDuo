<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="zh-CN">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>用户管理 - 管理员控制台</title>
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }

                body {
                    font-family: 'Microsoft YaHei', Arial, sans-serif;
                    background-color: #f5f7fa;
                    padding-top: 70px;
                }

                .container {
                    max-width: 1400px;
                    margin: 0 auto;
                    padding: 20px;
                }

                .page-header {
                    background: white;
                    padding: 25px;
                    border-radius: 12px;
                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                    margin-bottom: 30px;
                }

                .page-title {
                    font-size: 24px;
                    font-weight: 600;
                    color: #333;
                    margin-bottom: 10px;
                }

                .page-subtitle {
                    color: #666;
                    font-size: 16px;
                }

                .breadcrumb {
                    margin-bottom: 20px;
                }

                .breadcrumb a {
                    color: #667eea;
                    text-decoration: none;
                }

                .breadcrumb a:hover {
                    text-decoration: underline;
                }

                .users-container {
                    background: white;
                    border-radius: 12px;
                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                    overflow: hidden;
                }

                .users-header {
                    padding: 20px 25px;
                    border-bottom: 1px solid #e2e8f0;
                }

                .users-title {
                    font-size: 18px;
                    font-weight: 600;
                    color: #333;
                }

                .users-table {
                    width: 100%;
                    border-collapse: collapse;
                }

                .users-table th,
                .users-table td {
                    padding: 15px 20px;
                    text-align: left;
                    border-bottom: 1px solid #e2e8f0;
                }

                .users-table th {
                    background-color: #f8fafc;
                    font-weight: 600;
                    color: #4a5568;
                    font-size: 14px;
                }

                .users-table td {
                    color: #2d3748;
                }

                .users-table tr:hover {
                    background-color: #f7fafc;
                }

                .user-name {
                    font-weight: 500;
                    max-width: 150px;
                    overflow: hidden;
                    text-overflow: ellipsis;
                    white-space: nowrap;
                }

                .user-email {
                    max-width: 200px;
                    overflow: hidden;
                    text-overflow: ellipsis;
                    white-space: nowrap;
                }

                .btn {
                    padding: 6px 12px;
                    border: none;
                    border-radius: 6px;
                    text-decoration: none;
                    font-size: 12px;
                    font-weight: 500;
                    cursor: pointer;
                    transition: all 0.3s;
                    display: inline-flex;
                    align-items: center;
                    gap: 4px;
                    margin-right: 6px;
                }

                .btn-danger {
                    background-color: #e53e3e;
                    color: white;
                }

                .btn-danger:hover {
                    background-color: #c53030;
                }

                .btn-secondary {
                    background-color: #e2e8f0;
                    color: #4a5568;
                }

                .btn-secondary:hover {
                    background-color: #cbd5e0;
                }

                .actions-cell {
                    white-space: nowrap;
                }

                .empty-state {
                    text-align: center;
                    padding: 60px 20px;
                    color: #666;
                }

                .empty-icon {
                    font-size: 48px;
                    margin-bottom: 20px;
                }

                .empty-icon img {
                    width: 48px;
                    height: 48px;
                    opacity: 0.5;
                }

                .alert {
                    padding: 15px;
                    border-radius: 8px;
                    margin-bottom: 20px;
                }

                .alert-success {
                    background-color: #f0fff4;
                    border: 1px solid #9ae6b4;
                    color: #276749;
                }

                .alert-error {
                    background-color: #fed7d7;
                    border: 1px solid #feb2b2;
                    color: #c53030;
                }

                .warning-text {
                    background-color: #fef5e7;
                    border: 1px solid #f6e05e;
                    color: #744210;
                    padding: 15px;
                    border-radius: 8px;
                    margin-bottom: 20px;
                    font-size: 14px;
                }

                @media (max-width: 1200px) {
                    .users-table {
                        font-size: 14px;
                    }

                    .users-table th,
                    .users-table td {
                        padding: 10px 15px;
                    }
                }

                @media (max-width: 768px) {
                    .container {
                        padding: 10px;
                    }

                    .users-table th,
                    .users-table td {
                        padding: 8px 10px;
                    }

                    .btn {
                        padding: 4px 8px;
                        font-size: 11px;
                    }

                    .user-name,
                    .user-email {
                        max-width: 120px;
                    }
                }
            </style>
        </head>

        <body>
            <!-- 导航栏 -->
            <%@ include file="head.jsp" %>

                <div class="container">
                    <!-- 面包屑导航 -->
                    <div class="breadcrumb">
                        <a href="${pageContext.request.contextPath}/AdminDashboardServlet">管理员控制台</a> > 用户管理
                    </div>

                    <!-- 页面头部 -->
                    <div class="page-header">
                        <div class="page-title">用户管理</div>
                        <div class="page-subtitle">管理平台上的所有用户信息</div>
                    </div>

                    <!-- 警告提示 -->
                    <div class="warning-text">
                        <img src="${pageContext.request.contextPath}/icon/Error.png" alt="警告"
                            style="width: 16px; height: 16px; vertical-align: middle; margin-right: 5px;">
                        注意：删除用户操作不可恢复，请谨慎操作。删除用户可能会影响相关的订单和商铺数据。
                    </div>

                    <!-- 消息提示 -->
                    <c:if test="${not empty param.success}">
                        <div class="alert alert-success">
                            <c:choose>
                                <c:when test="${param.success == 'delete_success'}">用户删除成功！</c:when>
                                <c:otherwise>操作成功！</c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>

                    <c:if test="${not empty param.error}">
                        <div class="alert alert-error">
                            <c:choose>
                                <c:when test="${param.error == 'delete_failed'}">用户删除失败，请重试！</c:when>
                                <c:otherwise>操作失败，请重试！</c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>

                    <!-- 用户列表 -->
                    <div class="users-container">
                        <div class="users-header">
                            <div class="users-title">用户列表 (${users.size()} 个用户)</div>
                        </div>

                        <c:choose>
                            <c:when test="${not empty users}">
                                <table class="users-table">
                                    <thead>
                                        <tr>
                                            <th>用户ID</th>
                                            <th>用户名</th>
                                            <th>邮箱</th>
                                            <th>手机号</th>
                                            <th>注册时间</th>
                                            <th>最后更新</th>
                                            <th>操作</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="user" items="${users}">
                                            <tr>
                                                <td>${user.user_id}</td>
                                                <td class="user-name" title="${user.username}">
                                                    ${user.username}
                                                </td>
                                                <td class="user-email" title="${user.email}">
                                                    ${user.email}
                                                </td>
                                                <td>${user.phone}</td>
                                                <td>${user.create_time}</td>
                                                <td>${user.update_time}</td>
                                                <td class="actions-cell">
                                                    <a href="${pageContext.request.contextPath}/AdminUserDetailServlet?userId=${user.user_id}"
                                                        class="btn btn-secondary" target="_blank">
                                                        查看详情
                                                    </a>
                                                    </a>
                                                    <button class="btn btn-danger"
                                                        onclick="deleteUser(${user.user_id}, '${user.username}')">
                                                        删除
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <div class="empty-icon">
                                        <img src="${pageContext.request.contextPath}/icon/UserInfo.png" alt="用户">
                                    </div>
                                    <div>暂无用户数据</div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <script>
                    function deleteUser(userId, username) {
                        if (confirm('确定要删除用户 "' + username + '" 吗？\n\n此操作不可恢复，可能会影响相关的订单和商铺数据！')) {
                            window.location.href = '${pageContext.request.contextPath}/AdminActionServlet?action=delete&type=user&id=' + userId;
                        }
                    }
                </script>
        </body>

        </html>