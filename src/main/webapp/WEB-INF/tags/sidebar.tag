<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ attribute name="role" required="true" rtexprvalue="true"%>
<%@ attribute name="activePage" required="true"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:if test="${role == 'admin'}">
<div class="sidebar">
    <div class="sidebar-title">管理员功能</div>
    <a href="${ctx}/admin/borrow/apply" class="nav-item ${activePage == 'borrow-apply' ? 'active' : ''}">
        <span class="icon">📖</span> 图书借阅
    </a>
    <a href="${ctx}/admin/borrow/list" class="nav-item ${activePage == 'borrow-list' ? 'active' : ''}">
        <span class="icon">📚</span> 借阅管理
    </a>
    <a href="${ctx}/admin/book/list" class="nav-item ${activePage == 'book-list' ? 'active' : ''}">
        <span class="icon">📚</span> 图书管理
    </a>
    <a href="${ctx}/admin/user/list" class="nav-item ${activePage == 'user-list' ? 'active' : ''}">
        <span class="icon">👥</span> 用户管理
    </a>
    <a href="${ctx}/admin/overdue/list" class="nav-item ${activePage == 'overdue-list' ? 'active' : ''}">
        <span class="icon">⏰</span> 逾期管理
    </a>
    <a href="${ctx}/admin/stats/system" class="nav-item ${activePage == 'stats' ? 'active' : ''}">
        <span class="icon">📊</span> 系统统计
    </a>
    <a href="${ctx}/admin/borrow/my" class="nav-item ${activePage == 'borrow-my' ? 'active' : ''}">
        <span class="icon">📚</span> 我的借阅
    </a>
</div>
</c:if>
<c:if test="${role == 'user'}">
<div class="sidebar">
    <div class="sidebar-title">用户功能</div>
    <a href="${ctx}/user/borrow/apply" class="nav-item ${activePage == 'borrow-apply' ? 'active' : ''}">
        <span class="icon">📖</span> 图书借阅
    </a>
    <a href="${ctx}/user/borrow/list" class="nav-item ${activePage == 'borrow-list' ? 'active' : ''}">
        <span class="icon">📚</span> 我的借阅
    </a>
    <a href="${ctx}/user/overdue/list" class="nav-item ${activePage == 'overdue-list' ? 'active' : ''}">
        <span class="icon">⏰</span> 逾期记录
    </a>
    <a href="${ctx}/user/profile" class="nav-item ${activePage == 'profile' ? 'active' : ''}">
        <span class="icon">👤</span> 个人信息
    </a>
</div>
</c:if>
