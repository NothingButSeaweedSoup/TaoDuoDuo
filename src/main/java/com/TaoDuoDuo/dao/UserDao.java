package com.TaoDuoDuo.dao;

import com.TaoDuoDuo.entity.User;
import com.TaoDuoDuo.util.DBUtil;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * 用户数据访问对象
 * 负责用户相关的数据库操作
 */
public class UserDao {
    /**
     * 添加新用户到数据库，添加成功后对user_id进行赋值
     * 
     * @param user 包含用户信息的对象，密码应已加密
     * @return 添加成功返回true，否则返回false
     */
    public boolean addUser(User user) {
        String sql = "insert into user(username,password,email,phone) values(?,?,?,?)";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPhone());
            boolean result = ps.executeUpdate() > 0;
            if (result) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int generatedId = generatedKeys.getInt(1);
                    user.setUser_id(generatedId);
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
     * 更新用户信息
     * 
     * @param user 包含用户信息的对象，密码应已加密
     * @return 更新成功返回true，否则返回false
     */
    public boolean updateUser(User user) {
        String sql = "update user set username = ?,password = ?,email = ?,phone = ? where user_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPhone());
            ps.setInt(5, user.getUser_id());
            boolean result = ps.executeUpdate() > 0;
            DBUtil.close(null, ps, conn);
            return result;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 删除用户
     * 
     * @param user_id 用户id
     * @return 删除成功返回true，否则返回false
     */
    public boolean deleteUser(int user_id) {
        String sql = "delete from user where user_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, user_id);
            boolean result = ps.executeUpdate() > 0;
            DBUtil.close(null, ps, conn);
            return result;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 根据用户id获取用户信息
     * 
     * @param user_id 用户id
     * @return 用户信息，如果用户不存在则返回null
     */
    public Optional<User> getUserById(int user_id) {
        String sql = "select * from user where user_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, user_id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User(
                        rs.getInt("user_id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getTimestamp("create_time").toLocalDateTime(),
                        rs.getTimestamp("update_time").toLocalDateTime());
                DBUtil.close(rs, ps, conn);
                return Optional.of(user);
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
     * 根据用户名获取用户信息
     * 
     * @param username 用户名
     * @return 用户信息，如果用户不存在则返回null
     */
    public Optional<User> getUserByUsername(String username) {
        String sql = "select * from user where username = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User(
                        rs.getInt("user_id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getTimestamp("create_time").toLocalDateTime(),
                        rs.getTimestamp("update_time").toLocalDateTime());
                DBUtil.close(rs, ps, conn);
                return Optional.of(user);
            } else {
                DBUtil.close(rs, ps, conn);
                return Optional.empty();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    public Optional<User> getUserByEmail(String email) {
        String sql = "select * from user where email = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User(
                        rs.getInt("user_id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getTimestamp("create_time").toLocalDateTime(),
                        rs.getTimestamp("update_time").toLocalDateTime());
                DBUtil.close(rs, ps, conn);
                return Optional.of(user);
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
     * 根据手机号获取用户信息
     * 
     * @param phone 手机号
     * @return 用户信息，如果用户不存在则返回null
     */
    public Optional<User> getUserByPhone(String phone) {
        String sql = "select * from user where phone = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, phone);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User(
                        rs.getInt("user_id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getTimestamp("create_time").toLocalDateTime(),
                        rs.getTimestamp("update_time").toLocalDateTime());
                DBUtil.close(rs, ps, conn);
                return Optional.of(user);
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
     * 获取所有用户信息
     * 
     * @return 所有用户信息
     */
    public Optional<List<User>> getAllUsers() {
        String sql = "select * from user";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            List<User> users = new ArrayList<>();
            while (rs.next()) {
                User user = new User(
                        rs.getInt("user_id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getTimestamp("create_time").toLocalDateTime(),
                        rs.getTimestamp("update_time").toLocalDateTime());
                users.add(user);
            }
            DBUtil.close(rs, ps, conn);
            return Optional.of(users);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    /**
     * 管理员删除用户
     * 
     * @param userId 用户ID
     * @return 删除成功返回true
     */
    public boolean adminDeleteUser(int userId) {
        String sql = "delete from user where user_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            boolean result = ps.executeUpdate() > 0;
            DBUtil.close(null, ps, conn);
            return result;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}