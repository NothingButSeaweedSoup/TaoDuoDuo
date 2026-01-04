package com.TaoDuoDuo.servlet;

import com.TaoDuoDuo.dao.OrderDao;
import com.TaoDuoDuo.dao.OrderDetailDao;
import com.TaoDuoDuo.dao.UserDao;
import com.TaoDuoDuo.dao.ShopDao;
import com.TaoDuoDuo.entity.Order;
import com.TaoDuoDuo.entity.OrderDetail;
import com.TaoDuoDuo.entity.User;
import com.TaoDuoDuo.entity.Shop;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

/**
 * 订单详情Servlet
 * 提供订单详细信息查看功能
 */
@WebServlet("/OrderDetailServlet")
public class OrderDetailServlet extends HttpServlet {

    private OrderDao orderDao;
    private OrderDetailDao orderDetailDao;
    private UserDao userDao;
    private ShopDao shopDao;

    @Override
    public void init() throws ServletException {
        orderDao = new OrderDao();
        orderDetailDao = new OrderDetailDao();
        userDao = new UserDao();
        shopDao = new ShopDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 检查用户登录状态
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");
        Integer userRole = (Integer) session.getAttribute("role");

        if (userId == null || userRole == null) {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp?error=not_logged_in");
            return;
        }

        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "订单ID不能为空");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);

            // 获取订单信息
            Optional<Order> orderOpt = orderDao.getOrderById(orderId);
            if (!orderOpt.isPresent()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "订单不存在");
                return;
            }

            Order order = orderOpt.get();

            // 权限检查：普通用户只能查看自己的订单，管理员和商家可以查看相关订单
            if (userRole != 3) { // 不是管理员
                if (userRole == 1 && order.getUser_id() != userId) {
                    // 普通用户只能查看自己的订单
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "无权查看此订单");
                    return;
                } else if (userRole == 2) {
                    // 商家只能查看自己店铺的订单
                    Optional<List<Shop>> userShopsOpt = shopDao.getShopByOwnerId(userId);
                    boolean hasPermission = false;
                    if (userShopsOpt.isPresent()) {
                        for (Shop shop : userShopsOpt.get()) {
                            if (shop.getShop_id() == order.getShop_id()) {
                                hasPermission = true;
                                break;
                            }
                        }
                    }
                    if (!hasPermission) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN, "无权查看此订单");
                        return;
                    }
                }
            }

            // 获取订单详情
            Optional<List<OrderDetail>> orderDetailsOpt = orderDetailDao.getOrderDetailsByOrderId(orderId);
            List<OrderDetail> orderDetails = orderDetailsOpt.orElse(List.of());

            // 获取用户信息
            Optional<User> userOpt = userDao.getUserById(order.getUser_id());
            User orderUser = userOpt.orElse(null);

            // 获取商铺信息
            Optional<Shop> shopOpt = shopDao.getShopById(order.getShop_id());
            Shop shop = shopOpt.orElse(null);

            // 设置请求属性
            request.setAttribute("order", order);
            request.setAttribute("orderDetails", orderDetails);
            request.setAttribute("orderUser", orderUser);
            request.setAttribute("shop", shop);
            request.setAttribute("currentUserId", userId);
            request.setAttribute("currentUserRole", userRole);

            // 转发到订单详情页面
            request.getRequestDispatcher("/view/order-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "订单ID格式错误");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "获取订单详情失败");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}