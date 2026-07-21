<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="sidebar">
    <div class="sidebar-title">用户功能</div>
    <a href="${pageContext.request.contextPath}/user/borrow/apply" class="nav-item ${activePage == 'borrow-apply' ? 'active' : ''}">
        <span class="icon">📖</span> 图书借阅
    </a>
    <a href="${pageContext.request.contextPath}/user/borrow/list" class="nav-item ${activePage == 'borrow-list' ? 'active' : ''}">
        <span class="icon">📚</span> 我的借阅
    </a>
    <a href="${pageContext.request.contextPath}/user/overdue/list" class="nav-item ${activePage == 'overdue-list' ? 'active' : ''}">
        <span class="icon">⏰</span> 逾期记录
    </a>
    <a href="${pageContext.request.contextPath}/user/profile" class="nav-item ${activePage == 'profile' ? 'active' : ''}">
        <span class="icon">👤</span> 个人信息
    </a>
</div>
