package org.cloudlibrary.interceptor;

import org.cloudlibrary.entity.Admin;
import org.cloudlibrary.entity.User;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * 统一认证拦截器
 * - /admin/** 路径要求 Session 中存在 loginAdmin
 * - /user/** 路径要求 Session 中存在 loginUser
 * - 登录页面和静态资源不拦截
 */
public class AuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {

        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());

        HttpSession session = request.getSession(false);

        // 管理员路径：要求 loginAdmin 存在
        if (path.startsWith("/admin/")) {
            if (session != null) {
                Admin admin = (Admin) session.getAttribute("loginAdmin");
                if (admin != null) {
                    return true; // 已认证的管理员，放行
                }
            }
            // 未认证，重定向到管理员登录页
            response.sendRedirect(contextPath + "/admin/toLogin");
            return false;
        }

        // 用户路径：要求 loginUser 存在
        if (path.startsWith("/user/")) {
            if (session != null) {
                User user = (User) session.getAttribute("loginUser");
                if (user != null) {
                    return true; // 已认证的用户，放行
                }
            }
            // 未认证，重定向到用户登录页
            response.sendRedirect(contextPath + "/user/toLogin");
            return false;
        }

        // 其他路径（首页等），放行
        return true;
    }
}
