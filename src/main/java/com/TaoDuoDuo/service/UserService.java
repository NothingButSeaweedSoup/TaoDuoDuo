package com.TaoDuoDuo.service;

import com.TaoDuoDuo.dao.UserDao;
import com.TaoDuoDuo.entity.User;
import com.TaoDuoDuo.util.BCryptUtil;

import java.util.Optional;

/**
 * 用户服务类
 * 处理用户相关的业务逻辑，包括登录、注册、密码验证等
 */
public class UserService {
    private UserDao userDao;

    public UserService() {
        this.userDao = new UserDao();
    }

    /**
     * 用户登录验证（支持用户ID/用户名/手机号/邮箱登录）
     * 
     * @param loginId  登录标识（手机号/邮箱）
     * @param password 明文密码
     * @return 登录成功返回用户对象，失败返回Optional.empty()
     */
    public Optional<User> login(String loginId, String password) {
        Optional<User> userOptional = userDao.getUserByPhone(loginId);
        if (userOptional.isEmpty()) {
            userOptional = userDao.getUserByEmail(loginId);
        }

        // 只有当用户存在时才验证密码
        if (userOptional.isPresent() && BCryptUtil.verify(password, userOptional.get().getPassword())) {
            return userOptional;
        }

        return Optional.empty();
    }

    /**
     * 用户注册
     * 
     * @param username 用户名
     * @param password 明文密码
     * @param email    邮箱
     * @param phone    手机号
     * @return 注册成功返回用户对象，失败返回Optional.empty()
     */
    public Optional<User> register(String username, String password, String email, String phone) {
        // 检查用户名是否已存在
        if (userDao.getUserByUsername(username).isPresent()) {
            return Optional.empty();
        }

        // 检查邮箱是否已存在
        if (userDao.getUserByEmail(email).isPresent()) {
            return Optional.empty();
        }

        // 检查手机号是否已存在
        if (userDao.getUserByPhone(phone).isPresent()) {
            return Optional.empty();
        }

        // 创建新用户（密码加密）
        User user = new User(username, BCryptUtil.encrypt(password), email, phone);

        if (userDao.addUser(user)) {
            return Optional.of(user);
        }

        return Optional.empty();
    }

    /**
     * 根据用户ID获取用户信息
     * 
     * @param userId 用户ID
     * @return 用户对象，不存在返回null
     */
    public User getUserById(int userId) {
        Optional<User> userOptional = userDao.getUserById(userId);
        return userOptional.orElse(null);
    }

    /**
     * 根据用户名获取用户信息
     * 
     * @param username 用户名
     * @return 用户对象，不存在返回null
     */
    public User getUserByUsername(String username) {
        Optional<User> userOptional = userDao.getUserByUsername(username);
        return userOptional.orElse(null);
    }

    /**
     * 根据邮箱获取用户信息
     * 
     * @param email 邮箱
     * @return 用户对象，不存在返回null
     */
    public User getUserByEmail(String email) {
        Optional<User> userOptional = userDao.getUserByEmail(email);
        return userOptional.orElse(null);
    }

    /**
     * 根据手机号获取用户信息
     * 
     * @param phone 手机号
     * @return 用户对象，不存在返回null
     */
    public User getUserByPhone(String phone) {
        Optional<User> userOptional = userDao.getUserByPhone(phone);
        return userOptional.orElse(null);
    }

    /**
     * 验证用户密码
     * 
     * @param username 用户名
     * @param password 明文密码
     * @return 密码正确返回true，否则返回false
     */
    public boolean verifyPassword(String username, String password) {
        Optional<User> userOptional = userDao.getUserByUsername(username);
        if (userOptional.isPresent()) {
            return BCryptUtil.verify(password, userOptional.get().getPassword());
        }
        return false;
    }

    /**
     * 更新用户个人信息
     * 
     * @param userId   用户ID
     * @param username 新用户名（null表示不修改）
     * @param password 新密码（null表示不修改）
     * @param email    新邮箱（null表示不修改）
     * @param phone    新手机号（null表示不修改）
     * @return 更新成功返回true，否则返回false
     */
    public boolean updateUserProfile(int userId, String username, String password, String email, String phone) {
        Optional<User> userOptional = userDao.getUserById(userId);
        if (userOptional.isEmpty()) {
            return false;
        }

        User user = userOptional.get();

        // 更新用户名
        if (username != null && !username.trim().isEmpty()) {
            user.setUsername(username.trim());
        }

        // 更新密码（需要加密）
        if (password != null && !password.trim().isEmpty()) {
            user.setPassword(BCryptUtil.encrypt(password));
        }

        // 更新邮箱
        if (email != null && !email.trim().isEmpty()) {
            user.setEmail(email.trim());
        }

        // 更新手机号
        if (phone != null && !phone.trim().isEmpty()) {
            user.setPhone(phone.trim());
        }

        return userDao.updateUser(user);
    }
}
