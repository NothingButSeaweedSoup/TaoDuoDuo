package com.TaoDuoDuo.dao;

import com.TaoDuoDuo.entity.Review;
import com.TaoDuoDuo.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class ReviewDao {
    /**
     * 向数据库中添加一条新的评价记录，添加成功后，会对新的评价ID进行赋值
     *
     * @param review 包含评价信息的 Review 对象，需包含订单ID、用户ID、评价内容和评分
     * @return 添加成功返回 true，失败返回 false
     */
    public boolean addReview(Review review) {
        String sql = "insert into review(order_id, user_id, content, rating) values(?,?,?,?)";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setInt(1, review.getOrder_id());
            ps.setInt(2, review.getUser_id());
            ps.setString(3, review.getContent());
            ps.setInt(4, review.getRating());
            boolean result = ps.executeUpdate() > 0;
            if (result) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int generatedId = generatedKeys.getInt(1);
                    review.setReview_id(generatedId);
                }
                generatedKeys.close();
            }
            DBUtil.close(null, ps, conn);
            return result;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 更新一条评价记录，更新成功返回 true，失败返回 false
     *
     * @param review 包含评价信息的 Review 对象，需包含评价ID、订单ID、用户ID、评价内容和评分
     * @return 更新成功返回 true，失败返回 false
     */
    public boolean updateReview(Review review) {
        String sql = "update review set order_id = ?, user_id = ?, content = ?, rating = ? where review_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, review.getOrder_id());
            ps.setInt(2, review.getUser_id());
            ps.setString(3, review.getContent());
            ps.setInt(4, review.getRating());
            ps.setInt(5, review.getReview_id());
            boolean result = ps.executeUpdate() > 0;
            DBUtil.close(null, ps, conn);
            return result;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 删除一条评价记录，删除成功返回 true，失败返回 false
     *
     * @param review_id 评价ID
     * @return 删除成功返回 true，失败返回 false
     */
    public boolean deleteReview(int review_id) {
        String sql = "delete from review where review_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, review_id);
            boolean result = ps.executeUpdate() > 0;
            DBUtil.close(null, ps, conn);
            return result;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 根据评价ID获取一条评价记录，获取成功返回 Optional 对象，失败返回 Optional.empty()
     *
     * @param review_id 评价ID
     * @return 获取成功返回 Optional 对象，失败返回 Optional.empty()
     */
    public Optional<Review> getReviewById(int review_id) {
        String sql = "select * from review where review_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, review_id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Review review = new Review();
                review.setReview_id(rs.getInt("review_id"));
                review.setOrder_id(rs.getInt("order_id"));
                review.setUser_id(rs.getInt("user_id"));
                review.setContent(rs.getString("content"));
                review.setRating(rs.getInt("rating"));
                review.setCreate_time(rs.getTimestamp("create_time").toLocalDateTime());
                DBUtil.close(rs, ps, conn);
                return Optional.of(review);
            } else {
                DBUtil.close(rs, ps, conn);
                return Optional.empty();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    /**
     * 根据订单ID获取一条评价记录，获取成功返回 Optional 对象，失败返回 Optional.empty()
     *
     * @param order_id 订单ID
     * @return 获取成功返回 Optional 对象，失败返回 Optional.empty()
     */
    public Optional<Review> getReviewByOrderId(int order_id) {
        String sql = "select * from review where order_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, order_id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Review review = new Review();
                review.setReview_id(rs.getInt("review_id"));
                review.setOrder_id(rs.getInt("order_id"));
                review.setUser_id(rs.getInt("user_id"));
                review.setContent(rs.getString("content"));
                review.setRating(rs.getInt("rating"));
                review.setCreate_time(rs.getTimestamp("create_time").toLocalDateTime());
                DBUtil.close(rs, ps, conn);
                return Optional.of(review);
            } else {
                DBUtil.close(rs, ps, conn);
                return Optional.empty();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    /**
     * 根据用户ID获取该用户所有的评价记录，获取成功返回 Optional 列表，失败返回 Optional.empty()
     *
     * @param user_id 用户ID
     * @return 获取成功返回 Optional 列表，失败返回 Optional.empty()
     */
    public Optional<List<Review>> getReviewsByUserId(int user_id) {
        String sql = "select * from review where user_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, user_id);
            ResultSet rs = ps.executeQuery();
            List<Review> reviews = new ArrayList<>();
            while (rs.next()) {
                Review review = new Review();
                review.setReview_id(rs.getInt("review_id"));
                review.setOrder_id(rs.getInt("order_id"));
                review.setUser_id(rs.getInt("user_id"));
                review.setContent(rs.getString("content"));
                review.setRating(rs.getInt("rating"));
                review.setCreate_time(rs.getTimestamp("create_time").toLocalDateTime());
                reviews.add(review);
            }
            DBUtil.close(rs, ps, conn);
            return Optional.of(reviews);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    /**
     * 根据商品ID获取该商品的所有评价记录
     * 通过订单详情表关联查询
     *
     * @param product_id 商品ID
     * @return 获取成功返回 Optional 列表，失败返回 Optional.empty()
     */
    public Optional<List<Review>> getReviewsByProductId(int product_id) {
        String sql = "SELECT r.* FROM review r " +
                "INNER JOIN `order` o ON r.order_id = o.order_id " +
                "INNER JOIN order_detail od ON o.order_id = od.order_id " +
                "WHERE od.product_id = ? " +
                "ORDER BY r.create_time DESC";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, product_id);
            ResultSet rs = ps.executeQuery();
            List<Review> reviews = new ArrayList<>();
            while (rs.next()) {
                Review review = new Review();
                review.setReview_id(rs.getInt("review_id"));
                review.setOrder_id(rs.getInt("order_id"));
                review.setUser_id(rs.getInt("user_id"));
                review.setContent(rs.getString("content"));
                review.setRating(rs.getInt("rating"));
                review.setCreate_time(rs.getTimestamp("create_time").toLocalDateTime());
                reviews.add(review);
            }
            DBUtil.close(rs, ps, conn);
            return Optional.of(reviews);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    /**
     * 根据商品ID获取该商品的评价统计信息
     *
     * @param product_id 商品ID
     * @return 评价统计信息：[总评价数, 平均评分, 5星数, 4星数, 3星数, 2星数, 1星数]
     */
    public Optional<ReviewStatistics> getReviewStatisticsByProductId(int product_id) {
        String sql = "SELECT " +
                "COUNT(*) as total_count, " +
                "AVG(r.rating) as avg_rating, " +
                "SUM(CASE WHEN r.rating = 5 THEN 1 ELSE 0 END) as five_star, " +
                "SUM(CASE WHEN r.rating = 4 THEN 1 ELSE 0 END) as four_star, " +
                "SUM(CASE WHEN r.rating = 3 THEN 1 ELSE 0 END) as three_star, " +
                "SUM(CASE WHEN r.rating = 2 THEN 1 ELSE 0 END) as two_star, " +
                "SUM(CASE WHEN r.rating = 1 THEN 1 ELSE 0 END) as one_star " +
                "FROM review r " +
                "INNER JOIN `order` o ON r.order_id = o.order_id " +
                "INNER JOIN order_detail od ON o.order_id = od.order_id " +
                "WHERE od.product_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, product_id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                ReviewStatistics stats = new ReviewStatistics(
                        rs.getInt("total_count"),
                        rs.getDouble("avg_rating"),
                        rs.getInt("five_star"),
                        rs.getInt("four_star"),
                        rs.getInt("three_star"),
                        rs.getInt("two_star"),
                        rs.getInt("one_star"));
                DBUtil.close(rs, ps, conn);
                return Optional.of(stats);
            } else {
                DBUtil.close(rs, ps, conn);
                return Optional.empty();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    /**
     * 评价统计信息类
     */
    public static class ReviewStatistics {
        private final int totalCount;
        private final double avgRating;
        private final int fiveStar;
        private final int fourStar;
        private final int threeStar;
        private final int twoStar;
        private final int oneStar;

        public ReviewStatistics(int totalCount, double avgRating, int fiveStar, int fourStar,
                int threeStar, int twoStar, int oneStar) {
            this.totalCount = totalCount;
            this.avgRating = avgRating;
            this.fiveStar = fiveStar;
            this.fourStar = fourStar;
            this.threeStar = threeStar;
            this.twoStar = twoStar;
            this.oneStar = oneStar;
        }

        public int getTotalCount() {
            return totalCount;
        }

        public double getAvgRating() {
            return avgRating;
        }

        public int getFiveStar() {
            return fiveStar;
        }

        public int getFourStar() {
            return fourStar;
        }

        public int getThreeStar() {
            return threeStar;
        }

        public int getTwoStar() {
            return twoStar;
        }

        public int getOneStar() {
            return oneStar;
        }
    }
}
