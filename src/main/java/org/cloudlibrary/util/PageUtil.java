package org.cloudlibrary.util;

import java.util.List;

/**
 * 分页工具类
 */
public class PageUtil<T> {
    // 当前页码
    private int currentPage;
    // 每页显示条数
    private int pageSize;
    // 总记录数
    private int totalCount;
    // 总页数
    private int totalPage;
    // 数据列表
    private List<T> list;
    // 页面显示的页码数量
    private int pageShowCount = 5;

    public PageUtil() {}

    public PageUtil(int currentPage, int pageSize, int totalCount, List<T> list) {
        if (pageSize <= 0) {
            pageSize = 10;
        }
        this.pageSize = pageSize;
        this.totalCount = Math.max(0, totalCount);
        this.list = list;
        // 计算总页数
        this.totalPage = (this.totalCount + this.pageSize - 1) / this.pageSize;
        // 确保当前页在合理范围内
        if (currentPage < 1) {
            currentPage = 1;
        }
        if (currentPage > this.totalPage && this.totalPage > 0) {
            currentPage = this.totalPage;
        }
        this.currentPage = currentPage;
    }

    // 静态辅助方法：安全计算数据库分页偏移量
    public static int getOffset(Integer page, Integer size) {
        int validPage = (page == null || page < 1) ? 1 : page;
        int validSize = (size == null || size < 1) ? 10 : size;
        return (validPage - 1) * validSize;
    }

    public static int getValidPage(Integer page) {
        return (page == null || page < 1) ? 1 : page;
    }

    public static int getValidSize(Integer size) {
        return (size == null || size < 1) ? 10 : size;
    }

    // 获取开始页码
    public int getStartPage() {
        int startPage = currentPage - (pageShowCount / 2);
        if (startPage < 1) {
            startPage = 1;
        }
        int endPage = startPage + pageShowCount - 1;
        if (endPage > totalPage) {
            endPage = totalPage;
            startPage = endPage - pageShowCount + 1;
            if (startPage < 1) {
                startPage = 1;
            }
        }
        return startPage;
    }

    // 获取结束页码
    public int getEndPage() {
        int startPage = getStartPage();
        int endPage = startPage + pageShowCount - 1;
        if (endPage > totalPage) {
            endPage = totalPage;
        }
        return endPage;
    }

    // 是否有上一页
    public boolean hasPrevious() {
        return currentPage > 1;
    }

    // 是否有下一页
    public boolean hasNext() {
        return currentPage < totalPage;
    }

    // getter和setter方法
    public int getCurrentPage() {
        return currentPage;
    }

    public void setCurrentPage(int currentPage) {
        this.currentPage = currentPage;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    public int getTotalCount() {
        return totalCount;
    }

    public void setTotalCount(int totalCount) {
        this.totalCount = totalCount;
        // 重新计算总页数
        this.totalPage = (totalCount + pageSize - 1) / pageSize;
    }

    public int getTotalPage() {
        return totalPage;
    }

    public void setTotalPage(int totalPage) {
        this.totalPage = totalPage;
    }

    public List<T> getList() {
        return list;
    }

    public void setList(List<T> list) {
        this.list = list;
    }

    public int getPageShowCount() {
        return pageShowCount;
    }

    public void setPageShowCount(int pageShowCount) {
        this.pageShowCount = pageShowCount;
    }
}