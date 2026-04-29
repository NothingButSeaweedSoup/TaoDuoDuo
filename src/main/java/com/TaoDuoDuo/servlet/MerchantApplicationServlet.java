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

/**
 * 商家入驻申请处理Servlet
 */
@WebServlet("/MerchantApplicationServlet")
public class MerchantApplicationServlet extends HttpServlet {
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
        // GET请求用于显示商家入驻页面，重定向到个人中心
        response.sendRedirect(request.getContextPath() + "/ProfileServlet");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        // 检查用户是否已登录
        if (userId == null) {
            request.setAttribute("error", "请先登录");
            request.getRequestDispatcher("/view/login.jsp").forward(request, response);
            return;
        }

        String shopName = request.getParameter("shopName");
        
        // 验证店铺名称
        if (shopName == null || shopName.trim().isEmpty()) {
            request.setAttribute("error", "店铺名称不能为空");
            request.getRequestDispatcher("/ProfileServlet").forward(request, response);
            return;
        }

        shopName = shopName.trim();
        
        // 验证店铺名称长度
        if (shopName.length() < 2 || shopName.length() > 50) {
            request.setAttribute("error", "店铺名称长度必须在2-50个字符之间");
            request.getRequestDispatcher("/ProfileServlet").forward(request, response);
            return;
        }

        try {
            // 创建新店铺（允许商家创建多个店铺）
            Shop shop = new Shop(shopName, userId);
            boolean success = shopService.createShop(shop);
            
            if (success) {
                // 店铺创建成功
                request.setAttribute("success", "merchant_application_success");
                request.setAttribute("shopName", shopName);
                
                // 如果用户还不是商家，确保session中的角色信息正确
                if (!userRoleService.hasRole(userId, 2)) {
                    // 手动添加商家角色（防止触发器失败的情况）
                    userRoleService.addUserRole(userId, 2);
                    session.setAttribute("role", 2); // 切换到商家角色
                }
                
            } else {
                request.setAttribute("error", "申请失败，店铺名称可能已被使用，请更换后重试");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "系统错误，请稍后重试");
        }
        
        // 重定向回个人中心页面
        request.getRequestDispatcher("/ProfileServlet").forward(request, response);
    }
}