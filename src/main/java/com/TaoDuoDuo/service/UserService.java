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
     * 用户登录验证
     * 
     * @param username 用户名
     * @param password 明文密码
     * @return 登录成功返回用户对象，失败返回Optional.empty()
     */
    public Optional<User> login(String username, String password) {
        Optional<User> userOptional = userDao.getUserByUsername(username);

        if (!userOptional.isPresent()) {
            return Optional.empty();
        }

        User user = userOptional.get();

        if (BCryptUtil.verify(password, user.getPassword())) {
            return Optional.of(user);
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
