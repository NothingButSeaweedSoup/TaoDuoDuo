package com.TaoDuoDuo.entity;

import java.time.LocalDateTime;

public class Shop {
    private int shop_id;
    private String shop_name;
    private int owner_id;
    private LocalDateTime create_time;
    private LocalDateTime update_time;

    public Shop() {
    }

    public Shop(String shop_name, int owner_id, LocalDateTime create_time, LocalDateTime update_time) {
        this.shop_name = shop_name;
        this.owner_id = owner_id;
        this.create_time = create_time;
        this.update_time = update_time;
    }

    public Shop(String shop_name, int owner_id) {
        this.shop_name = shop_name;
        this.owner_id = owner_id;
    }

    public Shop(int shop_id, String shop_name, int owner_id, LocalDateTime create_time, LocalDateTime update_time) {
        this.shop_id = shop_id;
        this.shop_name = shop_name;
        this.owner_id = owner_id;
        this.create_time = create_time;
        this.update_time = update_time;
    }

    public int getShop_id() {
        return shop_id;
    }

    public void setShop_id(int shop_id) {
        this.shop_id = shop_id;
    }

    public String getShop_name() {
        return shop_name;
    }

    public void setShop_name(String shop_name) {
        this.shop_name = shop_name;
    }

    public int getOwner_id() {
        return owner_id;
    }

    public void setOwner_id(int owner_id) {
        this.owner_id = owner_id;
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
