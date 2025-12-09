<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <%@ page import="com.TaoDuoDuo.entity.*" %>
    <%@ page import="java.util.List" %>
      <% Product product=(Product) request.getAttribute("product"); List<ProductImage> productImages = (List
        <ProductImage>) request.getAttribute("productImages");
          Shop shop = (Shop) request.getAttribute("shop");
          List<Review> reviews = (List<Review>) request.getAttribute("reviews");
              String productName = product != null ? product.getProduct_name() : "商品详情";
              %>
              <!DOCTYPE html>
              <html lang="zh-CN">

              <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>
                  <%= productName %>
                </title>
                <style>
                  * {
                    box-sizing: border-box;
                  }

                  html {
                    width: 100%;
                    height: 100%;
                  }

                  body {
                    width: 100%;
                    min-height: 100%;
                    margin: 0;
                    padding: 110px 20px 40px;
                    background-color: #f5f5f5;
                    display: flex;
                    justify-content: center;
                    align-items: flex-start;
                    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Microsoft YaHei", sans-serif;
                  }

                  span {
                    word-break: break-word;
                  }

                  .main-container {
                    position: relative;
                    width: 1440px;
                    max-width: 100%;
                    min-height: 900px;
                    margin: 0 auto;
                  }

                  .img_main {
                    width: 480px;
                    height: 480px;
                    overflow: hidden;
                    position: absolute;
                    left: 0;
                    top: 0;
                    background-color: #fff;
                    border-radius: 12px;
                    border: 1px solid #e8e8e8;
                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
                  }

                  .img_main img {
                    width: 100%;
                    height: 100%;
                    object-fit: cover;
                  }

                  .img_list_container {
                    width: 485px;
                    height: 85px;
                    position: absolute;
                    left: 0;
                    top: 510px;
                  }

                  .img_list_wrapper {
                    width: 100%;
                    height: 100%;
                    position: relative;
                    overflow: hidden;
                  }

                  .img_list {
                    display: flex;
                    flex-direction: row;
                    gap: 12px;
                    align-items: flex-start;
                    transition: transform 0.3s ease;
                  }

                  .img_list_wrapper {
                    position: relative;
                  }

                  .img_item {
                    width: 85px;
                    height: 85px;
                    overflow: hidden;
                    position: relative;
                    flex-shrink: 0;
                    background-color: #fff;
                    border: 1px solid #e8e8e8;
                    border-radius: 6px;
                    cursor: pointer;
                    transition: all 0.3s;
                  }

                  .img_item:hover {
                    border-color: #40a9ff;
                    box-shadow: 0 2px 8px rgba(64, 169, 255, 0.2);
                  }

                  .img_item img {
                    width: 100%;
                    height: 100%;
                    object-fit: cover;
                  }

                  .img_item.active {
                    border: 2px solid #1890ff;
                    box-shadow: 0 2px 8px rgba(24, 144, 255, 0.3);
                  }

                  .img_scroll_button {
                    position: absolute;
                    top: 50%;
                    transform: translateY(-50%);
                    width: 30px;
                    height: 30px;
                    background-color: rgba(0, 0, 0, 0.5);
                    color: white;
                    border: none;
                    border-radius: 50%;
                    cursor: pointer;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    z-index: 10;
                    transition: background-color 0.3s;
                  }

                  .img_scroll_button:hover {
                    background-color: rgba(0, 0, 0, 0.7);
                  }

                  .img_scroll_button.prev {
                    left: 10px;
                  }

                  .img_scroll_button.next {
                    right: 10px;
                  }

                  .img_scroll_button.hidden {
                    display: none;
                  }

                  .product_info {
                    width: 520px;
                    height: auto;
                    position: absolute;
                    left: 50%;
                    margin-left: -200px;
                    top: 0;
                    display: flex;
                    flex-direction: row;
                    flex-wrap: wrap;
                    gap: 28px 24px;
                    align-content: flex-start;
                    align-items: flex-start;
                  }

                  .product_name {
                    width: 520px;
                    min-height: 100px;
                    overflow: hidden;
                    position: relative;
                    flex-shrink: 0;
                    background-color: #fff;
                    border-radius: 10px;
                    padding: 20px;
                    display: flex;
                    align-items: center;
                    font-size: 20px;
                    font-weight: 600;
                    color: #262626;
                    line-height: 1.4;
                    border: 1px solid #e8e8e8;
                  }

                  .product_description {
                    width: 520px;
                    min-height: 150px;
                    overflow: hidden;
                    position: relative;
                    flex-shrink: 0;
                    background-color: #fff;
                    border-radius: 10px;
                    padding: 20px;
                    font-size: 14px;
                    line-height: 1.8;
                    color: #595959;
                    border: 1px solid #e8e8e8;
                  }

                  .product_price {
                    width: 248px;
                    height: 60px;
                    overflow: hidden;
                    position: relative;
                    flex-shrink: 0;
                    border-radius: 10px;
                    background-color: #fff5f0;
                    padding: 15px;
                    display: flex;
                    align-items: center;
                    font-size: 24px;
                    color: #ff6b35;
                    font-weight: 600;
                    border: 1px solid #ffe7d9;
                  }

                  .product_stock {
                    width: 248px;
                    height: 60px;
                    overflow: hidden;
                    position: relative;
                    flex-shrink: 0;
                    border-radius: 10px;
                    background-color: #fff;
                    padding: 15px;
                    display: flex;
                    align-items: center;
                    font-size: 14px;
                    color: #595959;
                    border: 1px solid #e8e8e8;
                  }

                  .form {
                    width: 520px;
                    height: 150px;
                    position: absolute;
                    left: 50%;
                    margin-left: -200px;
                    top: 400px;
                  }

                  .num_of_product {
                    width: 520px;
                    height: 60px;
                    position: absolute;
                    left: 0px;
                    top: 0px;
                    display: flex;
                    align-items: center;
                    gap: 15px;
                    background: #fff;
                    border: 1px solid #d9d9d9;
                    border-radius: 10px;
                    padding: 0 20px;
                    transition: all 0.3s;
                  }

                  .num_of_product:focus-within {
                    border-color: #40a9ff;
                    box-shadow: 0 0 0 2px rgba(24, 144, 255, 0.1);
                  }

                  .num_of_product label {
                    font-size: 15px;
                    color: #595959;
                    white-space: nowrap;
                    font-weight: 500;
                  }

                  .quantity_control {
                    display: flex;
                    align-items: center;
                    gap: 0;
                    border: 1px solid #e8e8e8;
                    border-radius: 6px;
                    overflow: hidden;
                  }

                  .quantity_btn {
                    width: 40px;
                    height: 40px;
                    border: none;
                    background-color: #f5f5f5;
                    color: #595959;
                    font-size: 20px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: all 0.3s;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                  }

                  .quantity_btn:hover:not(:disabled) {
                    background-color: #ff6b35;
                    color: #fff;
                  }

                  .quantity_btn:disabled {
                    background-color: #f5f5f5;
                    color: #d9d9d9;
                    cursor: not-allowed;
                  }

                  .num_of_product input {
                    width: 80px;
                    height: 40px;
                    padding: 0 12px;
                    border: none;
                    border-left: 1px solid #e8e8e8;
                    border-right: 1px solid #e8e8e8;
                    font-size: 15px;
                    text-align: center;
                    box-sizing: border-box;
                    transition: all 0.3s;
                  }

                  .num_of_product input:focus {
                    outline: none;
                    border-color: #40a9ff;
                  }

                  .num_of_product input::placeholder {
                    color: #bfbfbf;
                  }

                  .total_price_display {
                    font-size: 18px;
                    color: #ff6b35;
                    font-weight: 600;
                    white-space: nowrap;
                  }

                  .add_cart {
                    width: 260px;
                    height: 60px;
                    overflow: hidden;
                    position: absolute;
                    left: 0px;
                    top: 90px;
                    border-radius: 10px 0px 0px 10px;
                    background-color: #fff;
                    cursor: pointer;
                    transition: all 0.3s;
                    border: 1px solid #ff6b35;
                    font-size: 16px;
                    font-weight: 500;
                    color: #ff6b35;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                  }

                  .add_cart:hover {
                    background-color: #fff5f0;
                    border-color: #ff8c5a;
                    color: #ff8c5a;
                  }

                  .submit {
                    width: 260px;
                    height: 60px;
                    overflow: hidden;
                    position: absolute;
                    left: 260px;
                    top: 90px;
                    border-radius: 0px 10px 10px 0px;
                    background-color: #ff6b35;
                    cursor: pointer;
                    transition: all 0.3s;
                    border: 1px solid #ff6b35;
                    font-size: 16px;
                    font-weight: 500;
                    color: #fff;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                  }

                  .submit:hover {
                    background-color: #ff8c5a;
                    border-color: #ff8c5a;
                    box-shadow: 0 2px 8px rgba(255, 107, 53, 0.3);
                  }

                  .shop_name {
                    width: 340px;
                    min-height: 100px;
                    overflow: hidden;
                    position: absolute;
                    right: 0;
                    top: 0;
                    background-color: #fff;
                    border-radius: 10px;
                    padding: 20px;
                    display: flex;
                    align-items: center;
                    font-size: 18px;
                    font-weight: 600;
                    color: #262626;
                    border: 1px solid #e8e8e8;
                  }

                  .product_reviews {
                    width: 340px;
                    height: 420px;
                    max-height: 420px;
                    overflow-y: auto;
                    position: absolute;
                    right: 0;
                    top: 120px;
                    background-color: #fff;
                    border-radius: 10px;
                    padding: 20px;
                    border: 1px solid #e8e8e8;
                    scroll-behavior: smooth;
                  }

                  .product_reviews::-webkit-scrollbar {
                    width: 6px;
                  }

                  .product_reviews::-webkit-scrollbar-thumb {
                    background-color: #d9d9d9;
                    border-radius: 3px;
                  }

                  .product_reviews::-webkit-scrollbar-thumb:hover {
                    background-color: #bfbfbf;
                  }

                  .review_item {
                    margin-bottom: 15px;
                    padding: 15px;
                    background-color: #fafafa;
                    border-radius: 8px;
                    border: 1px solid #f0f0f0;
                  }

                  .review_item:last-child {
                    margin-bottom: 0;
                  }

                  .review_rating {
                    color: #faad14;
                    margin-bottom: 8px;
                    font-size: 16px;
                  }

                  .review_content {
                    font-size: 13px;
                    line-height: 1.6;
                    color: #595959;
                    position: relative;
                  }

                  .review_content.collapsed {
                    max-height: 60px;
                    overflow: hidden;
                  }

                  .review_content.collapsed::after {
                    content: '';
                    position: absolute;
                    bottom: 0;
                    left: 0;
                    right: 0;
                    height: 20px;
                    background: linear-gradient(to bottom, transparent, #fafafa);
                  }

                  .review_expand_btn {
                    font-size: 12px;
                    color: #1890ff;
                    cursor: pointer;
                    margin-top: 5px;
                    display: inline-block;
                    user-select: none;
                  }

                  .review_expand_btn:hover {
                    color: #40a9ff;
                    text-decoration: underline;
                  }

                  .review_time {
                    font-size: 12px;
                    color: #8c8c8c;
                    margin-top: 8px;
                  }

                  .container>* {
                    width: 100%;
                    height: 100%;
                  }

                  @media (max-width: 1500px) {
                    .main-container {
                      max-width: 100%;
                      transform: scale(0.95);
                      transform-origin: top center;
                    }
                  }

                  @media (max-width: 1280px) {
                    .main-container {
                      transform: scale(0.85);
                    }
                  }

                  @media (max-width: 1024px) {
                    .main-container {
                      transform: scale(0.75);
                    }
                  }
                </style>
              </head>

              <body>
                <!-- 导航栏 -->
                <%@ include file="head.jsp" %>

                  <div class="main-container">
                    <!-- 主图 -->
                    <div id="img_main" class="img_main">
                      <% if (productImages !=null && !productImages.isEmpty()) { %>
                        <img src="<%= request.getContextPath() + productImages.get(0).getImage_url() %>" alt="商品主图"
                          id="mainImage">
                        <% } %>
                    </div>

                    <!-- 图片列表 -->
                    <div class="img_list_container">
                      <div class="img_list_wrapper">
                        <button class="img_scroll_button prev" id="prevBtn" style="display: none;">‹</button>
                        <div id="img_list" class="img_list">
                          <% if (productImages !=null && !productImages.isEmpty()) { %>
                            <% for (int i=0; i < productImages.size(); i++) { %>
                              <div class="img_item <%= i == 0 ? " active" : "" %>" data-image-url="<%=
                                  request.getContextPath() + productImages.get(i).getImage_url() %>" data-index="<%= i +
                                    1 %>">
                                    <img src="<%= request.getContextPath() + productImages.get(i).getImage_url() %>"
                                      alt="商品图片<%= i + 1 %>">
                              </div>
                              <% } %>
                                <% } %>
                        </div>
                        <button class="img_scroll_button next" id="nextBtn" style="display: none;">›</button>
                      </div>
                    </div>


                    <!-- 商品信息 -->
                    <div id="product_info" class="product_info">
                      <% if (product !=null) { %>
                        <div id="product_name" class="product_name">
                          <%= product.getProduct_name() %>
                        </div>
                        <div id="product_description" class="product_description">
                          <%= product.getDescription() !=null ? product.getDescription() : "" %>
                        </div>
                        <div id="product_price" class="product_price">¥<%= String.format("%.2f", product.getPrice()) %>
                        </div>
                        <div id="product_stock" class="product_stock">库存：<%= product.getStock() %>
                        </div>
                        <% } %>
                    </div>

                    <!-- 表单 -->
                    <form id="form" class="form" method="post" action="<%= request.getContextPath() %>/PaymentServlet">
                      <input type="hidden" name="productId"
                        value="<%= product != null ? product.getProduct_id() : "" %>">
                      <input type="hidden" id="unitPrice" value="<%= product != null ? product.getPrice() : 0 %>">
                      <div id="num_of_product" class="num_of_product">
                        <label for="quantity">数量</label>
                        <div class="quantity_control">
                          <button type="button" class="quantity_btn" id="decreaseBtn">−</button>
                          <input type="text" name="quantity" id="quantity" placeholder="1" pattern="[1-9][0-9]*"
                            value="1" required>
                          <button type="button" class="quantity_btn" id="increaseBtn">+</button>
                        </div>
                        <span class="total_price_display">总价：¥<span id="totalPrice">
                            <%= product !=null ? String.format("%.2f", product.getPrice()) : "0.00" %>
                          </span></span>
                      </div>
                      <button type="button" id="add_cart" class="add_cart">加入购物车</button>
                      <button type="submit" id="submit" class="submit">立即购买</button>
                    </form>

                    <!-- 店铺名称 -->
                    <div id="shop_name" class="shop_name">
                      <% if (shop !=null) { %>
                        商家：<%= shop.getShop_name() %>
                          <% } %>
                    </div>

                    <!-- 商品评价 -->
                    <div id="product_reviews" class="product_reviews">
                      <% if (reviews !=null && !reviews.isEmpty()) { %>
                        <% for (Review review : reviews) { %>
                          <div class="review_item">
                            <div class="review_rating">
                              <% for (int i=0; i < review.getRating(); i++) { %>
                                ★
                                <% } %>
                            </div>
                            <div class="review_content collapsed">
                              <%= review.getContent() %>
                            </div>
                            <span class="review_expand_btn" style="display: none;">展开</span>
                            <% if (review.getCreate_time() !=null) { %>
                              <div class="review_time">
                                <%= review.getCreate_time() %>
                              </div>
                              <% } %>
                          </div>
                          <% } %>
                            <% } else { %>
                              <div>暂无评价</div>
                              <% } %>
                    </div>
                  </div>

                  <script>

                    // 实时计算总价和限制输入为自然数
                    document.addEventListener('DOMContentLoaded', function () {
                      const quantityInput = document.getElementById('quantity');
                      const totalPriceSpan = document.getElementById('totalPrice');
                      const unitPriceInput = document.getElementById('unitPrice');
                      const decreaseBtn = document.getElementById('decreaseBtn');
                      const increaseBtn = document.getElementById('increaseBtn');
                      const stock = <%= product != null ? product.getStock() : 999 %>;

                      // 计算总价的函数
                      function updateTotalPrice() {
                        const quantity = parseInt(quantityInput.value) || 0;
                        const unitPrice = parseFloat(unitPriceInput.value) || 0;
                        const totalPrice = (quantity * unitPrice).toFixed(2);
                        if (totalPriceSpan) {
                          totalPriceSpan.textContent = totalPrice;
                        }
                      }

                      // 更新按钮状态
                      function updateButtonState() {
                        const quantity = parseInt(quantityInput.value) || 1;
                        decreaseBtn.disabled = quantity <= 1;
                        increaseBtn.disabled = quantity >= stock;
                      }

                      // 减少数量
                      if (decreaseBtn) {
                        decreaseBtn.addEventListener('click', function () {
                          let quantity = parseInt(quantityInput.value) || 1;
                          if (quantity > 1) {
                            quantity--;
                            quantityInput.value = quantity;
                            updateTotalPrice();
                            updateButtonState();
                          }
                        });
                      }

                      // 增加数量
                      if (increaseBtn) {
                        increaseBtn.addEventListener('click', function () {
                          let quantity = parseInt(quantityInput.value) || 1;
                          if (quantity < stock) {
                            quantity++;
                            quantityInput.value = quantity;
                            updateTotalPrice();
                            updateButtonState();
                          }
                        });
                      }

                      if (quantityInput) {
                        quantityInput.addEventListener('input', function (e) {
                          // 只允许数字
                          let value = this.value.replace(/[^\d]/g, '');
                          // 移除前导零（除非只有一个0，但自然数不允许0，所以直接移除）
                          if (value.length > 1 && value.startsWith('0')) {
                            value = value.replace(/^0+/, '');
                          }
                          // 如果为空或为0，清空
                          if (value === '' || value === '0') {
                            value = '';
                          }
                          this.value = value;

                          // 实时更新总价和按钮状态
                          updateTotalPrice();
                          updateButtonState();
                        });

                        quantityInput.addEventListener('keypress', function (e) {
                          // 阻止输入非数字字符
                          if (!/[0-9]/.test(e.key) && !['Backspace', 'Delete', 'Tab', 'Enter', 'ArrowLeft', 'ArrowRight'].includes(e.key)) {
                            e.preventDefault();
                          }
                        });

                        quantityInput.addEventListener('paste', function (e) {
                          e.preventDefault();
                          const paste = (e.clipboardData || window.clipboardData).getData('text');
                          const numbersOnly = paste.replace(/[^\d]/g, '');
                          if (numbersOnly && parseInt(numbersOnly) > 0) {
                            this.value = parseInt(numbersOnly).toString();
                            updateTotalPrice();
                            updateButtonState();
                          }
                        });

                        // 页面加载时计算一次总价和更新按钮状态
                        updateTotalPrice();
                        updateButtonState();
                      }

                      // 支付表单提交前确认
                      const paymentForm = document.getElementById('form');
                      if (paymentForm) {
                        paymentForm.addEventListener('submit', function (e) {
                          const quantity = parseInt(document.getElementById('quantity').value);
                          const stock = <%= product != null ? product.getStock() : 0 %>;
                          const totalPrice = document.getElementById('totalPrice').textContent;

                          // 验证数量
                          if (!quantity || quantity <= 0) {
                            e.preventDefault();
                            alert('请输入有效的购买数量');
                            return false;
                          }

                          // 验证库存
                          if (quantity > stock) {
                            e.preventDefault();
                            alert('购买数量超过库存！当前库存：' + stock);
                            return false;
                          }

                          // 确认支付
                          const confirmed = confirm(
                            '确认支付 ¥' + totalPrice + ' 吗？\n\n' +
                            '点击确定将跳转到支付宝支付页面'
                          );

                          if (!confirmed) {
                            e.preventDefault();
                            return false;
                          }
                        });
                      }

                      // 图片切换功能
                      const mainImage = document.getElementById('mainImage');
                      const imgItems = document.querySelectorAll('.img_item');

                      // 为每个缩略图添加点击事件
                      imgItems.forEach(function (item) {
                        item.addEventListener('click', function () {
                          // 获取点击的图片URL
                          const imageUrl = this.getAttribute('data-image-url');

                          // 更新主图
                          if (mainImage && imageUrl) {
                            mainImage.src = imageUrl;
                          }

                          // 移除所有缩略图的active状态
                          imgItems.forEach(function (img) {
                            img.classList.remove('active');
                          });

                          // 给当前点击的缩略图添加active状态
                          this.classList.add('active');
                        });
                      });

                      // 缩略图滑动功能
                      const imgList = document.getElementById('img_list');
                      const prevBtn = document.getElementById('prevBtn');
                      const nextBtn = document.getElementById('nextBtn');
                      const imgListWrapper = document.querySelector('.img_list_wrapper');

                      let currentScroll = 0;
                      const scrollStep = 97; // 每次滚动一个缩略图的宽度 (85px + 12px gap)

                      // 检查是否需要显示滚动按钮
                      function updateScrollButtons() {
                        if (!imgList || !imgListWrapper) return;

                        const maxScroll = imgList.scrollWidth - imgListWrapper.clientWidth;

                        // 如果内容宽度小于等于容器宽度，隐藏所有按钮
                        if (maxScroll <= 0) {
                          prevBtn.style.display = 'none';
                          nextBtn.style.display = 'none';
                          return;
                        }

                        // 显示/隐藏左按钮
                        if (currentScroll <= 0) {
                          prevBtn.style.display = 'none';
                        } else {
                          prevBtn.style.display = 'flex';
                        }

                        // 显示/隐藏右按钮
                        if (currentScroll >= maxScroll) {
                          nextBtn.style.display = 'none';
                        } else {
                          nextBtn.style.display = 'flex';
                        }
                      }

                      // 向左滚动
                      if (prevBtn) {
                        prevBtn.addEventListener('click', function () {
                          currentScroll = Math.max(0, currentScroll - scrollStep);
                          imgList.style.transform = 'translateX(-' + currentScroll + 'px)';
                          updateScrollButtons();
                        });
                      }

                      // 向右滚动
                      if (nextBtn) {
                        nextBtn.addEventListener('click', function () {
                          const maxScroll = imgList.scrollWidth - imgListWrapper.clientWidth;
                          currentScroll = Math.min(maxScroll, currentScroll + scrollStep);
                          imgList.style.transform = 'translateX(-' + currentScroll + 'px)';
                          updateScrollButtons();
                        });
                      }

                      // 初始化按钮状态
                      updateScrollButtons();

                      // 窗口大小改变时重新计算
                      window.addEventListener('resize', function () {
                        currentScroll = 0;
                        imgList.style.transform = 'translateX(0)';
                        updateScrollButtons();
                      });

                      // 评论展开/收起功能
                      const reviewItems = document.querySelectorAll('.review_item');

                      reviewItems.forEach(function (item) {
                        const content = item.querySelector('.review_content');
                        const expandBtn = item.querySelector('.review_expand_btn');

                        if (content && expandBtn) {
                          // 检查内容是否超过限制高度（60px约3行）
                          if (content.scrollHeight > 60) {
                            // 显示展开按钮
                            expandBtn.style.display = 'inline-block';

                            // 添加点击事件
                            expandBtn.addEventListener('click', function () {
                              if (content.classList.contains('collapsed')) {
                                // 展开
                                content.classList.remove('collapsed');
                                expandBtn.textContent = '收起';
                              } else {
                                // 收起
                                content.classList.add('collapsed');
                                expandBtn.textContent = '展开';
                              }
                            });
                          } else {
                            // 内容不长，移除 collapsed 类，隐藏按钮
                            content.classList.remove('collapsed');
                            expandBtn.style.display = 'none';
                          }
                        }
                      });

                      // 检查URL参数显示购物车操作结果
                      const urlParams = new URLSearchParams(window.location.search);
                      if (urlParams.get('cartSuccess') === 'true') {
                        alert('已成功加入购物车！');
                        // 清除URL参数
                        window.history.replaceState({}, document.title, window.location.pathname + '?id=' + urlParams.get('id'));
                      } else if (urlParams.get('cartError') === 'true') {
                        alert('加入购物车失败，请重试');
                        window.history.replaceState({}, document.title, window.location.pathname + '?id=' + urlParams.get('id'));
                      }

                      // 加入购物车按钮
                      const addCartBtn = document.getElementById('add_cart');
                      if (addCartBtn) {
                        addCartBtn.addEventListener('click', function () {
                          const quantity = parseInt(document.getElementById('quantity').value);
                          const productId = <%= product != null ? product.getProduct_id() : 0 %>;
                          const stock = <%= product != null ? product.getStock() : 0 %>;

                          // 验证数量
                          if (!quantity || quantity <= 0) {
                            alert('请输入有效的购买数量');
                            return;
                          }

                          // 验证库存
                          if (quantity > stock) {
                            alert('购买数量超过库存！当前库存：' + stock);
                            return;
                          }

                          // 创建表单并提交
                          const form = document.createElement('form');
                          form.method = 'POST';
                          form.action = '<%= request.getContextPath() %>/AddToCartServlet';

                          const productIdInput = document.createElement('input');
                          productIdInput.type = 'hidden';
                          productIdInput.name = 'productId';
                          productIdInput.value = productId;
                          form.appendChild(productIdInput);

                          const quantityInput = document.createElement('input');
                          quantityInput.type = 'hidden';
                          quantityInput.name = 'quantity';
                          quantityInput.value = quantity;
                          form.appendChild(quantityInput);

                          document.body.appendChild(form);
                          form.submit();
                        });
                      }
                    });
                  </script>
              </body>

              </html>