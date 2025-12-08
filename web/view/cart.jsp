<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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

            html {
                width: 100%;
                height: 100%;
            }

            body {
                width: 100%;
                min-height: 100%;
                margin: 0;
                padding: 110px 0 40px;
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Microsoft YaHei", sans-serif;
            }

            /* 购物车主容器 */
            .cart-container {
                width: 1280px;
                margin: 0 auto;
                position: relative;
                min-height: 800px;
            }

            /* 购物车标题 */
            .cart-title {
                font-size: 28px;
                font-weight: 700;
                color: #262626;
                margin-bottom: 30px;
                padding-left: 42px;
            }

            /* 购物车商品项 */
            .cart-item-1,
            .cart-item-2,
            .cart-item-3 {
                width: 831px;
                height: 180px;
                position: absolute;
                left: 42px;
                background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
                border-radius: 16px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
                transition: all 0.3s;
                border: 2px solid transparent;
            }

            .cart-item-1 {
                top: 113.5px;
            }

            .cart-item-2 {
                top: 323.5px;
            }

            .cart-item-3 {
                top: 533.5px;
            }

            .cart-item-1:hover,
            .cart-item-2:hover,
            .cart-item-3:hover {
                box-shadow: 0 8px 30px rgba(102, 126, 234, 0.25);
                border-color: #667eea;
                transform: translateY(-2px);
            }

            /* 复选框样式 */
            .checkbox-1,
            .checkbox-2,
            .checkbox-3 {
                width: 24px;
                height: 24px;
                position: absolute;
                left: 15px;
                top: 78px;
                cursor: pointer;
                accent-color: #667eea;
            }

            /* 缩略图 */
            .thumbnail-1,
            .thumbnail-2,
            .thumbnail-3 {
                width: 120px;
                height: 120px;
                position: absolute;
                left: 50px;
                top: 30px;
                border-radius: 12px;
                overflow: hidden;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            }

            .thumbnail-1 img,
            .thumbnail-2 img,
            .thumbnail-3 img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            /* 商品店铺 */
            .product-shop-1,
            .product-shop-2,
            .product-shop-3 {
                width: 312px;
                height: 25px;
                position: absolute;
                left: 190px;
                top: 25px;
                font-size: 13px;
                color: #8c8c8c;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
                padding: 0 10px;
                background-color: #f0f0f0;
                border-radius: 12px;
                display: flex;
                align-items: center;
            }

            .product-shop-1::before,
            .product-shop-2::before,
            .product-shop-3::before {
                content: '🏪';
                margin-right: 5px;
            }

            /* 商品名称 */
            .product-name-1,
            .product-name-2,
            .product-name-3 {
                width: 480px;
                height: 90px;
                position: absolute;
                left: 190px;
                top: 60px;
                font-size: 16px;
                font-weight: 600;
                color: #262626;
                line-height: 1.6;
                overflow: hidden;
                padding: 10px;
                display: -webkit-box;
                -webkit-line-clamp: 3;
                -webkit-box-orient: vertical;
            }

            /* 按钮组 */
            .button-group-1,
            .button-group-2,
            .button-group-3 {
                width: 120px;
                height: 45px;
                position: absolute;
                left: 700px;
                top: 30px;
                display: flex;
                align-items: center;
                gap: 0;
                border: 2px solid #e8e8e8;
                border-radius: 25px;
                overflow: hidden;
                background-color: #fff;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            }

            .quantity-btn {
                width: 38px;
                height: 43px;
                border: none;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: #fff;
                font-size: 20px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s;
            }

            .quantity-btn:hover:not(:disabled) {
                background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
                transform: scale(1.1);
            }

            .quantity-btn:disabled {
                background-color: #f5f5f5;
                color: #d9d9d9;
                cursor: not-allowed;
            }

            .quantity-input {
                width: 44px;
                height: 43px;
                border: none;
                text-align: center;
                font-size: 16px;
                font-weight: 600;
                color: #262626;
            }

            /* 商品价格 */
            .product-quantity-1,
            .product-quantity-2,
            .product-quantity-3 {
                width: 120px;
                height: 50px;
                position: absolute;
                left: 700px;
                top: 95px;
                font-size: 22px;
                font-weight: 700;
                background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            /* 购物车明细 */
            .cart-summary {
                width: 320px;
                position: absolute;
                left: 920px;
                top: 113.5px;
                background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
                border-radius: 20px;
                box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
                padding: 30px;
                border: 2px solid #e8e8e8;
            }

            .summary-title {
                font-size: 22px;
                font-weight: 700;
                color: #262626;
                margin-bottom: 25px;
                padding-bottom: 15px;
                border-bottom: 2px solid #e8e8e8;
                display: flex;
                align-items: center;
            }

            .summary-title::before {
                content: '📋';
                margin-right: 10px;
                font-size: 24px;
            }

            /* 缩略图容器 */
            .summary-thumbnails {
                display: flex;
                gap: 15px;
                margin-bottom: 20px;
                min-height: 80px;
                align-items: center;
                justify-content: center;
            }

            .summary-thumbnail-1,
            .summary-thumbnail-2 {
                width: 80px;
                height: 80px;
                border-radius: 12px;
                overflow: hidden;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                transition: all 0.3s;
            }

            .summary-thumbnail-1:hover,
            .summary-thumbnail-2:hover {
                transform: scale(1.05) rotate(2deg);
            }

            .summary-thumbnail-1 img,
            .summary-thumbnail-2 img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            /* 已选信息 */
            .cart-selected-info {
                background: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%);
                border-radius: 15px;
                padding: 20px;
                margin-bottom: 20px;
                text-align: center;
            }

            .cart-selected-info .label {
                font-size: 14px;
                color: #8c8c8c;
                margin-bottom: 10px;
            }

            .cart-selected-info .value {
                font-size: 32px;
                font-weight: 700;
                background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
            }

            /* 结算按钮 */
            .checkout-button {
                width: 100%;
                height: 55px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: #fff;
                border: none;
                border-radius: 30px;
                font-size: 18px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s;
                box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
            }

            .checkout-button:hover:not(:disabled) {
                background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
                box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
                transform: translateY(-2px);
            }

            .checkout-button:disabled {
                background: linear-gradient(135deg, #d9d9d9 0%, #bfbfbf 100%);
                cursor: not-allowed;
                box-shadow: none;
            }

            /* 空购物车 */
            .cart-empty {
                width: 831px;
                position: absolute;
                left: 42px;
                top: 113.5px;
                background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
                padding: 80px 30px;
                border-radius: 20px;
                box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
                text-align: center;
            }

            .cart-empty-icon {
                font-size: 100px;
                margin-bottom: 25px;
                animation: float 3s ease-in-out infinite;
            }

            @keyframes float {

                0%,
                100% {
                    transform: translateY(0px);
                }

                50% {
                    transform: translateY(-20px);
                }
            }

            .cart-empty-text {
                font-size: 20px;
                color: #8c8c8c;
                margin-bottom: 35px;
            }

            .cart-empty-btn {
                display: inline-block;
                padding: 15px 50px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: #fff;
                text-decoration: none;
                border-radius: 30px;
                font-size: 18px;
                font-weight: 600;
                transition: all 0.3s;
                box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
            }

            .cart-empty-btn:hover {
                background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
                box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
                transform: translateY(-2px);
            }

            /* 空状态提示 */
            .empty-hint {
                text-align: center;
                color: #bfbfbf;
                font-size: 14px;
                padding: 20px;
            }
        </style>
    </head>

    <body>
        <!-- 导航栏 -->
        <%@ include file="head.jsp" %>

            <div class="cart-container">
                <!-- 购物车为空 -->
                <div class="cart-empty">
                    <div class="cart-empty-icon">🛒</div>
                    <div class="cart-empty-text">购物车还是空的，快去挑选心仪的商品吧~</div>
                    <a href="${pageContext.request.contextPath}/index.jsp" class="cart-empty-btn">开始购物</a>
                </div>

                <!-- 购物车明细 -->
                <div class="cart-summary">
                    <div class="summary-title">结算明细</div>

                    <div class="summary-thumbnails">
                        <div class="summary-thumbnail-1" id="summaryThumb1" style="display: none;">
                            <img src="" alt="商品1" id="summaryImg1">
                        </div>
                        <div class="summary-thumbnail-2" id="summaryThumb2" style="display: none;">
                            <img src="" alt="商品2" id="summaryImg2">
                        </div>
                        <div class="empty-hint" id="emptyHint">请选择商品</div>
                    </div>

                    <div class="cart-selected-info">
                        <div class="label">已选 <span id="selectedCount">0</span> 件商品</div>
                        <div class="value">¥<span id="totalPrice">0.00</span></div>
                    </div>

                    <button class="checkout-button" id="checkoutBtn" disabled>立即结算</button>
                </div>
            </div>

            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    // 更新明细区缩略图
                    function updateSummaryThumbnails() {
                        const selectedItems = [];

                        document.querySelectorAll('.item-checkbox:checked').forEach(function (checkbox) {
                            const cartItem = checkbox.closest('[class^="cart-item-"]');
                            const thumbnail = cartItem.querySelector('[class^="thumbnail-"]');
                            const img = thumbnail ? thumbnail.querySelector('img') : null;

                            if (img && img.src) {
                                selectedItems.push(img.src);
                            }
                        });

                        const thumb1 = document.getElementById('summaryThumb1');
                        const img1 = document.getElementById('summaryImg1');
                        const thumb2 = document.getElementById('summaryThumb2');
                        const img2 = document.getElementById('summaryImg2');
                        const emptyHint = document.getElementById('emptyHint');

                        if (selectedItems.length >= 1) {
                            img1.src = selectedItems[0];
                            thumb1.style.display = 'block';
                            emptyHint.style.display = 'none';
                        } else {
                            thumb1.style.display = 'none';
                            emptyHint.style.display = 'block';
                        }

                        if (selectedItems.length >= 2) {
                            img2.src = selectedItems[1];
                            thumb2.style.display = 'block';
                        } else {
                            thumb2.style.display = 'none';
                        }
                    }

                    // 更新总价
                    function updateTotal() {
                        let selectedCount = 0;
                        let totalPrice = 0;

                        document.querySelectorAll('.item-checkbox:checked').forEach(function (checkbox) {
                            const cartItem = checkbox.closest('[class^="cart-item-"]');
                            const quantityInput = cartItem.querySelector('.quantity-input');

                            if (quantityInput) {
                                const quantity = parseInt(quantityInput.value) || 0;
                                const price = parseFloat(quantityInput.getAttribute('data-price')) || 0;

                                selectedCount++;
                                totalPrice += quantity * price;

                                const itemTotal = cartItem.querySelector('.item-total');
                                if (itemTotal) {
                                    itemTotal.textContent = (quantity * price).toFixed(2);
                                }
                            }
                        });

                        document.getElementById('selectedCount').textContent = selectedCount;
                        document.getElementById('totalPrice').textContent = totalPrice.toFixed(2);

                        const checkoutBtn = document.getElementById('checkoutBtn');
                        if (checkoutBtn) {
                            checkoutBtn.disabled = selectedCount === 0;
                        }

                        updateSummaryThumbnails();
                    }

                    // 事件监听
                    document.querySelectorAll('.item-checkbox').forEach(function (checkbox) {
                        checkbox.addEventListener('change', updateTotal);
                    });

                    document.querySelectorAll('.decrease-btn').forEach(function (btn) {
                        btn.addEventListener('click', function () {
                            const cartId = this.getAttribute('data-cart-id');
                            const input = document.querySelector('.quantity-input[data-cart-id="' + cartId + '"]');
                            let quantity = parseInt(input.value);

                            if (quantity > 1) {
                                quantity--;
                                input.value = quantity;
                                updateTotal();
                            }
                        });
                    });

                    document.querySelectorAll('.increase-btn').forEach(function (btn) {
                        btn.addEventListener('click', function () {
                            const cartId = this.getAttribute('data-cart-id');
                            const input = document.querySelector('.quantity-input[data-cart-id="' + cartId + '"]');
                            const stock = parseInt(input.getAttribute('data-stock'));
                            let quantity = parseInt(input.value);

                            if (quantity < stock) {
                                quantity++;
                                input.value = quantity;
                                updateTotal();
                            } else {
                                alert('已达到库存上限');
                            }
                        });
                    });

                    const checkoutBtn = document.getElementById('checkoutBtn');
                    if (checkoutBtn) {
                        checkoutBtn.addEventListener('click', function () {
                            const selectedItems = [];
                            document.querySelectorAll('.item-checkbox:checked').forEach(function (checkbox) {
                                const cartItem = checkbox.closest('[class^="cart-item-"]');
                                const cartId = cartItem.getAttribute('data-cart-id');
                                selectedItems.push(cartId);
                            });

                            if (selectedItems.length === 0) {
                                alert('请选择要结算的商品');
                                return;
                            }

                            alert('跳转到结算页面，选中商品ID: ' + selectedItems.join(','));
                        });
                    }

                    updateTotal();
                });
            </script>
    </body>

    </html>