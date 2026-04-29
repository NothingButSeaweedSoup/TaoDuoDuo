package com.TaoDuoDuo.servlet;

import com.TaoDuoDuo.dao.CartDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "RemoveFromCartServlet", value = "/RemoveFromCartServlet")
public class RemoveFromCartServlet extends HttpServlet {
    private CartDao cartDao;

    @Override
    public void init() throws ServletException {
        cartDao = new CartDao();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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

        String cartIdStr = request.getParameter("cartId");

        if (cartIdStr != null) {
            try {
                int cartId = Integer.parseInt(cartIdStr);
                cartDao.deleteCart(cartId);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect(request.getContextPath() + "/CartServlet");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
