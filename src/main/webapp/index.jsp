<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>云借阅图书管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bootstrap-theme.css">
    <style>
        body {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--accent-color) 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            position: relative;
            overflow: hidden;
        }

        body::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 1px, transparent 1px);
            background-size: 50px 50px;
            animation: movePattern 20s linear infinite;
        }

        @keyframes movePattern {
            0% { transform: translate(0, 0); }
            100% { transform: translate(50px, 50px); }
        }

        .container {
            width: 100%;
            max-width: 900px;
            text-align: center;
            position: relative;
            z-index: 1;
            animation: fadeInUp 0.8s ease-out;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .title {
            font-size: 42px;
            color: white;
            margin-bottom: 20px;
            font-weight: 700;
            text-shadow: 0 4px 20px rgba(0,0,0,0.3);
            letter-spacing: 2px;
        }

        .subtitle {
            font-size: 18px;
            color: rgba(255, 255, 255, 0.9);
            margin-bottom: 60px;
            font-weight: 300;
        }

        .entry-list {
            display: flex;
            justify-content: center;
            gap: 50px;
            flex-wrap: wrap;
        }

        .entry-item {
            width: 280px;
            padding: 50px 30px;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            position: relative;
            overflow: hidden;
            cursor: pointer;
        }

        .entry-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            transition: height 0.4s;
        }

        .entry-item:hover {
            transform: translateY(-15px) scale(1.05);
            box-shadow: 0 30px 80px rgba(0,0,0,0.4);
        }

        .entry-item:hover::before {
            height: 100%;
            opacity: 0.05;
        }

        .entry-item a {
            text-decoration: none;
            color: var(--text-dark);
            display: block;
            position: relative;
            z-index: 1;
        }

        .entry-item .icon {
            font-size: 48px;
            margin-bottom: 20px;
            display: block;
            transition: transform 0.3s;
        }

        .entry-item:hover .icon {
            transform: scale(1.2) rotate(5deg);
        }

        .entry-item .role {
            font-size: 24px;
            margin-bottom: 20px;
            font-weight: 700;
            color: var(--text-dark);
            transition: color 0.3s;
        }

        .entry-item:hover .role {
            color: inherit;
        }

        .entry-item .desc {
            color: var(--text-muted);
            font-size: 15px;
            line-height: 1.8;
            transition: color 0.3s;
        }

        .entry-item:hover .desc {
            color: var(--text-dark);
        }

        .admin-entry {
            border-top: 5px solid var(--primary-color);
        }

        .admin-entry::before {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
        }

        .admin-entry:hover .role {
            color: var(--primary-color);
        }

        .user-entry {
            border-top: 5px solid var(--success);
        }

        .user-entry::before {
            background: linear-gradient(135deg, var(--success) 0%, #20c997 100%);
        }

        .user-entry:hover .role {
            color: var(--success);
        }

        @media (max-width: 768px) {
            .title { font-size: 32px; margin-bottom: 50px; }
            .entry-list { gap: 30px; }
            .entry-item { width: 100%; max-width: 350px; }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="title">📚 云借阅图书管理系统</div>
    <div class="subtitle">便捷的图书借阅管理平台</div>
    <div class="entry-list">
        <div class="entry-item admin-entry">
            <a href="${pageContext.request.contextPath}/admin/toLogin">
                <span class="icon">👨‍💼</span>
                <div class="role">管理员登录</div>
                <div class="desc">管理用户、图书、借阅、逾期等系统功能，全面掌控图书管理系统</div>
            </a>
        </div>
        <div class="entry-item user-entry">
            <a href="${pageContext.request.contextPath}/user/toLogin">
                <span class="icon">👤</span>
                <div class="role">普通用户登录</div>
                <div class="desc">借阅图书、归还图书、查看借阅记录，享受便捷的借阅服务</div>
            </a>
        </div>
    </div>
</div>
</body>
</html>