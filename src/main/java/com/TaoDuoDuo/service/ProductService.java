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
}
