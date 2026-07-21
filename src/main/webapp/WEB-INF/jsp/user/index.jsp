<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户首页 - 云借阅系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bootstrap-theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user-theme.css">
    <style>
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            gap: 24px;
            margin-top: 24px;
        }

        .menu-item {
            background: #ffffff;
            border-radius: var(--border-radius-lg, 16px);
            box-shadow: var(--card-shadow, 0 4px 12px rgba(0,0,0,0.05));
            border: 1px solid var(--border-color, #e2e8f0);
            overflow: hidden;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            text-align: center;
            padding: 36px 24px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .menu-item:hover {
            transform: translateY(-6px);
            box-shadow: 0 12px 24px rgba(16, 185, 129, 0.18);
            border-color: rgba(16, 185, 129, 0.3);
        }

        .menu-item a {
            text-decoration: none;
            color: var(--text-dark, #0f172a);
            display: flex;
            flex-direction: column;
            align-items: center;
            width: 100%;
            font-weight: 700;
            font-size: 16px;
        }

        .icon-wrapper {
            width: 72px;
            height: 72px;
            border-radius: 20px;
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.12) 0%, rgba(5, 150, 105, 0.18) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }

        .menu-item:hover .icon-wrapper {
            transform: scale(1.1) rotate(-3deg);
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.2) 0%, rgba(5, 150, 105, 0.28) 100%);
        }

        .menu-item .icon {
            font-size: 36px;
        }

        .menu-item a:hover {
            color: #047857;
        }
    </style>
</head>
<body>
<jsp:include page="../common/user-header.jsp">
    <jsp:param name="title" value="云借阅系统 - 用户中心"/>
</jsp:include>
<jsp:include page="../common/user-sidebar.jsp">
    <jsp:param name="activePage" value="home"/>
</jsp:include>

<div class="main-container">
    <div class="content">
        <h2 class="form-title">用户功能菜单</h2>
        <div class="menu-grid">
            <div class="menu-item">
                <a href="${pageContext.request.contextPath}/user/borrow/apply">
                    <div class="icon-wrapper">
                        <span class="icon">📖</span>
                    </div>
                    图书借阅
                </a>
            </div>
            <div class="menu-item">
                <a href="${pageContext.request.contextPath}/user/borrow/list">
                    <div class="icon-wrapper">
                        <span class="icon">📚</span>
                    </div>
                    我的借阅
                </a>
            </div>
            <div class="menu-item">
                <a href="${pageContext.request.contextPath}/user/overdue/list">
                    <div class="icon-wrapper">
                        <span class="icon">⏰</span>
                    </div>
                    逾期记录
                </a>
            </div>
        </div>
    </div>
</div>
</body>
</html>
