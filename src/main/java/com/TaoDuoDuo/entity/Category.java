package com.TaoDuoDuo.entity;

/**
 * 商品分类实体类
 * 对应数据库中的category表，支持分层分类结构
 */
public class Category {
    private int category_id; // 分类ID，主键
    private String category_name; // 分类名称
    private int parent_id; // 父分类ID，0表示根分类

    // 创建子分类用构造函数
    public Category(String category_name, int parent_id) {
        this.category_name = category_name;
        this.parent_id = parent_id;
    }

    // 创建根分类用构造函数
    public Category(String category_name) {
        this.category_name = category_name;
    }

    // 完整构造函数
    public Category(int category_id, String category_name, int parent_id) {
        this.category_id = category_id;
        this.category_name = category_name;
        this.parent_id = parent_id;
    }

    // 默认构造函数
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
