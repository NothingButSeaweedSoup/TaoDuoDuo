package com.TaoDuoDuo.dao;

import com.TaoDuoDuo.entity.Cart;
import com.TaoDuoDuo.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class CartDao {

    /**
     * 向购物车表中添加新的购物车记录，添加成功后会对购物车ID进行赋值
     * 
     * @param cart 包含用户ID、商品ID和数量的购物车对象
     * @return boolean 添加成功返回true，失败返回false
     * @throws Exception SQL执行异常时会打印堆栈跟踪
     */
    public boolean addCart(Cart cart) {
        Connection conn = DBUtil.getConnection();
        String sql = "INSERT INTO cart(user_id, product_id, quantity) VALUES(?, ?, ?)";
        try {
            PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setInt(1, cart.getUser_id());
            ps.setInt(2, cart.getProduct_id());
            ps.setInt(3, cart.getQuantity());

            boolean result = ps.executeUpdate() > 0;

            if (result) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int generatedId = generatedKeys.getInt(1);
                    cart.setCart_id(generatedId);
                }
                generatedKeys.close();
            }

            DBUtil.close(null, ps, conn);
            return result;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 更新购物车中的记录信息
     * 
     * @param cart 包含购物车ID、用户ID、商品ID和数量的购物车对象
     * @return boolean 更新成功返回true，失败返回false
     * @throws Exception SQL执行异常时会打印堆栈跟踪
     */
    public boolean updateCart(Cart cart) {
        Connection conn = DBUtil.getConnection();
        String sql = "update cart set user_id = ? ,product_id = ? ,quantity = ? where cart_id = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, cart.getUser_id());
            ps.setInt(2, cart.getProduct_id());
            ps.setInt(3, cart.getQuantity());
            ps.setInt(4, cart.getCart_id());
            boolean result = ps.executeUpdate() > 0;
            DBUtil.close(null, ps, conn);
            return result;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 根据购物车ID删除指定的购物车记录
     * 
     * @param cart_id 要删除的购物车记录的唯一标识符
     * @return boolean 删除成功返回true，失败返回false
     * @throws Exception SQL执行异常时会打印堆栈跟踪
     */
    public boolean deleteCart(int cart_id) {
        Connection conn = DBUtil.getConnection();
        String sql = "delete from cart where cart_id = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, cart_id);
            boolean result = ps.executeUpdate() > 0;
            DBUtil.close(null, ps, conn);
            return result;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 根据用户ID删除该用户的所有购物车记录
     * 
     * @param user_id 用户的唯一标识符
     * @return boolean 删除成功返回true，失败返回false
     * @throws Exception SQL执行异常时会打印堆栈跟踪
     */
    public boolean deleteCartByUserId(int user_id) {
        Connection conn = DBUtil.getConnection();
        String sql = "delete from cart where user_id = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, user_id);
            boolean result = ps.executeUpdate() > 0;
            DBUtil.close(null, ps, conn);
            return result;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 根据购物车ID查询单条购物车记录
     * 
     * @param cart_id 购物车记录的唯一标识符
     * @return Optional<Cart> 包含查询结果的可选购物车对象，未找到时返回空Optional
     * @throws Exception SQL执行异常时会打印堆栈跟踪
     */
    public Optional<Cart> getCartById(int cart_id) {
        Connection conn = DBUtil.getConnection();
        String sql = "select * from cart where cart_id = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, cart_id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Cart cart = new Cart(
                        rs.getInt("cart_id"),
                        rs.getInt("user_id"),
                        rs.getInt("product_id"),
                        rs.getInt("quantity"),
                        rs.getTimestamp("add_time").toLocalDateTime());
                DBUtil.close(rs, ps, conn);
                return Optional.of(cart);
            } else {
                DBUtil.close(rs, ps, conn);
                return Optional.empty();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    /**
     * 根据用户ID查询该用户的所有购物车记录
     * 
     * @param user_id 用户的唯一标识符
     * @return Optional<List<Cart>> 包含该用户所有购物车记录的可选列表，未找到时返回空Optional
     * @throws Exception SQL执行异常时会打印堆栈跟踪
     */
    public Optional<List<Cart>> getCartByUserId(int user_id) {
        Connection conn = DBUtil.getConnection();
        String sql = "select * from cart where user_id = ?";
        try {
            List<Cart> carts = new ArrayList<>();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, user_id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Cart cart = new Cart(
                        rs.getInt("cart_id"),
                        rs.getInt("user_id"),
                        rs.getInt("product_id"),
                        rs.getInt("quantity"),
                        rs.getTimestamp("add_time").toLocalDateTime());
                carts.add(cart);
            }
            DBUtil.close(rs, ps, conn);
            return Optional.of(carts);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    /**
     * 查询购物车表中的所有记录
     * 
     * @return Optional<List<Cart>> 包含所有购物车记录的可选列表，出现异常时返回空Optional
     * @throws Exception SQL执行异常时会打印堆栈跟踪
     */
    public Optional<List<Cart>> getAllCarts() {
        Connection conn = DBUtil.getConnection();
        String sql = "select * from cart";
        try {
            List<Cart> carts = new ArrayList<>();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Cart cart = new Cart(
                        rs.getInt("cart_id"),
                        rs.getInt("user_id"),
                        rs.getInt("product_id"),
                        rs.getInt("quantity"),
                        rs.getTimestamp("add_time").toLocalDateTime());
                carts.add(cart);
            }
            DBUtil.close(rs, ps, conn);
            return Optional.of(carts);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    /**
     * 根据用户ID和商品ID查询购物车记录
     * 
     * @param user_id    用户ID
     * @param product_id 商品ID
     * @return Optional<Cart> 包含查询结果的可选购物车对象，未找到时返回空Optional
     */
    public Optional<Cart> getCartByUserIdAndProductId(int user_id, int product_id) {
        Connection conn = DBUtil.getConnection();
        String sql = "select * from cart where user_id = ? and product_id = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, user_id);
            ps.setInt(2, product_id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Cart cart = new Cart(
                        rs.getInt("cart_id"),
                        rs.getInt("user_id"),
                        rs.getInt("product_id"),
                        rs.getInt("quantity"),
                        rs.getTimestamp("add_time").toLocalDateTime());
                DBUtil.close(rs, ps, conn);
                return Optional.of(cart);
            } else {
                DBUtil.close(rs, ps, conn);
                return Optional.empty();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }
}
