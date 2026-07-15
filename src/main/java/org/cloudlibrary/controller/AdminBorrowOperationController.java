package org.cloudlibrary.controller;

import org.cloudlibrary.constant.AppConstants;
import org.cloudlibrary.entity.Book;
import org.cloudlibrary.entity.Admin;
import org.cloudlibrary.service.BookService;
import org.cloudlibrary.service.BorrowService;
import org.cloudlibrary.util.PageUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/admin/borrow")
public class AdminBorrowOperationController {

    @Autowired
    private BorrowService borrowService;
    
    @Autowired
    private BookService bookService;

    /**
     * 管理员借书页面
     */
    @GetMapping("/apply")
    public String apply(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String keyword,
            Model model) {
        List<Book> books;
        int totalCount;
        
        // 计算偏移量
        int offset = (page - 1) * size;
        
        // 根据是否有关键词进行搜索或获取所有图书
        if (keyword != null && !keyword.trim().isEmpty()) {
            books = bookService.searchBooks(keyword, offset, size);
            totalCount = bookService.countSearchBooks(keyword);
        } else {
            // 获取总记录数
            totalCount = bookService.countTotalBook();
            // 获取当前页数据
            books = bookService.getBooksByPage(offset, size);
        }
        
        // 获取热门图书排行榜
        List<Book> topBooks = bookService.getTopBooks(AppConstants.TOP_RANKING_LIMIT);
        
        // 创建分页对象
        PageUtil<Book> pageUtil = new PageUtil<>(page, size, totalCount, books);
        
        model.addAttribute("pageUtil", pageUtil);
        model.addAttribute("topBooks", topBooks);
        model.addAttribute("keyword", keyword);
        // 添加当前日期用于前端日期控件的最小值限制
        model.addAttribute("currentDate", java.time.LocalDate.now().toString());
        return "admin/borrow/apply";
    }

    /**
     * 管理员执行借书操作
     */
    @PostMapping("/apply")
    public String applyBorrow(@RequestParam Integer bookId,
                              @RequestParam String dueTime,
                              HttpSession session) {
        Admin admin = (Admin) session.getAttribute("loginAdmin");
        if (admin == null) {
            return "redirect:/admin/toLogin";
        }

        try {
            // 使用事务方法：创建借阅记录 + 扣减库存（原子操作）
            borrowService.borrowBook(admin.getId(), bookId, dueTime);
        } catch (RuntimeException e) {
            return "redirect:/admin/borrow/apply?error=stock";
        }

        return "redirect:/admin/borrow/my";
    }
}