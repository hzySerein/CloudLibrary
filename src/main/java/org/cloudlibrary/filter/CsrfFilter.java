package org.cloudlibrary.filter;

import org.cloudlibrary.util.CsrfUtil;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * CSRF 防护过滤器
 * - GET 请求：生成/刷新 CSRF Token，存入 Session 和 Request Attribute
 * - POST 请求：验证请求中的 CSRF Token 与 Session 中的一致
 * - 静态资源请求：跳过验证
 */
public class CsrfFilter implements Filter {

    /** 需要排除 CSRF 验证的路径前缀 */
    private static final String[] EXCLUDE_PREFIXES = {
            "/static/", "/uploads/"
    };

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 无需初始化
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String uri = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = uri.substring(contextPath.length());

        // 静态资源跳过
        if (isExcluded(path)) {
            chain.doFilter(request, response);
            return;
        }

        String method = httpRequest.getMethod().toUpperCase();

        if ("GET".equals(method) || "HEAD".equals(method) || "OPTIONS".equals(method)) {
            // GET 请求：确保 Session 中有 Token，并设置到 Request Attribute
            ensureToken(httpRequest);
            chain.doFilter(request, response);
        } else if ("POST".equals(method)) {
            // POST 请求：验证 CSRF Token
            HttpSession session = httpRequest.getSession(false);
            if (session == null) {
                sendForbidden(httpRequest, httpResponse);
                return;
            }

            String sessionToken = (String) session.getAttribute(CsrfUtil.CSRF_TOKEN_ATTR);
            String requestToken = httpRequest.getParameter(CsrfUtil.CSRF_PARAM_NAME);

            // 也检查请求头（用于 AJAX 请求）
            if (requestToken == null) {
                requestToken = httpRequest.getHeader("X-CSRF-Token");
            }

            if (sessionToken != null && sessionToken.equals(requestToken)) {
                // 验证通过，继续处理
                chain.doFilter(request, response);
            } else {
                // 验证失败，返回 403
                sendForbidden(httpRequest, httpResponse);
            }
        } else {
            // 其他方法（PUT、DELETE 等）放行
            chain.doFilter(request, response);
        }
    }

    /**
     * 确保 Session 中存在 CSRF Token，并设置到 Request Attribute
     */
    private void ensureToken(HttpServletRequest request) {
        HttpSession session = request.getSession(true);
        String token = (String) session.getAttribute(CsrfUtil.CSRF_TOKEN_ATTR);
        if (token == null || token.isEmpty()) {
            token = CsrfUtil.generateToken();
            session.setAttribute(CsrfUtil.CSRF_TOKEN_ATTR, token);
        }
        // 设置到 Request Attribute，供 JSP 通过 ${_csrf_token} 访问
        request.setAttribute(CsrfUtil.CSRF_TOKEN_ATTR, token);
    }

    /**
     * 判断请求路径是否需要排除
     */
    private boolean isExcluded(String path) {
        for (String prefix : EXCLUDE_PREFIXES) {
            if (path.startsWith(prefix)) {
                return true;
            }
        }
        return false;
    }

    /**
     * 返回 403 禁止访问
     */
    private void sendForbidden(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 如果是 AJAX 请求，返回纯文本 403
        String xRequestedWith = request.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equals(xRequestedWith)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().write("CSRF 验证失败，请刷新页面后重试");
            return;
        }
        // 普通请求转发到错误页面
        request.setAttribute("errorMsg", "CSRF 验证失败，请刷新页面后重试");
        request.getRequestDispatcher("/WEB-INF/jsp/common/csrf-error.jsp").forward(request, response);
    }

    @Override
    public void destroy() {
        // 无需清理
    }
}
