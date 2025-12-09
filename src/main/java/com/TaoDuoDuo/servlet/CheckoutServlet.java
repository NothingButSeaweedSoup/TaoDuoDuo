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
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "CheckoutServlet", value = "/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {
    private CartService cartService;

    @Override
    public void init() throws ServletException {
        cartService = new CartService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp?error=required");
            return;
        }

        String[] selectedCartIds = request.getParameterValues("selectedCartIds");

        if (selectedCartIds == null || selectedCartIds.length == 0) {
            response.sendRedirect(request.getContextPath() + "/CartServlet?error=noSelection");
            return;
        }

        List<CartItem> allCartItems = cartService.getUserCartItems(userId);
        List<CartItem> selectedItems = new ArrayList<>();
        double totalAmount = 0.0;
        StringBuilder productNames = new StringBuilder();

        for (String cartIdStr : selectedCartIds) {
            try {
                int cartId = Integer.parseInt(cartIdStr);
                for (CartItem item : allCartItems) {
                    if (item.getCart().getCart_id() == cartId) {
                        selectedItems.add(item);
                        totalAmount += item.getSubtotal();
                        if (productNames.length() > 0) {
                            productNames.append("、");
                        }
                        productNames.append(item.getProduct().getProduct_name());
                        break;
                    }
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        if (selectedItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/CartServlet?error=noSelection");
            return;
        }

        // TODO: 为每个商品创建单独的订单
        // 这里暂时只处理支付宝支付的总订单

        session.setAttribute("checkoutItems", selectedItems);
        session.setAttribute("checkoutTotal", totalAmount);
        session.setAttribute("selectedCartIds", selectedCartIds);

        // 生成订单号
        String outTradeNo = "ORDER_" + System.currentTimeMillis() + "_" + userId;

        // 商品名称（最多显示前3个商品）
        String subject = productNames.toString();
        if (subject.length() > 50) {
            subject = subject.substring(0, 47) + "...";
        }

        // 创建支付表单并直接输出
        PrintWriter out = response.getWriter();
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head><meta charset='UTF-8'><title>正在跳转到支付页面...</title></head>");
        out.println("<body>");
        out.println("<h3 style='text-align:center; margin-top:100px;'>正在跳转到支付宝支付页面...</h3>");
        out.println("<form id='payForm' method='post' action='" + request.getContextPath() + "/pay'>");
        out.println("<input type='hidden' name='outTradeNo' value='" + outTradeNo + "'>");
        out.println("<input type='hidden' name='totalAmount' value='" + String.format("%.2f", totalAmount) + "'>");
        out.println("<input type='hidden' name='subject' value='" + subject + "'>");
        out.println("</form>");
        out.println("<script>document.getElementById('payForm').submit();</script>");
        out.println("</body>");
        out.println("</html>");
    }
}
