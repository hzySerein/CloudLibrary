package org.cloudlibrary.controller;

import org.cloudlibrary.entity.User;
import org.cloudlibrary.service.UserService;
import org.cloudlibrary.view.AccountProfileView;
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
@RequestMapping("/user")
public class UserLoginController {

    @Autowired
    private UserService userService;

    // 跳转到用户登录页
    @GetMapping("/toLogin")
    public String toLogin(Model model) {
        model.addAttribute("role", "user");
        model.addAttribute("roleName", "用户");
        model.addAttribute("themeClass", "");
        model.addAttribute("loginAction", "/user/login");
        model.addAttribute("pageTitle", "用户登录");
        return "auth/login";
    }

    // 处理用户登录请求
    @PostMapping("/login")
    public String login(
            @RequestParam("username") String username,
            @RequestParam("password") String password,
            Model model,
            HttpServletRequest request) {

        // 调用Service查询用户
        User user = userService.login(username, password);

        if (user != null) {
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
            user.setPassword(null);
            newSession.setAttribute("loginUser", user);
            return "redirect:/user/borrow/apply";
        } else {
            // 登录失败：返回登录页，提示错误
            model.addAttribute("msg", "用户名或密码错误！");
            model.addAttribute("role", "user");
            model.addAttribute("roleName", "用户");
            model.addAttribute("themeClass", "");
            model.addAttribute("loginAction", "/user/login");
            model.addAttribute("pageTitle", "用户登录");
            return "auth/login";
        }
    }

    // 用户首页
    @GetMapping("/index")
    public String userIndex(HttpSession session) {
        // 校验是否登录
        if (session.getAttribute("loginUser") == null) {
            return "redirect:/user/toLogin";
        }
        return "redirect:/user/borrow/apply"; // 登录后直接跳转到借阅页面
    }

    // 用户退出登录
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
        return "redirect:/user/toLogin";
    }
    
    // 跳转到修改个人信息页面
    @GetMapping("/profile")
    public String toProfile(HttpSession session, Model model) {
        User user = (User) session.getAttribute("loginUser");
        if (user == null) {
            return "redirect:/user/toLogin";
        }
        // 从数据库获取最新信息
        User currentUser = userService.getUserById(user.getId());
        AccountProfileView view = new AccountProfileView();
        view.setId(currentUser.getId());
        view.setUsername(currentUser.getUsername());
        view.setName(currentUser.getName());
        view.setPhone(currentUser.getPhone());
        view.setRoleName("用户");
        view.setAvatarIcon("👤");
        view.setProfileAction("/user/profile");
        view.setCancelUrl("/user/index");
        model.addAttribute("accountProfile", view);
        model.addAttribute("role", "user");
        return "account/profile";
    }
    
    // 处理修改个人信息请求
    @PostMapping("/profile")
    public String updateProfile(
            User user,
            @RequestParam(required = false) String oldPassword,
            @RequestParam(required = false) String confirmPassword,
            HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/user/toLogin";
        }

        try {
            userService.updateProfile(loginUser.getId(), user, oldPassword, confirmPassword);
        } catch (IllegalArgumentException e) {
            if ("旧密码输入错误".equals(e.getMessage())) {
                return "redirect:/user/profile?error=oldpwd";
            }
            return "redirect:/user/profile?error=confirm";
        }

        // 更新session中的用户信息
        session.setAttribute("loginUser", userService.getUserById(loginUser.getId()));
        return "redirect:/user/index";
    }
}