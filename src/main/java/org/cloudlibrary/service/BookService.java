package org.cloudlibrary.service;

import org.cloudlibrary.entity.Book;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Map;

public interface BookService {
    List<Book> getBooksByPage(int offset, int size);
    List<Book> searchBooks(String keyword, int offset, int size);
    int countTotalBook();
    int countSearchBooks(String keyword);
    Book getBookById(Integer id);
    Book getBookByIsbn(String isbn);
    Map<String, Integer> countBookTypeRatio();
    List<Book> getTopBooks(int limit);
    int addBook(Book book);
    int updateBook(Book book);
    int deleteBook(Integer id);
    int updateStock(Integer id, Integer num);
    int updateCover(Integer id, String cover);

    // 业务方法（封装业务逻辑）
    void addBookWithCover(Book book, MultipartFile coverFile, String uploadDir) throws IOException;
    void updateBookPreservingCover(Book book);
    void deleteBookWithCover(Integer id, String realPath);
    void disableBook(Integer id);
    void enableBook(Integer id);
    void uploadCover(Integer id, MultipartFile file, String uploadDir) throws IOException;
}