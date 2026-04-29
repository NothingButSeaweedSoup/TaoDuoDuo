package com.TaoDuoDuo.servlet;

import com.TaoDuoDuo.dao.CartDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * 清理购物车Servlet - 支付成功后删除已购买的商品
 */
@WebServlet("/ClearCartServlet")
public class ClearCartServlet extends HttpServlet {
    private CartDao cartDao;

    @Override
    public void init() throws ServletException {
        cartDao = new CartDao();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String[] selectedCartIds = (String[]) session.getAttribute("selectedCartIds");

        if (selectedCartIds != null && selectedCartIds.length > 0) {
            for (String cartIdStr : selectedCartIds) {
                try {
                    int cartId = Integer.parseInt(cartIdStr);
                    cartDao.deleteCart(cartId);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
            // 清理session中的购物车相关数据
            session.removeAttribute("selectedCartIds");
            session.removeAttribute("checkoutItems");
            session.removeAttribute("checkoutTotal");
        }

        response.setContentType("text/plain;charset=UTF-8");
        response.getWriter().write("success");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
