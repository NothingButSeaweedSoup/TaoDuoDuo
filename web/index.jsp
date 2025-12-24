<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ page import="java.util.List" %>
            <%@ page import="java.util.Map" %>
                <%@ page import="com.TaoDuoDuo.entity.Product" %>

                    <!-- 如果没有商品数据，重定向到HomeServlet -->
                    <c:if test="${empty randomProducts}">
                        <% response.sendRedirect(request.getContextPath() + "/HomeServlet" ); %>
                    </c:if>
                    <!DOCTYPE html>
                    <html lang="zh-CN">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>淘多多 - 首页</title>
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
                                /* 为固定导航栏留出空间 */
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

                            /* 主要内容区域 */
                            .main-content {
                                display: flex;
                                gap: 20px;
                                margin-bottom: 30px;
                            }

                            /* 轮播图区域 */
                            .carousel-section {
                                flex: 2;
                                height: 300px;
                                position: relative;
                                overflow: hidden;
                                border-radius: 8px;
                                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                            }

                            .carousel-container {
                                width: 100%;
                                height: 100%;
                                position: relative;
                            }

                            .carousel-slide {
                                position: absolute;
                                top: 0;
                                left: 0;
                                width: 100%;
                                height: 100%;
                                opacity: 0;
                                transition: opacity 0.5s ease-in-out;
                            }

                            .carousel-slide.active {
                                opacity: 1;
                            }

                            .carousel-slide img {
                                width: 100%;
                                height: 100%;
                                object-fit: cover;
                            }

                            /* 轮播图指示器 */
                            .carousel-indicators {
                                position: absolute;
                                bottom: 15px;
                                left: 50%;
                                transform: translateX(-50%);
                                display: flex;
                                gap: 8px;
                            }

                            .indicator {
                                width: 10px;
                                height: 10px;
                                border-radius: 50%;
                                background-color: rgba(255, 255, 255, 0.5);
                                cursor: pointer;
                                transition: background-color 0.3s;
                            }

                            .indicator.active {
                                background-color: #fff;
                            }

                            /* 轮播图导航按钮 */
                            .carousel-nav {
                                position: absolute;
                                top: 50%;
                                transform: translateY(-50%);
                                background-color: rgba(0, 0, 0, 0.5);
                                color: white;
                                border: none;
                                width: 40px;
                                height: 40px;
                                border-radius: 50%;
                                cursor: pointer;
                                font-size: 18px;
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                transition: background-color 0.3s;
                            }

                            .carousel-nav:hover {
                                background-color: rgba(0, 0, 0, 0.7);
                            }

                            .carousel-nav.prev {
                                left: 15px;
                            }

                            .carousel-nav.next {
                                right: 15px;
                            }

                            /* 分类侧边栏 */
                            .category-sidebar {
                                flex: 1;
                                height: 300px;
                                background-color: #a8a8a8;
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                color: #333;
                                font-size: 20px;
                                font-weight: bold;
                            }

                            /* 商品网格 */
                            .products-grid {
                                display: grid;
                                grid-template-columns: repeat(5, 1fr);
                                gap: 20px;
                            }

                            .product-item {
                                background-color: #fff;
                                border-radius: 8px;
                                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
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
                                height: 120px;
                                object-fit: cover;
                                background-color: #f5f5f5;
                            }

                            .product-info {
                                padding: 12px;
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

                            /* 响应式设计 */
                            @media (max-width: 768px) {
                                .main-content {
                                    flex-direction: column;
                                }

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
                                                <span id="searchTypeText">商品</span>
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
                                            id="searchInput">

                                        <!-- 搜索按钮 -->
                                        <button class="search-btn" onclick="performSearch()">搜索</button>
                                    </div>
                                </div>

                                <!-- 主要内容区域 -->
                                <div class="main-content">
                                    <!-- 轮播图 -->
                                    <div class="carousel-section">
                                        <div class="carousel-container">
                                            <div class="carousel-slide active">
                                                <img src="images/carousel/car-1.png" alt="轮播图1">
                                            </div>
                                            <div class="carousel-slide">
                                                <img src="images/carousel/car-2.png" alt="轮播图2">
                                            </div>

                                            <!-- 导航按钮 -->
                                            <button class="carousel-nav prev" onclick="prevSlide()">‹</button>
                                            <button class="carousel-nav next" onclick="nextSlide()">›</button>

                                            <!-- 指示器 -->
                                            <div class="carousel-indicators">
                                                <div class="indicator active" onclick="currentSlide(1)"></div>
                                                <div class="indicator" onclick="currentSlide(2)"></div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- 分类侧边栏 -->
                                    <div class="category-sidebar">
                                        分类
                                    </div>
                                </div>

                                <!-- 商品网格 -->
                                <div class="products-grid">
                                    <!-- 显示商品 -->
                                    <c:forEach var="productMap" items="${randomProducts}">
                                        <a href="${pageContext.request.contextPath}/ProductDetailServlet?id=${productMap.product.product_id}"
                                            class="product-item">
                                            <img src="${pageContext.request.contextPath}/${productMap.imageUrl}"
                                                alt="${productMap.product.product_name}" class="product-image"
                                                onerror="this.src='${pageContext.request.contextPath}/images/productImage/default.png'">
                                            <div class="product-info">
                                                <div class="product-name">
                                                    ${productMap.product.product_name}
                                                </div>
                                                <div class="product-price">¥${productMap.product.price}
                                                </div>
                                            </div>
                                        </a>
                                    </c:forEach>
                                </div>
                            </div>
                    </body>

                    <script>
                        let currentSlideIndex = 0;
                        const slides = document.querySelectorAll('.carousel-slide');
                        const indicators = document.querySelectorAll('.indicator');
                        const totalSlides = slides.length;

                        // 显示指定的幻灯片
                        function showSlide(index) {
                            // 移除所有活动状态
                            slides.forEach(slide => slide.classList.remove('active'));
                            indicators.forEach(indicator => indicator.classList.remove('active'));

                            // 添加活动状态到当前幻灯片
                            slides[index].classList.add('active');
                            indicators[index].classList.add('active');

                            currentSlideIndex = index;
                        }

                        // 下一张幻灯片
                        function nextSlide() {
                            const nextIndex = (currentSlideIndex + 1) % totalSlides;
                            showSlide(nextIndex);
                        }

                        // 上一张幻灯片
                        function prevSlide() {
                            const prevIndex = (currentSlideIndex - 1 + totalSlides) % totalSlides;
                            showSlide(prevIndex);
                        }

                        // 跳转到指定幻灯片
                        function currentSlide(index) {
                            showSlide(index - 1);
                        }

                        // 自动轮播
                        function autoSlide() {
                            nextSlide();
                        }

                        // 启动自动轮播，每3秒切换一次
                        let autoSlideInterval = setInterval(autoSlide, 3000);

                        // 鼠标悬停时暂停自动轮播
                        const carouselSection = document.querySelector('.carousel-section');
                        carouselSection.addEventListener('mouseenter', () => {
                            clearInterval(autoSlideInterval);
                        });

                        // 鼠标离开时恢复自动轮播
                        carouselSection.addEventListener('mouseleave', () => {
                            autoSlideInterval = setInterval(autoSlide, 3000);
                        });

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
                    </script>

                    </html>