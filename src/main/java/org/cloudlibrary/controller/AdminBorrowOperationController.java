package org.cloudlibrary.controller;

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
            HttpSession session,
            Model model) {
        Admin admin = (Admin) session.getAttribute("loginAdmin");
        if (admin == null) {
            return "redirect:/admin/toLogin";
        }

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

        // 创建分页对象
        PageUtil<Book> pageUtil = new PageUtil<>(page, size, totalCount, books);

        model.addAttribute("pageUtil", pageUtil);
        model.addAttribute("keyword", keyword);
        model.addAttribute("currentDate", java.time.LocalDate.now().toString());
        model.addAttribute("role", "admin");
        model.addAttribute("roleName", "管理员");
        model.addAttribute("account", admin);
        model.addAttribute("applyUrl", "/admin/borrow/apply");
        model.addAttribute("detailUrl", "/admin/book/detail/");
        model.addAttribute("borrowListUrl", "/admin/borrow/my");
        return "borrow/apply";
    }

    /**
     * 管理员执行借书操作
     */
    @PostMapping("/apply")
    public String applyBorrow(@RequestParam Integer bookId,
                              @RequestParam(required = false) String dueTime,
                              HttpSession session) {
        Admin admin = (Admin) session.getAttribute("loginAdmin");
        if (admin == null) {
            return "redirect:/admin/toLogin";
        }

        try {
            // 使用事务方法：创建借阅记录 + 扣减库存（原子操作）
            borrowService.borrowBook(admin.getId(), bookId, dueTime);
        } catch (Exception e) {
            String msg = e.getMessage();
            if (msg != null && msg.contains("禁用")) {
                return "redirect:/admin/borrow/apply?error=disabled";
            } else if (msg != null && msg.contains("库存")) {
                return "redirect:/admin/borrow/apply?error=stock";
            } else {
                return "redirect:/admin/borrow/apply?error=system";
            }
        }

        return "redirect:/admin/borrow/my";
    }
}