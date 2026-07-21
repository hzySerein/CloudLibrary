<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="sidebar">
    <div class="sidebar-title">管理员功能</div>
    <a href="${pageContext.request.contextPath}/admin/borrow/apply" class="nav-item ${activePage == 'borrow-apply' ? 'active' : ''}">
        <span class="icon">📖</span> 图书借阅
    </a>
    <a href="${pageContext.request.contextPath}/admin/borrow/list" class="nav-item ${activePage == 'borrow-list' ? 'active' : ''}">
        <span class="icon">📚</span> 借阅管理
    </a>
    <a href="${pageContext.request.contextPath}/admin/book/list" class="nav-item ${activePage == 'book-list' ? 'active' : ''}">
        <span class="icon">📚</span> 图书管理
    </a>
    <a href="${pageContext.request.contextPath}/admin/user/list" class="nav-item ${activePage == 'user-list' ? 'active' : ''}">
        <span class="icon">👥</span> 用户管理
    </a>
    <a href="${pageContext.request.contextPath}/admin/overdue/list" class="nav-item ${activePage == 'overdue-list' ? 'active' : ''}">
        <span class="icon">⏰</span> 逾期管理
    </a>
    <a href="${pageContext.request.contextPath}/admin/stats/system" class="nav-item ${activePage == 'stats' ? 'active' : ''}">
        <span class="icon">📊</span> 系统统计
    </a>
    <a href="${pageContext.request.contextPath}/admin/borrow/my" class="nav-item ${activePage == 'borrow-my' ? 'active' : ''}">
        <span class="icon">📚</span> 我的借阅
    </a>
</div>
