<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.TaoDuoDuo.entity.Shop" %>
<%@ page import="com.TaoDuoDuo.entity.Product" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.text.DecimalFormat" %>
                        <!DOCTYPE html>
                        <html lang="zh-CN">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>商铺详细管理 - 淘多多</title>
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

                                .container {
                                    max-width: 1400px;
                                    margin: 0 auto;
                                }

                                .page-header {
                                    background: white;
                                    border-radius: 12px;
                                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
                                    padding: 30px;
                                    margin-bottom: 30px;
                                }

                                .header-content {
                                    display: flex;
                                    justify-content: space-between;
                                    align-items: center;
                                }

                                .shop-info h1 {
                                    font-size: 28px;
                                    font-weight: 600;
                                    color: #262626;
                                    margin: 0 0 10px 0;
                                }

                                .shop-meta {
                                    font-size: 14px;
                                    color: #8c8c8c;
                                    line-height: 1.5;
                                }

                                .header-actions {
                                    display: flex;
                                    gap: 10px;
                                }

                                .content-grid {
                                    display: grid;
                                    grid-template-columns: 1fr 2fr;
                                    gap: 30px;
                                }

                                .content-card {
                                    background: white;
                                    border-radius: 12px;
                                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
                                    padding: 30px;
                                }

                                .card-title {
                                    font-size: 20px;
                                    font-weight: 600;
                                    color: #262626;
                                    margin: 0 0 20px 0;
                                    padding-bottom: 15px;
                                    border-bottom: 2px solid #f0f0f0;
                                }

                                .message {
                                    padding: 15px 20px;
                                    border-radius: 8px;
                                    margin-bottom: 20px;
                                    font-size: 15px;
                                }

                                .message.success {
                                    background: #f6ffed;
                                    border: 1px solid #b7eb8f;
                                    color: #52c41a;
                                }

                                .message.error {
                                    background: #fff2f0;
                                    border: 1px solid #ffccc7;
                                    color: #ff4d4f;
                                }

                                .form-group {
                                    margin-bottom: 20px;
                                }

                                .form-label {
                                    display: block;
                                    font-size: 14px;
                                    font-weight: 500;
                                    color: #262626;
                                    margin-bottom: 8px;
                                }

                                .form-input,
                                .form-textarea {
                                    width: 100%;
                                    padding: 12px;
                                    border: 1px solid #d9d9d9;
                                    border-radius: 6px;
                                    font-size: 14px;
                                    transition: all 0.3s;
                                }

                                .form-input:focus,
                                .form-textarea:focus {
                                    outline: none;
                                    border-color: #667eea;
                                    box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.1);
                                }

                                .form-textarea {
                                    min-height: 80px;
                                    resize: vertical;
                                }

                                .form-row {
                                    display: grid;
                                    grid-template-columns: 1fr 1fr;
                                    gap: 15px;
                                }

                                .btn {
                                    padding: 10px 20px;
                                    border: none;
                                    border-radius: 6px;
                                    font-size: 14px;
                                    font-weight: 500;
                                    cursor: pointer;
                                    text-decoration: none;
                                    display: inline-block;
                                    transition: all 0.3s;
                                    text-align: center;
                                }

                                .btn-primary {
                                    background: #667eea;
                                    color: white;
                                }

                                .btn-primary:hover {
                                    background: #5a67d8;
                                    transform: translateY(-1px);
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

                                .btn-success {
                                    background: #52c41a;
                                    color: white;
                                }

                                .btn-success:hover {
                                    background: #389e0d;
                                }

                                .btn-warning {
                                    background: #faad14;
                                    color: white;
                                }

                                .btn-warning:hover {
                                    background: #d48806;
                                }

                                .btn-danger {
                                    background: #ff4d4f;
                                    color: white;
                                }

                                .btn-danger:hover {
                                    background: #d9363e;
                                }

                                .btn-small {
                                    padding: 6px 12px;
                                    font-size: 12px;
                                }

                                .search-bar {
                                    display: flex;
                                    gap: 10px;
                                    margin-bottom: 20px;
                                }

                                .search-input {
                                    flex: 1;
                                    padding: 10px 15px;
                                    border: 1px solid #d9d9d9;
                                    border-radius: 6px;
                                    font-size: 14px;
                                }

                                .product-list {
                                    display: grid;
                                    gap: 15px;
                                }

                                .product-item {
                                    border: 1px solid #f0f0f0;
                                    border-radius: 8px;
                                    padding: 20px;
                                    transition: all 0.3s;
                                }

                                .product-item:hover {
                                    border-color: #667eea;
                                    box-shadow: 0 2px 8px rgba(102, 126, 234, 0.1);
                                }

                                .product-header {
                                    display: flex;
                                    justify-content: space-between;
                                    align-items: flex-start;
                                    margin-bottom: 15px;
                                }

                                .product-info h3 {
                                    font-size: 16px;
                                    font-weight: 600;
                                    color: #262626;
                                    margin: 0 0 5px 0;
                                }

                                .product-meta {
                                    font-size: 12px;
                                    color: #8c8c8c;
                                    line-height: 1.4;
                                }

                                .product-actions {
                                    display: flex;
                                    gap: 5px;
                                    flex-wrap: wrap;
                                }

                                .product-description {
                                    font-size: 14px;
                                    color: #595959;
                                    margin-bottom: 10px;
                                    line-height: 1.4;
                                }

                                .product-stats {
                                    display: flex;
                                    gap: 20px;
                                    font-size: 14px;
                                }

                                .stat-item {
                                    display: flex;
                                    align-items: center;
                                    gap: 5px;
                                }

                                .stat-label {
                                    color: #8c8c8c;
                                }

                                .stat-value {
                                    font-weight: 600;
                                    color: #262626;
                                }

                                .status-badge {
                                    padding: 4px 8px;
                                    border-radius: 4px;
                                    font-size: 12px;
                                    font-weight: 500;
                                }

                                .status-listed {
                                    background: #f6ffed;
                                    color: #52c41a;
                                    border: 1px solid #b7eb8f;
                                }

                                .status-unlisted {
                                    background: #fff2f0;
                                    color: #ff4d4f;
                                    border: 1px solid #ffccc7;
                                }

                                .empty-state {
                                    text-align: center;
                                    padding: 60px 20px;
                                    color: #8c8c8c;
                                }

                                .empty-state .icon {
                                    font-size: 64px;
                                    margin-bottom: 20px;
                                }

                                .back-link {
                                    display: inline-flex;
                                    align-items: center;
                                    gap: 8px;
                                    color: #667eea;
                                    text-decoration: none;
                                    font-size: 14px;
                                    margin-bottom: 20px;
                                    transition: all 0.3s;
                                }

                                .back-link:hover {
                                    color: #5a67d8;
                                }

                                .edit-form {
                                    display: none;
                                    margin-top: 15px;
                                    padding: 20px;
                                    background: #f8f9fa;
                                    border-radius: 8px;
                                    border: 1px solid #e8e8e8;
                                }

                                .image-manager {
                                    display: none;
                                    margin-top: 15px;
                                    padding: 20px;
                                    background: #f8f9fa;
                                    border-radius: 8px;
                                    border: 1px solid #e8e8e8;
                                }

                                .image-upload-area {
                                    border: 2px solid #ddd;
                                    border-radius: 8px;
                                    padding: 20px;
                                    text-align: center;
                                    margin-bottom: 15px;
                                    transition: border-color 0.3s;
                                }

                                .image-upload-area:hover {
                                    border-color: #667eea;
                                }

                                .upload-btn {
                                    background: #667eea;
                                    color: white;
                                    padding: 8px 16px;
                                    border: none;
                                    border-radius: 4px;
                                    cursor: pointer;
                                    font-size: 14px;
                                }

                                .upload-btn:hover {
                                    background: #5a67d8;
                                }

                                .image-grid {
                                    display: grid;
                                    grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
                                    gap: 10px;
                                    margin-top: 15px;
                                }

                                .image-item {
                                    position: relative;
                                    border: 1px solid #ddd;
                                    border-radius: 6px;
                                    overflow: hidden;
                                }

                                .image-item img {
                                    width: 100%;
                                    height: 80px;
                                    object-fit: cover;
                                }

                                .image-item .delete-btn {
                                    position: absolute;
                                    top: 2px;
                                    right: 2px;
                                    background: rgba(255, 0, 0, 0.8);
                                    color: white;
                                    border: none;
                                    border-radius: 3px;
                                    width: 20px;
                                    height: 20px;
                                    cursor: pointer;
                                    font-size: 12px;
                                }

                                .image-item .sort-order {
                                    position: absolute;
                                    bottom: 2px;
                                    left: 2px;
                                    background: rgba(0, 0, 0, 0.7);
                                    color: white;
                                    padding: 1px 4px;
                                    border-radius: 3px;
                                    font-size: 10px;
                                }

                                .file-input {
                                    display: none;
                                }

                                /* 响应式设计 */
                                @media (max-width: 1024px) {
                                    .content-grid {
                                        grid-template-columns: 1fr;
                                    }
                                }

                                @media (max-width: 768px) {
                                    .header-content {
                                        flex-direction: column;
                                        gap: 15px;
                                        align-items: flex-start;
                                    }

                                    .product-header {
                                        flex-direction: column;
                                        gap: 10px;
                                    }

                                    .product-actions {
                                        align-self: flex-start;
                                    }

                                    .form-row {
                                        grid-template-columns: 1fr;
                                    }

                                    .search-bar {
                                        flex-direction: column;
                                    }
                                }
                            </style>
                        </head>

                        <body>
                            <%@ include file="head.jsp" %>

                                <div class="container">
                                    <!-- 返回链接 -->
                                    <a href="${pageContext.request.contextPath}/ShopManagementServlet"
                                        class="back-link">
                                        ← 返回商铺管理
                                    </a>

                                    <% Shop shop=(Shop) request.getAttribute("shop"); List<Product> products = (List
                                        <Product>) request.getAttribute("products");
                                            Boolean hasProducts = (Boolean) request.getAttribute("hasProducts");
                                            String searchKeyword = (String) request.getAttribute("searchKeyword");

                                            String success = (String) request.getAttribute("success");
                                            String error = (String) request.getAttribute("error");
                                            String productName = (String) request.getAttribute("productName");
                                            String shopName = (String) request.getAttribute("shopName");

                                            DecimalFormat df = new DecimalFormat("#0.00");
                                            %>

                                            <!-- 页面头部 -->
                                            <div class="page-header">
                                                <div class="header-content">
                                                    <div class="shop-info">
                                                        <h1>
                                                            <img src="${pageContext.request.contextPath}/icon/Shop.png" alt="店铺"
                                                                 style="width: 32px; height: 32px; vertical-align: middle; margin-right: 10px;">
                                                            ${shop.shop_name}
                                                        </h1>
                                                        <div class="shop-meta">
                                                            <div>店铺ID: ${shop.shop_id}
                                                            </div>
                                                            <div>创建时间: <%= shop.getCreate_time() != null ?
                                                                shop.getCreate_time().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"))
                                                                : "未知" %>
                                                            </div>
                                                            <% if (shop.getUpdate_time() != null &&
                                                                !shop.getUpdate_time().equals(shop.getCreate_time())) { %>
                                                                <div>更新时间: <%= shop.getUpdate_time().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")) %></div>
                                                            <% } %>
                                                        </div>
                                                    </div>
                                                    <div class="header-actions">
                                                        <button type="button" class="btn btn-secondary"
                                                            onclick="showEditShopForm()">
                                                            编辑店铺名称
                                                        </button>
                                                    </div>
                                                </div>

                                                <!-- 编辑店铺名称表单 -->
                                                <div id="edit-shop-form" class="edit-form">
                                                    <form method="post"
                                                        action="${pageContext.request.contextPath}/ShopDetailServlet">
                                                        <input type="hidden" name="action" value="updateShop">
                                                        <input type="hidden" name="shopId"
                                                            value="${shop.shop_id}">

                                                        <div class="form-group">
                                                            <label class="form-label">店铺名称:</label>
                                                            <input type="text" name="shopName" class="form-input"
                                                                value="${shop.shop_name}"
                                                                placeholder="请输入新的店铺名称" required maxlength="50"
                                                                minlength="2">
                                                        </div>

                                                        <div style="display: flex; gap: 10px;">
                                                            <button type="submit" class="btn btn-primary">保存修改</button>
                                                            <button type="button" class="btn btn-secondary"
                                                                onclick="hideEditShopForm()">取消</button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>

                                            <!-- 消息显示 -->
                                            <c:if test="${not empty success}">
                                                <div class="message success">
                                                    <img src="${pageContext.request.contextPath}/icon/Success.png"
                                                         alt="成功"
                                                         style="width: 14px; height: 14px; vertical-align: middle; margin-right: 4px;">
                                                    <c:choose>
                                                        <c:when test="${success == 'product_added'}">
                                                            商品添加成功！商品名称：${not empty productName ? productName : ''}
                                                            <c:if test="${not empty newProductId}">
                                                                <br>
                                                                <button type="button" class="btn btn-primary btn-small"
                                                                        style="margin-top: 10px;"
                                                                        onclick="showImageManager(<%= request.getAttribute("newProductId") %>)">
                                                                    <img src="${pageContext.request.contextPath}/icon/ImageFile.png"
                                                                         alt="选择"
                                                                         style="width: 14px; height: 14px; vertical-align: middle; margin-right: 4px;">
                                                                    立即上传商品图片
                                                                </button>
                                                            </c:if>
                                                        </c:when>
                                                        <c:when test="${success == 'shop_updated'}">
                                                            店铺名称更新成功！新名称：${not empty shopName ? shopName : ''}
                                                        </c:when>
                                                        <c:when test="${success == 'product_updated'}">
                                                            商品信息更新成功！商品名称：${not empty productName ? productName : ''}
                                                        </c:when>
                                                        <c:when test="${success == 'product_deleted'}">
                                                            商品删除成功！
                                                        </c:when>
                                                        <c:when test="${success == 'listing_updated'}">
                                                            ${not empty productName ? productName : '商品状态更新成功'}
                                                        </c:when>
                                                        <c:otherwise>
                                                            操作成功！
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </c:if>

                                            <c:if test="${not empty error}">
                                                <div class="message error">
                                                    ✗
                                                    <c:choose>
                                                        <c:when test="${error == 'invalid_params'}">
                                                            参数错误，请检查输入
                                                        </c:when>
                                                        <c:when test="${error == 'invalid_values'}">
                                                            价格和库存不能为负数
                                                        </c:when>
                                                        <c:when test="${error == 'invalid_numbers'}">
                                                            价格和库存必须为有效数字
                                                        </c:when>
                                                        <c:when test="${error == 'add_failed'}">
                                                            商品添加失败，请重试
                                                        </c:when>
                                                        <c:when test="${error == 'name_length'}">
                                                            店铺名称长度必须在2-50个字符之间
                                                        </c:when>
                                                        <c:when test="${error == 'name_exists'}">
                                                            店铺名称已被使用，请更换其他名称
                                                        </c:when>
                                                        <c:when test="${error == 'product_not_found'}">
                                                            商品不存在或无权限操作
                                                        </c:when>
                                                        <c:when test="${error == 'update_failed'}">
                                                            更新失败，请重试
                                                        </c:when>
                                                        <c:when test="${error == 'delete_failed'}">
                                                            删除失败，请重试
                                                        </c:when>
                                                        <c:when test="${error == 'listing_failed'}">
                                                            状态更新失败，请重试
                                                        </c:when>
                                                        <c:otherwise>
                                                            操作失败，请重试
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </c:if>

                                                            <div class="content-grid">
                                                                <!-- 左侧：添加商品 -->
                                                                <div class="content-card">
                                                                    <h2 class="card-title">
                                                                        <img src="${pageContext.request.contextPath}/icon/AddProduct-blue.png"
                                                                            alt="添加商品"
                                                                            style="width: 20px; height: 20px; vertical-align: middle; margin-right: 8px;">
                                                                        添加新商品
                                                                    </h2>

                                                                    <form method="post"
                                                                        action="${pageContext.request.contextPath}/ShopDetailServlet">
                                                                        <input type="hidden" name="action"
                                                                            value="addProduct">
                                                                        <input type="hidden" name="shopId"
                                                                            value="<%= shop.getShop_id() %>">

                                                                        <div class="form-group">
                                                                            <label class="form-label">商品名称:</label>
                                                                            <input type="text" name="productName"
                                                                                class="form-input" placeholder="请输入商品名称"
                                                                                required maxlength="50">
                                                                        </div>

                                                                        <div class="form-group">
                                                                            <label class="form-label">商品描述:</label>
                                                                            <textarea name="description"
                                                                                class="form-textarea"
                                                                                placeholder="请输入商品描述"
                                                                                required></textarea>
                                                                        </div>

                                                                        <div class="form-group">
                                                                            <label class="form-label">商品分类:</label>
                                                                            <select name="categoryId"
                                                                                class="form-input">
                                                                                <option value="3">毛绒玩具</option>
                                                                                <option value="4">食品</option>
                                                                                <option value="5">数码</option>
                                                                                <option value="6">电脑</option>
                                                                                <option value="7">电脑配件</option>
                                                                                <option value="8" selected>其他商品</option>
                                                                            </select>
                                                                        </div>

                                                                        <div class="form-row">
                                                                            <div class="form-group">
                                                                                <label class="form-label">价格
                                                                                    (元):</label>
                                                                                <input type="number" name="price"
                                                                                    class="form-input"
                                                                                    placeholder="0.00" step="0.01"
                                                                                    min="0" required>
                                                                            </div>

                                                                            <div class="form-group">
                                                                                <label class="form-label">库存:</label>
                                                                                <input type="number" name="stock"
                                                                                    class="form-input" placeholder="0"
                                                                                    min="0" required>
                                                                            </div>
                                                                        </div>

                                                                        <button type="submit" class="btn btn-primary"
                                                                            style="width: 100%;">
                                                                            <img src="${pageContext.request.contextPath}/icon/AddProduct-white.png"
                                                                                alt="添加"
                                                                                style="width: 16px; height: 16px; vertical-align: middle; margin-right: 5px;">
                                                                            添加商品
                                                                        </button>
                                                                    </form>
                                                                </div>

                                                                <!-- 右侧：商品列表 -->
                                                                <div class="content-card">
                                                                    <h2 class="card-title">
                                                                        <img src="${pageContext.request.contextPath}/icon/ProductList.png"
                                                                             alt="商品列表"
                                                                             style="width: 20px; height: 20px; vertical-align: middle; margin-right: 8px;">
                                                                        商品管理
                                                                    </h2>

                                                                    <!-- 搜索栏 -->
                                                                    <div class="search-bar">
                                                                        <form method="get"
                                                                            action="${pageContext.request.contextPath}/ShopDetailServlet"
                                                                            style="display: flex; gap: 10px; width: 100%;">
                                                                            <input type="hidden" name="shopId"
                                                                                value="<%= shop.getShop_id() %>">
                                                                            <input type="text" name="search"
                                                                                class="search-input"
                                                                                placeholder="搜索商品名称..."
                                                                                value="<%= searchKeyword != null ? searchKeyword : "" %>">
                                                                            <button type="submit"
                                                                                class="btn btn-primary">搜索</button>
                                                                            <% if (searchKeyword !=null &&
                                                                                !searchKeyword.isEmpty()) { %>
                                                                                <a href="${pageContext.request.contextPath}/ShopDetailServlet?shopId=<%= shop.getShop_id() %>"
                                                                                    class="btn btn-secondary">清除</a>
                                                                                <% } %>
                                                                        </form>
                                                                    </div>

                                                                    <!-- 商品列表 -->
                                                                    <% if (hasProducts !=null && hasProducts && products
                                                                        !=null) { %>
                                                                        <div class="product-list">
                                                                            <% for (Product product : products) { %>
                                                                                <div class="product-item">
                                                                                    <div class="product-header">
                                                                                        <div class="product-info">
                                                                                            <h3>
                                                                                                <%= product.getProduct_name()
                                                                                                    %>
                                                                                            </h3>
                                                                                            <div class="product-meta">
                                                                                                ID: <%=
                                                                                                    product.getProduct_id()
                                                                                                    %> |
                                                                                                    分类: <%=
                                                                                                        product.getCategory_id()
                                                                                        %> |
                                                                                        <span class="status-badge <%= product.isProduct_listing() ? "status-listed" : "status-unlisted" %>">
                                                                                            <%= product.isProduct_listing() ? "已上架" : "已下架" %>
                                                                                        </span>
                                                                                    </div>
                                                                                </div>
                                                                                <div class="product-actions">
                                                                                    <button type="button" class="btn btn-secondary btn-small"
                                                                                            onclick="showEditProductForm(<%= product.getProduct_id() %>)">
                                                                                        编辑
                                                                                    </button>
                                                                                    <button type="button" class="btn btn-primary btn-small"
                                                                                            onclick="showImageManager(<%= product.getProduct_id() %>)">
                                                                                        管理图片
                                                                                    </button>
                                                                                    <% if (product.isProduct_listing()) { %>
                                                                                        <button type="button" class="btn btn-warning btn-small"
                                                                                                onclick="toggleListing(<%= product.getProduct_id() %>, false)">
                                                                                            下架
                                                                                        </button>
                                                                                    <% } else { %>
                                                                                        <button type="button" class="btn btn-success btn-small"
                                                                                                onclick="toggleListing(<%= product.getProduct_id() %>, true)">
                                                                                            上架
                                                                                        </button>
                                                                                    <% } %>
                                                                                    <button type="button" class="btn btn-danger btn-small"
                                                                                            onclick="deleteProduct(<%= product.getProduct_id() %>, '<%= product.getProduct_name() %>')">
                                                                                        删除
                                                                                    </button>
                                                                                </div>
                                                                            </div>

                                                                            <div class="product-description">
                                                                                <%= product.getDescription() %>
                                                                            </div>

                                                                                    <div class="product-stats">
                                                                                        <div class="stat-item">
                                                                                            <span
                                                                                                class="stat-label">价格:</span>
                                                                                            <span class="stat-value">¥
                                                                                                <%= df.format(product.getPrice())
                                                                                                    %>
                                                                                            </span>
                                                                                        </div>
                                                                                        <div class="stat-item">
                                                                                            <span
                                                                                                class="stat-label">库存:</span>
                                                                                            <span class="stat-value">
                                                                                                <%= product.getStock()
                                                                                                    %>
                                                                                            </span>
                                                                                        </div>
                                                                                    </div>

                                                                                    <!-- 编辑商品表单 -->
                                                                                    <div id="edit-product-form-<%= product.getProduct_id() %>"
                                                                                        class="edit-form">
                                                                                        <form method="post"
                                                                                            action="${pageContext.request.contextPath}/ShopDetailServlet">
                                                                                            <input type="hidden"
                                                                                                name="action"
                                                                                                value="updateProduct">
                                                                                            <input type="hidden"
                                                                                                name="shopId"
                                                                                                value="<%= shop.getShop_id() %>">
                                                                                            <input type="hidden"
                                                                                                name="productId"
                                                                                                value="<%= product.getProduct_id() %>">

                                                                                            <div class="form-group">
                                                                                                <label
                                                                                                    class="form-label">商品名称:</label>
                                                                                                <input type="text"
                                                                                                    name="productName"
                                                                                                    class="form-input"
                                                                                                    value="<%= product.getProduct_name() %>"
                                                                                                    required
                                                                                                    maxlength="50">
                                                                                            </div>

                                                                                            <div class="form-group">
                                                                                                <label
                                                                                                    class="form-label">商品描述:</label>
                                                                                                <textarea
                                                                                                    name="description"
                                                                                                    class="form-textarea"
                                                                                                    required><%= product.getDescription() %></textarea>
                                                                                            </div>

                                                                                            <div class="form-row">
                                                                                                <div class="form-group">
                                                                                                    <label
                                                                                                        class="form-label">价格
                                                                                                        (元):</label>
                                                                                                    <input type="number"
                                                                                                        name="price"
                                                                                                        class="form-input"
                                                                                                        value="<%= df.format(product.getPrice()) %>"
                                                                                                        step="0.01"
                                                                                                        min="0"
                                                                                                        required>
                                                                                                </div>

                                                                                                <div class="form-group">
                                                                                                    <label
                                                                                                        class="form-label">库存:</label>
                                                                                                    <input type="number"
                                                                                                        name="stock"
                                                                                                        class="form-input"
                                                                                                        value="<%= product.getStock() %>"
                                                                                                        min="0"
                                                                                                        required>
                                                                                                </div>
                                                                                            </div>

                                                                                            <div
                                                                                                style="display: flex; gap: 10px;">
                                                                                                <button type="submit"
                                                                                                    class="btn btn-primary">保存修改</button>
                                                                                                <button type="button"
                                                                                                    class="btn btn-secondary"
                                                                                                    onclick="hideEditProductForm(<%= product.getProduct_id() %>)">
                                                                                                    取消
                                                                                                </button>
                                                                                            </div>
                                                                                        </form>
                                                                                    </div>

                                                                                    <!-- 图片管理区域 -->
                                                                                    <div id="image-manager-<%= product.getProduct_id() %>"
                                                                                        class="image-manager">
                                                                                        <h4>商品图片管理</h4>

                                                                                        <!-- 上传区域 -->
                                                                                        <div class="image-upload-area">
                                                                                            <p>
                                                                                                <img src="${pageContext.request.contextPath}/icon/ImageFile.png"
                                                                                                     alt="上传图片"
                                                                                                     style="width: 14px; height: 14px; vertical-align: middle; margin-right: 4px;">
                                                                                                选择图片文件上传
                                                                                            </p>
                                                                                            <input type="file"
                                                                                                id="imageInput-<%= product.getProduct_id() %>"
                                                                                                class="file-input"
                                                                                                multiple
                                                                                                accept="image/*"
                                                                                                onchange="handleImageSelect(<%= product.getProduct_id() %>, event)">
                                                                                            <button type="button"
                                                                                                class="upload-btn"
                                                                                                onclick="document.getElementById('imageInput-<%= product.getProduct_id() %>').click()">
                                                                                                选择图片
                                                                                            </button>
                                                                                            <button type="button"
                                                                                                class="btn btn-success"
                                                                                                onclick="uploadImages(<%= product.getProduct_id() %>)"
                                                                                                style="margin-left: 10px;">
                                                                                                上传图片
                                                                                            </button>
                                                                                        </div>

                                                                                        <!-- 现有图片展示 -->
                                                                                        <div id="existing-images-<%= product.getProduct_id() %>"
                                                                                            class="image-grid">
                                                                                            <!-- 现有图片将通过JavaScript加载 -->
                                                                                        </div>

                                                                                        <!-- 待上传图片预览 -->
                                                                                        <div id="preview-images-<%= product.getProduct_id() %>"
                                                                                            class="image-grid">
                                                                                            <!-- 预览图片将通过JavaScript显示 -->
                                                                                        </div>

                                                                                        <div style="margin-top: 15px;">
                                                                                            <button type="button"
                                                                                                class="btn btn-secondary"
                                                                                                onclick="hideImageManager(<%= product.getProduct_id() %>)">
                                                                                                关闭
                                                                                            </button>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                                <% } %>
                                                                        </div>
                                                                        <% } else { %>
                                                                            <!-- 空状态 -->
                                                                            <div class="empty-state">
                                                                                <div class="icon">
                                                                                    <img src="${pageContext.request.contextPath}/icon/ProductManaging.png"
                                                                                         alt="商品管理"
                                                                                         style="width: 64px; height: 64px;">
                                                                                </div>
                                                                                <h3>暂无商品</h3>
                                                                                <p>
                                                                                    <% if (searchKeyword !=null &&
                                                                                        !searchKeyword.isEmpty()) { %>
                                                                                        没有找到包含 "<%= searchKeyword %>"
                                                                                            的商品
                                                                                            <% } else { %>
                                                                                                您还没有添加任何商品，请使用左侧表单添加商品
                                                                                                <% } %>
                                                                                </p>
                                                                            </div>
                                                                            <% } %>
                                                                </div>
                                                            </div>
                                </div>

                                <script>
                                    // 显示编辑店铺表单
                                    function showEditShopForm() {
                                        document.getElementById('edit-shop-form').style.display = 'block';
                                    }

                                    // 隐藏编辑店铺表单
                                    function hideEditShopForm() {
                                        document.getElementById('edit-shop-form').style.display = 'none';
                                    }

                                    // 显示编辑商品表单
                                    function showEditProductForm(productId) {
                                        document.getElementById('edit-product-form-' + productId).style.display = 'block';
                                    }

                                    // 隐藏编辑商品表单
                                    function hideEditProductForm(productId) {
                                        document.getElementById('edit-product-form-' + productId).style.display = 'none';
                                    }

                                    // 切换商品上架状态
                                    function toggleListing(productId, listing) {
                                        const action = listing ? '上架' : '下架';
                                        if (confirm('确定要' + action + '这个商品吗？')) {
                                            const form = document.createElement('form');
                                            form.method = 'POST';
                                            form.action = '${pageContext.request.contextPath}/ShopDetailServlet';

                                            const actionInput = document.createElement('input');
                                            actionInput.type = 'hidden';
                                            actionInput.name = 'action';
                                            actionInput.value = 'toggleListing';

                                            const shopIdInput = document.createElement('input');
                                            shopIdInput.type = 'hidden';
                                            shopIdInput.name = 'shopId';
                                            shopIdInput.value = '<%= shop.getShop_id() %>';

                                            const productIdInput = document.createElement('input');
                                            productIdInput.type = 'hidden';
                                            productIdInput.name = 'productId';
                                            productIdInput.value = productId;

                                            const listingInput = document.createElement('input');
                                            listingInput.type = 'hidden';
                                            listingInput.name = 'listing';
                                            listingInput.value = listing;

                                            form.appendChild(actionInput);
                                            form.appendChild(shopIdInput);
                                            form.appendChild(productIdInput);
                                            form.appendChild(listingInput);
                                            document.body.appendChild(form);
                                            form.submit();
                                        }
                                    }

                                    // 删除商品
                                    function deleteProduct(productId, productName) {
                                        if (confirm('确定要删除商品 "' + productName + '" 吗？\n\n此操作不可撤销！')) {
                                            const form = document.createElement('form');
                                            form.method = 'POST';
                                            form.action = '${pageContext.request.contextPath}/ShopDetailServlet';

                                            const actionInput = document.createElement('input');
                                            actionInput.type = 'hidden';
                                            actionInput.name = 'action';
                                            actionInput.value = 'deleteProduct';

                                            const shopIdInput = document.createElement('input');
                                            shopIdInput.type = 'hidden';
                                            shopIdInput.name = 'shopId';
                                            shopIdInput.value = '<%= shop.getShop_id() %>';

                                            const productIdInput = document.createElement('input');
                                            productIdInput.type = 'hidden';
                                            productIdInput.name = 'productId';
                                            productIdInput.value = productId;

                                            form.appendChild(actionInput);
                                            form.appendChild(shopIdInput);
                                            form.appendChild(productIdInput);
                                            document.body.appendChild(form);
                                            form.submit();
                                        }
                                    }

                                    // 图片管理相关函数
                                    let selectedFiles = {};

                                    // 显示图片管理器
                                    function showImageManager(productId) {
                                        document.getElementById('image-manager-' + productId).style.display = 'block';
                                        loadExistingImages(productId);
                                    }

                                    // 隐藏图片管理器
                                    function hideImageManager(productId) {
                                        document.getElementById('image-manager-' + productId).style.display = 'none';
                                        selectedFiles[productId] = [];
                                        updatePreview(productId);
                                    }

                                    // 处理图片选择
                                    function handleImageSelect(productId, event) {
                                        const files = Array.from(event.target.files);
                                        if (!selectedFiles[productId]) {
                                            selectedFiles[productId] = [];
                                        }

                                        files.forEach(file => {
                                            if (file.type.startsWith('image/')) {
                                                selectedFiles[productId].push(file);
                                            }
                                        });

                                        updatePreview(productId);
                                    }

                                    // 更新预览
                                    function updatePreview(productId) {
                                        const previewContainer = document.getElementById('preview-images-' + productId);
                                        previewContainer.innerHTML = '';

                                        if (!selectedFiles[productId] || selectedFiles[productId].length === 0) {
                                            return;
                                        }

                                        selectedFiles[productId].forEach((file, index) => {
                                            const reader = new FileReader();
                                            reader.onload = function (e) {
                                                const imageItem = document.createElement('div');
                                                imageItem.className = 'image-item';
                                                imageItem.innerHTML = `
                                                    <img src="${e.target.result}" alt="预览图片">
                                                    <button class="delete-btn" onclick="removePreviewImage(${productId}, ${index})">×</button>
                                                    <div class="sort-order">待上传</div>
                                                `;
                                                previewContainer.appendChild(imageItem);
                                            };
                                            reader.readAsDataURL(file);
                                        });
                                    }

                                    // 移除预览图片
                                    function removePreviewImage(productId, index) {
                                        selectedFiles[productId].splice(index, 1);
                                        updatePreview(productId);
                                    }

                                    // 上传图片
                                    function uploadImages(productId) {
                                        if (!selectedFiles[productId] || selectedFiles[productId].length === 0) {
                                            alert('请先选择要上传的图片');
                                            return;
                                        }

                                        const formData = new FormData();
                                        formData.append('productId', productId);

                                        selectedFiles[productId].forEach(file => {
                                            formData.append('images', file);
                                        });

                                        fetch('${pageContext.request.contextPath}/productImageUpload', {
                                            method: 'POST',
                                            body: formData
                                        })
                                            .then(response => response.json())
                                            .then(data => {
                                                if (data.success) {
                                                    alert(data.message);
                                                    selectedFiles[productId] = [];
                                                    updatePreview(productId);
                                                    loadExistingImages(productId);
                                                    document.getElementById('imageInput-' + productId).value = '';
                                                } else {
                                                    alert('上传失败: ' + data.message);
                                                }
                                            })
                                            .catch(error => {
                                                alert('上传失败: ' + error.message);
                                            });
                                    }

                                    // 加载现有图片
                                    function loadExistingImages(productId) {
                                        console.log('开始加载商品图片，ID:', productId);
                                        fetch('${pageContext.request.contextPath}/productImageUpload?action=getImages&productId=' + productId)
                                            .then(response => response.json())
                                            .then(data => {
                                                console.log('获取图片数据:', data);
                                                if (data.success) {
                                                    displayExistingImages(productId, data.images);
                                                } else {
                                                    console.error('获取图片失败:', data.message);
                                                }
                                            })
                                            .catch(error => {
                                                console.error('加载图片失败:', error);
                                            });
                                    }

                                    // 显示现有图片
                                    function displayExistingImages(productId, images) {
                                        const container = document.getElementById('existing-images-' + productId);
                                        container.innerHTML = '';

                                        if (images.length === 0) {
                                            container.innerHTML = '<p style="text-align: center; color: #666; grid-column: 1/-1;">暂无图片</p>';
                                            return;
                                        }

                                        const contextPath = '${pageContext.request.contextPath}';
                                        console.log('项目路径:', contextPath);

                                        images.forEach(function (image) {
                                            const imageItem = document.createElement('div');
                                            imageItem.className = 'image-item';

                                            const imageUrl = contextPath + image.imageUrl;
                                            console.log('构建图片URL:', imageUrl);

                                            const img = document.createElement('img');
                                            img.src = imageUrl;
                                            img.alt = '商品图片';
                                            img.onload = function () {
                                                console.log('图片加载成功:', this.src);
                                            };
                                            img.onerror = function () {
                                                console.error('图片加载失败:', this.src);
                                                this.style.border = '2px solid red';
                                                this.alt = '加载失败';
                                            };

                                            const deleteBtn = document.createElement('button');
                                            deleteBtn.className = 'delete-btn';
                                            deleteBtn.textContent = '×';
                                            deleteBtn.onclick = function () {
                                                deleteExistingImage(image.imageId, productId);
                                            };

                                            const sortOrder = document.createElement('div');
                                            sortOrder.className = 'sort-order';
                                            sortOrder.textContent = image.sortOrder;

                                            imageItem.appendChild(img);
                                            imageItem.appendChild(deleteBtn);
                                            imageItem.appendChild(sortOrder);

                                            container.appendChild(imageItem);
                                        });
                                    }

                                    // 删除现有图片
                                    function deleteExistingImage(imageId, productId) {
                                        if (!confirm('确定要删除这张图片吗？')) {
                                            return;
                                        }

                                        fetch('${pageContext.request.contextPath}/productImageUpload?action=deleteImage&imageId=' + imageId)
                                            .then(response => response.json())
                                            .then(data => {
                                                if (data.success) {
                                                    alert('图片删除成功');
                                                    loadExistingImages(productId);
                                                } else {
                                                    alert('删除失败: ' + data.message);
                                                }
                                            })
                                            .catch(error => {
                                                alert('删除失败: ' + error.message);
                                            });
                                    }
                                </script>
                        </body>

                        </html>