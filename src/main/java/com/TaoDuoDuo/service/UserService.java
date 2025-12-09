package com.TaoDuoDuo.service;

import com.TaoDuoDuo.dao.UserDao;
import com.TaoDuoDuo.entity.User;
import com.TaoDuoDuo.util.BCryptUtil;

import java.util.Optional;

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
}
