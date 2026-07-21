package org.cloudlibrary.controller;

import org.cloudlibrary.entity.Admin;
import org.cloudlibrary.service.AdminService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin")
public class AdminLoginController {

    @Autowired
    private AdminService adminService;

    // 跳转到管理员登录页
    @GetMapping("/toLogin")
    public String toLogin() {
        return "admin/login"; // 对应WEB-INF/jsp/admin/login.jsp
    }

    // 处理管理员登录请求
    @PostMapping("/login")
    public String login(
            @RequestParam("username") String username,
            @RequestParam("password") String password,
            Model model,
            HttpServletRequest request) {

        // 调用Service查询管理员
        Admin admin = adminService.login(username, password);

        if (admin != null) {
            // 登录成功：销毁旧Session（防止Session固定攻击），安全处理IllegalStateException
            HttpSession currentSession = request.getSession(false);
            if (currentSession != null) {
                try {
                    currentSession.invalidate();
                } catch (IllegalStateException ignored) {
                    // 会话已被销毁或已无效，忽略此异常
                }
            }
            HttpSession newSession = request.getSession(true);
            
            // 清除密码后再存入Session，避免密码哈希泄露
            admin.setPassword(null);
            newSession.setAttribute("loginAdmin", admin);
            return "redirect:/admin/index";
        } else {
            // 登录失败：返回登录页，提示错误
            model.addAttribute("msg", "用户名或密码错误！");
            return "admin/login";
        }
    }

    // 管理员首页
    @GetMapping("/index")
    public String adminIndex(HttpSession session) {
        // 校验是否登录
        if (session.getAttribute("loginAdmin") == null) {
            return "redirect:/admin/toLogin";
        }
        return "redirect:/admin/borrow/apply";
    }

    // 管理员退出登录
    @PostMapping("/logout")
    public String logout(HttpServletRequest request) {
        HttpSession currentSession = request.getSession(false);
        if (currentSession != null) {
            try {
                currentSession.invalidate(); // 完全清除session
            } catch (IllegalStateException ignored) {
                // 会话已无效
            }
        }
        return "redirect:/admin/toLogin";
    }
    
    // 跳转到修改个人信息页面
    @GetMapping("/profile")
    public String toProfile(HttpSession session, Model model) {
        Admin admin = (Admin) session.getAttribute("loginAdmin");
        if (admin == null) {
            return "redirect:/admin/toLogin";
        }
        // 从数据库获取最新信息（密码已被排除，不会传到前端）
        Admin currentAdmin = adminService.getAdminById(admin.getId());
        model.addAttribute("admin", currentAdmin);
        return "admin/profile";
    }

    // 处理修改个人信息请求
    @PostMapping("/profile")
    public String updateProfile(
            Admin admin,
            @RequestParam(required = false) String oldPassword,
            @RequestParam(required = false) String confirmPassword,
            HttpSession session) {
        Admin loginAdmin = (Admin) session.getAttribute("loginAdmin");
        if (loginAdmin == null) {
            return "redirect:/admin/toLogin";
        }

        try {
            adminService.updateProfile(loginAdmin.getId(), admin, oldPassword, confirmPassword);
        } catch (IllegalArgumentException e) {
            if ("旧密码输入错误".equals(e.getMessage())) {
                return "redirect:/admin/profile?error=oldpwd";
            }
            return "redirect:/admin/profile?error=confirm";
        }

        // 更新session中的管理员信息
        session.setAttribute("loginAdmin", adminService.getAdminById(loginAdmin.getId()));
        return "redirect:/admin/borrow/apply";
    }
}