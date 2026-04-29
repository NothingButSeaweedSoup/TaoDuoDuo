package com.TaoDuoDuo.util;

import java.io.*;
import java.util.Base64;

/**
 * 图片工具类
 * 提供图片与二进制数据之间的转换功能
 */
public class ImageUtil {

    /**
     * 将图片文件转换为二进制数组
     * 
     * @param imagePath 图片文件路径
     * @return 二进制数组
     * @throws IOException 文件读取异常
     */
    public static byte[] imageToBytes(String imagePath) throws IOException {
        File file = new File(imagePath);
        if (!file.exists()) {
            throw new FileNotFoundException("图片文件不存在: " + imagePath);
        }

        try (FileInputStream fis = new FileInputStream(file);
                ByteArrayOutputStream baos = new ByteArrayOutputStream()) {

            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = fis.read(buffer)) != -1) {
                baos.write(buffer, 0, bytesRead);
            }
            return baos.toByteArray();
        }
    }

    /**
     * 将InputStream转换为二进制数组
     * 
     * @param inputStream 输入流
     * @return 二进制数组
     * @throws IOException 流读取异常
     */
    public static byte[] inputStreamToBytes(InputStream inputStream) throws IOException {
        try (ByteArrayOutputStream baos = new ByteArrayOutputStream()) {
            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                baos.write(buffer, 0, bytesRead);
            }
            return baos.toByteArray();
        }
    }

    /**
     * 将二进制数组保存为图片文件
     * 
     * @param bytes      二进制数组
     * @param outputPath 输出文件路径
     * @throws IOException 文件写入异常
     */
    public static void bytesToImage(byte[] bytes, String outputPath) throws IOException {
        System.out.println("准备保存文件到: " + outputPath);

        File outputFile = new File(outputPath);
        File parentDir = outputFile.getParentFile();

        System.out.println("父目录: " + (parentDir != null ? parentDir.getAbsolutePath() : "null"));

        if (parentDir != null && !parentDir.exists()) {
            System.out.println("创建父目录...");
            boolean created = parentDir.mkdirs();
            System.out.println("父目录创建结果: " + created);
        }

        if (parentDir != null) {
            System.out.println("父目录权限 - 可读: " + parentDir.canRead() +
                    ", 可写: " + parentDir.canWrite() +
                    ", 可执行: " + parentDir.canExecute());
        }

        try (FileOutputStream fos = new FileOutputStream(outputFile)) {
            fos.write(bytes);
            System.out.println("文件写入成功，大小: " + bytes.length + " 字节");
        } catch (IOException e) {
            System.out.println("文件写入失败: " + e.getMessage());
            throw e;
        }

        // 验证文件是否真的被创建
        if (outputFile.exists()) {
            System.out.println("文件确认存在: " + outputFile.getAbsolutePath() + ", 大小: " + outputFile.length());
        } else {
            System.out.println("警告: 文件写入后不存在!");
        }
    }

    /**
     * 将二进制数组转换为Base64字符串
     * 
     * @param bytes 二进制数组
     * @return Base64字符串
     */
    public static String bytesToBase64(byte[] bytes) {
        return Base64.getEncoder().encodeToString(bytes);
    }

    /**
     * 将Base64字符串转换为二进制数组
     * 
     * @param base64String Base64字符串
     * @return 二进制数组
     */
    public static byte[] base64ToBytes(String base64String) {
        return Base64.getDecoder().decode(base64String);
    }

    /**
     * 将图片文件转换为Base64字符串
     * 
     * @param imagePath 图片文件路径
     * @return Base64字符串
     * @throws IOException 文件读取异常
     */
    public static String imageToBase64(String imagePath) throws IOException {
        byte[] bytes = imageToBytes(imagePath);
        return bytesToBase64(bytes);
    }

    /**
     * 将Base64字符串保存为图片文件
     * 
     * @param base64String Base64字符串
     * @param outputPath   输出文件路径
     * @throws IOException 文件写入异常
     */
    public static void base64ToImage(String base64String, String outputPath) throws IOException {
        byte[] bytes = base64ToBytes(base64String);
        bytesToImage(bytes, outputPath);
    }

    /**
     * 获取图片文件的MIME类型
     * 
     * @param fileName 文件名
     * @return MIME类型
     */
    public static String getMimeType(String fileName) {
        if (fileName == null) {
            return "application/octet-stream";
        }

        String extension = fileName.toLowerCase();
        if (extension.endsWith(".jpg") || extension.endsWith(".jpeg")) {
            return "image/jpeg";
        } else if (extension.endsWith(".png")) {
            return "image/png";
        } else if (extension.endsWith(".gif")) {
            return "image/gif";
        } else if (extension.endsWith(".bmp")) {
            return "image/bmp";
        } else if (extension.endsWith(".webp")) {
            return "image/webp";
        } else {
            return "application/octet-stream";
        }
    }

    /**
     * 验证文件是否为图片格式
     * 
     * @param fileName 文件名
     * @return 是否为图片格式
     */
    public static boolean isImageFile(String fileName) {
        if (fileName == null) {
            return false;
        }

        String extension = fileName.toLowerCase();
        return extension.endsWith(".jpg") ||
                extension.endsWith(".jpeg") ||
                extension.endsWith(".png") ||
                extension.endsWith(".gif") ||
                extension.endsWith(".bmp") ||
                extension.endsWith(".webp");
    }

    /**
     * 创建商品图片目录
     * 
     * @param webRootPath web根目录路径
     * @param productId   商品ID
     * @return 商品图片目录路径
     */
    public static String createProductImageDirectory(String webRootPath, int productId) {
        String dirPath = webRootPath + File.separator + "images" + File.separator +
                "productImage" + File.separator + productId;
        File dir = new File(dirPath);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        return dirPath;
    }

    /**
     * 获取商品图片的相对路径
     * 
     * @param productId 商品ID
     * @param fileName  文件名
     * @return 相对路径
     */
    public static String getProductImageRelativePath(int productId, String fileName) {
        return "images/productImage/" + productId + "/" + fileName;
    }

    /**
     * 压缩图片（简单的尺寸压缩）
     * 
     * @param originalBytes 原始图片字节数组
     * @param maxWidth      最大宽度
     * @param maxHeight     最大高度
     * @return 压缩后的字节数组
     */
    public static byte[] compressImage(byte[] originalBytes, int maxWidth, int maxHeight) {
        // 这里可以实现图片压缩逻辑
        // 为了简化，暂时返回原始字节数组
        // 实际项目中可以使用ImageIO和BufferedImage进行压缩
        return originalBytes;
    }
}