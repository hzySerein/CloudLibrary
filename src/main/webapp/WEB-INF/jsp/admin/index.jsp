<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN" class="admin-theme">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理员首页 - 云借阅系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bootstrap-theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin-theme.css">
</head>
<body>
<jsp:include page="../common/admin-header.jsp">
    <jsp:param name="title" value="云借阅系统 - 管理员后台"/>
</jsp:include>
<jsp:include page="../common/admin-sidebar.jsp">
    <jsp:param name="activePage" value="home"/>
</jsp:include>

<div class="main-container">
    <div class="content">
        <h2 class="form-title">核心功能菜单</h2>
        <div class="menu-grid">
            <div class="menu-item">
                <a href="${pageContext.request.contextPath}/admin/user/list">
                    <span class="icon">👥</span>
                    用户管理
                </a>
            </div>
            <div class="menu-item">
                <a href="${pageContext.request.contextPath}/admin/book/list">
                    <span class="icon">📚</span>
                    图书管理
                </a>
            </div>
            <div class="menu-item">
                <a href="${pageContext.request.contextPath}/admin/borrow/list">
                    <span class="icon">📖</span>
                    借阅管理
                </a>
            </div>
            <div class="menu-item">
                <a href="${pageContext.request.contextPath}/admin/overdue/list">
                    <span class="icon">⏰</span>
                    逾期管理
                </a>
            </div>
            <div class="menu-item">
                <a href="${pageContext.request.contextPath}/admin/stats/system">
                    <span class="icon">📊</span>
                    系统统计
                </a>
            </div>
            <div class="menu-item">
                <a href="${pageContext.request.contextPath}/admin/borrow/my">
                    <span class="icon">📚</span>
                    我的借阅
                </a>
            </div>
            <div class="menu-item">
                <a href="${pageContext.request.contextPath}/admin/profile">
                    <span class="icon">👤</span>
                    个人信息
                </a>
            </div>
        </div>
    </div>
</div>
</body>
</html>