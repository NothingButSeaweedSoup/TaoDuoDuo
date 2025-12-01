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
    public boolean addCart(Cart cart) {
        Connection conn = DBUtil.getConnection();
        String sql = "insert into cart(user_id, product_id, quantity) values(?,?,?)";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, cart.getUser_id());
            ps.setInt(2, cart.getProduct_id());
            ps.setInt(3, cart.getQuantity());
            boolean result = ps.executeUpdate() > 0;
            DBUtil.close(null, ps, conn);
            return result;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

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
                        rs.getTimestamp("add_time").toLocalDateTime()
                );
                DBUtil.close(rs, ps, conn);
                return Optional.of(cart);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

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
                        rs.getTimestamp("add_time").toLocalDateTime()
                );
                carts.add(cart);
            }
            DBUtil.close(rs, ps, conn);
            return Optional.of(carts);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

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
                        rs.getTimestamp("add_time").toLocalDateTime()
                );
                carts.add(cart);
            }
            DBUtil.close(rs, ps, conn);
            return Optional.of(carts);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }
}
