package org.cloudlibrary.controller;

import org.cloudlibrary.entity.Borrow;
import org.cloudlibrary.entity.User;
import org.cloudlibrary.service.BorrowService;
import org.cloudlibrary.util.PageUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/user/overdue")
public class UserOverdueController {

    @Autowired
    private BorrowService borrowService;

    @RequestMapping("/list")
    public String list(@RequestParam(value = "page", defaultValue = "1") int page,
                      @RequestParam(value = "size", defaultValue = "10") int size,
                      HttpSession session,
                      Model model) {
        // 获取当前用户
        User user = (User) session.getAttribute("loginUser");
        if (user == null) {
            return "redirect:/user/toLogin";
        }

        // 使用SQL级过滤和分页查询用户的逾期记录
        int offset = (page - 1) * size;
        int totalCount = borrowService.countOverdueByUserId(user.getId());
        List<Borrow> borrows = borrowService.getOverdueByUserIdPageWithDetails(user.getId(), offset, size);

        // 计算逾期天数
        for (Borrow borrow : borrows) {
            borrow.setOverdueDays(borrowService.calculateOverdueDays(borrow));
        }

        PageUtil<Borrow> pageUtil = new PageUtil<>(page, size, totalCount, borrows);
        model.addAttribute("pageUtil", pageUtil);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);

        return "user/overdue/list";
    }
}
