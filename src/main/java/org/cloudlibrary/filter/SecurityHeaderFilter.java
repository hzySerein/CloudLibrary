package org.cloudlibrary.filter;

import javax.servlet.*;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 安全响应头过滤器
 * 添加常见的安全HTTP头，防止点击劫持、MIME嗅探等攻击
 */
public class SecurityHeaderFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 无需初始化
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // 防止MIME嗅探（上传的文件不会被当作脚本执行）
        httpResponse.setHeader("X-Content-Type-Options", "nosniff");

        // 防止点击劫持
        httpResponse.setHeader("X-Frame-Options", "SAMEORIGIN");

        // XSS防护（现代浏览器）
        httpResponse.setHeader("X-XSS-Protection", "1; mode=block");

        // 内容安全策略（允许内联样式和脚本，限制其他资源来源）
        // 注意：由于项目使用内联style和script，CSP策略较宽松
        httpResponse.setHeader("Content-Security-Policy",
                "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval' https://cdn.jsdelivr.net; " +
                "style-src 'self' 'unsafe-inline'; img-src 'self' data:;");

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // 无需清理
    }
}
