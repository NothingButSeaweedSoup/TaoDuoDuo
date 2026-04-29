// ProductDetailServlet.java
package com.TaoDuoDuo.servlet;

import com.TaoDuoDuo.entity.Product;
import com.TaoDuoDuo.entity.ProductImage;
import com.TaoDuoDuo.entity.Review;
import com.TaoDuoDuo.entity.Shop;
import com.TaoDuoDuo.service.ProductDetailService;
import com.TaoDuoDuo.service.ProductService;
import com.TaoDuoDuo.service.ShopService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "ProductDetailServlet", value = "/ProductDetailServlet")
public class ProductDetailServlet extends HttpServlet {
    private ProductDetailService productDetailService;
    private ProductService productService;
    private ShopService shopService;

    @Override
    public void init() throws ServletException {
        productDetailService = new ProductDetailService();
        productService = new ProductService();
        shopService = new ShopService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 获取商品ID参数
            String productIdParam = request.getParameter("id");
            if (productIdParam == null || productIdParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/view/notFound.jsp");
                return;
            }

            int productId = Integer.parseInt(productIdParam);

            // 获取商品详细信息
            Optional<Product> productOptional = productDetailService.getProductDetail(productId);
            if (!productOptional.isPresent()) {
                response.sendRedirect(request.getContextPath() + "/view/notFound.jsp");
                return;
            }
            Product product = productOptional.get();

            // 获取商品图片列表
            List<ProductImage> productImages = productService.getProductImagesByProductId(productId);

            // 获取店铺信息
            Shop shop = shopService.getShopById(product.getShop_id());

            // 获取商品评价列表
            Optional<List<Review>> reviewsOptional = productDetailService.getProductReviews(productId);
            List<Review> reviews = reviewsOptional.orElse(null);

            // 设置请求属性
            request.setAttribute("product", product);
            request.setAttribute("productImages", productImages);
            request.setAttribute("shop", shop);
            request.setAttribute("reviews", reviews);

            // 转发到商品详情页面
            request.getRequestDispatcher("/view/item.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/view/notFound.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "服务器内部错误");
        }
    }
}
