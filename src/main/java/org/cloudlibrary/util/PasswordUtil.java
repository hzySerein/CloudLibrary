package org.cloudlibrary.util;

import org.cloudlibrary.constant.AppConstants;
import org.mindrot.jbcrypt.BCrypt;

/**
 * 密码工具类，使用BCrypt算法进行密码哈希和验证
 */
public class PasswordUtil {

    /**
     * 对明文密码进行BCrypt哈希
     *
     * @param plainPassword 明文密码
     * @return BCrypt哈希后的密码字符串
     */
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(AppConstants.BCRYPT_LOG_ROUNDS));
    }

    /**
     * 验证明文密码是否匹配哈希密码
     * 同时支持BCrypt哈希密码和旧的明文密码（用于平滑迁移）
     *
     * @param plainPassword  用户输入的明文密码
     * @param storedPassword 数据库中存储的密码（可能是BCrypt哈希或明文）
     * @return 是否匹配
     */
    public static boolean checkPassword(String plainPassword, String storedPassword) {
        if (storedPassword == null || plainPassword == null) {
            return false;
        }
        // BCrypt哈希密码以 "$2a$"、"$2b$" 或 "$2y$" 开头，长度为60
        if (isBCryptHash(storedPassword)) {
            return BCrypt.checkpw(plainPassword, storedPassword);
        }
        // 兼容旧的明文密码
        return plainPassword.equals(storedPassword);
    }

    /**
     * 判断存储的密码是否已经是BCrypt哈希格式
     *
     * @param storedPassword 数据库中存储的密码
     * @return 是否是BCrypt哈希
     */
    public static boolean isBCryptHash(String storedPassword) {
        return storedPassword != null
                && storedPassword.length() == 60
                && (storedPassword.startsWith("$2a$")
                    || storedPassword.startsWith("$2b$")
                    || storedPassword.startsWith("$2y$"));
    }
}
