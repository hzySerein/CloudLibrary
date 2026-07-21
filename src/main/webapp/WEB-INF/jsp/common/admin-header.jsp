<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="header">
    <div class="header-left">
        <button class="mobile-menu-toggle" aria-label="切换菜单" onclick="toggleMobileMenu()">
            <span></span>
            <span></span>
            <span></span>
        </button>
        <h2><c:out value="${title}"/></h2>
    </div>
    <div class="user-info">
        <span class="user-name">欢迎您：<c:out value="${loginUser.name}"/></span>
        <a href="${pageContext.request.contextPath}/admin/profile" class="user-action">个人中心</a>
        <form action="${pageContext.request.contextPath}/admin/logout" method="post" style="display:inline;">
            <input type="hidden" name="_csrf" value="${_csrf_token}">
            <button type="submit" class="user-action logout" style="background:none;border:none;cursor:pointer;">退出登录</button>
        </form>
    </div>
</div>
