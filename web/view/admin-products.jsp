<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="zh-CN">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>商品管理 - 管理员控制台</title>
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

                .products-container {
                    background: white;
                    border-radius: 12px;
                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                    overflow: hidden;
                }

                .products-header {
                    padding: 20px 25px;
                    border-bottom: 1px solid #e2e8f0;
                }

                .products-title {
                    font-size: 18px;
                    font-weight: 600;
                    color: #333;
                }

                .products-table {
                    width: 100%;
                    border-collapse: collapse;
                }

                .products-table th,
                .products-table td {
                    padding: 15px 20px;
                    text-align: left;
                    border-bottom: 1px solid #e2e8f0;
                }

                .products-table th {
                    background-color: #f8fafc;
                    font-weight: 600;
                    color: #4a5568;
                    font-size: 14px;
                }

                .products-table td {
                    color: #2d3748;
                }

                .products-table tr:hover {
                    background-color: #f7fafc;
                }

                .product-name {
                    font-weight: 500;
                    max-width: 200px;
                    overflow: hidden;
                    text-overflow: ellipsis;
                    white-space: nowrap;
                }

                .product-price {
                    font-weight: 600;
                    color: #e53e3e;
                }

                .status-badge {
                    padding: 4px 8px;
                    border-radius: 12px;
                    font-size: 12px;
                    font-weight: 500;
                }

                .status-listed {
                    background-color: #f0fff4;
                    color: #38a169;
                }

                .status-unlisted {
                    background-color: #fed7d7;
                    color: #c53030;
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

                .btn-primary {
                    background-color: #667eea;
                    color: white;
                }

                .btn-primary:hover {
                    background-color: #5a67d8;
                }

                .btn-success {
                    background-color: #38a169;
                    color: white;
                }

                .btn-success:hover {
                    background-color: #2f855a;
                }

                .btn-warning {
                    background-color: #dd6b20;
                    color: white;
                }

                .btn-warning:hover {
                    background-color: #c05621;
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
                    min-width: 200px;
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

                @media (max-width: 1200px) {
                    .products-table {
                        font-size: 14px;
                    }

                    .products-table th,
                    .products-table td {
                        padding: 10px 15px;
                    }
                }

                @media (max-width: 768px) {
                    .container {
                        padding: 10px;
                    }

                    .products-table th,
                    .products-table td {
                        padding: 8px 10px;
                    }

                    .btn {
                        padding: 4px 8px;
                        font-size: 11px;
                    }

                    .product-name {
                        max-width: 150px;
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
                        <a href="${pageContext.request.contextPath}/AdminDashboardServlet">管理员控制台</a> > 商品管理
                    </div>

                    <!-- 页面头部 -->
                    <div class="page-header">
                        <div class="page-title">商品管理</div>
                        <div class="page-subtitle">管理平台上的所有商品信息</div>
                    </div>

                    <!-- 消息提示 -->
                    <c:if test="${not empty param.success}">
                        <div class="alert alert-success">
                            <c:choose>
                                <c:when test="${param.success == 'delete_success'}">商品删除成功！</c:when>
                                <c:when test="${param.success == 'toggle_success'}">商品状态更新成功！</c:when>
                                <c:otherwise>操作成功！</c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>

                    <c:if test="${not empty param.error}">
                        <div class="alert alert-error">
                            <c:choose>
                                <c:when test="${param.error == 'delete_failed'}">商品删除失败，请重试！</c:when>
                                <c:when test="${param.error == 'toggle_failed'}">商品状态更新失败，请重试！</c:when>
                                <c:otherwise>操作失败，请重试！</c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>

                    <!-- 商品列表 -->
                    <div class="products-container">
                        <div class="products-header">
                            <div class="products-title">商品列表 (${products.size()} 个商品)</div>
                        </div>

                        <c:choose>
                            <c:when test="${not empty products}">
                                <table class="products-table">
                                    <thead>
                                        <tr>
                                            <th>商品ID</th>
                                            <th>商品名称</th>
                                            <th>价格</th>
                                            <th>库存</th>
                                            <th>分类ID</th>
                                            <th>商铺ID</th>
                                            <th>状态</th>
                                            <th>创建时间</th>
                                            <th>操作</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="product" items="${products}">
                                            <tr>
                                                <td>${product.product_id}</td>
                                                <td class="product-name" title="${product.product_name}">
                                                    ${product.product_name}
                                                </td>
                                                <td class="product-price">¥${product.price}</td>
                                                <td>${product.stock}</td>
                                                <td>${product.category_id}</td>
                                                <td>${product.shop_id}</td>
                                                <td>
                                                    <span
                                                        class="status-badge ${product.product_listing ? 'status-listed' : 'status-unlisted'}">
                                                        ${product.product_listing ? '已上架' : '已下架'}
                                                    </span>
                                                </td>
                                                <td>${product.create_time}</td>
                                                <td class="actions-cell">
                                                    <c:choose>
                                                        <c:when test="${product.product_listing}">
                                                            <button class="btn btn-warning"
                                                                onclick="toggleProduct(${product.product_id}, false, '${product.product_name}')">
                                                                下架
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button class="btn btn-success"
                                                                onclick="toggleProduct(${product.product_id}, true, '${product.product_name}')">
                                                                上架
                                                            </button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <a href="${pageContext.request.contextPath}/ProductDetailServlet?id=${product.product_id}"
                                                        class="btn btn-secondary" target="_blank">
                                                        查看
                                                    </a>
                                                    <button class="btn btn-danger"
                                                        onclick="deleteProduct(${product.product_id}, '${product.product_name}')">
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
                                        <img src="${pageContext.request.contextPath}/icon/ProductList.png" alt="商品">
                                    </div>
                                    <div>暂无商品数据</div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <script>
                    function toggleProduct(productId, listing, productName) {
                        const action = listing ? '上架' : '下架';
                        if (confirm('确定要' + action + '商品 "' + productName + '" 吗？')) {
                            window.location.href = '${pageContext.request.contextPath}/AdminActionServlet?action=toggle&type=product&id=' + productId + '&listing=' + listing;
                        }
                    }

                    function deleteProduct(productId, productName) {
                        if (confirm('确定要删除商品 "' + productName + '" 吗？此操作不可恢复！')) {
                            window.location.href = '${pageContext.request.contextPath}/AdminActionServlet?action=delete&type=product&id=' + productId;
                        }
                    }
                </script>
        </body>

        </html>