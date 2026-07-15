package org.cloudlibrary.controller;

import org.cloudlibrary.constant.AppConstants;
import org.cloudlibrary.service.BookService;
import org.cloudlibrary.service.BorrowService;
import org.cloudlibrary.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin/stats")
public class AdminStatsController {

    @Autowired
    private BookService bookService;
    @Autowired
    private UserService userService;
    @Autowired
    private BorrowService borrowService;

    @GetMapping("/system")
    public String systemStats(Model model) {
        // 基础数据
        int totalBook = bookService.countTotalBook();
        int totalUser = userService.countTotalUser();
        int totalBorrow = borrowService.countTotalBorrow();
        int unReturnBorrow = borrowService.countUnReturnBorrow();

        // 图书类型占比
        Map<String, Integer> bookTypeRatio = bookService.countBookTypeRatio();

        // 借阅趋势（近6个月）
        List<Map<String, Object>> borrowTrend = borrowService.countBorrowTrend(AppConstants.TREND_MONTHS);

        // 热门图书排行榜（前10名）
        List<org.cloudlibrary.entity.Book> topBooks = bookService.getTopBooks(AppConstants.TOP_RANKING_LIMIT);

        // 活跃用户排行榜（前10名）
        List<org.cloudlibrary.entity.User> activeUsers = userService.getActiveUsers(AppConstants.TOP_RANKING_LIMIT);

        model.addAttribute("totalBook", totalBook);
        model.addAttribute("totalUser", totalUser);
        model.addAttribute("totalBorrow", totalBorrow);
        model.addAttribute("unReturnBorrow", unReturnBorrow);
        model.addAttribute("bookTypeRatio", bookTypeRatio);
        model.addAttribute("borrowTrend", borrowTrend);
        model.addAttribute("topBooks", topBooks);
        model.addAttribute("activeUsers", activeUsers);

        return "admin/stats/system";
    }
}