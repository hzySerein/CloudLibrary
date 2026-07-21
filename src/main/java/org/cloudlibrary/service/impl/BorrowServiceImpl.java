package org.cloudlibrary.service.impl;

import org.cloudlibrary.constant.BorrowStatus;
import org.cloudlibrary.constant.StatusConstants;
import org.cloudlibrary.entity.Borrow;
import org.cloudlibrary.entity.Book;
import org.cloudlibrary.entity.User;
import org.cloudlibrary.mapper.BorrowMapper;
import org.cloudlibrary.service.BookService;
import org.cloudlibrary.service.BorrowService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map;

@Service
public class BorrowServiceImpl implements BorrowService {

    @Autowired
    private BorrowMapper borrowMapper;

    @Autowired
    private BookService bookService;

    @Override
    public int countSearchBorrows(String keyword) {
        return borrowMapper.countSearchBorrows(keyword);
    }

    @Override
    public int countSearchUserBorrows(Integer userId, String keyword) {
        return borrowMapper.countSearchUserBorrows(userId, keyword);
    }

    @Override
    public int countTotalBorrow() {
        return borrowMapper.countTotalBorrow();
    }

    @Override
    public int countUnReturnBorrow() {
        return borrowMapper.countUnReturnBorrow();
    }

    @Override
    public int countByUserId(Integer userId) {
        return borrowMapper.countByUserId(userId);
    }

    @Override
    public int countByBookId(Integer bookId) {
        return borrowMapper.countByBookId(bookId);
    }

    @Override
    public List<Map<String, Object>> countBorrowTrend(Integer months) {
        return borrowMapper.countBorrowTrend(months);
    }

    @Override
    public Borrow getBorrowById(Integer id) {
        return borrowMapper.selectById(id);
    }
    
    @Override
    public int addBorrow(Borrow borrow) {
        return borrowMapper.insert(borrow);
    }

    @Override
    public int returnBook(Integer id) {
        // 用户申请归还，将状态设置为待确认归还
        return borrowMapper.updateStatus(id, BorrowStatus.PENDING_CONFIRM);
    }

    @Override
    @Transactional
    public int confirmReturnBook(Integer id) {
        return doReturnBook(id);
    }

    @Override
    @Transactional
    public int forceReturnBook(Integer id) {
        return doReturnBook(id);
    }

    /**
     * 内部归还实现（confirmReturnBook 和 forceReturnBook 共用）
     */
    private int doReturnBook(Integer id) {
        Borrow borrow = borrowMapper.selectById(id);
        if (borrow == null) {
            return 0;
        }
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        borrowMapper.updateReturnTime(id, sdf.format(new Date()));
        return borrowMapper.updateStatus(id, BorrowStatus.RETURNED);
    }
    
    @Override
    public int calculateOverdueDays(Borrow borrow) {
        if (borrow == null || borrow.getDueTime() == null) {
            return 0;
        }
        
        Date dueDate = borrow.getDueTime();
        Date currentDate = new Date();
        
        // 如果已归还，使用归还时间；否则使用当前时间
        Date compareDate = borrow.getReturnTime() != null ? borrow.getReturnTime() : currentDate;
        
        // 计算日期差（忽略时间部分，只比较日期）
        Calendar dueCal = Calendar.getInstance();
        dueCal.setTime(dueDate);
        dueCal.set(Calendar.HOUR_OF_DAY, 0);
        dueCal.set(Calendar.MINUTE, 0);
        dueCal.set(Calendar.SECOND, 0);
        dueCal.set(Calendar.MILLISECOND, 0);
        
        Calendar compareCal = Calendar.getInstance();
        compareCal.setTime(compareDate);
        compareCal.set(Calendar.HOUR_OF_DAY, 0);
        compareCal.set(Calendar.MINUTE, 0);
        compareCal.set(Calendar.SECOND, 0);
        compareCal.set(Calendar.MILLISECOND, 0);
        
        long diffInMillis = compareCal.getTimeInMillis() - dueCal.getTimeInMillis();
        long diffInDays = diffInMillis / (1000 * 60 * 60 * 24);
        
        // 如果compareDate晚于dueDate，返回天数差；否则返回0
        return diffInDays > 0 ? (int) diffInDays : 0;
    }

    // ========== 带关联信息的查询（解决N+1问题） ==========

    @Override
    public List<Borrow> getBorrowsByPageWithDetails(int offset, int size) {
        return borrowMapper.selectByPageWithDetails(offset, size);
    }

    @Override
    public List<Borrow> searchBorrowsWithDetails(String keyword, int offset, int size) {
        return borrowMapper.searchBorrowsWithDetails(keyword, offset, size);
    }

    @Override
    public List<Borrow> getBorrowByUserIdWithDetails(Integer userId) {
        return borrowMapper.selectByUserIdWithDetails(userId);
    }

