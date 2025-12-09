package com.TaoDuoDuo.servlet;

import com.TaoDuoDuo.dao.CartDao;
import com.TaoDuoDuo.dao.ProductDao;
import com.TaoDuoDuo.entity.Cart;
import com.TaoDuoDuo.entity.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "UpdateCartServlet", value = "/UpdateCartServlet")
public class UpdateCartServlet extends HttpServlet {
    private CartDao cartDao;
    private ProductDao productDao;

    @Override
    public void init() throws ServletException {
        cartDao = new CartDao();
        productDao = new ProductDao();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\":false,\"message\":\"未登录\"}");
            return;
        }

        String cartIdStr = request.getParameter("cartId");
        String quantityStr = request.getParameter("quantity");
        boolean success = false;

        if (cartIdStr != null && quantityStr != null) {
            try {
                int cartId = Integer.parseInt(cartIdStr);
                int quantity = Integer.parseInt(quantityStr);

                if (quantity > 0) {
                    Optional<Cart> cartOptional = cartDao.getCartById(cartId);
                    if (cartOptional.isPresent()) {
                        Cart cart = cartOptional.get();

                        // 检查库存
                        Optional<Product> productOptional = productDao.getProductById(cart.getProduct_id());
                        if (productOptional.isPresent()) {
                            Product product = productOptional.get();
                            int stock = product.getStock();

                            // 如果请求数量超过库存，自动调整为库存数量
                            if (quantity > stock) {
                                quantity = stock;
                            }

                            cart.setQuantity(quantity);
                            success = cartDao.updateCart(cart);
                        }
                    }
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        if (success) {
            response.getWriter().write("{\"success\":true}");
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"更新失败\"}");
        }
    }
}
