package org.cloudlibrary.controller;

import org.cloudlibrary.constant.AppConstants;
import org.cloudlibrary.entity.Book;
import org.cloudlibrary.entity.Borrow;
import org.cloudlibrary.entity.User;
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
@RequestMapping("/user/borrow")
public class UserBorrowController {

    @Autowired
    private BorrowService borrowService;
    @Autowired
    private BookService bookService;

    @GetMapping("/list")
    public String list(
            HttpSession session,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String keyword,
            Model model) {
        User user = (User) session.getAttribute("loginUser");
        if (user == null) {
            return "redirect:/user/toLogin";
        }

        List<Borrow> borrows;
        int totalCount;

        // 计算偏移量
        int offset = (page - 1) * size;

        // 使用JOIN查询一次性获取借阅记录及关联的图书信息
        if (keyword != null && !keyword.trim().isEmpty()) {
            borrows = borrowService.searchUserBorrowsWithDetails(user.getId(), keyword, offset, size);
            totalCount = borrowService.countSearchUserBorrows(user.getId(), keyword);
        } else {
            totalCount = borrowService.countByUserId(user.getId());
            borrows = borrowService.getBorrowByUserIdPageWithDetails(user.getId(), offset, size);
        }

        // 使用工具方法构建映射
        model.addAttribute("overdueDaysMap", borrowService.buildOverdueDaysMap(borrows));
        model.addAttribute("bookMap", borrowService.buildBookMap(borrows));
        
        // 创建分页对象
        PageUtil<Borrow> pageUtil = new PageUtil<>(page, size, totalCount, borrows);
        
        model.addAttribute("pageUtil", pageUtil);
        model.addAttribute("keyword", keyword);
        return "user/borrow/list";
    }

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
        model.addAttribute("books", books);  // 添加图书列表
        model.addAttribute("topBooks", topBooks);
        model.addAttribute("keyword", keyword);
        // 添加当前日期用于前端日期控件的最小值限制
        model.addAttribute("currentDate", java.time.LocalDate.now().toString());
        return "user/borrow/apply";
    }

    @PostMapping("/apply")
    public String applyBorrow(@RequestParam Integer bookId,
                              @RequestParam(required = false) String dueTime,
                              HttpSession session) {
        User user = (User) session.getAttribute("loginUser");
        if (user == null) {
            return "redirect:/user/toLogin";
        }

        try {
            // 使用事务方法：创建借阅记录 + 扣减库存（原子操作）
            borrowService.borrowBook(user.getId(), bookId, dueTime);
        } catch (Exception e) {
            String msg = e.getMessage();
            if (msg != null && msg.contains("禁用")) {
                return "redirect:/user/borrow/apply?error=disabled";
            } else if (msg != null && msg.contains("库存")) {
                return "redirect:/user/borrow/apply?error=stock";
            } else {
                return "redirect:/user/borrow/apply?error=system";
            }
        }

        return "redirect:/user/borrow/list";
    }

    @PostMapping("/return/{id}")
    public String returnApply(@PathVariable Integer id) {
        // 用户申请归还，更新状态为待确认归还
        borrowService.returnBook(id);
        return "redirect:/user/borrow/list";
    }

    @GetMapping(value = "/book/detail/{id}", produces = "application/json")
    @ResponseBody
    public Book getBookDetail(@PathVariable Integer id) {
        try {
            Book book = bookService.getBookById(id);
            if (book != null) {
                return book;
            } else {
                Book errorBook = new Book();
                errorBook.setId(-1);
                errorBook.setName("未找到图书");
                return errorBook;
            }
        } catch (Exception e) {
            Book errorBook = new Book();
            errorBook.setId(-1);
            errorBook.setName("加载出错，请稍后重试");
            return errorBook;
        }
    }
}