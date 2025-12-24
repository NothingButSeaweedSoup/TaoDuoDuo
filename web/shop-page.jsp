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
                            <title>${shop.shop_name} - 商家主页 - 淘多多</title>
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

                                /* 全局搜索框样式 */
                                .global-search-section {
                                    margin-bottom: 20px;
                                }

                                .global-search-container {
                                    display: flex;
                                    align-items: center;
                                    background-color: #fff;
                                    border: 2px solid #4285f4;
                                    border-radius: 25px;
                                    padding: 8px 15px;
                                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                                    transition: box-shadow 0.3s;
                                }

                                .global-search-container:hover {
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

                                /* 商家信息区域 */
                                .shop-header {
                                    background-color: #fff;
                                    padding: 30px;
                                    border-radius: 12px;
                                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                                    margin-bottom: 20px;
                                    text-align: center;
                                }

                                .shop-name {
                                    font-size: 32px;
                                    font-weight: 700;
                                    color: #333;
                                    margin-bottom: 10px;
                                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                                    -webkit-background-clip: text;
                                    -webkit-text-fill-color: transparent;
                                    background-clip: text;
                                }

                                .shop-info {
                                    font-size: 16px;
                                    color: #666;
                                    margin-bottom: 20px;
                                }

                                /* 店内搜索区域 */
                                .shop-search-section {
                                    background-color: #fff;
                                    padding: 20px;
                                    border-radius: 12px;
                                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                                    margin-bottom: 20px;
                                }

                                .shop-search-title {
                                    font-size: 18px;
                                    font-weight: 600;
                                    color: #333;
                                    margin-bottom: 15px;
                                    display: flex;
                                    align-items: center;
                                    gap: 8px;
                                }

                                .shop-search-container {
                                    display: flex;
                                    align-items: center;
                                    background-color: #f8f9fa;
                                    border: 2px solid #e9ecef;
                                    border-radius: 25px;
                                    padding: 8px 15px;
                                    transition: all 0.3s;
                                }

                                .shop-search-container:focus-within {
                                    border-color: #4285f4;
                                    background-color: #fff;
                                    box-shadow: 0 2px 8px rgba(66, 133, 244, 0.2);
                                }

                                .shop-search-input {
                                    flex: 1;
                                    border: none;
                                    outline: none;
                                    font-size: 16px;
                                    padding: 8px 0;
                                    background: transparent;
                                }

                                .shop-search-input::placeholder {
                                    color: #999;
                                }

                                .shop-search-btn {
                                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                                    color: #fff;
                                    border: none;
                                    padding: 10px 20px;
                                    border-radius: 20px;
                                    font-size: 14px;
                                    font-weight: 600;
                                    cursor: pointer;
                                    transition: all 0.3s;
                                    margin-left: 10px;
                                }

                                .shop-search-btn:hover {
                                    transform: translateY(-1px);
                                    box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
                                }

                                /* 商品展示区域 */
                                .products-section {
                                    background-color: #fff;
                                    padding: 20px;
                                    border-radius: 12px;
                                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                                }

                                .products-header {
                                    display: flex;
                                    justify-content: space-between;
                                    align-items: center;
                                    margin-bottom: 20px;
                                    padding-bottom: 15px;
                                    border-bottom: 2px solid #f0f0f0;
                                }

                                .products-title {
                                    font-size: 20px;
                                    font-weight: 600;
                                    color: #333;
                                }

                                .products-count {
                                    font-size: 14px;
                                    color: #666;
                                    background-color: #f8f9fa;
                                    padding: 5px 12px;
                                    border-radius: 15px;
                                }

                                .products-grid {
                                    display: grid;
                                    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                                    gap: 20px;
                                }

                                .product-item {
                                    background-color: #fff;
                                    border: 1px solid #e8e8e8;
                                    border-radius: 12px;
                                    overflow: hidden;
                                    cursor: pointer;
                                    transition: all 0.3s;
                                    text-decoration: none;
                                    color: inherit;
                                }

                                .product-item:hover {
                                    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
                                    transform: translateY(-4px);
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
                                    font-size: 16px;
                                    font-weight: 500;
                                    color: #333;
                                    margin-bottom: 8px;
                                    overflow: hidden;
                                    text-overflow: ellipsis;
                                    white-space: nowrap;
                                }

                                .product-price {
                                    font-size: 18px;
                                    font-weight: 600;
                                    color: #ff6b35;
                                }

                                /* 无商品样式 */
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
                                }

                                /* 响应式设计 */
                                @media (max-width: 768px) {
                                    .products-grid {
                                        grid-template-columns: repeat(2, 1fr);
                                    }

                                    .shop-name {
                                        font-size: 24px;
                                    }

                                    .products-header {
                                        flex-direction: column;
                                        gap: 10px;
                                        align-items: flex-start;
                                    }
                                }
                            </style>
                        </head>

                        <body>
                            <!-- 导航栏 -->
                            <%@ include file="view/head.jsp" %>

                                <div class="container">
                                    <!-- 全局搜索框 -->
                                    <div class="global-search-section">
                                        <div class="global-search-container">
                                            <img src="${pageContext.request.contextPath}/icon/Search_Blue.png" alt="搜索"
                                                class="search-icon">

                                            <div class="search-type-selector">
                                                <button class="search-type-btn" onclick="toggleGlobalSearchType()">
                                                    <span id="globalSearchTypeText">商品</span>
                                                    <div class="search-type-arrow"></div>
                                                </button>
                                                <div class="search-type-dropdown" id="globalSearchTypeDropdown">
                                                    <div class="search-type-option"
                                                        onclick="selectGlobalSearchType('商品')">商品</div>
                                                    <div class="search-type-option"
                                                        onclick="selectGlobalSearchType('商家')">商家</div>
                                                </div>
                                            </div>

                                            <input type="text" class="search-input" placeholder="请输入搜索关键词..."
                                                id="globalSearchInput">

                                            <button class="search-btn" onclick="performGlobalSearch()">搜索</button>
                                        </div>
                                    </div>

                                    <c:if test="${not empty error}">
                                        <div class="no-products">
                                            <img src="${pageContext.request.contextPath}/icon/NotFoundShark.png"
                                                alt="错误" class="no-products-image">
                                            <div class="no-products-title">出错了</div>
                                            <div class="no-products-text">${error}</div>
                                        </div>
                                    </c:if>

                                    <c:if test="${empty error}">
                                        <!-- 商家信息 -->
                                        <div class="shop-header">
                                            <div class="shop-name">${shop.shop_name}</div>
                                            <div class="shop-info">
                                                商家ID: ${shop.shop_id} | 创建时间: ${shop.create_time}
                                            </div>
                                        </div>

                                        <!-- 店内搜索 -->
                                        <div class="shop-search-section">
                                            <div class="shop-search-title">
                                                🔍 店内搜索
                                            </div>
                                            <div class="shop-search-container">
                                                <input type="text" class="shop-search-input"
                                                    placeholder="在 ${shop.shop_name} 中搜索商品..." id="shopSearchInput"
                                                    value="${searchKeyword}">
                                                <button class="shop-search-btn"
                                                    onclick="performShopSearch()">店内搜索</button>
                                            </div>
                                        </div>

                                        <!-- 商品展示 -->
                                        <div class="products-section">
                                            <div class="products-header">
                                                <div class="products-title">
                                                    <c:choose>
                                                        <c:when test="${not empty searchKeyword}">
                                                            搜索 "${searchKeyword}" 的结果
                                                        </c:when>
                                                        <c:otherwise>
                                                            店内商品
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="products-count">共 ${productCount} 件商品</div>
                                            </div>

                                            <c:choose>
                                                <c:when test="${productCount > 0}">
                                                    <div class="products-grid">
                                                        <c:forEach var="productMap" items="${products}">
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
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="no-products">
                                                        <img src="${pageContext.request.contextPath}/icon/NotFoundShark.png"
                                                            alt="暂无商品" class="no-products-image">
                                                        <div class="no-products-title">
                                                            <c:choose>
                                                                <c:when test="${not empty searchKeyword}">
                                                                    没有找到相关商品
                                                                </c:when>
                                                                <c:otherwise>
                                                                    暂无商品
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        <div class="no-products-text">
                                                            <c:choose>
                                                                <c:when test="${not empty searchKeyword}">
                                                                    在 ${shop.shop_name} 中没有找到与 "${searchKeyword}" 相关的商品
                                                                </c:when>
                                                                <c:otherwise>
                                                                    ${shop.shop_name} 还没有上架任何商品
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </c:if>
                                </div>

                                <script>
                                    // 全局搜索功能
                                    function toggleGlobalSearchType() {
                                        const dropdown = document.getElementById('globalSearchTypeDropdown');
                                        const arrow = document.querySelector('.search-type-arrow');

                                        dropdown.classList.toggle('show');
                                        arrow.style.transform = dropdown.classList.contains('show') ? 'rotate(180deg)' : 'rotate(0deg)';
                                    }

                                    function selectGlobalSearchType(type) {
                                        document.getElementById('globalSearchTypeText').textContent = type;
                                        document.getElementById('globalSearchTypeDropdown').classList.remove('show');
                                        document.querySelector('.search-type-arrow').style.transform = 'rotate(0deg)';

                                        const searchInput = document.getElementById('globalSearchInput');
                                        if (type === '商品') {
                                            searchInput.placeholder = '请输入商品名称...';
                                        } else if (type === '商家') {
                                            searchInput.placeholder = '请输入商家名称...';
                                        }
                                    }

                                    function performGlobalSearch() {
                                        const searchType = document.getElementById('globalSearchTypeText').textContent;
                                        const searchKeyword = document.getElementById('globalSearchInput').value.trim();

                                        if (!searchKeyword) {
                                            alert('请输入搜索关键词');
                                            return;
                                        }

                                        const contextPath = '${pageContext.request.contextPath}';
                                        const searchUrl = contextPath + '/SearchServlet?type=' + encodeURIComponent(searchType) + '&keyword=' + encodeURIComponent(searchKeyword);
                                        window.location.href = searchUrl;
                                    }

                                    // 店内搜索功能
                                    function performShopSearch() {
                                        const searchKeyword = document.getElementById('shopSearchInput').value.trim();
                                        const shopId = '${shop.shop_id}';
                                        const contextPath = '${pageContext.request.contextPath}';

                                        let searchUrl = contextPath + '/ShopPageServlet?id=' + shopId;
                                        if (searchKeyword) {
                                            searchUrl += '&search=' + encodeURIComponent(searchKeyword);
                                        }

                                        window.location.href = searchUrl;
                                    }

                                    // 点击其他地方关闭下拉菜单
                                    document.addEventListener('click', function (event) {
                                        const selector = document.querySelector('.search-type-selector');
                                        const dropdown = document.getElementById('globalSearchTypeDropdown');

                                        if (selector && !selector.contains(event.target)) {
                                            dropdown.classList.remove('show');
                                            document.querySelector('.search-type-arrow').style.transform = 'rotate(0deg)';
                                        }
                                    });

                                    // 回车键搜索
                                    document.getElementById('globalSearchInput').addEventListener('keypress', function (event) {
                                        if (event.key === 'Enter') {
                                            performGlobalSearch();
                                        }
                                    });

                                    document.getElementById('shopSearchInput').addEventListener('keypress', function (event) {
                                        if (event.key === 'Enter') {
                                            performShopSearch();
                                        }
                                    });

                                    // 页面加载时设置正确的占位符
                                    document.addEventListener('DOMContentLoaded', function () {
                                        selectGlobalSearchType('商品');
                                    });
                                </script>
                        </body>

                        </html>