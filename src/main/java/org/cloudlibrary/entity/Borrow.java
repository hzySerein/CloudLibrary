package org.cloudlibrary.entity;

import java.util.Date;

public class Borrow {
    private Integer id;
    private Integer bookId;
    private Integer userId;
    private Date borrowTime;
    private Date dueTime;
    private Date returnTime;
    private Integer status; // 0-未归还, 1-已归还, 2-待确认归还
    private Integer overdueDays; // 逾期天数
    private Book book;   // 关联图书信息（JOIN 查询时填充）
    private User user;   // 关联用户信息（JOIN 查询时填充）

    // Getter & Setter
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public Integer getBookId() { return bookId; }
    public void setBookId(Integer bookId) { this.bookId = bookId; }
    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    public Date getBorrowTime() { return borrowTime; }
    public void setBorrowTime(Date borrowTime) { this.borrowTime = borrowTime; }
    public Date getDueTime() { return dueTime; }
    public void setDueTime(Date dueTime) { this.dueTime = dueTime; }
    public Date getReturnTime() { return returnTime; }
    public void setReturnTime(Date returnTime) { this.returnTime = returnTime; }
    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
    public Integer getOverdueDays() { return overdueDays; }
    public void setOverdueDays(Integer overdueDays) { this.overdueDays = overdueDays; }
    public Book getBook() { return book; }
    public void setBook(Book book) { this.book = book; }
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
}