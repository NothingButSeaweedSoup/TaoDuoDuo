package com.TaoDuoDuo.servlet;

import com.TaoDuoDuo.service.ProductImageService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**
 * 商品图片上传处理Servlet
 */
@WebServlet("/productImageUpload")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class ProductImageUploadServlet extends HttpServlet {

    private ProductImageService productImageService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.productImageService = new ProductImageService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // 获取商品ID
            String productIdStr = request.getParameter("productId");
            if (productIdStr == null || productIdStr.trim().isEmpty()) {
                out.print("{\"success\":false,\"message\":\"商品ID不能为空\"}");
                return;
            }

            int productId;
            try {
                productId = Integer.parseInt(productIdStr);
            } catch (NumberFormatException e) {
                out.print("{\"success\":false,\"message\":\"商品ID格式错误\"}");
                return;
            }

            // 获取web根目录路径
            String webRootPath = getServletContext().getRealPath("/");
            System.out.println("Web根目录: " + webRootPath); // 调试信息

            // 验证目录结构
            java.io.File imagesDir = new java.io.File(webRootPath, "images");
            System.out.println("images目录存在: " + imagesDir.exists() + ", 路径: " + imagesDir.getAbsolutePath());

            // 获取上传的文件
            Collection<Part> parts = request.getParts();
            List<Part> imageParts = new ArrayList<>();

            for (Part part : parts) {
                if (part.getName().equals("images") && part.getSize() > 0) {
                    imageParts.add(part);
                }
            }

            if (imageParts.isEmpty()) {
                out.print("{\"success\":false,\"message\":\"请选择要上传的图片\"}");
                return;
            }

            // 上传图片
            int successCount = productImageService.uploadProductImages(productId, imageParts, webRootPath);

            if (successCount > 0) {
                out.print("{\"success\":true,\"message\":\"成功上传" + successCount + "张图片\",\"count\":" + successCount
                        + "}");
            } else {
                out.print("{\"success\":false,\"message\":\"图片上传失败，请检查文件格式\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\":false,\"message\":\"服务器错误：" + e.getMessage() + "\"}");
        } finally {
            out.close();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            String action = request.getParameter("action");

            if ("getImages".equals(action)) {
                // 获取商品图片列表
                String productIdStr = request.getParameter("productId");
                if (productIdStr != null && !productIdStr.trim().isEmpty()) {
                    int productId = Integer.parseInt(productIdStr);
                    var images = productImageService.getProductImages(productId);

                    if (images != null && !images.isEmpty()) {
                        StringBuilder json = new StringBuilder("{\"success\":true,\"images\":[");
                        for (int i = 0; i < images.size(); i++) {
                            if (i > 0)
                                json.append(",");
                            var img = images.get(i);

                            // 确保图片URL格式正确（以斜杠开头）
                            String imageUrl = img.getImage_url();
                            if (imageUrl != null && !imageUrl.startsWith("/")) {
                                imageUrl = "/" + imageUrl;
                            }

                            json.append("{")
                                    .append("\"imageId\":").append(img.getImage_id()).append(",")
                                    .append("\"imageUrl\":\"").append(imageUrl).append("\",")
                                    .append("\"sortOrder\":").append(img.getSort_order())
                                    .append("}");
                        }
                        json.append("]}");
                        out.print(json.toString());
                    } else {
                        out.print("{\"success\":true,\"images\":[]}");
                    }
                } else {
                    out.print("{\"success\":false,\"message\":\"商品ID不能为空\"}");
                }
            } else if ("deleteImage".equals(action)) {
                // 删除图片
                String imageIdStr = request.getParameter("imageId");
                if (imageIdStr != null && !imageIdStr.trim().isEmpty()) {
                    int imageId = Integer.parseInt(imageIdStr);
                    String webRootPath = getServletContext().getRealPath("/");

                    boolean success = productImageService.deleteProductImage(imageId, webRootPath);
                    if (success) {
                        out.print("{\"success\":true,\"message\":\"图片删除成功\"}");
                    } else {
                        out.print("{\"success\":false,\"message\":\"图片删除失败\"}");
                    }
                } else {
                    out.print("{\"success\":false,\"message\":\"图片ID不能为空\"}");
                }
            } else {
                out.print("{\"success\":false,\"message\":\"未知操作\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\":false,\"message\":\"服务器错误：" + e.getMessage() + "\"}");
        } finally {
            out.close();
        }
    }
}