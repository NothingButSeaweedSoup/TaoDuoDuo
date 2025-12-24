package com.TaoDuoDuo.dao;

import com.TaoDuoDuo.entity.Product;
import com.TaoDuoDuo.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class ProductDao {

    /**
     * 添加新的商品信息
     * 
     * @param product 包含商品名称、描述、价格、库存、分类ID和店铺ID的商品对象
     * @return boolean 添加成功返回true，失败返回false
     * @throws SQLException SQL执行异常时会打印堆栈跟踪
     */
    public boolean addProduct(Product product) {
        String sql = "insert into product(product_name, description, price, stock, category_id, shop_id, product_listing) values(?,?,?,?,?,?,?)";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setString(1, product.getProduct_name());
            ps.setString(2, product.getDescription());
            ps.setDouble(3, product.getPrice());
            ps.setInt(4, product.getStock());
            ps.setInt(5, product.getCategory_id());
            ps.setInt(6, product.getShop_id());
            ps.setBoolean(7, product.isProduct_listing());
            boolean result = ps.executeUpdate() > 0;
            if (result) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int generatedId = generatedKeys.getInt(1);
                    product.setProduct_id(generatedId);
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
     * 更新商品信息
     * 
     * @param product 包含商品ID及需要更新信息的商品对象
     * @return boolean 更新成功返回true，失败返回false
     * @throws SQLException SQL执行异常时会打印堆栈跟踪
     */
    public boolean updateProduct(Product product) {
        String sql = "update product set product_name = ?, description = ?, price = ?, stock = ?, category_id = ?, shop_id = ?, product_listing = ? where product_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, product.getProduct_name());
            ps.setString(2, product.getDescription());
            ps.setDouble(3, product.getPrice());
            ps.setInt(4, product.getStock());
            ps.setInt(5, product.getCategory_id());
            ps.setInt(6, product.getShop_id());
            ps.setBoolean(7, product.isProduct_listing());
            ps.setInt(8, product.getProduct_id());
            boolean result = ps.executeUpdate() > 0;
            DBUtil.close(null, ps, conn);
            return result;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 根据商品ID删除指定商品
     * 
     * @param product_id 要删除的商品记录的唯一标识符
     * @return boolean 删除成功返回true，失败返回false
     * @throws SQLException SQL执行异常时会打印堆栈跟踪
     */
    public boolean deleteProduct(int product_id) {
        String sql = "delete from product where product_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, product_id);
            boolean result = ps.executeUpdate() > 0;
            DBUtil.close(null, ps, conn);
            return result;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 根据商品ID查询单个商品信息
     * 
     * @param product_id 商品记录的唯一标识符
     * @return Optional<Product> 包含查询结果的可选商品对象，未找到时返回空Optional
     * @throws SQLException SQL执行异常时会打印堆栈跟踪
     */
    public Optional<Product> getProductById(int product_id) {
        String sql = "select * from product where product_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, product_id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Product product = new Product();
                product.setProduct_id(rs.getInt("product_id"));
                product.setProduct_name(rs.getString("product_name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setStock(rs.getInt("stock"));
                product.setCategory_id(rs.getInt("category_id"));
                product.setShop_id(rs.getInt("shop_id"));
                product.setProduct_listing(rs.getBoolean("product_listing"));
                DBUtil.close(rs, ps, conn);
                return Optional.of(product);
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
     * 根据分类ID查询该分类下的所有商品
     * 
     * @param category_id 分类的唯一标识符
     * @return Optional<List<Product>> 包含指定分类下所有商品的可选列表，未找到时返回空Optional
     * @throws SQLException SQL执行异常时会打印堆栈跟踪
     */
    public Optional<List<Product>> getProductsByCategoryId(int category_id) {
        String sql = "select * from product where category_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, category_id);
            ResultSet rs = ps.executeQuery();
            List<Product> products = new ArrayList<>();
            while (rs.next()) {
                Product product = new Product();
                product.setProduct_id(rs.getInt("product_id"));
                product.setProduct_name(rs.getString("product_name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setStock(rs.getInt("stock"));
                product.setCategory_id(rs.getInt("category_id"));
                product.setShop_id(rs.getInt("shop_id"));
                product.setProduct_listing(rs.getBoolean("product_listing"));
                products.add(product);
            }
            DBUtil.close(rs, ps, conn);
            return Optional.of(products);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    /**
     * 根据店铺ID查询该店铺下的所有商品
     * 
     * @param shop_id 店铺的唯一标识符
     * @return Optional<List<Product>> 包含指定店铺下所有商品的可选列表，未找到时返回空Optional
     * @throws SQLException SQL执行异常时会打印堆栈跟踪
     */
    public Optional<List<Product>> getProductsByShopId(int shop_id) {
        String sql = "select * from product where shop_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, shop_id);
            ResultSet rs = ps.executeQuery();
            List<Product> products = new ArrayList<>();
            while (rs.next()) {
                Product product = new Product();
                product.setProduct_id(rs.getInt("product_id"));
                product.setProduct_name(rs.getString("product_name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setStock(rs.getInt("stock"));
                product.setCategory_id(rs.getInt("category_id"));
                product.setShop_id(rs.getInt("shop_id"));
                product.setProduct_listing(rs.getBoolean("product_listing"));
                products.add(product);
            }
            DBUtil.close(rs, ps, conn);
            return Optional.of(products);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    /**
     * 根据商品名称模糊查询商品
     * 
     * @param product_name 商品名称关键字
     * @return Optional<List<Product>> 包含匹配商品名称的所有商品记录的可选列表，未找到时返回空Optional
     * @throws SQLException SQL执行异常时会打印堆栈跟踪
     */
    public Optional<List<Product>> getProductsByName(String product_name) {
        String sql = "select * from product where product_name like ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, "%" + product_name + "%");
            ResultSet rs = ps.executeQuery();
            List<Product> products = new ArrayList<>();
            while (rs.next()) {
                Product product = new Product();
                product.setProduct_id(rs.getInt("product_id"));
                product.setProduct_name(rs.getString("product_name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setStock(rs.getInt("stock"));
                product.setCategory_id(rs.getInt("category_id"));
                product.setShop_id(rs.getInt("shop_id"));
                product.setProduct_listing(rs.getBoolean("product_listing"));
                products.add(product);
            }
            DBUtil.close(rs, ps, conn);
            return Optional.of(products);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    /**
     * 更新商品上架状态
     * 
     * @param product_id 商品ID
     * @param listing    上架状态（true=上架，false=下架）
     * @return boolean 更新成功返回true，失败返回false
     * @throws SQLException SQL执行异常时会打印堆栈跟踪
     */
    public boolean updateProductListing(int product_id, boolean listing) {
        String sql = "update product set product_listing = ? where product_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setBoolean(1, listing);
            ps.setInt(2, product_id);
            boolean result = ps.executeUpdate() > 0;
            DBUtil.close(null, ps, conn);
            return result;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 查询所有上架的商品
     * 
     * @return Optional<List<Product>> 包含所有上架商品的可选列表，未找到时返回空Optional
     * @throws SQLException SQL执行异常时会打印堆栈跟踪
     */
    public Optional<List<Product>> getListedProducts() {
        String sql = "select * from product where product_listing = true";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            List<Product> products = new ArrayList<>();
            while (rs.next()) {
                Product product = new Product();
                product.setProduct_id(rs.getInt("product_id"));
                product.setProduct_name(rs.getString("product_name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setStock(rs.getInt("stock"));
                product.setCategory_id(rs.getInt("category_id"));
                product.setShop_id(rs.getInt("shop_id"));
                product.setProduct_listing(rs.getBoolean("product_listing"));
                products.add(product);
            }
            DBUtil.close(rs, ps, conn);
            return Optional.of(products);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    /**
     * 根据分类ID查询该分类下所有上架的商品
     * 
     * @param category_id 分类的唯一标识符
     * @return Optional<List<Product>> 包含指定分类下所有上架商品的可选列表，未找到时返回空Optional
     * @throws SQLException SQL执行异常时会打印堆栈跟踪
     */
    public Optional<List<Product>> getListedProductsByCategoryId(int category_id) {
        String sql = "select * from product where category_id = ? and product_listing = true";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, category_id);
            ResultSet rs = ps.executeQuery();
            List<Product> products = new ArrayList<>();
            while (rs.next()) {
                Product product = new Product();
                product.setProduct_id(rs.getInt("product_id"));
                product.setProduct_name(rs.getString("product_name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setStock(rs.getInt("stock"));
                product.setCategory_id(rs.getInt("category_id"));
                product.setShop_id(rs.getInt("shop_id"));
                product.setProduct_listing(rs.getBoolean("product_listing"));
                products.add(product);
            }
            DBUtil.close(rs, ps, conn);
            return Optional.of(products);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    /**
     * 获取随机上架商品，最多返回指定数量
     * 
     * @param limit 最大返回数量
     * @return Optional<List<Product>> 包含随机上架商品的可选列表，未找到时返回空Optional
     * @throws SQLException SQL执行异常时会打印堆栈跟踪
     */
    public Optional<List<Product>> getRandomListedProducts(int limit) {
        String sql = "select * from product where product_listing = true order by rand() limit ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            List<Product> products = new ArrayList<>();
            while (rs.next()) {
                Product product = new Product();
                product.setProduct_id(rs.getInt("product_id"));
                product.setProduct_name(rs.getString("product_name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setStock(rs.getInt("stock"));
                product.setCategory_id(rs.getInt("category_id"));
                product.setShop_id(rs.getInt("shop_id"));
                product.setProduct_listing(rs.getBoolean("product_listing"));
                products.add(product);
            }
            DBUtil.close(rs, ps, conn);
            return Optional.of(products);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    /**
     * 扣除商品库存（支付成功后调用）
     * 使用乐观锁防止并发问题
     * 
     * @param product_id 商品ID
     * @param quantity   扣除数量
     * @return StockUpdateResult 库存更新结果
     */
    public StockUpdateResult decreaseStock(int product_id, int quantity) {
        if (quantity <= 0) {
            return new StockUpdateResult(false, "扣除数量必须大于0", 0);
        }

        String sql = "UPDATE product SET stock = stock - ? WHERE product_id = ? AND stock >= ? AND product_listing = true";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, quantity);
            ps.setInt(2, product_id);
            ps.setInt(3, quantity);

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                // 查询更新后的库存
                int newStock = getCurrentStock(product_id);
                DBUtil.close(null, ps, conn);
                return new StockUpdateResult(true, "库存扣除成功", newStock);
            } else {
                DBUtil.close(null, ps, conn);
                // 检查具体失败原因
                Optional<Product> productOpt = getProductById(product_id);
                if (!productOpt.isPresent()) {
                    return new StockUpdateResult(false, "商品不存在", 0);
                }

                Product product = productOpt.get();
                if (!product.isProduct_listing()) {
                    return new StockUpdateResult(false, "商品已下架", product.getStock());
                }

                if (product.getStock() < quantity) {
                    return new StockUpdateResult(false, "库存不足，当前库存：" + product.getStock(), product.getStock());
                }

                return new StockUpdateResult(false, "库存扣除失败", product.getStock());
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return new StockUpdateResult(false, "数据库操作异常：" + e.getMessage(), 0);
        }
    }

    /**
     * 增加商品库存（退款或取消订单时调用）
     * 
     * @param product_id 商品ID
     * @param quantity   增加数量
     * @return StockUpdateResult 库存更新结果
     */
    public StockUpdateResult increaseStock(int product_id, int quantity) {
        if (quantity <= 0) {
            return new StockUpdateResult(false, "增加数量必须大于0", 0);
        }

        String sql = "UPDATE product SET stock = stock + ? WHERE product_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, quantity);
            ps.setInt(2, product_id);

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                int newStock = getCurrentStock(product_id);
                DBUtil.close(null, ps, conn);
                return new StockUpdateResult(true, "库存增加成功", newStock);
            } else {
                DBUtil.close(null, ps, conn);
                return new StockUpdateResult(false, "商品不存在", 0);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return new StockUpdateResult(false, "数据库操作异常：" + e.getMessage(), 0);
        }
    }

    /**
     * 批量扣除库存（多商品订单）
     * 
     * @param stockUpdates 库存更新列表
     * @return BatchStockUpdateResult 批量更新结果
     */
    public BatchStockUpdateResult batchDecreaseStock(List<StockUpdate> stockUpdates) {
        BatchStockUpdateResult result = new BatchStockUpdateResult();
        Connection conn = DBUtil.getConnection();

        try {
            // 开启事务
            conn.setAutoCommit(false);

            for (StockUpdate update : stockUpdates) {
                StockUpdateResult singleResult = decreaseStockInTransaction(conn, update.getProductId(),
                        update.getQuantity());
                result.addResult(update.getProductId(), singleResult);

                if (!singleResult.isSuccess()) {
                    // 如果任何一个商品库存扣除失败，回滚整个事务
                    conn.rollback();
                    result.setOverallSuccess(false);
                    result.setErrorMessage("商品ID " + update.getProductId() + " 库存扣除失败：" + singleResult.getMessage());
                    return result;
                }
            }

            // 所有商品库存扣除成功，提交事务
            conn.commit();
            result.setOverallSuccess(true);

        } catch (SQLException e) {
            try {
                conn.rollback();
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
            e.printStackTrace();
            result.setOverallSuccess(false);
            result.setErrorMessage("批量库存扣除异常：" + e.getMessage());
        } finally {
            try {
                conn.setAutoCommit(true);
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return result;
    }

    /**
     * 在事务中扣除库存（内部方法）
     */
    private StockUpdateResult decreaseStockInTransaction(Connection conn, int product_id, int quantity)
            throws SQLException {
        String sql = "UPDATE product SET stock = stock - ? WHERE product_id = ? AND stock >= ? AND product_listing = true";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, quantity);
        ps.setInt(2, product_id);
        ps.setInt(3, quantity);

        int affectedRows = ps.executeUpdate();
        ps.close();

        if (affectedRows > 0) {
            int newStock = getCurrentStockInTransaction(conn, product_id);
            return new StockUpdateResult(true, "库存扣除成功", newStock);
        } else {
            // 检查失败原因
            Optional<Product> productOpt = getProductById(product_id);
            if (!productOpt.isPresent()) {
                return new StockUpdateResult(false, "商品不存在", 0);
            }

            Product product = productOpt.get();
            if (!product.isProduct_listing()) {
                return new StockUpdateResult(false, "商品已下架", product.getStock());
            }

            if (product.getStock() < quantity) {
                return new StockUpdateResult(false, "库存不足，当前库存：" + product.getStock(), product.getStock());
            }

            return new StockUpdateResult(false, "库存扣除失败", product.getStock());
        }
    }

    /**
     * 获取当前库存数量
     */
    private int getCurrentStock(int product_id) {
        String sql = "SELECT stock FROM product WHERE product_id = ?";
        Connection conn = DBUtil.getConnection();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, product_id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int stock = rs.getInt("stock");
                DBUtil.close(rs, ps, conn);
                return stock;
            }
            DBUtil.close(rs, ps, conn);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * 在事务中获取当前库存数量
     */
    private int getCurrentStockInTransaction(Connection conn, int product_id) throws SQLException {
        String sql = "SELECT stock FROM product WHERE product_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, product_id);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            int stock = rs.getInt("stock");
            rs.close();
            ps.close();
            return stock;
        }
        rs.close();
        ps.close();
        return 0;
    }

    /**
     * 库存更新结果类
     */
    public static class StockUpdateResult {
        private final boolean success;
        private final String message;
        private final int currentStock;

        public StockUpdateResult(boolean success, String message, int currentStock) {
            this.success = success;
            this.message = message;
            this.currentStock = currentStock;
        }

        public boolean isSuccess() {
            return success;
        }

        public String getMessage() {
            return message;
        }

        public int getCurrentStock() {
            return currentStock;
        }
    }

    /**
     * 库存更新项类
     */
    public static class StockUpdate {
        private final int productId;
        private final int quantity;

        public StockUpdate(int productId, int quantity) {
            this.productId = productId;
            this.quantity = quantity;
        }

        public int getProductId() {
            return productId;
        }

        public int getQuantity() {
            return quantity;
        }
    }

    /**
     * 批量库存更新结果类
     */
    public static class BatchStockUpdateResult {
        private boolean overallSuccess = true;
        private String errorMessage = "";
        private final java.util.Map<Integer, StockUpdateResult> results = new java.util.HashMap<>();

        public void addResult(int productId, StockUpdateResult result) {
            results.put(productId, result);
        }

        public boolean isOverallSuccess() {
            return overallSuccess;
        }

        public void setOverallSuccess(boolean success) {
            this.overallSuccess = success;
        }

        public String getErrorMessage() {
            return errorMessage;
        }

        public void setErrorMessage(String message) {
            this.errorMessage = message;
        }

        public java.util.Map<Integer, StockUpdateResult> getResults() {
            return results;
        }
    }
}