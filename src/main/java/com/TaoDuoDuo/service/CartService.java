package com.TaoDuoDuo.service;

import com.TaoDuoDuo.dao.CartDao;
import com.TaoDuoDuo.dao.ProductDao;
import com.TaoDuoDuo.dao.ProductImageDao;
import com.TaoDuoDuo.entity.Cart;
import com.TaoDuoDuo.entity.CartItem;
import com.TaoDuoDuo.entity.Product;
import com.TaoDuoDuo.entity.ProductImage;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class CartService {
    private CartDao cartDao;
    private ProductDao productDao;
    private ProductImageDao productImageDao;

    public CartService() {
        this.cartDao = new CartDao();
        this.productDao = new ProductDao();
        this.productImageDao = new ProductImageDao();
    }

    public boolean addToCart(int userId, int productId, int quantity) {
        // 检查购物车中是否已存在该商品
        Optional<Cart> existingCartOptional = cartDao.getCartByUserIdAndProductId(userId, productId);

        if (existingCartOptional.isPresent()) {
            // 如果已存在，更新数量（累加）
            Cart existingCart = existingCartOptional.get();
            existingCart.setQuantity(existingCart.getQuantity() + quantity);
            return cartDao.updateCart(existingCart);
        } else {
            // 如果不存在，添加新记录
            Cart cart = new Cart(userId, productId, quantity);
            return cartDao.addCart(cart);
        }
    }

    public List<CartItem> getUserCartItems(int userId) {
        List<CartItem> cartItems = new ArrayList<>();
        Optional<List<Cart>> cartsOptional = cartDao.getCartByUserId(userId);

        if (cartsOptional.isPresent()) {
            List<Cart> carts = cartsOptional.get();
            for (Cart cart : carts) {
                Optional<Product> productOptional = productDao.getProductById(cart.getProduct_id());
                if (productOptional.isPresent()) {
                    Product product = productOptional.get();

                    String productImage = "/icon/Akari.jpg"; // 默认图片
                    Optional<List<ProductImage>> imagesOptional = productImageDao
                            .getProductImageByProductId(cart.getProduct_id());
                    if (imagesOptional.isPresent() && !imagesOptional.get().isEmpty()) {
                        productImage = imagesOptional.get().get(0).getImage_url();
                    }

                    CartItem cartItem = new CartItem(cart, product, productImage);
                    cartItems.add(cartItem);
                }
            }
        }

        return cartItems;
    }

    /**
     * 从购物车中移除指定的商品
     * @param cartId 购物车项ID
     * @return 移除成功返回true，失败返回false
     */
    public boolean removeFromCart(int cartId) {
        return cartDao.deleteCart(cartId);
    }

    /**
     * 清空指定用户的购物车
     * @param userId 用户ID
     * @return 清空成功返回true，失败返回false
     */
    public boolean clearUserCart(int userId) {
        return cartDao.deleteCartByUserId(userId);
    }
}
