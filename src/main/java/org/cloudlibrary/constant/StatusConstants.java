package org.cloudlibrary.constant;

/**
 * 通用状态常量（用于 Book.status 和 User.status）
 */
public class StatusConstants {

    /** 禁用 */
    public static final int DISABLED = 0;

    /** 启用 */
    public static final int ENABLED = 1;

    private StatusConstants() {
        // 常量类，禁止实例化
    }
}
