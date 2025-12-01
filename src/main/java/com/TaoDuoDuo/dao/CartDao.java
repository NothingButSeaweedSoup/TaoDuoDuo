package com.TaoDuoDuo.dao;

import com.TaoDuoDuo.entity.Cart;
import com.TaoDuoDuo.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;

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
        String sql = "update cart set user_id=?,product_id=?,quantity=? where ";
    }
}
