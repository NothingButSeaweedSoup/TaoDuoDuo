package com.TaoDuoDuo.servlet;

import com.TaoDuoDuo.service.CartService;
import com.TaoDuoDuo.service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "AddToCartServlet", value = "/AddToCartServlet")
public class AddToCartServlet extends HttpServlet {
    private CartService cartService;
    private ProductService productService;

    @Override
    public void init() throws ServletException {
        cartService = new CartService();
        productService = new ProductService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        Integer userRole = (Integer) session.getAttribute("role");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp?error=required");
            return;
        }

        // 检查用户角色，只有用户身份才能使用购物车
        if (userRole == null || userRole != 1) {
            response.sendRedirect(request.getContextPath() + "/view/error.jsp?error=" +
                    java.net.URLEncoder.encode("只有用户身份才能使用购物车功能", "UTF-8"));
            return;
        }

        String productIdStr = request.getParameter("productId");
        String quantityStr = request.getParameter("quantity");

        if (productIdStr == null || quantityStr == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        try {
            int productId = Integer.parseInt(productIdStr);
            int quantity = Integer.parseInt(quantityStr);

            if (quantity <= 0) {
                quantity = 1;
            }

            // 检查商品是否可以购买（上架且有库存）
            if (!productService.canPurchase(productId, quantity)) {
                response.sendRedirect(
                        request.getContextPath() + "/view/error.jsp?error=" +
                                java.net.URLEncoder.encode("商品已下架或库存不足，无法加入购物车", "UTF-8"));
                return;
            }

            boolean success = cartService.addToCart(userId, productId, quantity);

            if (success) {
                response.sendRedirect(
                        request.getContextPath() + "/ProductDetailServlet?id=" + productId + "&cartSuccess=true");
            } else {
                response.sendRedirect(
                        request.getContextPath() + "/ProductDetailServlet?id=" + productId + "&cartError=true");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
