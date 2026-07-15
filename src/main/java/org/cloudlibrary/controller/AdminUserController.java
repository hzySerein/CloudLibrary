package org.cloudlibrary.controller;

import org.cloudlibrary.entity.User;
import org.cloudlibrary.service.UserService;
import org.cloudlibrary.util.PageUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin/user")
public class AdminUserController {

    @Autowired
    private UserService userService;

    @GetMapping("/list")
    public String list(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String keyword,
            Model model) {
        int offset = (page - 1) * size;
        List<User> users;
        int totalCount;
        if (keyword != null && !keyword.trim().isEmpty()) {
            users = userService.searchUsers(keyword, offset, size);
            totalCount = userService.countSearchUsers(keyword);
        } else {
            totalCount = userService.countTotalUser();
            users = userService.getUsersByPage(offset, size);
        }
        model.addAttribute("pageUtil", new PageUtil<>(page, size, totalCount, users));
        model.addAttribute("keyword", keyword);
        return "admin/user/list";
    }

    @GetMapping("/toAdd")
    public String toAdd() {
        return "admin/user/add";
    }

    @PostMapping("/add")
    public String add(User user) {
        userService.addUser(user); // Service层已处理role和status默认值
        return "redirect:/admin/user/list";
    }

    @GetMapping("/toEdit/{id}")
    public String toEdit(@PathVariable Integer id, Model model) {
        model.addAttribute("user", userService.getUserById(id));
        return "admin/user/edit";
    }

    @PostMapping("/edit")
    public String edit(User user) {
        userService.updateUser(user);
        return "redirect:/admin/user/list";
    }

    @PostMapping("/delete/{id}")
    public String delete(@PathVariable Integer id) {
        try {
            userService.deleteUserIfNoBorrows(id);
        } catch (IllegalStateException e) {
            return "redirect:/admin/user/list?error=has_borrows";
        }
        return "redirect:/admin/user/list";
    }
}
