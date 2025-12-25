package com.TaoDuoDuo.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * BCrypt密码加密工具类
 * 提供密码的加密和验证功能，使用BCrypt算法确保安全性
 */
public class BCryptUtil {

    /**
     * 加密字符串（自动生成盐值）
     * 
     * @param rawString 原始字符串（如密码）
     * @return 加密后的字符串（直接存数据库）
     */
    public static String encrypt(String rawString) {
        if (rawString == null || rawString.isEmpty()) {
            throw new IllegalArgumentException("输入字符串不能为空");
        }
        // 默认成本因子=10（安全且性能平衡）
        return BCrypt.hashpw(rawString, BCrypt.gensalt());
    }

    /**
     * 验证字符串是否匹配
     * 
     * @param rawString     原始字符串（用户输入）
     * @param encodedString 加密后的字符串（数据库中的值）
     * @return true=匹配，false=不匹配
     */
    public static boolean verify(String rawString, String encodedString) {
        if (rawString == null || encodedString == null) {
            return false;
        }
        return BCrypt.checkpw(rawString, encodedString);
    }
}