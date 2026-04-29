package com.TaoDuoDuo.servlet;

import com.TaoDuoDuo.dao.UserDao;
import com.TaoDuoDuo.dao.OrderDao;
import com.TaoDuoDuo.dao.ShopDao;
import com.TaoDuoDuo.entity.User;
import com.TaoDuoDuo.entity.Order;
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
 * 管理员用户详情查看Servlet
 */
@WebServlet("/AdminUserDetailServlet")
public class AdminUserDetailServlet extends HttpServlet {

    private UserDao userDao;
    private OrderDao orderDao;
    private ShopDao shopDao;

    @Override
    public void init() throws ServletException {
        userDao = new UserDao();
        orderDao = new OrderDao();
        shopDao = new ShopDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 检查管理员权限
        HttpSession session = request.getSession();
        Integer userRole = (Integer) session.getAttribute("role");

        if (userRole == null || userRole != 3) {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp?error=access_denied");
            return;
        }

        String userIdStr = request.getParameter("userId");
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "用户ID不能为空");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdStr);

            // 获取用户信息
            Optional<User> userOpt = userDao.getUserById(userId);
            if (!userOpt.isPresent()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "用户不存在");
                return;
            }

            User user = userOpt.get();

            // 获取用户的订单
            Optional<List<Order>> userOrdersOpt = orderDao.getOrderByUserId(userId);
            List<Order> userOrders = userOrdersOpt.orElse(List.of());

            // 获取用户的商铺
            Optional<List<Shop>> userShopsOpt = shopDao.getShopByOwnerId(userId);
            List<Shop> userShops = userShopsOpt.orElse(List.of());

            // 计算统计信息
            double totalSpent = userOrders.stream()
                    .filter(order -> "completed".equals(order.getOrder_status()))
                    .mapToDouble(Order::getTotal_amount)
                    .sum();

            long completedOrders = userOrders.stream()
                    .filter(order -> "completed".equals(order.getOrder_status()))
                    .count();

            // 设置请求属性
            request.setAttribute("user", user);
            request.setAttribute("userOrders", userOrders);
            request.setAttribute("userShops", userShops);
            request.setAttribute("totalSpent", totalSpent);
            request.setAttribute("completedOrders", completedOrders);

            // 转发到用户详情页面
            request.getRequestDispatcher("/view/admin-user-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "用户ID格式错误");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "获取用户详情失败");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}