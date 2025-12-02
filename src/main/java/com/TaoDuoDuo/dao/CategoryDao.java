package com.TaoDuoDuo.dao;

import com.TaoDuoDuo.entity.Category;
import com.TaoDuoDuo.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class CategoryDao {

    /**
     * 添加新的商品分类，如果父分类ID为0则表示该分类为根分类，添加成功后会对新的分类ID进行赋值
     * @param category 包含分类名称和父分类ID的分类对象
     * @return boolean 添加成功返回true，失败返回false
     * @throws SQLException SQL执行异常时会打印堆栈跟踪
     */
    public boolean addCategory(Category category) {
        String sql;
        if(category.getParent_id() == 0){
            sql = "insert into category(category_name) values(?)";
        }else {
            sql = "insert into category(category_name, parent_id) values(?,?)";
        }
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setString(1, category.getCategory_name());
            if(category.getParent_id() != 0){
                ps.setInt(2, category.getParent_id());
            }
            boolean result = ps.executeUpdate() > 0;

            if (result) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int generatedId = generatedKeys.getInt(1);
                    category.setCategory_id(generatedId);
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
     * 更新商品分类信息
     * @param category 包含分类ID、分类名称和父分类ID的分类对象
     * @return boolean 更新成功返回true，失败返回false
     * @throws SQLException SQL执行异常时会打印堆栈跟踪
     */
    public boolean updateCategory(Category category) {
        String sql = "update category set category_name = ?, parent_id = ? where category_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, category.getCategory_name());
            ps.setInt(2, category.getParent_id());
            ps.setInt(3, category.getCategory_id());
            boolean result = ps.executeUpdate() > 0;
            DBUtil.close(null, ps, conn);
            return result;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 根据分类ID删除指定的商品分类
     * @param category_id 要删除的分类记录的唯一标识符
     * @return boolean 删除成功返回true，失败返回false
     * @throws SQLException SQL执行异常时会打印堆栈跟踪
     */
    public boolean deleteCategory(int category_id) {
        String sql = "delete from category where category_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, category_id);
            boolean result = ps.executeUpdate() > 0;
            DBUtil.close(null, ps, conn);
            return result;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 根据分类ID查询单个商品分类
     * @param category_id 分类记录的唯一标识符
     * @return Optional<Category> 包含查询结果的可选分类对象，未找到时返回空Optional
     * @throws SQLException SQL执行异常时会打印堆栈跟踪
     */
    public Optional<Category> getCategoryById(int category_id) {
        String sql = "select * from category where category_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, category_id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Category category = new Category(
                        rs.getInt("category_id"),
                        rs.getString("category_name"),
                        rs.getInt("parent_id")
                );
                DBUtil.close(rs, ps, conn);
                return Optional.of(category);
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
     * 查询所有商品分类
     * @return Optional<List<Category>> 包含所有分类记录的可选列表，出现异常时返回空Optional
     * @throws SQLException SQL执行异常时会打印堆栈跟踪
     */
    public Optional<List<Category>> getAllCategories() {
        String sql = "select * from category";
        Connection conn = DBUtil.getConnection();
        try {
            List<Category> categories = new ArrayList<>();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Category category = new Category(
                        rs.getInt("category_id"),
                        rs.getString("category_name"),
                        rs.getInt("parent_id")
                );
                categories.add(category);
            }
            DBUtil.close(rs, ps, conn);
            return Optional.of(categories);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    /**
     * 根据父分类ID查询所有子分类
     * @param parent_id 父分类的唯一标识符
     * @return Optional<List<Category>> 包含指定父分类下所有子分类的可选列表，出现异常时返回空Optional
     * @throws SQLException SQL执行异常时会打印堆栈跟踪
     */
    public Optional<List<Category>> getAllCategoriesByParentId(int parent_id) {
        String sql = "select * from category where parent_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            List<Category> categories = new ArrayList<>();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, parent_id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Category category = new Category(
                        rs.getInt("category_id"),
                        rs.getString("category_name"),
                        rs.getInt("parent_id")
                );
                categories.add(category);
            }
            DBUtil.close(rs, ps, conn);
            return Optional.of(categories);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    /**
     * 根据分类名称模糊查询分类
     * @param category_name 分类名称关键字
     * @return Optional<List<Category>> 包含匹配分类名称的所有分类记录的可选列表，出现异常时返回空Optional
     * @throws Exception SQL执行异常时会打印堆栈跟踪
     */
    public Optional<List<Category>> getAllCategoriesByCategoryName(String category_name) {
        String sql = "select * from category where category_name like ?";
        Connection conn = DBUtil.getConnection();
        try {
            List<Category> categories = new ArrayList<>();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, "%" + category_name + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Category category = new Category(
                        rs.getInt("category_id"),
                        rs.getString("category_name"),
                        rs.getInt("parent_id")
                );
                categories.add(category);
            }
            DBUtil.close(rs, ps, conn);
            return Optional.of(categories);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }
}
