<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.TaoDuoDuo.entity.CartItem" %>
        <%@ page import="java.util.List" %>
            <% List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
                    boolean isEmpty = (cartItems == null || cartItems.isEmpty());
                    %>
                    <!DOCTYPE html>
                    <html lang="zh-CN">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>购物车 - 淘多多</title>
                        <style>
                            * {
                                box-sizing: border-box;
                            }

                            body {
                                margin: 0;
                                padding: 110px 20px 40px;
                                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Microsoft YaHei", sans-serif;
                                min-height: 100vh;
                            }

                            .cart-container {
                                max-width: 1280px;
                                margin: 0 auto;
                            }

                            .cart-title {
                                font-size: 28px;
                                font-weight: 700;
                                color: #262626;
                                margin-bottom: 30px;
                            }

                            .cart-content {
                                display: flex;
                                gap: 30px;
                                align-items: flex-start;
                            }

                            .cart-items {
                                flex: 1;
                                display: flex;
                                flex-direction: column;
                                gap: 20px;
                            }

                            .cart-item {
                                background: white;
                                border-radius: 16px;
                                padding: 20px;
                                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
                                display: flex;
                                align-items: center;
                                gap: 20px;
                                transition: all 0.3s;
                            }

                            .cart-item:hover {
                                box-shadow: 0 8px 30px rgba(102, 126, 234, 0.25);
                                transform: translateY(-2px);
                            }

                            .cart-item-checkbox {
                                width: 24px;
                                height: 24px;
                                cursor: pointer;
                                accent-color: #667eea;
                            }

                            .cart-item-image {
                                width: 120px;
                                height: 120px;
                                border-radius: 12px;
                                overflow: hidden;
                            }

                            .cart-item-image img {
                                width: 100%;
                                height: 100%;
                                object-fit: cover;
                            }

                            .cart-item-info {
                                flex: 1;
                                display: flex;
                                flex-direction: column;
                                gap: 10px;
                            }

                            .cart-item-name {
                                font-size: 18px;
                                font-weight: 600;
                                color: #262626;
                            }

                            .cart-item-price {
                                font-size: 20px;
                                font-weight: 700;
                                color: #ff6b6b;
                            }

                            .cart-item-stock {
                                font-size: 14px;
                                color: #8c8c8c;
                            }

                            .cart-item-stock.low-stock {
                                color: #ff4d4f;
                                font-weight: 600;
                            }

                            .cart-item-quantity {
                                display: flex;
                                align-items: center;
                                gap: 10px;
                            }

                            .quantity-btn {
                                width: 32px;
                                height: 32px;
                                border: 1px solid #d9d9d9;
                                background: white;
                                border-radius: 6px;
                                cursor: pointer;
                                font-size: 18px;
                                transition: all 0.3s;
                            }

                            .quantity-btn:hover {
                                border-color: #667eea;
                                color: #667eea;
                            }

                            .quantity-input {
                                width: 60px;
                                height: 32px;
                                text-align: center;
                                border: 1px solid #d9d9d9;
                                border-radius: 6px;
                                font-size: 16px;
                            }

                            .cart-item-remove {
                                padding: 8px 16px;
                                background: #ff4d4f;
                                color: white;
                                border: none;
                                border-radius: 8px;
                                cursor: pointer;
                                transition: all 0.3s;
                            }

                            .cart-item-remove:hover {
                                background: #ff7875;
                            }

                            .cart-summary {
                                width: 350px;
                                background: white;
                                border-radius: 16px;
                                padding: 25px;
                                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
                                position: sticky;
                                top: 130px;
                            }

                            .summary-title {
                                font-size: 20px;
                                font-weight: 700;
                                margin-bottom: 20px;
                                color: #262626;
                            }

                            .summary-item {
                                display: flex;
                                justify-content: space-between;
                                margin-bottom: 15px;
                                font-size: 16px;
                            }

                            .summary-total {
                                display: flex;
                                justify-content: space-between;
                                padding-top: 15px;
                                border-top: 2px solid #f0f0f0;
                                font-size: 20px;
                                font-weight: 700;
                                color: #ff6b6b;
                                margin-bottom: 20px;
                            }

                            .checkout-btn {
                                width: 100%;
                                height: 50px;
                                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                                color: white;
                                border: none;
                                border-radius: 12px;
                                font-size: 18px;
                                font-weight: 600;
                                cursor: pointer;
                                transition: all 0.3s;
                            }

                            .checkout-btn:hover {
                                transform: translateY(-2px);
                                box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
                            }

                            .checkout-btn:disabled {
                                background: #d9d9d9;
                                cursor: not-allowed;
                                transform: none;
                            }

                            .empty-cart {
                                text-align: center;
                                padding: 100px 20px;
                            }

                            .empty-cart-icon {
                                font-size: 80px;
                                margin-bottom: 20px;
                            }

                            .empty-cart-text {
                                font-size: 20px;
                                color: #8c8c8c;
                                margin-bottom: 30px;
                            }

                            .continue-shopping {
                                padding: 12px 30px;
                                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                                color: white;
                                text-decoration: none;
                                border-radius: 25px;
                                font-size: 16px;
                                font-weight: 600;
                                transition: all 0.3s;
                                display: inline-block;
                            }

                            .continue-shopping:hover {
                                transform: translateY(-2px);
                                box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
                            }
                        </style>
                    </head>

                    <body>
                        <%@ include file="head.jsp" %>

                            <div class="cart-container">
                                <h1 class="cart-title">购物车</h1>

                                <% if (isEmpty) { %>
                                    <div class="empty-cart">
                                        <div class="empty-cart-icon">🛒</div>
                                        <div class="empty-cart-text">购物车是空的</div>
                                        <a href="<%= request.getContextPath() %>/index.jsp"
                                            class="continue-shopping">去逛逛</a>
                                    </div>
                                    <% } else { %>
                                        <div class="cart-content">
                                            <div class="cart-items">
                                                <% for (CartItem item : cartItems) { String
                                                    imgSrc=request.getContextPath(); if (item.getProductImage() !=null)
                                                    { imgSrc +=item.getProductImage(); } else { imgSrc
                                                    +="/images/default.png" ; } %>
                                                    <div class="cart-item">
                                                        <input type="checkbox" class="cart-item-checkbox"
                                                            data-cart-id="<%= item.getCart().getCart_id() %>"
                                                            data-price="<%= item.getProduct().getPrice() %>"
                                                            data-quantity="<%= item.getCart().getQuantity() %>"
                                                            data-stock="<%= item.getProduct().getStock() %>">

                                                        <div class="cart-item-image">
                                                            <img src="<%= imgSrc %>"
                                                                alt="<%= item.getProduct().getProduct_name() %>">
                                                        </div>

                                                        <div class="cart-item-info">
                                                            <div class="cart-item-name">
                                                                <%= item.getProduct().getProduct_name() %>
                                                            </div>
                                                            <div class="cart-item-price">¥<%= String.format("%.2f",
                                                                    item.getProduct().getPrice()) %>
                                                            </div>
                                                            <% String stockClass=item.getProduct().getStock() < 10
                                                                ? "cart-item-stock low-stock" : "cart-item-stock" ; %>
                                                                <div class="<%= stockClass %>">
                                                                    库存：<%= item.getProduct().getStock() %>件
                                                                </div>
                                                                <div class="cart-item-quantity">
                                                                    <span>数量：</span>
                                                                    <button class="quantity-btn"
                                                                        onclick="updateQuantity(<%= item.getCart().getCart_id() %>, -1, <%= item.getProduct().getStock() %>)">-</button>
                                                                    <input type="text" class="quantity-input"
                                                                        id="quantity-<%= item.getCart().getCart_id() %>"
                                                                        value="<%= item.getCart().getQuantity() %>"
                                                                        readonly>
                                                                    <button class="quantity-btn"
                                                                        onclick="updateQuantity(<%= item.getCart().getCart_id() %>, 1, <%= item.getProduct().getStock() %>)">+</button>
                                                                </div>
                                                        </div>

                                                        <button class="cart-item-remove"
                                                            onclick="removeItem(<%= item.getCart().getCart_id() %>)">删除</button>
                                                    </div>
                                                    <% } %>
                                            </div>

                                            <div class="cart-summary">
                                                <div class="summary-title">订单摘要</div>
                                                <div class="summary-item">
                                                    <span>已选商品：</span>
                                                    <span id="selectedCount">0</span>
                                                </div>
                                                <div class="summary-total">
                                                    <span>总计：</span>
                                                    <span id="totalAmount">¥0.00</span>
                                                </div>
                                                <button class="checkout-btn" id="checkoutBtn" disabled
                                                    onclick="checkout()">结算</button>
                                            </div>
                                        </div>
                                        <% } %>
                            </div>

                            <script>
                                function updateQuantity(cartId, change, stock) {
                                    const input = document.getElementById('quantity-' + cartId);
                                    let quantity = parseInt(input.value) + change;

                                    // 限制最小值为1
                                    if (quantity < 1) quantity = 1;

                                    // 限制最大值为库存
                                    if (quantity > stock) {
                                        quantity = stock;
                                        alert('已达到库存上限（' + stock + '件）');
                                    }

                                    // 使用AJAX更新数量
                                    const xhr = new XMLHttpRequest();
                                    xhr.open('POST', '<%= request.getContextPath() %>/UpdateCartServlet', true);
                                    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

                                    xhr.onload = function () {
                                        if (xhr.status === 200) {
                                            // 更新成功，更新页面显示
                                            input.value = quantity;

                                            // 更新checkbox的data-quantity属性
                                            const checkbox = input.closest('.cart-item').querySelector('.cart-item-checkbox');
                                            if (checkbox) {
                                                checkbox.dataset.quantity = quantity;
                                            }

                                            // 如果该商品被选中，更新总价
                                            if (checkbox && checkbox.checked) {
                                                updateSummary();
                                            }
                                        } else {
                                            alert('更新数量失败，请重试');
                                        }
                                    };

                                    xhr.onerror = function () {
                                        alert('网络错误，请重试');
                                    };

                                    xhr.send('cartId=' + cartId + '&quantity=' + quantity);
                                }

                                function removeItem(cartId) {
                                    if (confirm('确定要删除这个商品吗？')) {
                                        const form = document.createElement('form');
                                        form.method = 'POST';
                                        form.action = '<%= request.getContextPath() %>/RemoveFromCartServlet';

                                        const cartIdInput = document.createElement('input');
                                        cartIdInput.type = 'hidden';
                                        cartIdInput.name = 'cartId';
                                        cartIdInput.value = cartId;
                                        form.appendChild(cartIdInput);

                                        document.body.appendChild(form);
                                        form.submit();
                                    }
                                }

                                function updateSummary() {
                                    const checkboxes = document.querySelectorAll('.cart-item-checkbox:checked');
                                    let total = 0;

                                    checkboxes.forEach(checkbox => {
                                        const price = parseFloat(checkbox.dataset.price);
                                        const quantity = parseInt(checkbox.dataset.quantity);
                                        total += price * quantity;
                                    });

                                    document.getElementById('selectedCount').textContent = checkboxes.length;
                                    document.getElementById('totalAmount').textContent = '¥' + total.toFixed(2);
                                    document.getElementById('checkoutBtn').disabled = checkboxes.length === 0;
                                }

                                function checkout() {
                                    const checkboxes = document.querySelectorAll('.cart-item-checkbox:checked');
                                    if (checkboxes.length === 0) {
                                        alert('请选择要结算的商品');
                                        return;
                                    }

                                    const form = document.createElement('form');
                                    form.method = 'POST';
                                    form.action = '<%= request.getContextPath() %>/CheckoutServlet';

                                    checkboxes.forEach(checkbox => {
                                        const input = document.createElement('input');
                                        input.type = 'hidden';
                                        input.name = 'selectedCartIds';
                                        input.value = checkbox.dataset.cartId;
                                        form.appendChild(input);
                                    });

                                    document.body.appendChild(form);
                                    form.submit();
                                }

                                document.addEventListener('DOMContentLoaded', function () {
                                    const checkboxes = document.querySelectorAll('.cart-item-checkbox');
                                    checkboxes.forEach(checkbox => {
                                        checkbox.addEventListener('change', updateSummary);
                                    });
                                });
                            </script>
                    </body>

                    </html>