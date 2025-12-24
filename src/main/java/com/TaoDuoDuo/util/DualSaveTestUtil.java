package com.TaoDuoDuo.util;

import java.io.File;

/**
 * 双重保存测试工具类
 * 用于验证图片是否同时保存到运行时目录和源码目录
 */
public class DualSaveTestUtil {

    /**
     * 检查图片是否在两个目录中都存在
     * 
     * @param runtimeWebPath 运行时web目录路径
     * @param sourceWebPath  源码web目录路径
     * @param productId      商品ID
     * @param fileName       文件名
     * @return 检查结果信息
     */
    public static String checkDualSave(String runtimeWebPath, String sourceWebPath, int productId, String fileName) {
        StringBuilder result = new StringBuilder();

        // 构建图片路径
        String imagePath = "images" + File.separator + "productImage" + File.separator + productId + File.separator
                + fileName;

        String runtimePath = runtimeWebPath + File.separator + imagePath;
        String sourcePath = sourceWebPath + File.separator + imagePath;

        File runtimeFile = new File(runtimePath);
        File sourceFile = new File(sourcePath);

        result.append("=== 双重保存检查结果 ===\n");
        result.append("商品ID: ").append(productId).append("\n");
        result.append("文件名: ").append(fileName).append("\n");
        result.append("运行时路径: ").append(runtimePath).append("\n");
        result.append("运行时文件存在: ").append(runtimeFile.exists()).append("\n");
        if (runtimeFile.exists()) {
            result.append("运行时文件大小: ").append(runtimeFile.length()).append(" bytes\n");
        }

        result.append("源码路径: ").append(sourcePath).append("\n");
        result.append("源码文件存在: ").append(sourceFile.exists()).append("\n");
        if (sourceFile.exists()) {
            result.append("源码文件大小: ").append(sourceFile.length()).append(" bytes\n");
        }

        boolean bothExist = runtimeFile.exists() && sourceFile.exists();
        result.append("双重保存成功: ").append(bothExist).append("\n");

        if (bothExist && runtimeFile.length() == sourceFile.length()) {
            result.append("文件大小一致: true\n");
        } else if (bothExist) {
            result.append("文件大小一致: false\n");
        }

        return result.toString();
    }

    /**
     * 列出商品目录下的所有图片文件
     * 
     * @param webPath   web目录路径
     * @param productId 商品ID
     * @return 文件列表信息
     */
    public static String listProductImages(String webPath, int productId) {
        StringBuilder result = new StringBuilder();

        String productDir = webPath + File.separator + "images" + File.separator + "productImage" + File.separator
                + productId;
        File dir = new File(productDir);

        result.append("=== 商品图片列表 ===\n");
        result.append("目录: ").append(productDir).append("\n");
        result.append("目录存在: ").append(dir.exists()).append("\n");

        if (dir.exists() && dir.isDirectory()) {
            File[] files = dir.listFiles();
            if (files != null && files.length > 0) {
                result.append("文件数量: ").append(files.length).append("\n");
                for (File file : files) {
                    if (file.isFile()) {
                        result.append("- ").append(file.getName())
                                .append(" (").append(file.length()).append(" bytes)\n");
                    }
                }
            } else {
                result.append("目录为空\n");
            }
        }

        return result.toString();
    }
}