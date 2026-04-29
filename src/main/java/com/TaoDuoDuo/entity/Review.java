package com.TaoDuoDuo.entity;

import java.time.LocalDateTime;

public class Review {
    private int review_id;
    private int order_id;
    private int user_id;
    private String content;
    private int rating;
    private LocalDateTime create_time;

    public Review(int order_id, int user_id, String content, int rating) {
        this.order_id = order_id;
        this.user_id = user_id;
        this.content = content;
        this.rating = rating;
    }

    public Review(int order_id, int user_id, String content, int rating, LocalDateTime create_time) {
        this.order_id = order_id;
        this.user_id = user_id;
        this.content = content;
        this.rating = rating;
        this.create_time = create_time;
    }

    public Review(int review_id, int order_id, int user_id, String content, int rating, LocalDateTime create_time) {
        this.review_id = review_id;
        this.order_id = order_id;
        this.user_id = user_id;
        this.content = content;
        this.rating = rating;
        this.create_time = create_time;
    }

    public Review() {
    }

    public int getReview_id() {
        return review_id;
    }

    public void setReview_id(int review_id) {
        this.review_id = review_id;
    }

    public int getOrder_id() {
        return order_id;
    }

    public void setOrder_id(int order_id) {
        this.order_id = order_id;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public LocalDateTime getCreate_time() {
        return create_time;
    }

    public void setCreate_time(LocalDateTime create_time) {
        this.create_time = create_time;
    }
}
