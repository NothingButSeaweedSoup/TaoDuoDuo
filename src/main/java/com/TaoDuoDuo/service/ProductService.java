package com.TaoDuoDuo.service;

import com.TaoDuoDuo.dao.ProductDao;
import com.TaoDuoDuo.dao.ProductImageDao;
import com.TaoDuoDuo.entity.Product;
import com.TaoDuoDuo.entity.ProductImage;

import java.util.List;

public class ProductService {
    private ProductDao productDao;
    private ProductImageDao productImageDao;

    public ProductService() {
        this.productDao = new ProductDao();
        this.productImageDao = new ProductImageDao();
    }

    /**
     * 根据商品ID获取商品详细信息
     * 
     * @param productId 商品ID
     * @return Product对象
     */
    public Product getProductById(int productId) {
        return productDao.getProductById(productId).orElse(null);
    }

    /**
     * 根据商品ID获取商品的所有图片
     * 
     * @param productId 商品ID
     * @return ProductImage列表
     */
    public List<ProductImage> getProductImagesByProductId(int productId) {
        // 修改方法名以匹配 ProductImageDao 中的实际方法名
        return productImageDao.getProductImageByProductId(productId).orElse(null);
    }

    /**
     * 检查商品是否可以购买（上架且有库存）
     * 
     * @param productId 商品ID
     * @param quantity  购买数量
     * @return true表示可以购买，false表示不能购买
     */
    public boolean canPurchase(int productId, int quantity) {
        Product product = getProductById(productId);
        if (product == null) {
            return false; // 商品不存在
        }

        // 检查商品是否上架
        if (!product.isProduct_listing()) {
            return false; // 商品已下架
        }

        // 检查库存
        if (product.getStock() < quantity) {
            return false; // 库存不足
        }

        return true;
    }

    /**
     * 检查商品是否上架
     * 
     * @param productId 商品ID
     * @return true表示上架，false表示下架或不存在
     */
    public boolean isProductListed(int productId) {
        Product product = getProductById(productId);
        return product != null && product.isProduct_listing();
    }

    /**
     * 获取上架商品的详细信息
     * 
     * @param productId 商品ID
     * @return 上架的商品对象，如果商品不存在或已下架则返回null
     */
    public Product getListedProductById(int productId) {
        Product product = getProductById(productId);
        if (product != null && product.isProduct_listing()) {
            return product;
        }
        return null;
    }

    /**
     * 根据店铺ID获取所有商品
     * 
     * @param shopId 店铺ID
     * @return 商品列表
     */
    public List<Product> getProductsByShopId(int shopId) {
        return productDao.getProductsByShopId(shopId).orElse(null);
    }

    /**
     * 根据店铺ID和商品名称搜索商品
     * 
     * @param shopId      店铺ID
     * @param productName 商品名称关键字
     * @return 匹配的商品列表
     */
    public List<Product> searchProductsByShopIdAndName(int shopId, String productName) {
        List<Product> allProducts = getProductsByShopId(shopId);
        if (allProducts == null || productName == null || productName.trim().isEmpty()) {
            return allProducts;
        }

        String keyword = productName.trim().toLowerCase();
        return allProducts.stream()
                .filter(product -> product.getProduct_name().toLowerCase().contains(keyword))
                .collect(java.util.stream.Collectors.toList());
    }

    /**
     * 添加新商品
     * 
     * @param product 商品信息
     * @return 添加成功返回true
     */
    public boolean addProduct(Product product) {
        if (product == null || product.getProduct_name() == null || product.getProduct_name().trim().isEmpty()) {
            return false;
        }

        // 验证价格和库存
        if (product.getPrice() < 0 || product.getStock() < 0) {
            return false;
        }

        return productDao.addProduct(product);
    }

    /**
     * 更新商品信息
     * 
     * @param product 商品信息
     * @return 更新成功返回true
     */
    public boolean updateProduct(Product product) {
        if (product == null || product.getProduct_name() == null || product.getProduct_name().trim().isEmpty()) {
            return false;
        }

        // 验证价格和库存
        if (product.getPrice() < 0 || product.getStock() < 0) {
            return false;
        }

        return productDao.updateProduct(product);
    }

    /**
     * 删除商品
     * 
     * @param productId 商品ID
     * @return 删除成功返回true
     */
    public boolean deleteProduct(int productId) {
        return productDao.deleteProduct(productId);
    }

    /**
     * 更新商品上架状态
     * 
     * @param productId 商品ID
     * @param listing   上架状态
     * @return 更新成功返回true
     */
    public boolean updateProductListing(int productId, boolean listing) {
        return productDao.updateProductListing(productId, listing);
    }

    /**
     * 添加商品图片
     * 
     * @param productImage 商品图片对象
     * @return 添加成功返回true
     */
    public boolean addProductImage(ProductImage productImage) {
        return productImageDao.addProductImage(productImage);
    }

    /**
     * 删除商品图片
     * 
     * @param imageId 图片ID
     * @return 删除成功返回true
     */
    public boolean deleteProductImage(int imageId) {
        return productImageDao.deleteProductImage(imageId);
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
}
