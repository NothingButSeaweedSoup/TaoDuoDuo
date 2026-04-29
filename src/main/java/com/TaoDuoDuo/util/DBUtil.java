package com.TaoDuoDuo.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.*;
import java.util.Properties;

/**
 * 数据库工具类
 * 提供数据库连接和资源关闭的统一管理
 */
public class DBUtil {
    private static String url; // 数据库连接URL
    private static String user; // 数据库用户名
    private static String password; // 数据库密码

    // 静态初始化块，加载数据库配置
    static {
        try {
            // 加载配置文件
            Properties props = new Properties();
            InputStream input = DBUtil.class.getClassLoader().getResourceAsStream("db.properties");
            props.load(input);

            url = props.getProperty("db.url");
            user = props.getProperty("db.user");
            password = props.getProperty("db.password");

            // 加载数据库驱动程序
            Class.forName(props.getProperty("db.driver"));
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 获取数据库连接
     * 
     * @return 数据库连接对象，失败时返回null
     */
    public static Connection getConnection() {
        try {
            return DriverManager.getConnection(url, user, password);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 关闭数据库资源
     * 
     * @param rs   结果集
     * @param ps   预编译语句
     * @param conn 数据库连接
     */
    public static void close(ResultSet rs, PreparedStatement ps, Connection conn) {
        try {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
