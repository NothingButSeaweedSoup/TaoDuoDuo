package com.TaoDuoDuo.service;

import com.TaoDuoDuo.dao.UserRoleDao;
import com.TaoDuoDuo.entity.UserRole;

import java.util.List;
import java.util.Optional;

public class UserRoleService {
    private UserRoleDao userRoleDao;

    public UserRoleService() {
        this.userRoleDao = new UserRoleDao();
    }

    /**
     * 获取用户拥有的角色数量
     * 
     * @param userId 用户ID
     * @return 角色数量
     */
    public int getUserRoleCount(int userId) {
        return userRoleDao.getUserRoleCount(userId);
    }

    /**
     * 检查用户是否可以切换身份（拥有2个或以上角色）
     * 
     * @param userId 用户ID
     * @return true表示可以切换身份
     */
    public boolean canSwitchRole(int userId) {
        return getUserRoleCount(userId) >= 2;
    }

    /**
     * 获取用户的所有角色
     * 
     * @param userId 用户ID
     * @return 用户角色列表
     */
    public Optional<List<UserRole>> getUserRoles(int userId) {
        return userRoleDao.getUserRolesByUserId(userId);
    }

    /**
     * 检查用户是否拥有指定角色
     * 
     * @param userId 用户ID
     * @param roleId 角色ID (1-用户，2-商家，3-管理员)
     * @return true表示拥有该角色
     */
    public boolean hasRole(int userId, int roleId) {
        return userRoleDao.hasRole(userId, roleId);
    }

    /**
     * 为用户添加角色
     * 
     * @param userId 用户ID
     * @param roleId 角色ID
     * @return 添加成功返回true
     */
    public boolean addUserRole(int userId, int roleId) {
        // 检查是否已经拥有该角色
        if (hasRole(userId, roleId)) {
            return true; // 已经拥有，返回成功
        }

        UserRole userRole = new UserRole(userId, roleId);
        return userRoleDao.addUserRole(userRole);
    }

    /**
     * 移除用户角色
     * 
     * @param userId 用户ID
     * @param roleId 角色ID
     * @return 移除成功返回true
     */
    public boolean removeUserRole(int userId, int roleId) {
        return userRoleDao.removeUserRole(userId, roleId);
    }
}