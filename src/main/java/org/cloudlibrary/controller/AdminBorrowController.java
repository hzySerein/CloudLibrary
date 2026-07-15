package org.cloudlibrary.controller;

import org.cloudlibrary.entity.Borrow;
import org.cloudlibrary.entity.User;
import org.cloudlibrary.entity.Admin;
import org.cloudlibrary.service.BorrowService;
import org.cloudlibrary.util.PageUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/admin/borrow")
public class AdminBorrowController {

    @Autowired
    private BorrowService borrowService;

    @GetMapping("/list")
    public String list(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String keyword,
            HttpSession session,
            Model model) {
        List<Borrow> borrows;
        int totalCount;

        // 计算偏移量
        int offset = (page - 1) * size;

        // 使用JOIN查询一次性获取借阅记录及关联的图书和用户信息
        if (keyword != null && !keyword.trim().isEmpty()) {
            borrows = borrowService.searchBorrowsWithDetails(keyword, offset, size);
            totalCount = borrowService.countSearchBorrows(keyword);
        } else {
            totalCount = borrowService.countTotalBorrow();
            borrows = borrowService.getBorrowsByPageWithDetails(offset, size);
        }

        // 使用工具方法构建映射
        model.addAttribute("overdueDaysMap", borrowService.buildOverdueDaysMap(borrows));
        model.addAttribute("bookMap", borrowService.buildBookMap(borrows));
        model.addAttribute("userMap", borrowService.buildUserMap(borrows));

        PageUtil<Borrow> pageUtil = new PageUtil<>(page, size, totalCount, borrows);

        model.addAttribute("pageUtil", pageUtil);
        model.addAttribute("keyword", keyword);
        return "admin/borrow/list";
    }

    // 管理员查看自己的借阅记录
    @GetMapping("/my")
    public String myList(
            HttpSession session,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String keyword,
            Model model) {
        Admin admin = (Admin) session.getAttribute("loginAdmin");
        if (admin == null) {
            return "redirect:/admin/toLogin";
        }

        List<Borrow> borrows;
        int totalCount;
        int offset = (page - 1) * size;

        // 使用JOIN查询一次性获取借阅记录及关联的图书信息
        if (keyword != null && !keyword.trim().isEmpty()) {
            borrows = borrowService.searchUserBorrowsWithDetails(admin.getId(), keyword, offset, size);
            totalCount = borrowService.countSearchUserBorrows(admin.getId(), keyword);
        } else {
            totalCount = borrowService.countByUserId(admin.getId());
            borrows = borrowService.getBorrowByUserIdPageWithDetails(admin.getId(), offset, size);
        }

        // 使用工具方法构建映射
        model.addAttribute("overdueDaysMap", borrowService.buildOverdueDaysMap(borrows));
        model.addAttribute("bookMap", borrowService.buildBookMap(borrows));

        // 创建分页对象
        PageUtil<Borrow> pageUtil = new PageUtil<>(page, size, totalCount, borrows);

        model.addAttribute("pageUtil", pageUtil);
        model.addAttribute("keyword", keyword);
        return "admin/borrow/my_list";
    }

    @PostMapping("/confirmReturn/{id}")
    public String confirmReturn(@PathVariable Integer id) {
        // 使用事务方法：确认归还 + 恢复库存（原子操作）
        borrowService.confirmReturnWithStock(id);
        return "redirect:/admin/borrow/list";
    }

    @PostMapping("/return/{id}")
    public String returnApply(@PathVariable Integer id) {
        borrowService.returnBook(id);
        return "redirect:/admin/borrow/my";
    }

    @PostMapping("/forceReturn/{id}")
    public String forceReturn(@PathVariable Integer id) {
        // 使用事务方法：强制归还 + 恢复库存（原子操作）
        borrowService.forceReturnWithStock(id);
        return "redirect:/admin/borrow/list";
    }
}