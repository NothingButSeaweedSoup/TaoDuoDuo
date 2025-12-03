package com.TaoDuoDuo.dao;

import com.TaoDuoDuo.entity.OrderDetail;
import com.TaoDuoDuo.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class OrderDetailDao {
    public boolean addOrderDetail(OrderDetail orderDetail) {
        String sql = "insert into order_detail(order_id, product_id, quantity, price) values(?,?,?,?)";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setInt(1, orderDetail.getOrder_id());
            ps.setInt(2, orderDetail.getProduct_id());
            ps.setInt(3, orderDetail.getQuantity());
            ps.setDouble(4, orderDetail.getPrice());
            boolean result = ps.executeUpdate() > 0;
            if(result){
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if(generatedKeys.next()){
                    int generatedId = generatedKeys.getInt(1);
                    orderDetail.setOrder_detail_id(generatedId);
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

    public boolean updateOrderDetail(OrderDetail orderDetail) {
        String sql = "update order_detail set order_id = ?, product_id = ?, quantity = ?, price = ? where order_detail_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, orderDetail.getOrder_id());
            ps.setInt(2, orderDetail.getProduct_id());
            ps.setInt(3, orderDetail.getQuantity());
            ps.setDouble(4, orderDetail.getPrice());
            ps.setInt(5, orderDetail.getOrder_detail_id());
            boolean result = ps.executeUpdate() > 0;
            DBUtil.close(null, ps, conn);
            return result;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteOrderDetail(int order_detail_id) {
        String sql = "delete from order_detail where order_detail_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, order_detail_id);
            boolean result = ps.executeUpdate() > 0;
            DBUtil.close(null, ps, conn);
            return result;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Optional<OrderDetail> getOrderDetailById(int order_detail_id) {
        String sql = "select * from order_detail where order_detail_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, order_detail_id);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) {
                OrderDetail orderDetail = new OrderDetail(
                        rs.getInt("order_detail_id"),
                        rs.getInt("order_id"),
                        rs.getInt("product_id"),
                        rs.getInt("quantity"),
                        rs.getDouble("price")
                );
                DBUtil.close(rs, ps, conn);
                return Optional.of(orderDetail);
            }else {
                DBUtil.close(rs, ps, conn);
                return Optional.empty();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    public Optional<OrderDetail> getOrderDetailByOrderId(int order_id) {
        String sql = "select * from order_detail where order_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, order_id);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) {
                OrderDetail orderDetail = new OrderDetail(
                        rs.getInt("order_detail_id"),
                        rs.getInt("order_id"),
                        rs.getInt("product_id"),
                        rs.getInt("quantity"),
                        rs.getDouble("price")
                );
                DBUtil.close(rs, ps, conn);
                return Optional.of(orderDetail);
            }else {
                DBUtil.close(rs, ps, conn);
                return Optional.empty();
            }
        }catch (SQLException e){
            e.printStackTrace();
        }
        return Optional.empty();
    }

    public Optional<List<OrderDetail>> getOrderDetailByProductId(int product_id) {
        String sql = "select * from order_detail where product_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, product_id);
            ResultSet rs = ps.executeQuery();
            List<OrderDetail> orderDetails = new ArrayList<>();
            while(rs.next()) {
                OrderDetail orderDetail = new OrderDetail(
                        rs.getInt("order_detail_id"),
                        rs.getInt("order_id"),
                        rs.getInt("product_id"),
                        rs.getInt("quantity"),
                        rs.getDouble("price")
                );
                orderDetails.add(orderDetail);
            }
            DBUtil.close(rs, ps, conn);
            return Optional.of(orderDetails);
        }catch (SQLException e){
            e.printStackTrace();
        }
        return Optional.empty();
    }

    public Optional<List<OrderDetail>> getAllOrderDetail() {
        String sql = "select * from order_detail";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            List<OrderDetail> orderDetails = new ArrayList<>();
            while(rs.next()) {
                OrderDetail orderDetail = new OrderDetail(
                        rs.getInt("order_detail_id"),
                        rs.getInt("order_id"),
                        rs.getInt("product_id"),
                        rs.getInt("quantity"),
                        rs.getDouble("price")
                );
                orderDetails.add(orderDetail);
            }
            DBUtil.close(rs, ps, conn);
            return Optional.of(orderDetails);
        }catch (SQLException e){
            e.printStackTrace();
        }
        return Optional.empty();
    }
}
