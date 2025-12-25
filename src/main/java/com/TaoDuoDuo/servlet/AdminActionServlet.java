package com.TaoDuoDuo.servlet;

import com.TaoDuoDuo.dao.ProductDao;
import com.TaoDuoDuo.dao.ShopDao;
import com.TaoDuoDuo.dao.UserDao;
import com.TaoDuoDuo.entity.Shop;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * 管理员操作Servlet
 * 处理管理员的各种操作，如删除、更新等
 */
@WebServlet("/AdminActionServlet")
public class AdminActionServlet extends HttpServlet {

    private ShopDao shopDao;
    private ProductDao productDao;
    private UserDao userDao;

    @Override
    public void init() throws ServletException {
        shopDao = new ShopDao();
        productDao = new ProductDao();
        userDao = new UserDao();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 检查管理员权限
        HttpSession session = request.getSession();
        Integer userRole = (Integer) session.getAttribute("role");

        if (userRole == null || userRole != 3) {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp?error=access_denied");
            return;
        }

        String action = request.getParameter("action");
        String type = request.getParameter("type");

        try {
            if ("delete".equals(action)) {
                handleDelete(request, response, type);
            } else if ("update".equals(action)) {
                handleUpdate(request, response, type);
            } else if ("toggle".equals(action)) {
                handleToggle(request, response, type);
            } else {
                response.sendRedirect(request.getContextPath() + "/AdminDashboardServlet");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/AdminDashboardServlet?error=operation_failed");
        }
    }

    /**
     * 处理删除操作
     */
    private void handleDelete(HttpServletRequest request, HttpServletResponse response, String type)
            throws IOException {

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/AdminDashboardServlet?error=invalid_id");
            return;
        }

        int id = Integer.parseInt(idStr);
        boolean success = false;
        String redirectUrl = "";

        switch (type) {
            case "shop":
                success = shopDao.adminDeleteShop(id);
                redirectUrl = "/AdminDashboardServlet?action=shops";
                break;
            case "product":
                success = productDao.adminDeleteProduct(id);
                redirectUrl = "/AdminDashboardServlet?action=products";
                break;
            case "user":
                success = userDao.adminDeleteUser(id);
                redirectUrl = "/AdminDashboardServlet?action=users";
                break;
            default:
                redirectUrl = "/AdminDashboardServlet";
        }

        if (success) {
            response.sendRedirect(request.getContextPath() + redirectUrl + "&success=delete_success");
        } else {
            response.sendRedirect(request.getContextPath() + redirectUrl + "&error=delete_failed");
        }
    }

    /**
     * 处理更新操作
     */
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, String type)
            throws IOException {

        boolean success = false;
        String redirectUrl = "";

        switch (type) {
            case "shop":
                success = handleShopUpdate(request);
                redirectUrl = "/AdminDashboardServlet?action=shops";
                break;
            default:
                redirectUrl = "/AdminDashboardServlet";
        }

        if (success) {
            response.sendRedirect(request.getContextPath() + redirectUrl + "&success=update_success");
        } else {
            response.sendRedirect(request.getContextPath() + redirectUrl + "&error=update_failed");
        }
    }

    /**
     * 处理切换操作（如上架/下架）
     */
    private void handleToggle(HttpServletRequest request, HttpServletResponse response, String type)
            throws IOException {

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/AdminDashboardServlet?error=invalid_id");
            return;
        }

        int id = Integer.parseInt(idStr);
        boolean success = false;
        String redirectUrl = "";

        switch (type) {
            case "product":
                String listingStr = request.getParameter("listing");
                boolean listing = "true".equals(listingStr);
                success = productDao.adminUpdateProductListing(id, listing);
                redirectUrl = "/AdminDashboardServlet?action=products";
                break;
            default:
                redirectUrl = "/AdminDashboardServlet";
        }

        if (success) {
            response.sendRedirect(request.getContextPath() + redirectUrl + "&success=toggle_success");
        } else {
            response.sendRedirect(request.getContextPath() + redirectUrl + "&error=toggle_failed");
        }
    }

    /**
     * 处理商铺更新
     */
    private boolean handleShopUpdate(HttpServletRequest request) {
        try {
            String idStr = request.getParameter("id");
            String shopName = request.getParameter("shopName");

            if (idStr == null || shopName == null || shopName.trim().isEmpty()) {
                return false;
            }

            int shopId = Integer.parseInt(idStr);
            Shop shop = new Shop();
            shop.setShop_id(shopId);
            shop.setShop_name(shopName.trim());

            return shopDao.adminUpdateShop(shop);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}