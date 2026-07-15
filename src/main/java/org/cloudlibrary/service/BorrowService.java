package org.cloudlibrary.service;

import org.cloudlibrary.entity.Book;
import org.cloudlibrary.entity.Borrow;
import org.cloudlibrary.entity.User;

import java.util.List;
import java.util.Map;

public interface BorrowService {
    int countTotalBorrow();
    int countUnReturnBorrow();
    int countSearchBorrows(String keyword);
    int countSearchUserBorrows(Integer userId, String keyword);
    int countByUserId(Integer userId);
    int countByBookId(Integer bookId);
    List<Map<String, Object>> countBorrowTrend(Integer months);
    int addBorrow(Borrow borrow);
    Borrow getBorrowById(Integer id);
    int returnBook(Integer id);
    int confirmReturnBook(Integer id);
    int forceReturnBook(Integer id);
    int calculateOverdueDays(Borrow borrow);

    // 带关联信息的查询（解决N+1问题）
    List<Borrow> getBorrowsByPageWithDetails(int offset, int size);
    List<Borrow> searchBorrowsWithDetails(String keyword, int offset, int size);
    List<Borrow> getBorrowByUserIdWithDetails(Integer userId);
    List<Borrow> getBorrowByUserIdPageWithDetails(Integer userId, int offset, int size);
    List<Borrow> searchUserBorrowsWithDetails(Integer userId, String keyword, int offset, int size);

    // 逾期查询（SQL级过滤+分页）
    List<Borrow> getOverdueByPageWithDetails(int offset, int size);
    int countOverdue();
    List<Borrow> getOverdueByUserIdPageWithDetails(Integer userId, int offset, int size);
    int countOverdueByUserId(Integer userId);

    // 事务操作（借阅+库存 / 归还+库存）
    int borrowBook(Integer userId, Integer bookId, String dueTime);
    int confirmReturnWithStock(Integer id);
    int forceReturnWithStock(Integer id);

    // 工具方法：构建映射
    Map<Integer, Integer> buildOverdueDaysMap(List<Borrow> borrows);
    Map<Integer, Book> buildBookMap(List<Borrow> borrows);
    Map<Integer, User> buildUserMap(List<Borrow> borrows);
}