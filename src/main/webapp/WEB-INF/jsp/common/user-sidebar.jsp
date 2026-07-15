<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bootstrap-theme.css">
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
<style>
    .sidebar {
        position: fixed;
        top: 64px;
        left: 0;
        width: 220px;
        height: calc(100vh - 64px);
        background: white;
        border-right: 1px solid var(--border-color);
        padding: 20px 0;
        overflow-y: auto;
        z-index: 900;
        transition: transform 0.3s ease;
    }

    .sidebar-title {
        font-size: 14px;
        font-weight: 600;
        padding: 0 20px 15px;
        border-bottom: 2px solid #3d5a80;
        margin-bottom: 10px;
        color: var(--text-muted);
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .nav-item {
        display: flex;
        align-items: center;
        padding: 14px 20px;
        color: var(--text-dark);
        text-decoration: none;
        border-left: 3px solid transparent;
        transition: all 0.3s ease;
        font-size: 14px;
    }

    .nav-item:hover {
        background-color: rgba(61, 90, 128, 0.05);
        border-left-color: #3d5a80;
        color: #3d5a80;
    }

    .nav-item.active {
        background-color: rgba(61, 90, 128, 0.1);
        border-left-color: #3d5a80;
        color: #3d5a80;
        font-weight: 600;
    }

    .icon {
        margin-right: 10px;
        font-size: 18px;
    }

    @media (max-width: 768px) {
        .sidebar {
            transform: translateX(-100%);
            width: 260px;
            box-shadow: 2px 0 12px rgba(0, 0, 0, 0.15);
        }

        .sidebar.mobile-open {
            transform: translateX(0);
        }

        .nav-item {
            padding: 16px 24px;
            font-size: 15px;
        }

        .icon {
            font-size: 20px;
            margin-right: 12px;
        }
    }
</style>
