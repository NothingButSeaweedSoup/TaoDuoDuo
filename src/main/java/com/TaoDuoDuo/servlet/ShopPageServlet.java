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

@WebServlet("/ShopPageServlet")
public class ShopPageServlet extends HttpServlet {
    private ShopDao shopDao = new ShopDao();
    private ProductDao productDao = new ProductDao();
    private ProductImageDao productImageDao = new ProductImageDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String shopIdStr = request.getParameter("id");
        String searchKeyword = request.getParameter("search");

        // 验证商家ID
        if (shopIdStr == null || shopIdStr.trim().isEmpty()) {
            request.setAttribute("error", "商家ID不能为空");
            request.getRequestDispatcher("/shop-page.jsp").forward(request, response);
            return;
        }

        int shopId;
        try {
            shopId = Integer.parseInt(shopIdStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "无效的商家ID");
            request.getRequestDispatcher("/shop-page.jsp").forward(request, response);
            return;
        }

        // 获取商家信息
        Optional<Shop> shopOpt = shopDao.getShopById(shopId);
        if (!shopOpt.isPresent()) {
            request.setAttribute("error", "商家不存在");
            request.getRequestDispatcher("/shop-page.jsp").forward(request, response);
            return;
        }

        Shop shop = shopOpt.get();
        request.setAttribute("shop", shop);

        // 获取商家的商品
        Optional<List<Product>> productsOpt = productDao.getProductsByShopId(shopId);
        List<Map<String, Object>> productList = new ArrayList<>();

        if (productsOpt.isPresent()) {
            List<Product> products = productsOpt.get();

            for (Product product : products) {
                // 只显示已上架的商品
                if (product.isProduct_listing()) {
                    // 如果有搜索关键词，进行过滤
                    if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                        if (!product.getProduct_name().toLowerCase()
                                .contains(searchKeyword.toLowerCase())) {
                            continue; // 跳过不匹配的商品
                        }
                    }

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
                    productList.add(productMap);
                }
            }
        }

        request.setAttribute("products", productList);
        request.setAttribute("searchKeyword", searchKeyword);
        request.setAttribute("productCount", productList.size());

        // 转发到商家主页
        request.getRequestDispatcher("/shop-page.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}