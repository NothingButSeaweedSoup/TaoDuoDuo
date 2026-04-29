package com.TaoDuoDuo.servlet;

import com.TaoDuoDuo.dao.ProductDao;
import com.TaoDuoDuo.dao.ProductImageDao;
import com.TaoDuoDuo.dao.ShopDao;
import com.TaoDuoDuo.entity.Product;
import com.TaoDuoDuo.entity.ProductImage;
import com.TaoDuoDuo.entity.Shop;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@WebServlet("/SearchServlet")
public class SearchServlet extends HttpServlet {
    private ProductDao productDao = new ProductDao();
    private ProductImageDao productImageDao = new ProductImageDao();
    private ShopDao shopDao = new ShopDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String searchType = request.getParameter("type");
        String keyword = request.getParameter("keyword");

        // 参数验证
        if (keyword == null || keyword.trim().isEmpty()) {
            request.setAttribute("error", "请输入搜索关键词");
            request.getRequestDispatcher("/search-results.jsp").forward(request, response);
            return;
        }

        keyword = keyword.trim();

        // 设置搜索参数到request中，用于页面显示
        request.setAttribute("searchType", searchType);
        request.setAttribute("searchKeyword", keyword);

        if ("商品".equals(searchType)) {
            searchProducts(request, response, keyword);
        } else if ("商家".equals(searchType)) {
            searchShops(request, response, keyword);
        } else {
            request.setAttribute("error", "无效的搜索类型");
            request.getRequestDispatcher("/search-results.jsp").forward(request, response);
        }
    }

    private void searchProducts(HttpServletRequest request, HttpServletResponse response, String keyword)
            throws ServletException, IOException {

        Optional<List<Product>> productsOpt = productDao.getProductsByName(keyword);
        List<Map<String, Object>> productResults = new ArrayList<>();

        if (productsOpt.isPresent()) {
            List<Product> products = productsOpt.get();

            // 只显示已上架的商品
            for (Product product : products) {
                if (product.isProduct_listing()) {
                    Map<String, Object> productMap = new HashMap<>();
                    productMap.put("product", product);

                    // 获取商品的第一张图片
                    Optional<List<ProductImage>> imagesOpt = productImageDao
                            .getProductImageByProductId(product.getProduct_id());
                    String imageUrl = "icon/Akari.jpg";

                    if (imagesOpt.isPresent() && !imagesOpt.get().isEmpty()) {
                        ProductImage firstImage = imagesOpt.get().get(0);
                        imageUrl = firstImage.getImage_url();
                    }

                    productMap.put("imageUrl", imageUrl);
                    productResults.add(productMap);
                }
            }
        }

        request.setAttribute("searchResults", productResults);
        request.setAttribute("resultType", "products");
        request.setAttribute("resultCount", productResults.size());

        request.getRequestDispatcher("/search-results.jsp").forward(request, response);
    }

    private void searchShops(HttpServletRequest request, HttpServletResponse response, String keyword)
            throws ServletException, IOException {

        Optional<List<Shop>> shopsOpt = shopDao.getShopByName(keyword);
        List<Shop> shopResults = new ArrayList<>();

        if (shopsOpt.isPresent()) {
            shopResults = shopsOpt.get();
        }

        request.setAttribute("searchResults", shopResults);
        request.setAttribute("resultType", "shops");
        request.setAttribute("resultCount", shopResults.size());

        request.getRequestDispatcher("/search-results.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}