package org.cloudlibrary.entity;

import java.util.Date;

public class Book {
    private Integer id;
    private String name;
    private String author;
    private String isbn;
    private Integer stock;
    private String type;
    private Integer status;
    private String cover;  // 封面图片路径
    private String description; // 图书介绍
    private Date createTime;
    private Integer borrowCount; // 借阅次数，用于排行榜
    
    // 无参构造函数
    public Book() {
        this.createTime = new Date(); // 初始化创建时间为当前时间
    }

    // Getter & Setter
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }
    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }
    public Integer getStock() { return stock; }
    public void setStock(Integer stock) { this.stock = stock; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }
    public String getCover() { return cover; }
    public void setCover(String cover) { this.cover = cover; }
    public Integer getBorrowCount() { return borrowCount; }
    public void setBorrowCount(Integer borrowCount) { this.borrowCount = borrowCount; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}