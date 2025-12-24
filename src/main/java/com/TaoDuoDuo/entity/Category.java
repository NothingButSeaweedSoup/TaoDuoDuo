package com.TaoDuoDuo.entity;

public class Category {
    private int category_id;
    private String category_name;
    private int parent_id;

    public Category(String category_name, int parent_id) {
        this.category_name = category_name;
        this.parent_id = parent_id;
    }

    public Category(String category_name) {
        this.category_name = category_name;
    }

    public Category(int category_id, String category_name, int parent_id) {
        this.category_id = category_id;
        this.category_name = category_name;
        this.parent_id = parent_id;
    }

    public Category() {
    }

    public int getCategory_id() {
        return category_id;
    }

    public void setCategory_id(int category_id) {
        this.category_id = category_id;
    }

    public String getCategory_name() {
        return category_name;
    }

    public void setCategory_name(String category_name) {
        this.category_name = category_name;
    }

    public int getParent_id() {
        return parent_id;
    }

    public void setParent_id(int parent_id) {
        this.parent_id = parent_id;
    }
}
