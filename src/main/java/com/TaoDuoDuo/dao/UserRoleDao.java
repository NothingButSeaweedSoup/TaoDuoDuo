package com.TaoDuoDuo.dao;

import com.TaoDuoDuo.entity.UserRole;
import com.TaoDuoDuo.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class UserRoleDao {

    /**
     * 根据用户ID获取用户的所有角色
     * 
     * @param userId 用户ID
     * @return 用户角色列表
     */
    public Optional<List<UserRole>> getUserRolesByUserId(int userId) {
        String sql = "select * from user_role where user_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            List<UserRole> userRoles = new ArrayList<>();
            while (rs.next()) {
                UserRole userRole = new UserRole();
                userRole.setUser_role_id(rs.getInt("id"));
                userRole.setUser_id(rs.getInt("user_id"));
                userRole.setRole_id(rs.getInt("role_id"));
                // 数据库中没有create_time字段，设置为null或当前时间
                userRole.setCreate_time(null);
                userRoles.add(userRole);
            }
            DBUtil.close(rs, ps, conn);
            return Optional.of(userRoles);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    /**
     * 获取用户拥有的角色数量
     * 
     * @param userId 用户ID
     * @return 角色数量
     */
    public int getUserRoleCount(int userId) {
        String sql = "select count(*) from user_role where user_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int count = rs.getInt(1);
                DBUtil.close(rs, ps, conn);
                return count;
            }
            DBUtil.close(rs, ps, conn);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * 检查用户是否拥有指定角色
     * 
     * @param userId 用户ID
     * @param roleId 角色ID
     * @return true表示拥有该角色
     */
    public boolean hasRole(int userId, int roleId) {
        String sql = "select count(*) from user_role where user_id = ? and role_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, roleId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                boolean hasRole = rs.getInt(1) > 0;
                DBUtil.close(rs, ps, conn);
                return hasRole;
            }
            DBUtil.close(rs, ps, conn);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 为用户添加角色
     * 
     * @param userRole 用户角色关系
     * @return 添加成功返回true
     */
    public boolean addUserRole(UserRole userRole) {
        String sql = "insert into user_role(user_id, role_id) values(?, ?)";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userRole.getUser_id());
            ps.setInt(2, userRole.getRole_id());
            boolean result = ps.executeUpdate() > 0;
            DBUtil.close(null, ps, conn);
            return result;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 删除用户角色
     * 
     * @param userId 用户ID
     * @param roleId 角色ID
     * @return 删除成功返回true
     */
    public boolean removeUserRole(int userId, int roleId) {
        String sql = "delete from user_role where user_id = ? and role_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, roleId);
            boolean result = ps.executeUpdate() > 0;
            DBUtil.close(null, ps, conn);
            return result;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}