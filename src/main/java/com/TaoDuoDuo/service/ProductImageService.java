package com.TaoDuoDuo.service;

import com.TaoDuoDuo.dao.ProductImageDao;
import com.TaoDuoDuo.entity.ProductImage;
import com.TaoDuoDuo.util.ImageUtil;

import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.List;

/**
 * 商品图片服务类
 * 处理商品图片的上传、保存和管理
 */
public class ProductImageService {
    private ProductImageDao productImageDao;

    public ProductImageService() {
        this.productImageDao = new ProductImageDao();
    }

    /**
     * 上传商品图片
     * 
     * @param productId   商品ID
     * @param imagePart   图片文件Part对象
     * @param webRootPath web根目录路径
     * @return 上传成功返回true
     */
    public boolean uploadProductImage(int productId, Part imagePart, String webRootPath) {
        try {
            // 验证文件
            if (imagePart == null || imagePart.getSize() == 0) {
                return false;
            }

            String fileName = getFileName(imagePart);
            if (!ImageUtil.isImageFile(fileName)) {
                return false;
            }

            // 获取下一个排序序号
            int nextSortOrder = getNextSortOrder(productId);

            // 生成文件名和路径
            String fileExtension = getFileExtension(fileName);
            String newFileName = nextSortOrder + fileExtension;

            // 使用正确的路径分隔符构建路径
            String imageDir = "images" + File.separator + "productImage" + File.separator + productId;
            String relativePath = "/" + imageDir.replace(File.separator, "/") + "/" + newFileName; // 数据库存储用正斜杠，前面加斜杠

            // 运行时目录路径（target/web/images）
            String runtimePath = webRootPath + File.separator + imageDir + File.separator + newFileName;

            // 源码目录路径（project/web/images）
            String sourcePath = getSourceWebPath() + File.separator + imageDir + File.separator + newFileName;

            System.out.println("保存图片到运行时目录: " + runtimePath); // 调试信息
            System.out.println("保存图片到源码目录: " + sourcePath); // 调试信息
            System.out.println("相对路径: " + relativePath); // 调试信息

            // 将上传的图片转为二进制
            byte[] imageBytes = ImageUtil.inputStreamToBytes(imagePart.getInputStream());

            // 保存图片到运行时目录
            ImageUtil.bytesToImage(imageBytes, runtimePath);

            // 保存图片到源码目录
            ImageUtil.bytesToImage(imageBytes, sourcePath);

            // 保存图片信息到数据库
            ProductImage productImage = new ProductImage(productId, relativePath, nextSortOrder);
            return productImageDao.addProductImage(productImage);

        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 批量上传商品图片
     * 
     * @param productId   商品ID
     * @param imageParts  图片文件Part对象列表
     * @param webRootPath web根目录路径
     * @return 成功上传的图片数量
     */
    public int uploadProductImages(int productId, List<Part> imageParts, String webRootPath) {
        int successCount = 0;
        for (Part imagePart : imageParts) {
            if (uploadProductImage(productId, imagePart, webRootPath)) {
                successCount++;
            }
        }
        return successCount;
    }

    /**
     * 删除商品图片
     * 
     * @param imageId     图片ID
     * @param webRootPath web根目录路径
     * @return 删除成功返回true
     */
    public boolean deleteProductImage(int imageId, String webRootPath) {
        // 先获取图片信息
        ProductImage productImage = productImageDao.getProductImageById(imageId).orElse(null);
        if (productImage == null) {
            return false;
        }

        // 删除物理文件 - 将URL路径转换为系统路径
        String imageUrl = productImage.getImage_url();
        // 移除开头的斜杠，然后转换路径分隔符
        String systemPath = imageUrl.startsWith("/") ? imageUrl.substring(1) : imageUrl;
        systemPath = systemPath.replace("/", File.separator);

        // 运行时目录路径
        String runtimePath = webRootPath + File.separator + systemPath;

        // 源码目录路径
        String sourcePath = getSourceWebPath() + File.separator + systemPath;

        System.out.println("删除运行时图片文件: " + runtimePath); // 调试信息
        System.out.println("删除源码图片文件: " + sourcePath); // 调试信息

        // 删除运行时目录的文件
        File runtimeFile = new File(runtimePath);
        if (runtimeFile.exists()) {
            boolean deleted = runtimeFile.delete();
            System.out.println("运行时文件删除结果: " + deleted); // 调试信息
        } else {
            System.out.println("运行时文件不存在: " + runtimePath); // 调试信息
        }

        // 删除源码目录的文件
        File sourceFile = new File(sourcePath);
        if (sourceFile.exists()) {
            boolean deleted = sourceFile.delete();
            System.out.println("源码文件删除结果: " + deleted); // 调试信息
        } else {
            System.out.println("源码文件不存在: " + sourcePath); // 调试信息
        }

        // 删除数据库记录
        return productImageDao.deleteProductImage(imageId);
    }

    /**
     * 获取商品的所有图片
     * 
     * @param productId 商品ID
     * @return 图片列表
     */
    public List<ProductImage> getProductImages(int productId) {
        return productImageDao.getProductImageByProductId(productId).orElse(null);
    }

    /**
     * 获取商品主图
     * 
     * @param productId 商品ID
     * @return 主图对象
     */
    public ProductImage getProductMainImage(int productId) {
        return productImageDao.getProductMainImage(productId).orElse(null);
    }

    /**
     * 获取下一个排序序号
     * 
     * @param productId 商品ID
     * @return 下一个排序序号
     */
    private int getNextSortOrder(int productId) {
        List<ProductImage> existingImages = getProductImages(productId);
        if (existingImages == null || existingImages.isEmpty()) {
            return 1;
        }

        int maxSortOrder = existingImages.stream()
                .mapToInt(ProductImage::getSort_order)
                .max()
                .orElse(0);

        return maxSortOrder + 1;
    }

    /**
     * 从Part对象中获取文件名
     * 
     * @param part Part对象
     * @return 文件名
     */
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition != null) {
            for (String content : contentDisposition.split(";")) {
                if (content.trim().startsWith("filename")) {
                    return content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
                }
            }
        }
        return "unknown";
    }

