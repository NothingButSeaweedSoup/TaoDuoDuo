package com.TaoDuoDuo.servlet;

import com.TaoDuoDuo.entity.CartItem;
import com.TaoDuoDuo.entity.Order;
import com.TaoDuoDuo.service.CartService;
import com.TaoDuoDuo.service.OrderManagementService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CheckoutServlet", value = "/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {
    private CartService cartService;
    private OrderManagementService orderService;

    @Override
    public void init() throws ServletException {
        cartService = new CartService();
        orderService = new OrderManagementService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        Integer userRole = (Integer) session.getAttribute("role");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp?error=required");
            return;
        }

        // 检查用户角色，只有用户身份才能使用购物车结算
        if (userRole == null || userRole != 1) {
            response.sendRedirect(request.getContextPath() + "/view/error.jsp?error=" +
                    java.net.URLEncoder.encode("只有用户身份才能使用购物车功能", "UTF-8"));
            return;
        }

        String[] selectedCartIds = request.getParameterValues("selectedCartIds");

        if (selectedCartIds == null || selectedCartIds.length == 0) {
            response.sendRedirect(request.getContextPath() + "/CartServlet?error=noSelection");
            return;
        }

        List<CartItem> allCartItems = cartService.getUserCartItems(userId);
        Map<Integer, List<CartItem>> itemsByShop = new HashMap<>();
        List<String> unavailableProducts = new ArrayList<>();

        // 按店铺分组商品
        for (String cartIdStr : selectedCartIds) {
            try {
                int cartId = Integer.parseInt(cartIdStr);
                for (CartItem item : allCartItems) {
                    if (item.getCart().getCart_id() == cartId) {
                        // 检查商品是否上架
                        if (!item.getProduct().isProduct_listing()) {
                            unavailableProducts.add(item.getProduct().getProduct_name() + "（已下架）");
                            continue;
                        }

                        // 检查库存
                        if (item.getProduct().getStock() < item.getCart().getQuantity()) {
                            unavailableProducts.add(item.getProduct().getProduct_name() + "（库存不足）");
                            continue;
                        }

                        // 按店铺分组
                        int shopId = item.getProduct().getShop_id();
                        itemsByShop.computeIfAbsent(shopId, k -> new ArrayList<>()).add(item);
                        break;
                    }
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // 如果有不可购买的商品，返回错误信息
        if (!unavailableProducts.isEmpty()) {
            String errorMsg = "以下商品无法购买：" + String.join("、", unavailableProducts);
            response.sendRedirect(request.getContextPath() + "/CartServlet?error=" +
                    java.net.URLEncoder.encode(errorMsg, "UTF-8"));
            return;
        }

        if (itemsByShop.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/CartServlet?error=noSelection");
            return;
        }

        try {
            // 为每个店铺创建单独的订单
            List<Order> createdOrders = new ArrayList<>();
            
            for (Map.Entry<Integer, List<CartItem>> entry : itemsByShop.entrySet()) {
                int shopId = entry.getKey();
                List<CartItem> shopItems = entry.getValue();
                
                // 为每个店铺创建订单
                Order order = orderService.createOrderFromCart(userId, shopId, shopItems);
                if (order == null) {
                    throw new RuntimeException("创建店铺 " + shopId + " 的订单失败");
                }
                createdOrders.add(order);
            }
            
            // 清空购物车中已结算的商品
            for (String cartIdStr : selectedCartIds) {
                try {
                    int cartId = Integer.parseInt(cartIdStr);
                    cartService.removeFromCart(cartId);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
            
            // 存储订单信息到session
            if (createdOrders.size() == 1) {
                // 如果只有一个订单，保持原有逻辑
                session.setAttribute("createdOrder", createdOrders.get(0));
            } else {
                // 如果有多个订单，存储订单列表
                session.setAttribute("createdOrders", createdOrders);
            }
            
            // 跳转到订单确认页面
            response.sendRedirect(request.getContextPath() + "/view/order-create-confirmation.jsp");
            
        } catch (Exception e) {
            e.printStackTrace();
            String errorMsg = "创建订单失败：" + e.getMessage();
            response.sendRedirect(request.getContextPath() + "/CartServlet?error=" +
                    java.net.URLEncoder.encode(errorMsg, "UTF-8"));
        }
    }
}
