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
 * 管理员订单详情查看Servlet
 */
@WebServlet("/AdminOrderDetailServlet")
public class AdminOrderDetailServlet extends HttpServlet {

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

        // 检查管理员权限
        HttpSession session = request.getSession();
        Integer userRole = (Integer) session.getAttribute("role");

        if (userRole == null || userRole != 3) {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp?error=access_denied");
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

            // 转发到管理员订单详情页面
            request.getRequestDispatcher("/view/admin-order-detail.jsp").forward(request, response);

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