    /**
     * 获取文件扩展名
     * 
     * @param fileName 文件名
     * @return 扩展名（包含点号）
     */
    private String getFileExtension(String fileName) {
        if (fileName == null || !fileName.contains(".")) {
            return ".jpg"; // 默认扩展名
        }
        return fileName.substring(fileName.lastIndexOf("."));
    }

    /**
     * 获取项目源码web目录路径
     * 
     * @return 源码web目录的绝对路径
     */
    private String getSourceWebPath() {
        try {
            // 获取当前类的路径
            String classPath = this.getClass().getProtectionDomain().getCodeSource().getLocation().getPath();
            System.out.println("类路径: " + classPath); // 调试信息

            // 从类路径推断项目根目录
            // 类路径通常是: /path/to/project/target/classes/ 或
            // /path/to/project/out/production/classes/
            File classFile = new File(classPath);
            File projectRoot = null;

            // 向上查找项目根目录（包含pom.xml的目录）
            File current = classFile.getParentFile();
            while (current != null) {
                File pomFile = new File(current, "pom.xml");
                if (pomFile.exists()) {
                    projectRoot = current;
                    break;
                }
                current = current.getParentFile();
            }

            if (projectRoot != null) {
                String sourcePath = projectRoot.getAbsolutePath() + File.separator + "web";
                System.out.println("源码web目录: " + sourcePath); // 调试信息
                return sourcePath;
            } else {
                // 如果找不到项目根目录，使用当前工作目录
                String workingDir = System.getProperty("user.dir");
                String sourcePath = workingDir + File.separator + "web";
                System.out.println("使用工作目录web: " + sourcePath); // 调试信息
                return sourcePath;
            }
        } catch (Exception e) {
            e.printStackTrace();
            // 出错时使用当前工作目录
            String workingDir = System.getProperty("user.dir");
            String sourcePath = workingDir + File.separator + "web";
            System.out.println("异常时使用工作目录web: " + sourcePath); // 调试信息
            return sourcePath;
        }
    }
}