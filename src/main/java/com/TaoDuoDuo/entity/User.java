package com.TaoDuoDuo.entity;

import java.time.LocalDateTime;

/**
 * 用户实体类
 * 对应数据库中的user表
 */
public class User {
    private int user_id; // 用户ID，主键
    private String username; // 用户名
    private String password; // 密码（加密后）
    private String email; // 邮箱
    private String phone; // 手机号
    private LocalDateTime create_time; // 创建时间
    private LocalDateTime update_time; // 更新时间

    // 默认构造函数
    public User() {
    }

    // 带用户ID的构造函数
    public User(int user_id, String username, String password, String email, String phone) {
        this.user_id = user_id;
        this.username = username;
        this.password = password;
        this.email = email;
        this.phone = phone;
    }

    // 完整构造函数
    public User(int user_id, String username, String password, String email, String phone, LocalDateTime create_time,
            LocalDateTime update_time) {
        this.user_id = user_id;
        this.username = username;
        this.password = password;
        this.email = email;
        this.phone = phone;
        this.create_time = create_time;
        this.update_time = update_time;
    }

    // 注册用构造函数（不包含ID）
    public User(String username, String password, String email, String phone) {
        this.username = username;
        this.password = password;
        this.email = email;
        this.phone = phone;
    }

    // 注册用构造函数（包含时间）
    public User(String username, String password, String email, String phone, LocalDateTime create_time,
            LocalDateTime update_time) {
        this.username = username;
        this.password = password;
        this.email = email;
        this.phone = phone;
        this.create_time = create_time;
        this.update_time = update_time;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public LocalDateTime getCreate_time() {
        return create_time;
    }

    public void setCreate_time(LocalDateTime create_time) {
        this.create_time = create_time;
    }

    public LocalDateTime getUpdate_time() {
        return update_time;
    }

    public void setUpdate_time(LocalDateTime update_time) {
        this.update_time = update_time;
    }
}
