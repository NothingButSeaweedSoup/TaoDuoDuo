<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ page import="java.util.List" %>
            <%@ page import="java.util.Map" %>
                <%@ page import="com.TaoDuoDuo.entity.Product" %>
                    <%@ page import="com.TaoDuoDuo.entity.Shop" %>
                        <!DOCTYPE html>
                        <html lang="zh-CN">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>搜索结果 - 淘多多</title>
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

                                /* 搜索框样式 */
                                .search-section {
                                    margin-bottom: 20px;
                                }

                                .search-container {
                                    display: flex;
                                    align-items: center;
                                    background-color: #fff;
                                    border: 2px solid #4285f4;
                                    border-radius: 25px;
                                    padding: 8px 15px;
                                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                                    transition: box-shadow 0.3s;
                                }

                                .search-container:hover {
                                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                                }

                                .search-icon {
                                    width: 24px;
                                    height: 24px;
                                    margin-right: 12px;
                                    flex-shrink: 0;
                                }

                                .search-type-selector {
                                    position: relative;
                                    margin-right: 15px;
                                    flex-shrink: 0;
                                }

                                .search-type-btn {
                                    background: none;
                                    border: none;
                                    font-size: 16px;
                                    font-weight: 500;
                                    color: #333;
                                    cursor: pointer;
                                    display: flex;
                                    align-items: center;
                                    gap: 5px;
                                    padding: 5px 10px;
                                    border-radius: 6px;
                                    transition: background-color 0.3s;
                                }

                                .search-type-btn:hover {
                                    background-color: #f5f5f5;
                                }

                                .search-type-arrow {
                                    width: 0;
                                    height: 0;
                                    border-left: 4px solid transparent;
                                    border-right: 4px solid transparent;
                                    border-top: 5px solid #666;
                                    transition: transform 0.3s;
                                }

                                .search-type-dropdown {
                                    position: absolute;
                                    top: 100%;
                                    left: 0;
                                    background: #fff;
                                    border: 1px solid #ddd;
                                    border-radius: 8px;
                                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                                    z-index: 1000;
                                    min-width: 100px;
                                    display: none;
                                }

                                .search-type-dropdown.show {
                                    display: block;
                                }

                                .search-type-option {
                                    padding: 10px 15px;
                                    cursor: pointer;
                                    transition: background-color 0.3s;
                                    border-bottom: 1px solid #f0f0f0;
                                }

                                .search-type-option:last-child {
                                    border-bottom: none;
                                }

                                .search-type-option:hover {
                                    background-color: #f5f5f5;
                                }

                                .search-input {
                                    flex: 1;
                                    border: none;
                                    outline: none;
                                    font-size: 16px;
                                    padding: 8px 0;
                                    background: transparent;
                                }

                                .search-input::placeholder {
                                    color: #999;
                                }

                                .search-btn {
                                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                                    color: #fff;
                                    border: none;
                                    padding: 10px 25px;
                                    border-radius: 20px;
                                    font-size: 16px;
                                    font-weight: 600;
                                    cursor: pointer;
                                    transition: all 0.3s;
                                    margin-left: 15px;
                                    flex-shrink: 0;
                                }

                                .search-btn:hover {
                                    transform: translateY(-1px);
                                    box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
                                }

                                .search-header {
                                    background-color: #fff;
                                    padding: 20px;
                                    border-radius: 8px;
                                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                                    margin-bottom: 20px;
                                }

                                .search-info {
                                    font-size: 18px;
                                    color: #333;
                                    margin-bottom: 10px;
                                }

                                .search-keyword {
                                    color: #4285f4;
                                    font-weight: 600;
                                }

                                .result-count {
                                    font-size: 14px;
                                    color: #666;
                                }

                                .results-container {
                                    background-color: #fff;
                                    border-radius: 8px;
                                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                                    padding: 20px;
                                }

                                /* 商品结果样式 */
                                .products-grid {
                                    display: grid;
                                    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                                    gap: 20px;
                                }

                                .product-item {
                                    background-color: #fff;
                                    border: 1px solid #e8e8e8;
                                    border-radius: 8px;
                                    overflow: hidden;
                                    cursor: pointer;
                                    transition: all 0.3s;
                                    text-decoration: none;
                                    color: inherit;
                                }

                                .product-item:hover {
                                    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
                                    transform: translateY(-2px);
                                }

                                .product-image {
                                    width: 100%;
                                    height: 150px;
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
                                }

                                .product-price {
                                    font-size: 16px;
                                    font-weight: 600;
                                    color: #ff6b35;
                                }

                                /* 商家结果样式 */
                                .shops-list {
                                    display: flex;
                                    flex-direction: column;
                                    gap: 15px;
                                }

                                .shop-item {
                                    background-color: #fff;
                                    border: 1px solid #e8e8e8;
                                    border-radius: 8px;
                                    padding: 20px;
                                    cursor: pointer;
                                    transition: all 0.3s;
                                    text-decoration: none;
                                    color: inherit;
                                }

                                .shop-item:hover {
                                    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
                                    transform: translateY(-1px);
                                }

                                .shop-name {
                                    font-size: 18px;
                                    font-weight: 600;
                                    color: #333;
                                    margin-bottom: 8px;
                                }

                                .shop-info {
                                    font-size: 14px;
                                    color: #666;
                                }

                                /* 无结果样式 */
                                .no-results {
                                    text-align: center;
                                    padding: 60px 20px;
                                }

                                .no-results-image {
                                    width: 200px;
                                    height: auto;
                                    margin-bottom: 20px;
                                    opacity: 0.8;
                                }

                                .no-results-title {
                                    font-size: 24px;
                                    color: #333;
                                    margin-bottom: 10px;
                                }

                                .no-results-text {
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
                                    .products-grid {
                                        grid-template-columns: repeat(2, 1fr);
                                    }
                                }
                            </style>
                        </head>

                        <body>
                            <!-- 导航栏 -->
                            <%@ include file="view/head.jsp" %>

                                <div class="container">
                                    <!-- 搜索框区域 -->
                                    <div class="search-section">
                                        <div class="search-container">
                                            <!-- 搜索图标 -->
                                            <img src="${pageContext.request.contextPath}/icon/Search_Blue.png" alt="搜索"
                                                class="search-icon">

                                            <!-- 搜索类型选择器 -->
                                            <div class="search-type-selector">
                                                <button class="search-type-btn" onclick="toggleSearchType()">
                                                    <span id="searchTypeText">${searchType}</span>
                                                    <div class="search-type-arrow"></div>
                                                </button>
                                                <div class="search-type-dropdown" id="searchTypeDropdown">
                                                    <div class="search-type-option" onclick="selectSearchType('商品')">商品
                                                    </div>
                                                    <div class="search-type-option" onclick="selectSearchType('商家')">商家
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- 搜索输入框 -->
                                            <input type="text" class="search-input" placeholder="请输入搜索关键词..."
                                                id="searchInput" value="${searchKeyword}">

                                            <!-- 搜索按钮 -->
                                            <button class="search-btn" onclick="performSearch()">搜索</button>
                                        </div>
                                    </div>

                                    <!-- 搜索信息 -->
                                    <div class="search-header">
                                        <div class="search-info">
                                            搜索 "<span class="search-keyword">${searchKeyword}</span>" 在 ${searchType}
                                            中的结果
                                        </div>
                                        <div class="result-count">
                                            找到 ${resultCount} 个结果
                                        </div>
                                    </div>

                                    <!-- 搜索结果 -->
                                    <div class="results-container">
                                        <c:choose>
                                            <c:when test="${resultCount > 0}">
                                                <c:if test="${resultType == 'products'}">
                                                    <!-- 商品搜索结果 -->
                                                    <div class="products-grid">
                                                        <c:forEach var="productMap" items="${searchResults}">
                                                            <a href="${pageContext.request.contextPath}/ProductDetailServlet?id=${productMap.product.product_id}"
                                                                class="product-item">
                                                                <img src="${pageContext.request.contextPath}/${productMap.imageUrl}"
                                                                    alt="${productMap.product.product_name}"
                                                                    class="product-image"
                                                                    onerror="this.src='${pageContext.request.contextPath}/icon/Akari.jpg'">
                                                                <div class="product-info">
                                                                    <div class="product-name">
                                                                        ${productMap.product.product_name}</div>
                                                                    <div class="product-price">
                                                                        ¥${productMap.product.price}</div>
                                                                </div>
                                                            </a>
                                                        </c:forEach>
                                                    </div>
                                                </c:if>

                                                <c:if test="${resultType == 'shops'}">
                                                    <!-- 商家搜索结果 -->
                                                    <div class="shops-list">
                                                        <c:forEach var="shop" items="${searchResults}">
                                                            <a href="${pageContext.request.contextPath}/ShopPageServlet?id=${shop.shop_id}"
                                                                class="shop-item">
                                                                <div class="shop-name">${shop.shop_name}</div>
                                                                <div class="shop-info">商家ID: ${shop.shop_id} | 创建时间:
                                                                    ${shop.create_time}</div>
                                                            </a>
                                                        </c:forEach>
                                                    </div>
                                                </c:if>
                                            </c:when>
                                            <c:otherwise>
                                                <!-- 无搜索结果 -->
                                                <div class="no-results">
                                                    <img src="${pageContext.request.contextPath}/icon/NotFoundShark.png"
                                                        alt="未找到结果" class="no-results-image">
                                                    <div class="no-results-title">没有找到相关结果</div>
                                                    <div class="no-results-text">
                                                        抱歉，没有找到与 "<span class="search-keyword">${searchKeyword}</span>"
                                                        相关的${searchType}
                                                    </div>
                                                    <a href="${pageContext.request.contextPath}/HomeServlet"
                                                        class="back-btn">返回首页</a>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <script>
                                    // 搜索框功能
                                    function toggleSearchType() {
                                        const dropdown = document.getElementById('searchTypeDropdown');
                                        const arrow = document.querySelector('.search-type-arrow');

                                        dropdown.classList.toggle('show');
                                        arrow.style.transform = dropdown.classList.contains('show') ? 'rotate(180deg)' : 'rotate(0deg)';
                                    }

                                    function selectSearchType(type) {
                                        document.getElementById('searchTypeText').textContent = type;
                                        document.getElementById('searchTypeDropdown').classList.remove('show');
                                        document.querySelector('.search-type-arrow').style.transform = 'rotate(0deg)';

                                        // 更新搜索框占位符
                                        const searchInput = document.getElementById('searchInput');
                                        if (type === '商品') {
                                            searchInput.placeholder = '请输入商品名称...';
                                        } else if (type === '商家') {
                                            searchInput.placeholder = '请输入商家名称...';
                                        }
                                    }

                                    function performSearch() {
                                        const searchType = document.getElementById('searchTypeText').textContent;
                                        const searchKeyword = document.getElementById('searchInput').value.trim();

                                        if (!searchKeyword) {
                                            alert('请输入搜索关键词');
                                            return;
                                        }

                                        // 跳转到搜索结果页面
                                        const contextPath = '${pageContext.request.contextPath}';
                                        const searchUrl = contextPath + '/SearchServlet?type=' + encodeURIComponent(searchType) + '&keyword=' + encodeURIComponent(searchKeyword);
                                        window.location.href = searchUrl;
                                    }

                                    // 点击其他地方关闭下拉菜单
                                    document.addEventListener('click', function (event) {
                                        const selector = document.querySelector('.search-type-selector');
                                        const dropdown = document.getElementById('searchTypeDropdown');

                                        if (selector && !selector.contains(event.target)) {
                                            dropdown.classList.remove('show');
                                            document.querySelector('.search-type-arrow').style.transform = 'rotate(0deg)';
                                        }
                                    });

                                    // 回车键搜索
                                    document.getElementById('searchInput').addEventListener('keypress', function (event) {
                                        if (event.key === 'Enter') {
                                            performSearch();
                                        }
                                    });

                                    // 页面加载时设置正确的占位符
                                    document.addEventListener('DOMContentLoaded', function () {
                                        const currentType = document.getElementById('searchTypeText').textContent;
                                        selectSearchType(currentType);
                                    });
                                </script>

                        </body>

                        </html>