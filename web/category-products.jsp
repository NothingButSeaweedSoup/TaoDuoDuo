<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ page import="java.util.List" %>
            <%@ page import="java.util.Map" %>
                <%@ page import="com.TaoDuoDuo.entity.Category" %>
                    <%@ page import="com.TaoDuoDuo.entity.Product" %>
                        <!DOCTYPE html>
                        <html lang="zh-CN">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>${category.category_name} - 分类商品 - 淘多多</title>
                            <style>
                                * {
                                    margin: 0;
                                    padding: 0;
                                    box-sizing: border-box;
                                }

                                body {
                                    font-family: 'Microsoft YaHei', Arial, sans-serif;
                                    background-color: #f5f5f5;
                                    padding-top: 70px;
                                }

                                .container {
                                    max-width: 1200px;
                                    margin: 0 auto;
                                    padding: 20px;
                                }

                                /* 面包屑导航 */
                                .breadcrumb {
                                    background-color: #fff;
                                    padding: 15px 20px;
                                    border-radius: 8px;
                                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                                    margin-bottom: 20px;
                                    font-size: 14px;
                                }

                                .breadcrumb a {
                                    color: #4285f4;
                                    text-decoration: none;
                                    transition: color 0.3s;
                                }

                                .breadcrumb a:hover {
                                    color: #1a73e8;
                                }

                                .breadcrumb .separator {
                                    margin: 0 8px;
                                    color: #999;
                                }

                                .breadcrumb .current {
                                    color: #333;
                                    font-weight: 500;
                                }

                                /* 分类信息头部 */
                                .category-header {
                                    background-color: #fff;
                                    padding: 25px;
                                    border-radius: 8px;
                                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                                    margin-bottom: 20px;
                                }

                                .category-title {
                                    font-size: 28px;
                                    font-weight: 600;
                                    color: #333;
                                    margin-bottom: 15px;
                                    display: flex;
                                    align-items: center;
                                    gap: 10px;
                                }

                                .category-icon {
                                    width: 32px;
                                    height: 32px;
                                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                                    border-radius: 8px;
                                    display: flex;
                                    align-items: center;
                                    justify-content: center;
                                    color: white;
                                    font-weight: bold;
                                }

                                .category-stats {
                                    display: flex;
                                    gap: 30px;
                                    font-size: 14px;
                                    color: #666;
                                }

                                .stat-item {
                                    display: flex;
                                    align-items: center;
                                    gap: 5px;
                                }

                                .stat-number {
                                    font-weight: 600;
                                    color: #4285f4;
                                }

                                /* 子分类导航 */
                                .subcategories {
                                    background-color: #fff;
                                    padding: 20px;
                                    border-radius: 8px;
                                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                                    margin-bottom: 20px;
                                }

                                .subcategories-title {
                                    font-size: 16px;
                                    font-weight: 600;
                                    color: #333;
                                    margin-bottom: 15px;
                                }

                                .subcategories-list {
                                    display: flex;
                                    flex-wrap: wrap;
                                    gap: 10px;
                                }

                                .subcategory-item {
                                    background-color: #f8f9fa;
                                    border: 1px solid #e9ecef;
                                    border-radius: 20px;
                                    padding: 8px 16px;
                                    text-decoration: none;
                                    color: #495057;
                                    font-size: 14px;
                                    transition: all 0.3s;
                                }

                                .subcategory-item:hover {
                                    background-color: #4285f4;
                                    color: white;
                                    border-color: #4285f4;
                                    transform: translateY(-1px);
                                }

                                /* 商品筛选和排序 */
                                .filter-bar {
                                    background-color: #fff;
                                    padding: 20px;
                                    border-radius: 8px;
                                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                                    margin-bottom: 20px;
                                    display: flex;
                                    justify-content: space-between;
                                    align-items: center;
                                    flex-wrap: wrap;
                                    gap: 15px;
                                }

                                .filter-options {
                                    display: flex;
                                    gap: 15px;
                                    align-items: center;
                                }

                                .filter-label {
                                    font-size: 14px;
                                    color: #666;
                                    font-weight: 500;
                                }

                                .sort-options {
                                    display: flex;
                                    gap: 10px;
                                }

                                .sort-btn {
                                    background: none;
                                    border: 1px solid #ddd;
                                    padding: 8px 15px;
                                    border-radius: 20px;
                                    font-size: 14px;
                                    cursor: pointer;
                                    transition: all 0.3s;
                                    color: #666;
                                }

                                .sort-btn:hover,
                                .sort-btn.active {
                                    background-color: #4285f4;
                                    color: white;
                                    border-color: #4285f4;
                                }

                                /* 商品网格 */
                                .products-container {
                                    background-color: #fff;
                                    border-radius: 8px;
                                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                                    padding: 20px;
                                }

                                .products-grid {
                                    display: grid;
                                    grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
                                    gap: 20px;
                                }

                                .product-item {
                                    background-color: #fff;
                                    border: 1px solid #f0f0f0;
                                    border-radius: 8px;
                                    overflow: hidden;
                                    cursor: pointer;
                                    transition: all 0.3s;
                                    text-decoration: none;
                                    color: inherit;
                                }

                                .product-item:hover {
                                    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
                                    transform: translateY(-3px);
                                    border-color: #4285f4;
                                }

                                .product-image {
                                    width: 100%;
                                    height: 180px;
                                    object-fit: cover;
                                    background-color: #f5f5f5;
                                }

                                .product-info {
                                    padding: 15px;
                                }

                                .product-name {
                                    font-size: 14px;
                                    font-weight: 500;
                                    color: #333;
                                    margin-bottom: 8px;
                                    overflow: hidden;
                                    text-overflow: ellipsis;
                                    white-space: nowrap;
                                    line-height: 1.4;
                                }

                                .product-price {
                                    font-size: 18px;
                                    font-weight: 600;
                                    color: #ff6b35;
                                    margin-bottom: 5px;
                                }

                                .product-meta {
                                    font-size: 12px;
                                    color: #999;
                                    display: flex;
                                    justify-content: space-between;
                                }

                                /* 无商品状态 */
                                .no-products {
                                    text-align: center;
                                    padding: 60px 20px;
                                }

                                .no-products-image {
                                    width: 200px;
                                    height: auto;
                                    margin-bottom: 20px;
                                    opacity: 0.8;
                                }

                                .no-products-title {
                                    font-size: 24px;
                                    color: #333;
                                    margin-bottom: 10px;
                                }

                                .no-products-text {
                                    font-size: 16px;
                                    color: #666;
                                    margin-bottom: 20px;
                                }

                                .back-btn {
                                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                                    color: #fff;
                                    border: none;
                                    padding: 12px 30px;
                                    border-radius: 25px;
                                    font-size: 16px;
                                    font-weight: 600;
                                    cursor: pointer;
                                    transition: all 0.3s;
                                    text-decoration: none;
                                    display: inline-block;
                                }

                                .back-btn:hover {
                                    transform: translateY(-2px);
                                    box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
                                }

                                /* 响应式设计 */
                                @media (max-width: 768px) {
                                    .category-stats {
                                        flex-direction: column;
                                        gap: 10px;
                                    }

                                    .filter-bar {
                                        flex-direction: column;
                                        align-items: flex-start;
                                    }

                                    .products-grid {
                                        grid-template-columns: repeat(2, 1fr);
                                        gap: 15px;
                                    }

                                    .subcategories-list {
                                        justify-content: center;
                                    }
                                }

                                @media (max-width: 480px) {
                                    .products-grid {
                                        grid-template-columns: 1fr;
                                    }

                                    .category-title {
                                        font-size: 24px;
                                    }
                                }
                            </style>
                        </head>

                        <body>
                            <!-- 导航栏 -->
                            <%@ include file="view/head.jsp" %>

                                <div class="container">
                                    <!-- 面包屑导航 -->
                                    <div class="breadcrumb">
                                        <a href="${pageContext.request.contextPath}/HomeServlet">首页</a>
                                        <c:forEach var="pathCategory" items="${categoryPath}" varStatus="status">
                                            <span class="separator">></span>
                                            <c:choose>
                                                <c:when test="${status.last}">
                                                    <span class="current">${pathCategory.category_name}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <a
                                                        href="${pageContext.request.contextPath}/CategoryServlet?id=${pathCategory.category_id}">
                                                        ${pathCategory.category_name}
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                    </div>

                                    <!-- 分类信息头部 -->
                                    <div class="category-header">
                                        <div class="category-title">
                                            <div class="category-icon">
                                                ${category.category_name.substring(0, 1)}
                                            </div>
                                            ${category.category_name}
                                        </div>
                                        <div class="category-stats">
                                            <div class="stat-item">
                                                <span>商品数量:</span>
                                                <span class="stat-number">${productCount}</span>
                                            </div>
                                            <c:if test="${productCount > 0}">
                                                <div class="stat-item">
                                                    <span>价格区间:</span>
                                                    <span class="stat-number">¥${minPrice} - ¥${maxPrice}</span>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>

                                    <!-- 子分类导航 -->
                                    <c:if test="${not empty subCategories}">
                                        <div class="subcategories">
                                            <div class="subcategories-title">子分类</div>
                                            <div class="subcategories-list">
                                                <c:forEach var="subCategory" items="${subCategories}">
                                                    <a href="${pageContext.request.contextPath}/CategoryServlet?id=${subCategory.category_id}"
                                                        class="subcategory-item">
                                                        ${subCategory.category_name}
                                                    </a>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </c:if>

                                    <!-- 商品筛选和排序 -->
                                    <c:if test="${productCount > 0}">
                                        <div class="filter-bar">
                                            <div class="filter-options">
                                                <span class="filter-label">排序方式:</span>
                                                <div class="sort-options">
                                                    <button class="sort-btn active"
                                                        onclick="sortProducts('default')">默认排序
                                                    </button>
                                                    <button class="sort-btn" onclick="sortProducts('price-asc')">价格从低到高
                                                    </button>
                                                    <button class="sort-btn" onclick="sortProducts('price-desc')">价格从高到低
                                                    </button>
                                                    <button class="sort-btn"
                                                        onclick="sortProducts('name')">按名称排序</button>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>

                                    <!-- 商品展示区域 -->
                                    <div class="products-container">
                                        <c:choose>
                                            <c:when test="${productCount > 0}">
                                                <div class="products-grid" id="productsGrid">
                                                    <c:forEach var="productMap" items="${products}">
                                                        <a href="${pageContext.request.contextPath}/ProductDetailServlet?id=${productMap.product.product_id}"
                                                            class="product-item"
                                                            data-price="${productMap.product.price}"
                                                            data-name="${productMap.product.product_name}">
                                                            <img src="${pageContext.request.contextPath}/${productMap.imageUrl}"
                                                                alt="${productMap.product.product_name}"
                                                                class="product-image"
                                                                onerror="this.src='${pageContext.request.contextPath}/icon/Akari.jpg'">
                                                            <div class="product-info">
                                                                <div class="product-name">
                                                                    ${productMap.product.product_name}
                                                                </div>
                                                                <div class="product-price">
                                                                    ¥${productMap.product.price}
                                                                </div>
                                                                <div class="product-meta">
                                                                    <span>库存: ${productMap.product.stock}</span>
                                                                    <span>ID: ${productMap.product.product_id}</span>
                                                                </div>
                                                            </div>
                                                        </a>
                                                    </c:forEach>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="no-products">
                                                    <img src="${pageContext.request.contextPath}/icon/NotFoundShark.png"
                                                        alt="暂无商品" class="no-products-image">
                                                    <div class="no-products-title">该分类下暂无商品</div>
                                                    <div class="no-products-text">
                                                        "${category.category_name}" 分类下还没有上架的商品
                                                    </div>
                                                    <a href="${pageContext.request.contextPath}/HomeServlet"
                                                        class="back-btn">返回首页</a>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <script>
                                    // 商品排序功能
                                    function sortProducts(sortType) {
                                        const grid = document.getElementById('productsGrid');
                                        const products = Array.from(grid.children);

                                        // 更新排序按钮状态
                                        document.querySelectorAll('.sort-btn').forEach(btn => btn.classList.remove('active'));
                                        event.target.classList.add('active');

                                        // 排序逻辑
                                        products.sort((a, b) => {
                                            switch (sortType) {
                                                case 'price-asc':
                                                    return parseFloat(a.dataset.price) - parseFloat(b.dataset.price);
                                                case 'price-desc':
                                                    return parseFloat(b.dataset.price) - parseFloat(a.dataset.price);
                                                case 'name':
                                                    return a.dataset.name.localeCompare(b.dataset.name, 'zh-CN');
                                                default:
                                                    return 0; // 保持原始顺序
                                            }
                                        });

                                        // 重新排列DOM元素
                                        products.forEach(product => grid.appendChild(product));
                                    }

                                    // 页面加载完成后的初始化
                                    document.addEventListener('DOMContentLoaded', function () {
                                        console.log('分类商品页面加载完成');
                                        console.log('当前分类: ${category.category_name}');
                                        console.log('商品数量: ${productCount}');
                                    });
                                </script>

                        </body>

                        </html>