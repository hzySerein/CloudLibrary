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

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin/overdue")
public class AdminOverdueController {

    @Autowired
    private BorrowService borrowService;

    @RequestMapping("/list")
    public String list(@RequestParam(value = "page", defaultValue = "1") int page,
                      @RequestParam(value = "size", defaultValue = "10") int size,
                      Model model) {
        // 使用SQL级过滤和分页查询逾期记录
        int offset = (page - 1) * size;
        int totalCount = borrowService.countOverdue();
        List<Borrow> overdueBorrows = borrowService.getOverdueByPageWithDetails(offset, size);

        // 计算逾期天数，构建用户映射
        for (Borrow borrow : overdueBorrows) {
            borrow.setOverdueDays(borrowService.calculateOverdueDays(borrow));
        }
        Map<Integer, User> userMap = borrowService.buildUserMap(overdueBorrows);

        PageUtil<Borrow> pageUtil = new PageUtil<>(page, size, totalCount, overdueBorrows);
        model.addAttribute("pageUtil", pageUtil);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("userMap", userMap);

        return "admin/overdue/list";
    }
}