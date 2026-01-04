package com.TaoDuoDuo.servlet;

import com.TaoDuoDuo.dao.ShopDao;
import com.TaoDuoDuo.dao.ProductDao;
import com.TaoDuoDuo.dao.OrderDao;
import com.TaoDuoDuo.dao.UserDao;
import com.TaoDuoDuo.entity.Shop;
import com.TaoDuoDuo.entity.Product;
import com.TaoDuoDuo.entity.Order;
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
 * 管理员商铺详情查看Servlet
 */
@WebServlet("/AdminShopDetailServlet")
public class AdminShopDetailServlet extends HttpServlet {

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

        String shopIdStr = request.getParameter("shopId");
        if (shopIdStr == null || shopIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "商铺ID不能为空");
            return;
        }

        try {
            int shopId = Integer.parseInt(shopIdStr);

            // 获取商铺信息
            Optional<Shop> shopOpt = shopDao.getShopById(shopId);
            if (!shopOpt.isPresent()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "商铺不存在");
                return;
            }

            Shop shop = shopOpt.get();

            // 获取店主信息
            Optional<User> ownerOpt = userDao.getUserById(shop.getOwner_id());
            User owner = ownerOpt.orElse(null);

            // 获取商铺的商品
            Optional<List<Product>> shopProductsOpt = productDao.getProductsByShopId(shopId);
            List<Product> shopProducts = shopProductsOpt.orElse(List.of());

            // 获取商铺的订单
            Optional<List<Order>> shopOrdersOpt = orderDao.getOrderByShopId(shopId);
            List<Order> shopOrders = shopOrdersOpt.orElse(List.of());

            // 计算统计信息
            long listedProducts = shopProducts.stream()
                    .filter(Product::isProduct_listing)
                    .count();

            long unlistedProducts = shopProducts.size() - listedProducts;

            double totalRevenue = shopOrders.stream()
                    .filter(order -> "completed".equals(order.getOrder_status()))
                    .mapToDouble(Order::getTotal_amount)
                    .sum();

            long completedOrders = shopOrders.stream()
                    .filter(order -> "completed".equals(order.getOrder_status()))
                    .count();

            // 设置请求属性
            request.setAttribute("shop", shop);
            request.setAttribute("owner", owner);
            request.setAttribute("shopProducts", shopProducts);
            request.setAttribute("shopOrders", shopOrders);
            request.setAttribute("listedProducts", listedProducts);
            request.setAttribute("unlistedProducts", unlistedProducts);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("completedOrders", completedOrders);

            // 转发到商铺详情页面
            request.getRequestDispatcher("/view/admin-shop-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "商铺ID格式错误");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "获取商铺详情失败");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}