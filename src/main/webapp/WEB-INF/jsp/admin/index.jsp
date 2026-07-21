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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css">
    <style>
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 24px;
            margin-top: 24px;
        }
        .menu-item {
            background: #ffffff;
            border-radius: var(--border-radius-lg, 16px);
            overflow: hidden;
            box-shadow: var(--card-shadow, 0 4px 12px rgba(0,0,0,0.05));
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border: 1px solid var(--border-color, #e2e8f0);
            padding: 32px 24px;
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            position: relative;
        }
        .menu-item:hover {
            transform: translateY(-6px);
            box-shadow: var(--hover-shadow, 0 12px 24px rgba(54, 87, 124, 0.15));
            border-color: rgba(54, 87, 124, 0.3);
        }
        .icon-wrapper {
            width: 72px;
            height: 72px;
            border-radius: 20px;
            background: linear-gradient(135deg, rgba(54, 87, 124, 0.1) 0%, rgba(36, 60, 90, 0.15) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }
        .menu-item:hover .icon-wrapper {
            transform: scale(1.1) rotate(3deg);
            background: linear-gradient(135deg, rgba(54, 87, 124, 0.2) 0%, rgba(36, 60, 90, 0.25) 100%);
        }
        .menu-item .icon {
            font-size: 34px;
        }
        .menu-item h3 {
            font-size: 18px;
            font-weight: 700;
            color: var(--text-dark, #0f172a);
            margin-bottom: 10px;
        }
        .menu-item p {
            font-size: 13px;
            color: var(--text-muted, #64748b);
            line-height: 1.6;
            margin-bottom: 24px;
            flex-grow: 1;
        }
        .menu-btn {
            width: 100%;
            padding: 11px 18px;
            background: linear-gradient(135deg, #36577c 0%, #243c5a 100%);
            color: white !important;
            border: none;
            border-radius: var(--border-radius-md, 10px);
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            box-shadow: 0 4px 10px rgba(54, 87, 124, 0.25);
            display: block;
        }
        .menu-item:hover .menu-btn {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(54, 87, 124, 0.35);
        }
    </style>
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
                <div class="icon-wrapper">
                    <span class="icon">👥</span>
                </div>
                <h3>用户管理</h3>
                <p>查看、添加与维护系统账号及权限，管理系统用户状态</p>
                <a href="${pageContext.request.contextPath}/admin/user/list" class="menu-btn">进入管理</a>
            </div>
            <div class="menu-item">
                <div class="icon-wrapper">
                    <span class="icon">📚</span>
                </div>
                <h3>图书管理</h3>
                <p>录入、上架与编辑图书信息，维护系统图书库存及状态</p>
                <a href="${pageContext.request.contextPath}/admin/book/list" class="menu-btn">进入管理</a>
            </div>
            <div class="menu-item">
                <div class="icon-wrapper">
                    <span class="icon">📖</span>
                </div>
                <h3>借阅管理</h3>
                <p>审核与管理系统内所有用户的借阅申请、归还申请及借还历史</p>
                <a href="${pageContext.request.contextPath}/admin/borrow/list" class="menu-btn">进入管理</a>
            </div>
            <div class="menu-item">
                <div class="icon-wrapper">
                    <span class="icon">⏰</span>
                </div>
                <h3>逾期管理</h3>
                <p>监控与处理逾期未还图书的借阅记录，确保图书及时归还</p>
                <a href="${pageContext.request.contextPath}/admin/overdue/list" class="menu-btn">进入管理</a>
            </div>
            <div class="menu-item">
                <div class="icon-wrapper">
                    <span class="icon">📊</span>
                </div>
                <h3>系统统计</h3>
                <p>多维度统计分析系统借阅量、热门图书排行、库存量分布等数据</p>
                <a href="${pageContext.request.contextPath}/admin/stats/system" class="menu-btn">进入管理</a>
            </div>
            <div class="menu-item">
                <div class="icon-wrapper">
                    <span class="icon">📚</span>
                </div>
                <h3>我的借阅</h3>
                <p>管理个人借书历史及进行中的借书申请，查看还书进度</p>
                <a href="${pageContext.request.contextPath}/admin/borrow/my" class="menu-btn">进入管理</a>
            </div>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/static/js/layout.js"></script>
</body>
</html>