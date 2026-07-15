package org.cloudlibrary.mapper;

import org.apache.ibatis.annotations.Param;
import org.cloudlibrary.entity.Book;

import java.util.List;
import java.util.Map;

public interface BookMapper {
    List<Book> selectByPage(@Param("offset") int offset, @Param("size") int size);
    List<Book> searchBooks(@Param("keyword") String keyword, @Param("offset") int offset, @Param("size") int size);
    Book selectById(int id);
    Book selectByIsbn(String isbn);  // 新增方法
    int countTotalBook();
    int countSearchBooks(@Param("keyword") String keyword);
    List<Map<String, Object>> countBookTypeRatio(Map<String, Object> param);
    List<Book> selectTopBooks(int limit);
    int insert(Book book);
    int update(Book book);
    int updateCover(@Param("id") int id, @Param("cover") String cover);
    int deleteById(int id);
    int updateStock(@Param("id") int id, @Param("num") int num);
}