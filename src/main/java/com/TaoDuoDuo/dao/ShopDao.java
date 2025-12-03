package com.TaoDuoDuo.dao;

import com.TaoDuoDuo.entity.Shop;
import com.TaoDuoDuo.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class ShopDao {
    /**
     * 添加一个新的商店到数据库中，添加成功后会对新增的商店进行编号
     *
     * @param shop 包含商店信息的 Shop 对象，需要包含 shop_name 和 owner_id
     * @return 添加成功返回 true，失败返回 false
     */
    public boolean addShop(Shop shop){
        String sql = "insert into shop(shop_name,owner_id) values(?,?)";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setString(1, shop.getShop_name());
            ps.setInt(2, shop.getOwner_id());
            boolean result = ps.executeUpdate() > 0;
            if (result) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int generatedId = generatedKeys.getInt(1);
                    shop.setShop_id(generatedId);
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
     * 更新商店信息
     *
     * @param shop 包含商店信息的 Shop 对象，需要包含 shop_id、shop_name 和 owner_id
     * @return 更新成功返回 true，失败返回 false
     */
    public boolean updateShop(Shop shop){
        String sql = "update shop set shop_name = ?,owner_id = ? where shop_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, shop.getShop_name());
            ps.setInt(2, shop.getOwner_id());
            ps.setInt(3, shop.getShop_id());
            boolean result = ps.executeUpdate() > 0;
            DBUtil.close(null, ps, conn);
            return result;
        }catch (SQLException e){
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 删除商店信息
     *
     * @param shop_id 要删除的商店的编号
     * @return 删除成功返回 true，失败返回 false
     */
    public boolean deleteShop(int shop_id){
        String sql = "delete from shop where shop_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, shop_id);
            boolean result = ps.executeUpdate() > 0;
            DBUtil.close(null, ps, conn);
            return result;
        }catch (SQLException e){
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 根据商店编号获取商店信息
     *
     * @param shop_id 要查询的商店的编号
     * @return 查询成功返回包含商店信息的 Shop 对象，失败返回 null
     */
    public Optional<Shop> getShopById(int shop_id){
        String sql = "select * from shop where shop_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, shop_id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Shop shop = new Shop();
                shop.setShop_id(rs.getInt("shop_id"));
                shop.setShop_name(rs.getString("shop_name"));
                shop.setOwner_id(rs.getInt("owner_id"));
                shop.setCreate_time(rs.getTimestamp("create_time").toLocalDateTime());
                shop.setUpdate_time(rs.getTimestamp("update_time").toLocalDateTime());
                DBUtil.close(rs, ps, conn);
                return Optional.of(shop);
            }else {
                DBUtil.close(rs, ps, conn);
                return Optional.empty();
            }
        }catch (SQLException e){
            e.printStackTrace();
        }
        return Optional.empty();
    }

    /**
     * 根据商店名称获取商店信息
     *
     * @param shop_name 要查询的商店的名称
     * @return 获取成功返回包含商店信息的 Shop 列表，失败返回 null
     */
    public Optional<List<Shop>> getShopByName(String shop_name){
        String sql = "select * from shop where shop_name like ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, "%" + shop_name + "%");
            ResultSet rs = ps.executeQuery();
            List<Shop> shops = new ArrayList<>();
            while (rs.next()) {
                Shop shop = new Shop();
                shop.setShop_id(rs.getInt("shop_id"));
                shop.setShop_name(rs.getString("shop_name"));
                shop.setOwner_id(rs.getInt("owner_id"));
                shop.setCreate_time(rs.getTimestamp("create_time").toLocalDateTime());
                shop.setUpdate_time(rs.getTimestamp("update_time").toLocalDateTime());
                shops.add(shop);
            }
            DBUtil.close(rs, ps, conn);
            return Optional.of(shops);
        }catch (SQLException e){
            e.printStackTrace();
        }
        return Optional.empty();
    }

    /**
     * 根据商店所有者编号获取商店信息
     *
     * @param owner_id 要查询的商店所有者的编号
     * @return 获取成功返回包含商店信息的 Shop 列表，失败返回 null
     */
    public Optional<List<Shop>> getShopByOwnerId(int owner_id){
        String sql = "select * from shop where owner_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, owner_id);
            ResultSet rs = ps.executeQuery();
            List<Shop> shops = new ArrayList<>();
            while (rs.next()) {
                Shop shop = new Shop();
                shop.setShop_id(rs.getInt("shop_id"));
                shop.setShop_name(rs.getString("shop_name"));
                shop.setOwner_id(rs.getInt("owner_id"));
                shop.setCreate_time(rs.getTimestamp("create_time").toLocalDateTime());
                shop.setUpdate_time(rs.getTimestamp("update_time").toLocalDateTime());
                shops.add(shop);
            }
            DBUtil.close(rs, ps, conn);
            return Optional.of(shops);
        }catch (SQLException e){
            e.printStackTrace();
        }
        return Optional.empty();
    }

    /**
     * 获取所有商店信息
     *
     * @return 获取成功返回包含商店信息的 Shop 列表，失败返回 null
     */
    public Optional<List<Shop>> getAllShops(){
        String sql = "select * from shop";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            List<Shop> shops = new ArrayList<>();
            while (rs.next()) {
                Shop shop = new Shop();
                shop.setShop_id(rs.getInt("shop_id"));
                shop.setShop_name(rs.getString("shop_name"));
                shop.setOwner_id(rs.getInt("owner_id"));
                shop.setCreate_time(rs.getTimestamp("create_time").toLocalDateTime());
                shop.setUpdate_time(rs.getTimestamp("update_time").toLocalDateTime());
                shops.add(shop);
            }
            DBUtil.close(rs, ps, conn);
            return Optional.of(shops);
        }catch (SQLException e){
            e.printStackTrace();
        }
        return Optional.empty();
    }
}
