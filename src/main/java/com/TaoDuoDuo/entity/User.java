package com.TaoDuoDuo.entity;

import java.time.LocalDateTime;

public class User {
    private int user_id;
    private String username;
    private String password;
    private String email;
    private String phone;
    private LocalDateTime create_time;
    private LocalDateTime update_time;

    public User() {
    }

    public User(int user_id, String username, String password, String email, String phone) {
        this.user_id = user_id;
        this.username = username;
        this.password = password;
        this.email = email;
        this.phone = phone;
    }


    public User(int user_id, String username, String password, String email, String phone, LocalDateTime create_time, LocalDateTime update_time) {
        this.user_id = user_id;
        this.username = username;
        this.password = password;
        this.email = email;
        this.phone = phone;
        this.create_time = create_time;
        this.update_time = update_time;
    }

    public User(String username, String password, String email, String phone) {
        this.username = username;
        this.password = password;
        this.email = email;
        this.phone = phone;
    }

    public User(String username, String password, String email, String phone, LocalDateTime create_time, LocalDateTime update_time) {
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
