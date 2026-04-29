package com.TaoDuoDuo.service;

import com.TaoDuoDuo.dao.CategoryDao;
import com.TaoDuoDuo.dao.ProductDao;
import com.TaoDuoDuo.dao.ProductImageDao;
import com.TaoDuoDuo.entity.Category;
import com.TaoDuoDuo.entity.Product;
import com.TaoDuoDuo.entity.ProductImage;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * 分类服务类
 * 处理分类相关的业务逻辑，包括分类查询、商品获取、统计信息等
 */
public class CategoryService {

    private CategoryDao categoryDao;
    private ProductDao productDao;
    private ProductImageDao productImageDao;

    public CategoryService() {
        this.categoryDao = new CategoryDao();
        this.productDao = new ProductDao();
        this.productImageDao = new ProductImageDao();
    }

    /**
     * 获取所有分类
     * 
     * @return 分类列表
     */
    public List<Category> getAllCategories() {
        Optional<List<Category>> categoriesOpt = categoryDao.getAllCategories();
        return categoriesOpt.orElse(new ArrayList<>());
    }

    /**
     * 获取根分类（父分类ID为0的分类）
     * 
     * @return 根分类列表
     */
    public List<Category> getRootCategories() {
        Optional<List<Category>> categoriesOpt = categoryDao.getAllCategoriesByParentId(0);
        return categoriesOpt.orElse(new ArrayList<>());
    }

    /**
     * 根据父分类ID获取子分类
     * 
     * @param parentId 父分类ID
     * @return 子分类列表
     */
    public List<Category> getSubCategories(int parentId) {
        Optional<List<Category>> categoriesOpt = categoryDao.getAllCategoriesByParentId(parentId);
        return categoriesOpt.orElse(new ArrayList<>());
    }

    /**
     * 根据分类ID获取分类信息
     * 
     * @param categoryId 分类ID
     * @return 分类信息
     */
    public Optional<Category> getCategoryById(int categoryId) {
        return categoryDao.getCategoryById(categoryId);
    }

    /**
     * 根据分类ID获取该分类下的所有上架商品（包含图片信息）
     * 
     * @param categoryId 分类ID
     * @return 商品列表（包含图片URL）
     */
    public List<Map<String, Object>> getProductsByCategoryId(int categoryId) {
        List<Map<String, Object>> productResults = new ArrayList<>();

        Optional<List<Product>> productsOpt = productDao.getListedProductsByCategoryId(categoryId);
        if (productsOpt.isPresent()) {
            List<Product> products = productsOpt.get();

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
                productResults.add(productMap);
            }
        }

        return productResults;
    }

    /**
     * 获取分类层次结构（用于面包屑导航）
     * 
     * @param categoryId 分类ID
     * @return 从根分类到当前分类的路径
     */
    public List<Category> getCategoryPath(int categoryId) {
        List<Category> path = new ArrayList<>();

        Optional<Category> categoryOpt = getCategoryById(categoryId);
        if (!categoryOpt.isPresent()) {
            return path;
        }

        Category currentCategory = categoryOpt.get();
        path.add(0, currentCategory);

        // 递归获取父分类
        while (currentCategory.getParent_id() != 0) {
            Optional<Category> parentOpt = getCategoryById(currentCategory.getParent_id());
            if (parentOpt.isPresent()) {
                currentCategory = parentOpt.get();
                path.add(0, currentCategory);
            } else {
                break;
            }
        }

        return path;
    }

    /**
     * 获取分类统计信息
     * 
     * @param categoryId 分类ID
     * @return 分类统计信息
     */
    public CategoryStats getCategoryStats(int categoryId) {
        Optional<List<Product>> productsOpt = productDao.getListedProductsByCategoryId(categoryId);

        int productCount = 0;
        double minPrice = Double.MAX_VALUE;
        double maxPrice = 0;

        if (productsOpt.isPresent()) {
            List<Product> products = productsOpt.get();
            productCount = products.size();

            for (Product product : products) {
                double price = product.getPrice();
                if (price < minPrice) {
                    minPrice = price;
                }
                if (price > maxPrice) {
                    maxPrice = price;
                }
            }
        }

        if (productCount == 0) {
            minPrice = 0;
        }

        return new CategoryStats(productCount, minPrice, maxPrice);
    }

    /**
     * 根据分类名称搜索分类
     * 
     * @param categoryName 分类名称关键词
     * @return 匹配的分类列表
     */
    public List<Category> searchCategories(String categoryName) {
        Optional<List<Category>> categoriesOpt = categoryDao.getAllCategoriesByCategoryName(categoryName);
        return categoriesOpt.orElse(new ArrayList<>());
    }

    /**
     * 分类统计信息类
     */
    public static class CategoryStats {
        private final int productCount;
        private final double minPrice;
        private final double maxPrice;

        public CategoryStats(int productCount, double minPrice, double maxPrice) {
            this.productCount = productCount;
            this.minPrice = minPrice;
            this.maxPrice = maxPrice;
        }

        public int getProductCount() {
            return productCount;
        }

        public double getMinPrice() {
            return minPrice;
        }

        public double getMaxPrice() {
            return maxPrice;
        }
    }
}