    @Override
    public List<Borrow> getBorrowByUserIdPageWithDetails(Integer userId, int offset, int size) {
        return borrowMapper.selectByUserIdPageWithDetails(userId, offset, size);
    }

    @Override
    public List<Borrow> searchUserBorrowsWithDetails(Integer userId, String keyword, int offset, int size) {
        return borrowMapper.searchUserBorrowsWithDetails(userId, keyword, offset, size);
    }

    // ========== 逾期查询（SQL级过滤+分页） ==========

    @Override
    public List<Borrow> getOverdueByPageWithDetails(int offset, int size) {
        return borrowMapper.selectOverdueWithDetails(offset, size);
    }

    @Override
    public int countOverdue() {
        return borrowMapper.countOverdue();
    }

    @Override
    public List<Borrow> getOverdueByUserIdPageWithDetails(Integer userId, int offset, int size) {
        return borrowMapper.selectOverdueByUserIdWithDetails(userId, offset, size);
    }

    @Override
    public int countOverdueByUserId(Integer userId) {
        return borrowMapper.countOverdueByUserId(userId);
    }

    // ========== 事务操作（借阅+库存 / 归还+库存） ==========

    @Override
    @Transactional
    public int borrowBook(Integer userId, Integer bookId, String dueTime) {
        // 1. 校验图书信息
        Book book = bookService.getBookById(bookId);
        if (book == null) {
            throw new RuntimeException("图书不存在");
        }
        if (book.getStatus() != StatusConstants.ENABLED) {
            throw new RuntimeException("该图书已被禁用或下架");
        }
        if (book.getStock() <= 0) {
            throw new RuntimeException("图书库存不足");
        }

        // 2. 扣减库存（SQL层使用 WHERE stock + num >= 0 防止并发超借）
        int stockUpdated = bookService.updateStock(bookId, -1);
        if (stockUpdated == 0) {
            throw new RuntimeException("图书库存不足，可能已被其他用户借出");
        }

        // 3. 解析应归还时间与设置借阅时间
        java.util.Date parsedDueTime = null;
        if (dueTime != null && !dueTime.trim().isEmpty()) {
            try {
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
                parsedDueTime = sdf.parse(dueTime.trim());
            } catch (Exception e) {
                try {
                    java.text.SimpleDateFormat sdfFull = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                    parsedDueTime = sdfFull.parse(dueTime.trim());
                } catch (Exception ex) {
                    // 解析失败时，默认 30 天后
                }
            }
        }
        if (parsedDueTime == null) {
            java.util.Calendar cal = java.util.Calendar.getInstance();
            cal.add(java.util.Calendar.DAY_OF_MONTH, 30);
            parsedDueTime = cal.getTime();
        }

        // 4. 创建借阅记录
        Borrow borrow = new Borrow();
        borrow.setBookId(bookId);
        borrow.setUserId(userId);
        borrow.setBorrowTime(new java.util.Date());
        borrow.setDueTime(parsedDueTime);
        borrow.setStatus(BorrowStatus.UNRETURNED);
        borrowMapper.insert(borrow);

        return borrow.getId();
    }

    @Override
    @Transactional
    public int confirmReturnWithStock(Integer id) {
        // 确认归还
        int result = confirmReturnBook(id);
        if (result > 0) {
            // 恢复库存
            Borrow borrow = borrowMapper.selectById(id);
            if (borrow != null) {
                bookService.updateStock(borrow.getBookId(), 1);
            }
        }
        return result;
    }

    @Override
    @Transactional
    public int forceReturnWithStock(Integer id) {
        int result = forceReturnBook(id);
        if (result > 0) {
            Borrow borrow = borrowMapper.selectById(id);
            if (borrow != null) {
                bookService.updateStock(borrow.getBookId(), 1);
            }
        }
        return result;
    }

    // ========== 工具方法 ==========

    @Override
    public Map<Integer, Integer> buildOverdueDaysMap(List<Borrow> borrows) {
        Map<Integer, Integer> map = new HashMap<>();
        for (Borrow borrow : borrows) {
            map.put(borrow.getId(), calculateOverdueDays(borrow));
        }
        return map;
    }

    @Override
    public Map<Integer, Book> buildBookMap(List<Borrow> borrows) {
        Map<Integer, Book> map = new HashMap<>();
        for (Borrow borrow : borrows) {
            if (borrow.getBook() != null) {
                map.put(borrow.getBookId(), borrow.getBook());
            }
        }
        return map;
    }

    @Override
    public Map<Integer, User> buildUserMap(List<Borrow> borrows) {
        Map<Integer, User> map = new HashMap<>();
        for (Borrow borrow : borrows) {
            if (borrow.getUser() != null) {
                map.put(borrow.getUserId(), borrow.getUser());
            }
        }
        return map;
    }
}