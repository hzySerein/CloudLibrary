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
        /* 用户界面绿色主题覆盖 */
        .header {
            background-color: #28a745 !important; /* 绿色主题 */
        }
        
        .user-info a {
            background-color: rgba(40, 167, 69, 0.2) !important;
        }
        
        .user-info a:hover {
            background-color: rgba(40, 167, 69, 0.3) !important;
        }
        
        .sidebar-title {
            border-bottom: 2px solid #28a745 !important; /* 绿色主题 */
        }
        
        .nav-item:hover {
            background-color: #e8f5e9 !important; /* 浅绿色背景 */
            border-left-color: #28a745 !important;
        }
        
        .nav-item.active {
            background-color: #e8f5e9 !important; /* 浅绿色背景 */
            border-left-color: #28a745 !important;
            color: #28a745 !important;
        }
        
        .form-title {
            border-bottom: 2px solid #28a745 !important; /* 绿色主题 */
        }
        
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        
        .menu-item {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow: hidden;
            transition: all 0.3s ease;
            text-align: center;
            padding: 30px 20px;
        }
        
        .menu-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(40, 167, 69, 0.2); /* 绿色阴影 */
        }
        
        .menu-item a {
            text-decoration: none;
            color: #333;
            display: block;
            width: 100%;
            height: 100%;
        }
        
        .menu-item .icon {
            display: block;
            font-size: 40px;
            margin-bottom: 15px;
            color: #28a745; /* 绿色图标 */
        }
        
        .menu-item a:hover {
            color: #28a745; /* 绿色悬停 */
        }
    </style>
</head>
<body>
<div class="header">
    <h2>云借阅系统 - 用户中心</h2>
    <div class="user-info">
        欢迎您：<c:out value="${loginUser.name}"/>
        <a href="${pageContext.request.contextPath}/user/profile">修改个人信息</a>
        <a href="${pageContext.request.contextPath}/user/logout">退出登录</a>
    </div>
</div>

<div class="sidebar">
    <div class="sidebar-title">用户功能</div>
    <a href="${pageContext.request.contextPath}/user/borrow/apply" class="nav-item">
        <span class="icon">📖</span> 借阅图书
    </a>
    <a href="${pageContext.request.contextPath}/user/borrow/list" class="nav-item">
        <span class="icon">📚</span> 我的借阅
    </a>
    <a href="${pageContext.request.contextPath}/user/overdue/list" class="nav-item">
        <span class="icon">⏰</span> 逾期记录
    </a>
    <a href="${pageContext.request.contextPath}/user/profile" class="nav-item">
        <span class="icon">👤</span> 个人信息
    </a>
</div>

<div class="main-container">
    <div class="content">
        <h2 class="form-title">用户功能菜单</h2>
        <div class="menu-grid">
            <div class="menu-item">
                <a href="${pageContext.request.contextPath}/user/borrow/apply">
                    <span class="icon">📖</span>
                    图书借阅
                </a>
            </div>
            <div class="menu-item">
                <a href="${pageContext.request.contextPath}/user/borrow/list">
                    <span class="icon">📚</span>
                    我的借阅
                </a>
            </div>
            <div class="menu-item">
                <a href="${pageContext.request.contextPath}/user/overdue/list">
                    <span class="icon">⏰</span>
                    逾期记录
                </a>
            </div>
        </div>
    </div>
</div>
</body>
</html>