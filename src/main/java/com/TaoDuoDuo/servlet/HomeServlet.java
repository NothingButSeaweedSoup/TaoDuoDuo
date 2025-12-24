package com.TaoDuoDuo.servlet;

import com.TaoDuoDuo.dao.ProductDao;
import com.TaoDuoDuo.dao.ProductImageDao;
import com.TaoDuoDuo.entity.Product;
import com.TaoDuoDuo.entity.ProductImage;

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

@WebServlet("/HomeServlet")
public class HomeServlet extends HttpServlet {
    private ProductDao productDao = new ProductDao();
    private ProductImageDao productImageDao = new ProductImageDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 获取随机商品，最多20个
        Optional<List<Product>> randomProductsOpt = productDao.getRandomListedProducts(20);

        List<Map<String, Object>> productList = new ArrayList<>();

        if (randomProductsOpt.isPresent()) {
            List<Product> products = randomProductsOpt.get();

            for (Product product : products) {
                Map<String, Object> productMap = new HashMap<>();
                productMap.put("product", product);

                // 获取商品的第一张图片
                Optional<List<ProductImage>> imagesOpt = productImageDao
                        .getProductImageByProductId(product.getProduct_id());
                String imageUrl = "icon/Akari.jpg"; // 默认图片

                if (imagesOpt.isPresent() && !imagesOpt.get().isEmpty()) {
                    ProductImage firstImage = imagesOpt.get().get(0);
                    imageUrl = firstImage.getImage_url();
                }

                productMap.put("imageUrl", imageUrl);
                productList.add(productMap);
            }
        }

        // 将商品列表设置到request属性中
        request.setAttribute("randomProducts", productList);

        // 转发到index.jsp
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}