package org.cloudlibrary.constant;

/**
 * 借阅状态常量
 */
public class BorrowStatus {

    /** 未归还 */
    public static final int UNRETURNED = 0;

    /** 已归还 */
    public static final int RETURNED = 1;

    /** 待确认归还（用户已申请归还，等待管理员确认） */
    public static final int PENDING_CONFIRM = 2;

    private BorrowStatus() {
        // 常量类，禁止实例化
    }
}
