package com.TaoDuoDuo.entity;

import java.time.LocalDateTime;

public class UserRole {
    private int user_role_id;
    private int user_id;
    private int role_id;
    private LocalDateTime create_time;

    public UserRole() {
    }

    public UserRole(int user_id, int role_id) {
        this.user_id = user_id;
        this.role_id = role_id;
    }

    public UserRole(int user_role_id, int user_id, int role_id, LocalDateTime create_time) {
        this.user_role_id = user_role_id;
        this.user_id = user_id;
        this.role_id = role_id;
        this.create_time = create_time;
    }

    public int getUser_role_id() {
        return user_role_id;
    }

    public void setUser_role_id(int user_role_id) {
        this.user_role_id = user_role_id;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public int getRole_id() {
        return role_id;
    }

    public void setRole_id(int role_id) {
        this.role_id = role_id;
    }

    public LocalDateTime getCreate_time() {
        return create_time;
    }

    public void setCreate_time(LocalDateTime create_time) {
        this.create_time = create_time;
    }
}