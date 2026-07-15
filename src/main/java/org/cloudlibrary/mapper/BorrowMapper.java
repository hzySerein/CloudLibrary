package org.cloudlibrary.mapper;

import org.cloudlibrary.entity.Borrow;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface BorrowMapper {
    Borrow selectById(@Param("id") Integer id);
    int countTotalBorrow();
    int countUnReturnBorrow();
    int countSearchBorrows(@Param("keyword") String keyword);
    int countSearchUserBorrows(@Param("userId") Integer userId, @Param("keyword") String keyword);
    int countByUserId(@Param("userId") Integer userId);
    int countByBookId(@Param("bookId") Integer bookId);
    List<Map<String, Object>> countBorrowTrend(@Param("months") Integer months);
    int insert(Borrow borrow);
    int updateReturnTime(@Param("id") Integer id, @Param("returnTime") String returnTime);
    int updateStatus(@Param("id") Integer id, @Param("status") Integer status);

    // 带关联信息的查询（解决N+1问题）
    List<Borrow> selectByPageWithDetails(@Param("offset") int offset, @Param("size") int size);
    List<Borrow> searchBorrowsWithDetails(@Param("keyword") String keyword, @Param("offset") int offset, @Param("size") int size);
    List<Borrow> selectByUserIdWithDetails(@Param("userId") Integer userId);
    List<Borrow> selectByUserIdPageWithDetails(@Param("userId") Integer userId, @Param("offset") int offset, @Param("size") int size);
    List<Borrow> searchUserBorrowsWithDetails(@Param("userId") Integer userId, @Param("keyword") String keyword, @Param("offset") int offset, @Param("size") int size);

    // 逾期查询（SQL级过滤+分页）
    List<Borrow> selectOverdueWithDetails(@Param("offset") int offset, @Param("size") int size);
    int countOverdue();
    List<Borrow> selectOverdueByUserIdWithDetails(@Param("userId") Integer userId, @Param("offset") int offset, @Param("size") int size);
    int countOverdueByUserId(@Param("userId") Integer userId);
}