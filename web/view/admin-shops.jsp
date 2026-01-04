<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="zh-CN">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>商铺管理 - 管理员控制台</title>
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
                    max-width: 1200px;
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

                .shops-container {
                    background: white;
                    border-radius: 12px;
                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                    overflow: hidden;
                }

                .shops-header {
                    padding: 20px 25px;
                    border-bottom: 1px solid #e2e8f0;
                    display: flex;
                    justify-content: between;
                    align-items: center;
                }

                .shops-title {
                    font-size: 18px;
                    font-weight: 600;
                    color: #333;
                }

                .shops-table {
                    width: 100%;
                    border-collapse: collapse;
                }

                .shops-table th,
                .shops-table td {
                    padding: 15px 25px;
                    text-align: left;
                    border-bottom: 1px solid #e2e8f0;
                }

                .shops-table th {
                    background-color: #f8fafc;
                    font-weight: 600;
                    color: #4a5568;
                    font-size: 14px;
                }

                .shops-table td {
                    color: #2d3748;
                }

                .shops-table tr:hover {
                    background-color: #f7fafc;
                }

                .btn {
                    padding: 8px 16px;
                    border: none;
                    border-radius: 6px;
                    text-decoration: none;
                    font-size: 14px;
                    font-weight: 500;
                    cursor: pointer;
                    transition: all 0.3s;
                    display: inline-flex;
                    align-items: center;
                    gap: 5px;
                    margin-right: 8px;
                }

                .btn-primary {
                    background-color: #667eea;
                    color: white;
                }

                .btn-primary:hover {
                    background-color: #5a67d8;
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

                .modal {
                    display: none;
                    position: fixed;
                    z-index: 1000;
                    left: 0;
                    top: 0;
                    width: 100%;
                    height: 100%;
                    background-color: rgba(0, 0, 0, 0.5);
                }

                .modal-content {
                    background-color: white;
                    margin: 15% auto;
                    padding: 30px;
                    border-radius: 12px;
                    width: 90%;
                    max-width: 500px;
                    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
                }

                .modal-header {
                    font-size: 20px;
                    font-weight: 600;
                    margin-bottom: 20px;
                    color: #333;
                }

                .form-group {
                    margin-bottom: 20px;
                }

                .form-label {
                    display: block;
                    margin-bottom: 8px;
                    font-weight: 500;
                    color: #4a5568;
                }

                .form-input {
                    width: 100%;
                    padding: 12px;
                    border: 1px solid #e2e8f0;
                    border-radius: 6px;
                    font-size: 14px;
                    transition: border-color 0.3s;
                }

                .form-input:focus {
                    outline: none;
                    border-color: #667eea;
                    box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
                }

                .modal-actions {
                    display: flex;
                    gap: 10px;
                    justify-content: flex-end;
                }

                @media (max-width: 768px) {
                    .shops-table {
                        font-size: 14px;
                    }

                    .shops-table th,
                    .shops-table td {
                        padding: 10px 15px;
                    }

                    .btn {
                        padding: 6px 12px;
                        font-size: 12px;
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
                        <a href="${pageContext.request.contextPath}/AdminDashboardServlet">管理员控制台</a> > 商铺管理
                    </div>

                    <!-- 页面头部 -->
                    <div class="page-header">
                        <div class="page-title">商铺管理</div>
                        <div class="page-subtitle">管理平台上的所有商铺信息</div>
                    </div>

                    <!-- 消息提示 -->
                    <c:if test="${not empty param.success}">
                        <div class="alert alert-success">
                            <c:choose>
                                <c:when test="${param.success == 'delete_success'}">商铺删除成功！</c:when>
                                <c:when test="${param.success == 'update_success'}">商铺更新成功！</c:when>
                                <c:otherwise>操作成功！</c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>

                    <c:if test="${not empty param.error}">
                        <div class="alert alert-error">
                            <c:choose>
                                <c:when test="${param.error == 'delete_failed'}">商铺删除失败，请重试！</c:when>
                                <c:when test="${param.error == 'update_failed'}">商铺更新失败，请重试！</c:when>
                                <c:otherwise>操作失败，请重试！</c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>

                    <!-- 商铺列表 -->
                    <div class="shops-container">
                        <div class="shops-header">
                            <div class="shops-title">商铺列表 (${shops.size()} 个商铺)</div>
                        </div>

                        <c:choose>
                            <c:when test="${not empty shops}">
                                <table class="shops-table">
                                    <thead>
                                        <tr>
                                            <th>商铺ID</th>
                                            <th>商铺名称</th>
                                            <th>店主ID</th>
                                            <th>创建时间</th>
                                            <th>更新时间</th>
                                            <th>操作</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="shop" items="${shops}">
                                            <tr>
                                                <td>${shop.shop_id}</td>
                                                <td>${shop.shop_name}</td>
                                                <td>${shop.owner_id}</td>
                                                <td>${shop.create_time}</td>
                                                <td>${shop.update_time}</td>
                                                <td class="actions-cell">
                                                    <button class="btn btn-primary"
                                                        onclick="editShop(${shop.shop_id}, '${shop.shop_name}')">
                                                        编辑
                                                    </button>
                                                    <a href="${pageContext.request.contextPath}/AdminShopDetailServlet?shopId=${shop.shop_id}"
                                                        class="btn btn-secondary" target="_blank">
                                                        查看详情
                                                    </a>
                                                    </a>
                                                    <button class="btn btn-danger"
                                                        onclick="deleteShop(${shop.shop_id}, '${shop.shop_name}')">
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
                                        <img src="${pageContext.request.contextPath}/icon/Shop.png" alt="商铺">
                                    </div>
                                    <div>暂无商铺数据</div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- 编辑商铺模态框 -->
                <div id="editModal" class="modal">
                    <div class="modal-content">
                        <div class="modal-header">编辑商铺</div>
                        <form id="editForm" method="post"
                            action="${pageContext.request.contextPath}/AdminActionServlet">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="type" value="shop">
                            <input type="hidden" name="id" id="editShopId">

                            <div class="form-group">
                                <label class="form-label">商铺名称</label>
                                <input type="text" name="shopName" id="editShopName" class="form-input" required>
                            </div>

                            <div class="modal-actions">
                                <button type="button" class="btn btn-secondary" onclick="closeEditModal()">取消</button>
                                <button type="submit" class="btn btn-primary">保存</button>
                            </div>
                        </form>
                    </div>
                </div>

                <script>
                    function editShop(shopId, shopName) {
                        document.getElementById('editShopId').value = shopId;
                        document.getElementById('editShopName').value = shopName;
                        document.getElementById('editModal').style.display = 'block';
                    }

                    function closeEditModal() {
                        document.getElementById('editModal').style.display = 'none';
                    }

                    function deleteShop(shopId, shopName) {
                        if (confirm('确定要删除商铺 "' + shopName + '" 吗？此操作不可恢复！')) {
                            window.location.href = '${pageContext.request.contextPath}/AdminActionServlet?action=delete&type=shop&id=' + shopId;
                        }
                    }

                    // 点击模态框外部关闭
                    window.onclick = function (event) {
                        const modal = document.getElementById('editModal');
                        if (event.target === modal) {
                            modal.style.display = 'none';
                        }
                    }
                </script>
        </body>

        </html>