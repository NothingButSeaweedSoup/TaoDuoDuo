package com.TaoDuoDuo.servlet;

import com.TaoDuoDuo.dao.OrderDao;
import com.TaoDuoDuo.dao.ProductDao;
import com.TaoDuoDuo.dao.ShopDao;
import com.TaoDuoDuo.dao.UserDao;
import com.TaoDuoDuo.entity.Order;
import com.TaoDuoDuo.entity.Product;
import com.TaoDuoDuo.entity.Shop;
import com.TaoDuoDuo.entity.User;

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
 * 管理员控制台Servlet
 * 提供管理员的统一管理界面，包括商铺、商品、订单的管理
 */
@WebServlet("/AdminDashboardServlet")
public class AdminDashboardServlet extends HttpServlet {

    private ShopDao shopDao;
    private ProductDao productDao;
    private OrderDao orderDao;
    private UserDao userDao;

    @Override
    public void init() throws ServletException {
        shopDao = new ShopDao();
        productDao = new ProductDao();
        orderDao = new OrderDao();
        userDao = new UserDao();
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

        String action = request.getParameter("action");

        if ("shops".equals(action)) {
            handleShopsManagement(request, response);
        } else if ("products".equals(action)) {
            handleProductsManagement(request, response);
        } else if ("orders".equals(action)) {
            handleOrdersManagement(request, response);
        } else if ("users".equals(action)) {
            handleUsersManagement(request, response);
        } else {
            handleDashboard(request, response);
        }
    }

    /**
     * 处理管理员主控制台
     */
    private void handleDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 获取统计数据
            Optional<List<Shop>> allShopsOpt = shopDao.getAllShops();
            Optional<List<Product>> allProductsOpt = productDao.getAllProducts();
            Optional<List<User>> allUsersOpt = userDao.getAllUsers();

            int totalShops = allShopsOpt.map(List::size).orElse(0);
            int totalProducts = allProductsOpt.map(List::size).orElse(0);
            int totalUsers = allUsersOpt.map(List::size).orElse(0);

            // 获取最近的订单
            Optional<List<Order>> recentOrdersOpt = orderDao.getRecentOrders(10);

            // 设置请求属性
            request.setAttribute("totalShops", totalShops);
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("recentOrders", recentOrdersOpt.orElse(List.of()));

            // 转发到管理员控制台页面
            request.getRequestDispatcher("/view/admin-dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "获取统计数据失败");
        }
    }

    /**
     * 处理商铺管理
     */
    private void handleShopsManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Optional<List<Shop>> allShopsOpt = shopDao.getAllShops();
            request.setAttribute("shops", allShopsOpt.orElse(List.of()));
            request.getRequestDispatcher("/view/admin-shops.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "获取商铺数据失败");
        }
    }

    /**
     * 处理商品管理
     */
    private void handleProductsManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Optional<List<Product>> allProductsOpt = productDao.getAllProducts();
            request.setAttribute("products", allProductsOpt.orElse(List.of()));
            request.getRequestDispatcher("/view/admin-products.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "获取商品数据失败");
        }
    }

    /**
     * 处理订单管理
     */
    private void handleOrdersManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Optional<List<Order>> allOrdersOpt = orderDao.getAllOrders();
            request.setAttribute("orders", allOrdersOpt.orElse(List.of()));
            request.getRequestDispatcher("/view/admin-orders.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "获取订单数据失败");
        }
    }

    /**
     * 处理用户管理
     */
    private void handleUsersManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Optional<List<User>> allUsersOpt = userDao.getAllUsers();
            request.setAttribute("users", allUsersOpt.orElse(List.of()));
            request.getRequestDispatcher("/view/admin-users.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "获取用户数据失败");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}