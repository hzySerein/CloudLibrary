package org.cloudlibrary.constant;

/**
 * 应用常量
 */
public class AppConstants {

    /** Top Books / Active Users 排行榜显示数量 */
    public static final int TOP_RANKING_LIMIT = 10;

    /** 借阅趋势统计月数 */
    public static final int TREND_MONTHS = 6;

    /** 图书封面上传目录（Web 相对路径） */
    public static final String UPLOAD_DIR_BOOKS = "/uploads/books/";

    /** BCrypt 哈希轮数 */
    public static final int BCRYPT_LOG_ROUNDS = 10;

    /** 默认分页大小 */
    public static final int DEFAULT_PAGE_SIZE = 10;

    private AppConstants() {
        // 常量类，禁止实例化
    }
}
