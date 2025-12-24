package com.TaoDuoDuo.servlet;

import com.TaoDuoDuo.entity.Shop;
import com.TaoDuoDuo.service.ShopService;
import com.TaoDuoDuo.service.UserRoleService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * 商铺管理Servlet
 */
@WebServlet("/ShopManagementServlet")
public class ShopManagementServlet extends HttpServlet {
    private ShopService shopService;
    private UserRoleService userRoleService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.shopService = new ShopService();
        this.userRoleService = new UserRoleService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        Integer userRole = (Integer) session.getAttribute("role");
        
        // 检查用户是否已登录
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp?error=required");
            return;
        }
        
        // 检查用户是否是商家
        if (userRole == null || userRole != 2) {
            request.setAttribute("error", "您不是商家，无法访问商铺管理");
            request.getRequestDispatcher("/ProfileServlet").forward(request, response);
            return;
        }
        
        try {
            // 获取用户的所有店铺
            List<Shop> userShops = shopService.getShopsByUserId(userId);
            
            // 设置request属性
            request.setAttribute("userShops", userShops);
            request.setAttribute("hasShops", userShops != null && !userShops.isEmpty());
            
            // 处理消息参数
            String success = request.getParameter("success");
            String error = request.getParameter("error");
            request.setAttribute("success", success);
            request.setAttribute("error", error);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "获取店铺信息失败");
        }
        
        // 转发到商铺管理页面
        request.getRequestDispatcher("/view/shop-management.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        Integer userRole = (Integer) session.getAttribute("role");
        
        // 检查用户是否已登录且是商家
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp?error=required");
            return;
        }
        
        if (userRole == null || userRole != 2) {
            response.sendRedirect(request.getContextPath() + "/ShopManagementServlet?error=no_permission");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("update".equals(action)) {
            handleUpdateShop(request, response, userId);
        } else {
            response.sendRedirect(request.getContextPath() + "/ShopManagementServlet?error=invalid_action");
        }
    }
    
    /**
     * 处理店铺信息更新
     */
    private void handleUpdateShop(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        
        String shopIdStr = request.getParameter("shopId");
        String newShopName = request.getParameter("shopName");
        
        // 验证参数
        if (shopIdStr == null || newShopName == null || newShopName.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/ShopManagementServlet?error=invalid_params");
            return;
        }
        
        try {
            int shopId = Integer.parseInt(shopIdStr);
            newShopName = newShopName.trim();
            
            // 验证店铺名称长度
            if (newShopName.length() < 2 || newShopName.length() > 50) {
                response.sendRedirect(request.getContextPath() + "/ShopManagementServlet?error=name_length");
                return;
            }
            
            // 获取店铺信息，验证所有权
            Shop shop = shopService.getShopById(shopId);
            if (shop == null) {
                response.sendRedirect(request.getContextPath() + "/ShopManagementServlet?error=shop_not_found");
                return;
            }
            
            if (shop.getOwner_id() != userId) {
                response.sendRedirect(request.getContextPath() + "/ShopManagementServlet?error=no_permission");
                return;
            }
            
            // 更新店铺名称
            shop.setShop_name(newShopName);
            boolean success = shopService.updateShop(shop);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/ShopManagementServlet?success=shop_updated&shopName=" + 
                                    java.net.URLEncoder.encode(newShopName, "UTF-8"));
            } else {
                response.sendRedirect(request.getContextPath() + "/ShopManagementServlet?error=name_exists");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ShopManagementServlet?error=invalid_shop_id");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/ShopManagementServlet?error=system_error");
        }
    }
}