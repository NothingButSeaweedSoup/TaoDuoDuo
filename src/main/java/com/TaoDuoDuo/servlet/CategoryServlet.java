package com.TaoDuoDuo.servlet;

import com.TaoDuoDuo.entity.Category;
import com.TaoDuoDuo.service.CategoryService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * 分类商品展示Servlet
 * 处理分类页面的商品展示，支持分类浏览和AJAX分类查询
 * 主要功能：
 * 1. 展示指定分类下的商品列表
 * 2. 提供分类路径（面包屑导航）
 * 3. 显示子分类列表
 * 4. 提供分类统计信息
 * 5. 支持AJAX获取分类列表
 */
@WebServlet("/CategoryServlet")
public class CategoryServlet extends HttpServlet {

    private CategoryService categoryService;

    @Override
    public void init() throws ServletException {
        categoryService = new CategoryService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String categoryIdStr = request.getParameter("id");
        String action = request.getParameter("action");

        // 处理获取分类列表的请求
        if ("getCategories".equals(action)) {
            handleGetCategories(request, response);
            return;
        }

        // 处理分类商品展示
        if (categoryIdStr == null || categoryIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "分类ID不能为空");
            return;
        }

        try {
            int categoryId = Integer.parseInt(categoryIdStr);
            handleCategoryProducts(request, response, categoryId);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "无效的分类ID");
        }
    }

    /**
     * 处理分类商品展示
     */
    private void handleCategoryProducts(HttpServletRequest request, HttpServletResponse response, int categoryId)
            throws ServletException, IOException {

        // 获取分类信息
        Optional<Category> categoryOpt = categoryService.getCategoryById(categoryId);
        if (!categoryOpt.isPresent()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "分类不存在");
            return;
        }

        Category category = categoryOpt.get();

        // 获取分类路径
        List<Category> categoryPath = categoryService.getCategoryPath(categoryId);

        // 获取分类下的商品
        List<Map<String, Object>> products = categoryService.getProductsByCategoryId(categoryId);

        // 获取子分类
        List<Category> subCategories = categoryService.getSubCategories(categoryId);

        // 获取分类统计信息
        CategoryService.CategoryStats stats = categoryService.getCategoryStats(categoryId);

        // 设置请求属性
        request.setAttribute("category", category);
        request.setAttribute("categoryPath", categoryPath);
        request.setAttribute("products", products);
        request.setAttribute("subCategories", subCategories);
        request.setAttribute("productCount", stats.getProductCount());
        request.setAttribute("minPrice", stats.getMinPrice());
        request.setAttribute("maxPrice", stats.getMaxPrice());

        // 转发到分类商品页面
        request.getRequestDispatcher("/category-products.jsp").forward(request, response);
    }

    /**
     * 处理获取分类列表的AJAX请求
     */
    private void handleGetCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String parentIdStr = request.getParameter("parentId");
        int parentId = 0; // 默认获取根分类

        if (parentIdStr != null && !parentIdStr.trim().isEmpty()) {
            try {
                parentId = Integer.parseInt(parentIdStr);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "无效的父分类ID");
                return;
            }
        }

        List<Category> categories;
        if (parentId == 0) {
            categories = categoryService.getRootCategories();
        } else {
            categories = categoryService.getSubCategories(parentId);
        }

        // 设置响应类型为JSON
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        // 构建JSON响应
        StringBuilder json = new StringBuilder();
        json.append("{\"success\": true, \"categories\": [");

        for (int i = 0; i < categories.size(); i++) {
            Category category = categories.get(i);
            if (i > 0) {
                json.append(",");
            }
            json.append("{");
            json.append("\"id\": ").append(category.getCategory_id()).append(",");
            json.append("\"name\": \"").append(escapeJson(category.getCategory_name())).append("\",");
            json.append("\"parentId\": ").append(category.getParent_id());
            json.append("}");
        }

        json.append("]}");

        response.getWriter().write(json.toString());
    }

    /**
     * 转义JSON字符串中的特殊字符
     */
    private String escapeJson(String str) {
        if (str == null) {
            return "";
        }
        return str.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}