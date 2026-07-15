<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN" class="admin-theme">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理员登录 - 云借阅图书管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bootstrap-theme.css">
    <style>
        body {
            background: linear-gradient(135deg, #3d5a80 0%, #ee6c4d 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .login-container {
            width: 100%;
            max-width: 420px;
        }

        .login-header {
            text-align: center;
            padding: 30px 0 20px;
        }

        .login-header h1 {
            font-size: 28px;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 8px;
        }

        .login-header p {
            color: var(--text-muted);
            font-size: 14px;
        }

        .login-body {
            padding: 0 10px;
        }

        .form-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .form-options label {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 14px;
            color: var(--text-muted);
            cursor: pointer;
        }

        .form-options input[type="checkbox"] {
            width: auto;
            cursor: pointer;
        }

        .form-options a {
            font-size: 14px;
            color: var(--primary-color);
        }

        .form-options a:hover {
            color: var(--accent-color);
        }

        .back-link {
            text-align: center;
            margin-top: 24px;
        }

        .back-link a {
            color: var(--text-muted);
            font-size: 14px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .back-link a:hover {
            color: var(--primary-color);
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .slide-up {
            animation: slideUp 0.5s ease-out;
        }
    </style>
</head>
<body>
<div class="login-container slide-up">
    <div class="card">
        <div class="login-header">
            <h1>管理员登录</h1>
            <p>云借阅图书管理系统</p>
        </div>
        <div class="card-body login-body">
            <c:if test="${not empty msg}">
                <div class="alert alert-danger fade-in">
                    <span class="toast-icon">✕</span>
                    <span><c:out value="${msg}"/></span>
                </div>
            </c:if>
            <form id="loginForm" action="${pageContext.request.contextPath}/admin/login" method="post">
                <input type="hidden" name="_csrf" value="${_csrf_token}">
                <div class="form-group">
                    <label for="username">用户名</label>
                    <input type="text" id="username" name="username" class="form-control" placeholder="请输入用户名" required autofocus>
                    <div class="invalid-feedback"></div>
                </div>
                <div class="form-group">
                    <label for="password">密码</label>
                    <input type="password" id="password" name="password" class="form-control" placeholder="请输入密码" required>
                    <div class="invalid-feedback"></div>
                </div>
                <div class="form-options">
                    <label>
                        <input type="checkbox" name="remember" value="true">
                        记住密码
                    </label>
                    <a href="javascript:void(0)" onclick="toast.info('忘记密码功能请联系管理员')">忘记密码？</a>
                </div>
                <button type="submit" class="btn btn-primary btn-lg" style="width: 100%;">登 录</button>
            </form>
            <div class="back-link">
                <a href="${pageContext.request.contextPath}/">← 返回首页</a>
            </div>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/static/js/common.js"></script>
<script>
    const loginForm = document.getElementById('loginForm');
    new FormValidator(loginForm, {
        rules: {
            username: [
                { required: true, message: '请输入用户名' },
                { minLength: 3, message: '用户名至少需要3个字符' }
            ],
            password: [
                { required: true, message: '请输入密码' },
                { minLength: 6, message: '密码至少需要6个字符' }
            ]
        }
    });
</script>
</body>
</html>