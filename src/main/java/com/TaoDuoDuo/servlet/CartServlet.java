package com.TaoDuoDuo.servlet;

import com.TaoDuoDuo.entity.CartItem;
import com.TaoDuoDuo.service.CartService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "CartServlet", value = "/CartServlet")
public class CartServlet extends HttpServlet {
    private CartService cartService;

    @Override
    public void init() throws ServletException {
        cartService = new CartService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        Integer userRole = (Integer) session.getAttribute("role");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp?error=required");
            return;
        }

        // 检查用户角色，只有用户身份才能访问购物车
        if (userRole == null || userRole != 1) {
            response.sendRedirect(request.getContextPath() + "/view/error.jsp?error=" +
                    java.net.URLEncoder.encode("只有用户身份才能使用购物车功能", "UTF-8"));
            return;
        }

        List<CartItem> cartItems = cartService.getUserCartItems(userId);

        request.setAttribute("cartItems", cartItems);
        request.getRequestDispatcher("/view/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
