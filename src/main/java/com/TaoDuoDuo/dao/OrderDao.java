package com.TaoDuoDuo.dao;

import com.TaoDuoDuo.entity.Order;
import com.TaoDuoDuo.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;
import java.util.Optional;

public class OrderDao {
    /**
     * 添加订单记录到数据库
     * 
     * @param order 订单对象，包含用户ID、店铺ID、订单状态和总金额
     *              添加成功后会自动设置生成的订单ID
     * @return 添加成功返回true，失败返回false
     */
    public boolean addOrder(Order order) {
        String sql;
        if (order.getOrder_status() == null) {
            sql = "insert into `order`(user_id,shop_id,total_amount) values(?,?,?)";
        } else {
            sql = "insert into `order`(user_id,shop_id,order_status,total_amount) values(?,?,?,?)";
        }
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setInt(1, order.getUser_id());
            ps.setInt(2, order.getShop_id());
            if (order.getOrder_status() != null) {
                ps.setString(3, order.getOrder_status());
                ps.setDouble(4, order.getTotal_amount());
            } else {
                ps.setDouble(3, order.getTotal_amount());
            }
            boolean result = ps.executeUpdate() > 0;
            if (result) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int generatedId = generatedKeys.getInt(1);
                    order.setOrder_id(generatedId);
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
     * 更新订单记录信息
     * 
     * @param order 订单对象，必须包含订单ID以及要更新的用户ID、店铺ID、订单状态、总金额和支付宝订单号
     * @return 更新成功返回true，失败返回false
     */
    public boolean updateOrder(Order order) {
        String sql = "update `order` set user_id=?,shop_id=?,order_status=?,total_amount=?,alipay_order_no=?,update_time=NOW() where order_id=?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, order.getUser_id());
            ps.setInt(2, order.getShop_id());
            ps.setString(3, order.getOrder_status());
            ps.setDouble(4, order.getTotal_amount());
            ps.setString(5, order.getAlipay_order_no());
            ps.setInt(6, order.getOrder_id());
            boolean result = ps.executeUpdate() > 0;
            DBUtil.close(null, ps, conn);
            return result;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 根据订单ID删除订单记录
     * 
     * @param order_id 要删除的订单ID
     * @return 删除成功返回true，失败返回false
     */
    public boolean deleteOrder(int order_id) {
        String sql = "delete from `order` where order_id=?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, order_id);
            boolean result = ps.executeUpdate() > 0;
            DBUtil.close(null, ps, conn);
            return result;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 根据订单ID查询单个订单信息
     * 
     * @param order_id 订单ID
     * @return 包含订单信息的Optional对象，如果未找到则返回空Optional
     */
    public Optional<Order> getOrderById(int order_id) {
        String sql = "select * from `order` where order_id=?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, order_id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Order order = new Order(
                        rs.getInt("order_id"),
                        rs.getInt("user_id"),
                        rs.getInt("shop_id"),
                        rs.getString("order_status"),
                        rs.getDouble("total_amount"),
                        rs.getTimestamp("create_time") != null ? rs.getTimestamp("create_time").toLocalDateTime()
                                : null,
                        rs.getTimestamp("update_time") != null ? rs.getTimestamp("update_time").toLocalDateTime()
                                : null,
                        rs.getString("alipay_order_no"));
                DBUtil.close(rs, ps, conn);
                return Optional.of(order);
            } else {
                DBUtil.close(null, ps, conn);
                return Optional.empty();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    /**
     * 根据用户ID查询该用户的所有订单
     * 
     * @param user_id 用户ID
     * @return 包含订单列表的Optional对象，如果未找到则返回空Optional
     */
    public Optional<List<Order>> getOrderByUserId(int user_id) {
        String sql = "select * from `order` where user_id=? order by create_time desc";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, user_id);
            ResultSet rs = ps.executeQuery();
            List<Order> orders = new ArrayList<>();
            while (rs.next()) {
                Order order = new Order(
                        rs.getInt("order_id"),
                        rs.getInt("user_id"),
                        rs.getInt("shop_id"),
                        rs.getString("order_status"),
                        rs.getDouble("total_amount"),
                        rs.getTimestamp("create_time") != null ? rs.getTimestamp("create_time").toLocalDateTime()
                                : null,
                        rs.getTimestamp("update_time") != null ? rs.getTimestamp("update_time").toLocalDateTime()
                                : null,
                        rs.getString("alipay_order_no"));
                orders.add(order);
            }
            DBUtil.close(rs, ps, conn);
            return Optional.of(orders);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    /**
     * 根据用户ID和订单状态查询该用户的订单
     * 
     * @param user_id      用户ID
     * @param order_status 订单状态
     * @return 包含符合条件订单列表的Optional对象，如果未找到则返回空Optional
     */
    public Optional<List<Order>> getOrderByUserId(int user_id, String order_status) {
        String sql = "select * from `order` where user_id=? and order_status=?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, user_id);
            ps.setString(2, order_status);
            ResultSet rs = ps.executeQuery();
            List<Order> orders = new ArrayList<>();
            while (rs.next()) {
                Order order = new Order(
                        rs.getInt("order_id"),
                        rs.getInt("user_id"),
                        rs.getInt("shop_id"),
                        rs.getString("order_status"),
                        rs.getDouble("total_amount"),
                        rs.getTimestamp("create_time") != null ? rs.getTimestamp("create_time").toLocalDateTime()
                                : null,
                        rs.getTimestamp("update_time") != null ? rs.getTimestamp("update_time").toLocalDateTime()
                                : null,
                        rs.getString("alipay_order_no"));
                orders.add(order);
            }
            DBUtil.close(rs, ps, conn);
            return Optional.of(orders);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    /**
     * 根据店铺ID查询该店铺的所有订单
     * 
     * @param shop_id 店铺ID
     * @return 包含订单列表的Optional对象，如果未找到则返回空Optional
     */
    public Optional<List<Order>> getOrderByShopId(int shop_id) {
        String sql = "select * from `order` where shop_id=?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, shop_id);
            ResultSet rs = ps.executeQuery();
            List<Order> orders = new ArrayList<>();
            while (rs.next()) {
                Order order = new Order(
                        rs.getInt("order_id"),
                        rs.getInt("user_id"),
                        rs.getInt("shop_id"),
                        rs.getString("order_status"),
                        rs.getDouble("total_amount"),
                        rs.getTimestamp("create_time") != null ? rs.getTimestamp("create_time").toLocalDateTime()
                                : null,
                        rs.getTimestamp("update_time") != null ? rs.getTimestamp("update_time").toLocalDateTime()
                                : null,
                        rs.getString("alipay_order_no"));
                orders.add(order);
            }
            DBUtil.close(rs, ps, conn);
            return Optional.of(orders);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    /**
     * 根据店铺ID和订单状态查询该店铺的订单
     * 
     * @param shop_id      店铺ID
     * @param order_status 订单状态
     * @return 包含符合条件订单列表的Optional对象，如果未找到则返回空Optional
     */
    public Optional<List<Order>> getOrderByShopId(int shop_id, String order_status) {
        String sql = "select * from `order` where shop_id=? and order_status=?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, shop_id);
            ps.setString(2, order_status);
            ResultSet rs = ps.executeQuery();
            List<Order> orders = new ArrayList<>();
            while (rs.next()) {
                Order order = new Order(
                        rs.getInt("order_id"),
                        rs.getInt("user_id"),
                        rs.getInt("shop_id"),
                        rs.getString("order_status"),
                        rs.getDouble("total_amount"),
                        rs.getTimestamp("create_time") != null ? rs.getTimestamp("create_time").toLocalDateTime()
                                : null,
                        rs.getTimestamp("update_time") != null ? rs.getTimestamp("update_time").toLocalDateTime()
                                : null,
                        rs.getString("alipay_order_no"));
                orders.add(order);
            }
            DBUtil.close(rs, ps, conn);
            return Optional.of(orders);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    /**
     * 根据支付宝订单号查询订单
     * 
     * @param alipayOrderNo 支付宝订单号
     * @return 包含订单信息的Optional对象，如果未找到则返回空Optional
     */
    public Optional<Order> getOrderByAlipayOrderNo(String alipayOrderNo) {
        String sql = "select * from `order` where alipay_order_no=?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, alipayOrderNo);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Order order = new Order(
                        rs.getInt("order_id"),
                        rs.getInt("user_id"),
                        rs.getInt("shop_id"),
                        rs.getString("order_status"),
                        rs.getDouble("total_amount"),
                        rs.getTimestamp("create_time") != null ? rs.getTimestamp("create_time").toLocalDateTime()
                                : null,
                        rs.getTimestamp("update_time") != null ? rs.getTimestamp("update_time").toLocalDateTime()
                                : null,
                        rs.getString("alipay_order_no"));
                DBUtil.close(rs, ps, conn);
                return Optional.of(order);
            } else {
                DBUtil.close(rs, ps, conn);
                return Optional.empty();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    /**
     * 根据支付宝订单号更新订单支付状态
     * 
     * @param alipayOrderNo 支付宝订单号
     * @param newStatus     新的订单状态
     * @return 更新成功返回true，失败返回false
     */
    public boolean updateOrderStatusByAlipayOrderNo(String alipayOrderNo, String newStatus) {
        String sql = "update `order` set order_status=?, update_time=NOW() where alipay_order_no=?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, newStatus);
            ps.setString(2, alipayOrderNo);
            boolean result = ps.executeUpdate() > 0;
            DBUtil.close(null, ps, conn);
            return result;
        } catch (SQLException e) {
            System.err.println("更新订单状态失败: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 根据订单ID更新订单支付状态
     * 
     * @param orderId   订单ID
     * @param newStatus 新的订单状态
     * @return 更新成功返回true，失败返回false
     */
    public boolean updateOrderStatus(int orderId, String newStatus) {
        String sql = "update `order` set order_status=?, update_time=NOW() where order_id=?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, newStatus);
            ps.setInt(2, orderId);
            boolean result = ps.executeUpdate() > 0;
            DBUtil.close(null, ps, conn);
            return result;
        } catch (SQLException e) {
            System.err.println("更新订单状态失败: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
}