package com.TaoDuoDuo.dao;

import com.TaoDuoDuo.entity.ProductImage;
import com.TaoDuoDuo.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class ProductImageDao {
    /**
     * 添加商品图片记录到数据库
     * @param productImage 商品图片对象，包含商品ID、图片URL和排序序号
     *                     添加成功后会自动设置生成的图片ID
     * @return 添加成功返回true，失败返回false
     */
    public boolean addProductImage(ProductImage productImage) {
        String sql = "insert into product_image(product_id,image_url,sort_order) values(?,?,?)";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setInt(1, productImage.getProduct_id());
            ps.setString(2, productImage.getImage_url());
            ps.setInt(3, productImage.getSort_order());
            boolean result = ps.executeUpdate() > 0;
            if (result) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int generatedId = generatedKeys.getInt(1);
                    productImage.setImage_id(generatedId);
                }
                generatedKeys.close();
            }
            DBUtil.close(null, ps, conn);
            return result;
        }catch (SQLException e){
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 更新商品图片记录信息
     * @param productImage 商品图片对象，必须包含图片ID以及要更新的商品ID、图片URL和排序序号
     * @return 更新成功返回true，失败返回false
     */
    public boolean updateProductImage(ProductImage productImage) {
        String sql = "update product_image set product_id=?,image_url=?,sort_order=? where image_id=?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, productImage.getProduct_id());
            ps.setString(2, productImage.getImage_url());
            ps.setInt(3, productImage.getSort_order());
            ps.setInt(4, productImage.getImage_id());
            boolean result = ps.executeUpdate() > 0;
            DBUtil.close(null, ps, conn);
            return result;
        }catch (SQLException e){
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 根据图片ID删除商品图片记录
     * @param image_id 要删除的图片ID
     * @return 删除成功返回true，失败返回false
     */
    public boolean deleteProductImage(int image_id) {
        String sql = "delete from product_image where image_id=?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, image_id);
            boolean result = ps.executeUpdate() > 0;
            DBUtil.close(null, ps, conn);
            return result;
        }catch (SQLException e){
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 根据图片ID查询单个商品图片信息
     * @param image_id 图片ID
     * @return 包含商品图片信息的Optional对象，如果未找到则返回空Optional
     */
    public Optional<ProductImage> getProductImageById(int image_id) {
        String sql = "select * from product_image where image_id=?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, image_id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                ProductImage productImage = new ProductImage();
                productImage.setImage_id(rs.getInt("image_id"));
                productImage.setProduct_id(rs.getInt("product_id"));
                productImage.setImage_url(rs.getString("image_url"));
                productImage.setSort_order(rs.getInt("sort_order"));
                DBUtil.close(rs, ps, conn);
                return Optional.of(productImage);
            }else {
                DBUtil.close(null, ps, conn);
                return Optional.empty();
            }
        }catch (SQLException e){
            e.printStackTrace();
        }
        return Optional.empty();
    }

    /**
     * 根据商品ID查询该商品的所有图片信息
     * @param product_id 商品ID
     * @return 包含商品图片列表的Optional对象，如果未找到则返回空Optional
     */
    public Optional<List<ProductImage>> getProductImageByProductId(int product_id) {
        String sql = "select * from product_image where product_id=?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, product_id);
            ResultSet rs = ps.executeQuery();
            List<ProductImage> productImageList = new ArrayList<>();
            while (rs.next()) {
                ProductImage productImage = new ProductImage();
                productImage.setImage_id(rs.getInt("image_id"));
                productImage.setProduct_id(rs.getInt("product_id"));
                productImage.setImage_url(rs.getString("image_url"));
                productImage.setSort_order(rs.getInt("sort_order"));
                productImageList.add(productImage);
            }
            DBUtil.close(rs, ps, conn);
            return Optional.of(productImageList);
        }catch (SQLException e){
            e.printStackTrace();
        }
        return Optional.empty();
    }

    /**
     * 获取指定商品的主图（排序序号为1的图片）
     * @param product_id 商品ID
     * @return 包含主图信息的Optional对象，如果未找到则返回空Optional
     */
    public Optional<ProductImage> getProductMainImage(int product_id) {
        String sql = "select * from product_image where product_id=? and sort_order=1";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, product_id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                ProductImage productImage = new ProductImage();
                productImage.setImage_id(rs.getInt("image_id"));
                productImage.setProduct_id(rs.getInt("product_id"));
                productImage.setImage_url(rs.getString("image_url"));
                productImage.setSort_order(rs.getInt("sort_order"));
                DBUtil.close(rs, ps, conn);
                return Optional.of(productImage);
            }else {
                DBUtil.close(null, ps, conn);
                return Optional.empty();
            }
        }catch (SQLException e){
            e.printStackTrace();
        }
        return Optional.empty();
    }
}
