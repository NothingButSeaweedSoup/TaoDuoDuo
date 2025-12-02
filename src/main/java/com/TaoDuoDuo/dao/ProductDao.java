package com.TaoDuoDuo.dao;

import com.TaoDuoDuo.entity.Product;
import com.TaoDuoDuo.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class ProductDao {

    /**
     * 添加新的商品信息
     * @param product 包含商品名称、描述、价格、库存、分类ID和店铺ID的商品对象
     * @return boolean 添加成功返回true，失败返回false
     * @throws SQLException SQL执行异常时会打印堆栈跟踪
     */
    public boolean addProduct(Product product) {
        String sql = "insert into product(product_name, description, price, stock, category_id, shop_id) values(?,?,?,?,?,?)";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setString(1, product.getProduct_name());
            ps.setString(2, product.getDescription());
            ps.setDouble(3, product.getPrice());
            ps.setInt(4, product.getStock());
            ps.setInt(5, product.getCategory_id());
            ps.setInt(6, product.getShop_id());
            boolean result = ps.executeUpdate() > 0;
            if (result) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int generatedId = generatedKeys.getInt(1);
                    product.setProduct_id(generatedId);
                }
                generatedKeys.close();
            }
            DBUtil.close(null, ps, conn);
            return result;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 更新商品信息
     * @param product 包含商品ID及需要更新信息的商品对象
     * @return boolean 更新成功返回true，失败返回false
     * @throws SQLException SQL执行异常时会打印堆栈跟踪
     */
    public boolean updateProduct(Product product) {
        String sql = "update product set product_name = ?, description = ?, price = ?, stock = ?, category_id = ?, shop_id = ? where product_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, product.getProduct_name());
            ps.setString(2, product.getDescription());
            ps.setDouble(3, product.getPrice());
            ps.setInt(4, product.getStock());
            ps.setInt(5, product.getCategory_id());
            ps.setInt(6, product.getShop_id());
            ps.setInt(7, product.getProduct_id());
            boolean result = ps.executeUpdate() > 0;
            DBUtil.close(null, ps, conn);
            return result;
        }catch (SQLException e){
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 根据商品ID删除指定商品
     * @param product_id 要删除的商品记录的唯一标识符
     * @return boolean 删除成功返回true，失败返回false
     * @throws SQLException SQL执行异常时会打印堆栈跟踪
     */
    public boolean deleteProduct(int product_id) {
        String sql = "delete from product where product_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, product_id);
            boolean result = ps.executeUpdate() > 0;
            DBUtil.close(null, ps, conn);
            return result;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 根据商品ID查询单个商品信息
     * @param product_id 商品记录的唯一标识符
     * @return Optional<Product> 包含查询结果的可选商品对象，未找到时返回空Optional
     * @throws SQLException SQL执行异常时会打印堆栈跟踪
     */
    public Optional<Product> getProductById(int product_id) {
        String sql = "select * from product where product_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, product_id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Product product = new Product();
                product.setProduct_id(rs.getInt("product_id"));
                product.setProduct_name(rs.getString("product_name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setStock(rs.getInt("stock"));
                product.setCategory_id(rs.getInt("category_id"));
                product.setShop_id(rs.getInt("shop_id"));
                DBUtil.close(rs, ps, conn);
                return Optional.of(product);
            }else {
                DBUtil.close(rs, ps, conn);
                return Optional.empty();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    /**
     * 根据分类ID查询该分类下的所有商品
     * @param category_id 分类的唯一标识符
     * @return Optional<List<Product>> 包含指定分类下所有商品的可选列表，未找到时返回空Optional
     * @throws SQLException SQL执行异常时会打印堆栈跟踪
     */
    public Optional<List<Product>> getProductsByCategoryId(int category_id) {
        String sql = "select * from product where category_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, category_id);
            ResultSet rs = ps.executeQuery();
            List<Product> products = new ArrayList<>();
            while (rs.next()) {
                Product product = new Product();
                product.setProduct_id(rs.getInt("product_id"));
                product.setProduct_name(rs.getString("product_name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setStock(rs.getInt("stock"));
                product.setCategory_id(rs.getInt("category_id"));
                product.setShop_id(rs.getInt("shop_id"));
                products.add(product);
            }
            DBUtil.close(rs, ps, conn);
            return Optional.of(products);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    /**
     * 根据店铺ID查询该店铺下的所有商品
     * @param shop_id 店铺的唯一标识符
     * @return Optional<List<Product>> 包含指定店铺下所有商品的可选列表，未找到时返回空Optional
     * @throws SQLException SQL执行异常时会打印堆栈跟踪
     */
    public Optional<List<Product>> getProductsByShopId(int shop_id) {
        String sql = "select * from product where shop_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, shop_id);
            ResultSet rs = ps.executeQuery();
            List<Product> products = new ArrayList<>();
            while (rs.next()) {
                Product product = new Product();
                product.setProduct_id(rs.getInt("product_id"));
                product.setProduct_name(rs.getString("product_name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setStock(rs.getInt("stock"));
                product.setCategory_id(rs.getInt("category_id"));
                product.setShop_id(rs.getInt("shop_id"));
                products.add(product);
            }
            DBUtil.close(rs, ps, conn);
            return Optional.of(products);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    /**
     * 根据商品名称模糊查询商品
     * @param product_name 商品名称关键字
     * @return Optional<List<Product>> 包含匹配商品名称的所有商品记录的可选列表，未找到时返回空Optional
     * @throws SQLException SQL执行异常时会打印堆栈跟踪
     */
    public Optional<List<Product>> getProductsByName(String product_name) {
        String sql = "select * from product where product_name like ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, "%" + product_name + "%");
            ResultSet rs = ps.executeQuery();
            List<Product> products = new ArrayList<>();
            while (rs.next()) {
                Product product = new Product();
                product.setProduct_id(rs.getInt("product_id"));
                product.setProduct_name(rs.getString("product_name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setStock(rs.getInt("stock"));
                product.setCategory_id(rs.getInt("category_id"));
                product.setShop_id(rs.getInt("shop_id"));
                products.add(product);
            }
            DBUtil.close(rs, ps, conn);
            return Optional.of(products);
        }catch (SQLException e){
            e.printStackTrace();
        }
        return Optional.empty();
    }
}
