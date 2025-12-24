package com.TaoDuoDuo.servlet;

import com.TaoDuoDuo.entity.Product;
import com.TaoDuoDuo.entity.Shop;
import com.TaoDuoDuo.service.ProductService;
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
 * 商铺详细管理Servlet
 */
@WebServlet("/ShopDetailServlet")
public class ShopDetailServlet extends HttpServlet {
    private ShopService shopService;
    private ProductService productService;
    private UserRoleService userRoleService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.shopService = new ShopService();
        this.productService = new ProductService();
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
        
        // 检查用户是否已登录且是商家
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp?error=required");
            return;
        }
        
        if (userRole == null || userRole != 2) {
            request.setAttribute("error", "您不是商家，无法访问商铺管理");
            request.getRequestDispatcher("/ShopManagementServlet").forward(request, response);
            return;
        }
        
        String shopIdStr = request.getParameter("shopId");
        String searchKeyword = request.getParameter("search");
        
        if (shopIdStr == null || shopIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/ShopManagementServlet?error=invalid_shop_id");
            return;
        }
        
        try {
            int shopId = Integer.parseInt(shopIdStr);
            
            // 获取店铺信息并验证所有权
            Shop shop = shopService.getShopById(shopId);
            if (shop == null) {
                response.sendRedirect(request.getContextPath() + "/ShopManagementServlet?error=shop_not_found");
                return;
            }
            
            if (shop.getOwner_id() != userId) {
                response.sendRedirect(request.getContextPath() + "/ShopManagementServlet?error=no_permission");
                return;
            }
            
            // 获取商品列表
            List<Product> products;
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                products = productService.searchProductsByShopIdAndName(shopId, searchKeyword.trim());
                request.setAttribute("searchKeyword", searchKeyword.trim());
            } else {
                products = productService.getProductsByShopId(shopId);
            }
            
            // 设置request属性
            request.setAttribute("shop", shop);
            request.setAttribute("products", products);
            request.setAttribute("hasProducts", products != null && !products.isEmpty());
            
            // 处理消息参数
            String success = request.getParameter("success");
            String error = request.getParameter("error");
            String productName = request.getParameter("productName");
            String shopName = request.getParameter("shopName");
            
            request.setAttribute("success", success);
            request.setAttribute("error", error);
            request.setAttribute("productName", productName);
            request.setAttribute("shopName", shopName);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ShopManagementServlet?error=invalid_shop_id");
            return;
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "获取店铺信息失败");
        }
        
        // 转发到商铺详细管理页面
        request.getRequestDispatcher("/view/shop-detail.jsp").forward(request, response);
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
        String shopIdStr = request.getParameter("shopId");
        
        if (shopIdStr == null || shopIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/ShopManagementServlet?error=invalid_shop_id");
            return;
        }
        
        try {
            int shopId = Integer.parseInt(shopIdStr);
            
            // 验证店铺所有权
            Shop shop = shopService.getShopById(shopId);
            if (shop == null || shop.getOwner_id() != userId) {
                response.sendRedirect(request.getContextPath() + "/ShopManagementServlet?error=no_permission");
                return;
            }
            
            if ("addProduct".equals(action)) {
                handleAddProduct(request, response, shopId);
            } else if ("updateShop".equals(action)) {
                handleUpdateShop(request, response, shopId);
            } else if ("updateProduct".equals(action)) {
                handleUpdateProduct(request, response, shopId);
            } else if ("deleteProduct".equals(action)) {
                handleDeleteProduct(request, response, shopId);
            } else if ("toggleListing".equals(action)) {
                handleToggleListing(request, response, shopId);
            } else {
                response.sendRedirect(request.getContextPath() + "/ShopDetailServlet?shopId=" + shopId + "&error=invalid_action");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ShopManagementServlet?error=invalid_shop_id");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/ShopDetailServlet?shopId=" + shopIdStr + "&error=system_error");
        }
    }
    
    /**
     * 处理添加商品
     */
    private void handleAddProduct(HttpServletRequest request, HttpServletResponse response, int shopId) 
            throws IOException {
        
        String productName = request.getParameter("productName");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String stockStr = request.getParameter("stock");
        
        // 验证参数
        if (productName == null || productName.trim().isEmpty() ||
            description == null || description.trim().isEmpty() ||
            priceStr == null || priceStr.trim().isEmpty() ||
            stockStr == null || stockStr.trim().isEmpty()) {
            
            response.sendRedirect(request.getContextPath() + "/ShopDetailServlet?shopId=" + shopId + "&error=invalid_params");
            return;
        }
        
        try {
            double price = Double.parseDouble(priceStr);
            int stock = Integer.parseInt(stockStr);
            
            if (price < 0 || stock < 0) {
                response.sendRedirect(request.getContextPath() + "/ShopDetailServlet?shopId=" + shopId + "&error=invalid_values");
                return;
            }
            
            // 创建商品（默认分类ID为3，可以后续扩展）
            Product product = new Product(productName.trim(), description.trim(), price, stock, 3, shopId);
            boolean success = productService.addProduct(product);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/ShopDetailServlet?shopId=" + shopId + 
                                    "&success=product_added&productName=" + 
                                    java.net.URLEncoder.encode(productName.trim(), "UTF-8"));
            } else {
                response.sendRedirect(request.getContextPath() + "/ShopDetailServlet?shopId=" + shopId + "&error=add_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ShopDetailServlet?shopId=" + shopId + "&error=invalid_numbers");
        }
    }
    
    /**
     * 处理更新店铺信息
     */
    private void handleUpdateShop(HttpServletRequest request, HttpServletResponse response, int shopId) 
            throws IOException {
        
        String newShopName = request.getParameter("shopName");
        
        if (newShopName == null || newShopName.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/ShopDetailServlet?shopId=" + shopId + "&error=invalid_params");
            return;
        }
        
        newShopName = newShopName.trim();
        
        if (newShopName.length() < 2 || newShopName.length() > 50) {
            response.sendRedirect(request.getContextPath() + "/ShopDetailServlet?shopId=" + shopId + "&error=name_length");
            return;
        }
        
        Shop shop = shopService.getShopById(shopId);
        shop.setShop_name(newShopName);
        boolean success = shopService.updateShop(shop);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/ShopDetailServlet?shopId=" + shopId + 
                                "&success=shop_updated&shopName=" + 
                                java.net.URLEncoder.encode(newShopName, "UTF-8"));
        } else {
            response.sendRedirect(request.getContextPath() + "/ShopDetailServlet?shopId=" + shopId + "&error=name_exists");
        }
    }
    
    /**
     * 处理更新商品信息
     */
    private void handleUpdateProduct(HttpServletRequest request, HttpServletResponse response, int shopId) 
            throws IOException {
        
        String productIdStr = request.getParameter("productId");
        String productName = request.getParameter("productName");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String stockStr = request.getParameter("stock");
        
        if (productIdStr == null || productName == null || productName.trim().isEmpty() ||
            description == null || description.trim().isEmpty() ||
            priceStr == null || priceStr.trim().isEmpty() ||
            stockStr == null || stockStr.trim().isEmpty()) {
            
            response.sendRedirect(request.getContextPath() + "/ShopDetailServlet?shopId=" + shopId + "&error=invalid_params");
            return;
        }
        
        try {
            int productId = Integer.parseInt(productIdStr);
            double price = Double.parseDouble(priceStr);
            int stock = Integer.parseInt(stockStr);
            
            if (price < 0 || stock < 0) {
                response.sendRedirect(request.getContextPath() + "/ShopDetailServlet?shopId=" + shopId + "&error=invalid_values");
                return;
            }
            
            Product product = productService.getProductById(productId);
            if (product == null || product.getShop_id() != shopId) {
                response.sendRedirect(request.getContextPath() + "/ShopDetailServlet?shopId=" + shopId + "&error=product_not_found");
                return;
            }
            
            product.setProduct_name(productName.trim());
            product.setDescription(description.trim());
            product.setPrice(price);
            product.setStock(stock);
            
            boolean success = productService.updateProduct(product);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/ShopDetailServlet?shopId=" + shopId + 
                                    "&success=product_updated&productName=" + 
                                    java.net.URLEncoder.encode(productName.trim(), "UTF-8"));
            } else {
                response.sendRedirect(request.getContextPath() + "/ShopDetailServlet?shopId=" + shopId + "&error=update_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ShopDetailServlet?shopId=" + shopId + "&error=invalid_numbers");
        }
    }
    
    /**
     * 处理删除商品
     */
    private void handleDeleteProduct(HttpServletRequest request, HttpServletResponse response, int shopId) 
            throws IOException {
        
        String productIdStr = request.getParameter("productId");
        
        if (productIdStr == null || productIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/ShopDetailServlet?shopId=" + shopId + "&error=invalid_params");
            return;
        }
        
        try {
            int productId = Integer.parseInt(productIdStr);
            
            Product product = productService.getProductById(productId);
            if (product == null || product.getShop_id() != shopId) {
                response.sendRedirect(request.getContextPath() + "/ShopDetailServlet?shopId=" + shopId + "&error=product_not_found");
                return;
            }
            
            boolean success = productService.deleteProduct(productId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/ShopDetailServlet?shopId=" + shopId + "&success=product_deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/ShopDetailServlet?shopId=" + shopId + "&error=delete_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ShopDetailServlet?shopId=" + shopId + "&error=invalid_product_id");
        }
    }
    
    /**
     * 处理切换商品上架状态
     */
    private void handleToggleListing(HttpServletRequest request, HttpServletResponse response, int shopId) 
            throws IOException {
        
        String productIdStr = request.getParameter("productId");
        String listingStr = request.getParameter("listing");
        
        if (productIdStr == null || productIdStr.trim().isEmpty() || listingStr == null) {
            response.sendRedirect(request.getContextPath() + "/ShopDetailServlet?shopId=" + shopId + "&error=invalid_params");
            return;
        }
        
        try {
            int productId = Integer.parseInt(productIdStr);
            boolean listing = Boolean.parseBoolean(listingStr);
            
            Product product = productService.getProductById(productId);
            if (product == null || product.getShop_id() != shopId) {
                response.sendRedirect(request.getContextPath() + "/ShopDetailServlet?shopId=" + shopId + "&error=product_not_found");
                return;
            }
            
            boolean success = productService.updateProductListing(productId, listing);
            
            if (success) {
                String action = listing ? "上架" : "下架";
                response.sendRedirect(request.getContextPath() + "/ShopDetailServlet?shopId=" + shopId + 
                                    "&success=listing_updated&productName=" + 
                                    java.net.URLEncoder.encode(product.getProduct_name() + " " + action + "成功", "UTF-8"));
            } else {
                response.sendRedirect(request.getContextPath() + "/ShopDetailServlet?shopId=" + shopId + "&error=listing_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ShopDetailServlet?shopId=" + shopId + "&error=invalid_product_id");
        }
    }
}