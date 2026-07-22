<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ attribute name="role" required="true" rtexprvalue="true"%>
<%@ attribute name="account" type="java.lang.Object" required="true" rtexprvalue="true"%>
<%@ attribute name="headerTitle" required="false"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<div class="header">
    <div class="header-left">
        <button class="mobile-menu-toggle" aria-label="切换菜单" data-action="toggle-mobile-menu">
            <span></span>
            <span></span>
            <span></span>
        </button>
        <h2><c:out value="${not empty headerTitle ? headerTitle : (role == 'admin' ? '云借阅系统 - 管理员后台' : '云借阅系统 - 用户中心')}"/></h2>
    </div>
    <div class="user-info">
        <span class="user-name">欢迎您：<c:out value="${account.name}"/></span>
        <a href="${ctx}/${role}/profile" class="user-action">个人中心</a>
        <form action="${ctx}/${role}/logout" method="post" class="logout-form">
            <input type="hidden" name="_csrf" value="${_csrf_token}">
            <button type="submit" class="user-action logout">退出登录</button>
        </form>
    </div>
</div>
