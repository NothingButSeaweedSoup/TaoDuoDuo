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
     * @param productId 商品ID
     * @return Product对象
     */
    public Product getProductById(int productId) {
        return productDao.getProductById(productId).orElse(null);
    }

    /**
     * 根据商品ID获取商品的所有图片
     * @param productId 商品ID
     * @return ProductImage列表
     */
    public List<ProductImage> getProductImagesByProductId(int productId) {
        // 修改方法名以匹配 ProductImageDao 中的实际方法名
        return productImageDao.getProductImageByProductId(productId).orElse(null);
    }
}
