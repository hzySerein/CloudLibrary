package org.cloudlibrary.service.impl;

import org.cloudlibrary.constant.AppConstants;
import org.cloudlibrary.constant.StatusConstants;
import org.cloudlibrary.entity.Book;
import org.cloudlibrary.mapper.BookMapper;
import org.cloudlibrary.service.BookService;
import org.cloudlibrary.service.BorrowService;
import org.cloudlibrary.util.FileUploadUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class BookServiceImpl implements BookService {

    private static final Log logger = LogFactory.getLog(BookServiceImpl.class);

    @Autowired
    private BookMapper bookMapper;

    @Autowired
    private BorrowService borrowService;

    @Override
    public List<Book> getBooksByPage(int offset, int size) {
        return bookMapper.selectByPage(offset, size);
    }

    @Override
    public List<Book> searchBooks(String keyword, int offset, int size) {
        return bookMapper.searchBooks(keyword, offset, size);
    }

    @Override
    public int countSearchBooks(String keyword) {
        return bookMapper.countSearchBooks(keyword);
    }

    @Override
    public Book getBookById(Integer id) {
        return bookMapper.selectById(id);
    }

    @Override
    public Book getBookByIsbn(String isbn) {
        return bookMapper.selectByIsbn(isbn);
    }

    @Override
    public int countTotalBook() {
        return bookMapper.countTotalBook();
    }

    @Override
    public Map<String, Integer> countBookTypeRatio() {
        Map<String, Object> param = new HashMap<>();
        List<Map<String, Object>> list = bookMapper.countBookTypeRatio(param);
        Map<String, Integer> result = new HashMap<>();
        for (Map<String, Object> item : list) {
            result.put((String) item.get("type"), Integer.parseInt(item.get("count").toString()));
        }
        return result;
    }

    @Override
    public List<Book> getTopBooks(int limit) {
        try {
            return bookMapper.selectTopBooks(limit);
        } catch (Exception e) {
            logger.error("Error getting top books with limit: " + limit, e);
            return new ArrayList<>();
        }
    }

    @Override
    public int addBook(Book book) {
        return bookMapper.insert(book);
    }

    @Override
    public int updateBook(Book book) {
        return bookMapper.update(book);
    }

    @Override
    public int deleteBook(Integer id) {
        return bookMapper.deleteById(id);
    }

    @Override
    public int updateStock(Integer id, Integer num) {
        return bookMapper.updateStock(id, num);
    }

    @Override
    public int updateCover(Integer id, String cover) {
        return bookMapper.updateCover(id, cover);
    }

    // ========== 业务方法 ==========

    @Override
    @Transactional
    public void addBookWithCover(Book book, MultipartFile coverFile, String uploadDir) throws IOException {
        // ISBN唯一性校验
        Book existing = bookMapper.selectByIsbn(book.getIsbn());
        if (existing != null) {
            throw new IllegalArgumentException("ISBN号码已存在，请使用不同的ISBN");
        }
        // 设置默认状态
        book.setStatus(StatusConstants.ENABLED);
        // 插入图书
        bookMapper.insert(book);
        // 上传封面
        if (coverFile != null && !coverFile.isEmpty()) {
            if (book.getId() == null || book.getId() <= 0) {
                throw new IllegalStateException("图书添加失败，无法上传封面");
            }
            String coverPath = FileUploadUtil.uploadFile(coverFile, uploadDir, AppConstants.UPLOAD_DIR_BOOKS);
            bookMapper.updateCover(book.getId(), coverPath);
        }
    }

    @Override
    public void updateBookPreservingCover(Book book) {
        // ISBN唯一性校验（排除自身）
        Book existing = bookMapper.selectByIsbn(book.getIsbn());
        if (existing != null && !existing.getId().equals(book.getId())) {
            throw new IllegalArgumentException("ISBN号码已存在，请使用不同的ISBN");
        }
        // 保留原有封面
        Book original = bookMapper.selectById(book.getId());
        if (original != null && book.getCover() == null) {
            book.setCover(original.getCover());
        }
        bookMapper.update(book);
    }

    @Override
    @Transactional
    public void deleteBookWithCover(Integer id, String realPath) {
        // 检查借阅记录
        int borrowCount = borrowService.countByBookId(id);
        if (borrowCount > 0) {
            throw new IllegalStateException("该图书存在借阅记录，无法删除");
        }
        // 删除封面文件
        Book book = bookMapper.selectById(id);
        if (book != null && book.getCover() != null && !book.getCover().isEmpty()) {
            File coverFile = new File(realPath + book.getCover());
            if (coverFile.exists() && !coverFile.delete()) {
                logger.warn("Failed to delete cover file: " + coverFile.getPath());
            }
        }
        // 删除图书记录
        bookMapper.deleteById(id);
    }

    @Override
    public void disableBook(Integer id) {
        Book book = bookMapper.selectById(id);
        if (book != null) {
            book.setStatus(StatusConstants.DISABLED);
            bookMapper.update(book);
        }
    }

    @Override
    public void enableBook(Integer id) {
        Book book = bookMapper.selectById(id);
        if (book != null) {
            book.setStatus(StatusConstants.ENABLED);
            bookMapper.update(book);
        }
    }

    @Override
    public void uploadCover(Integer id, MultipartFile file, String uploadDir) throws IOException {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("未选择文件");
        }
        String coverPath = FileUploadUtil.uploadFile(file, uploadDir, AppConstants.UPLOAD_DIR_BOOKS);
        bookMapper.updateCover(id, coverPath);
    }
}