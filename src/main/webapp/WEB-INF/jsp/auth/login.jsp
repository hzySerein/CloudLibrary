<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN" class="${themeClass}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${pageTitle}"/> - 云借阅图书管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bootstrap-theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/pages/login.css">
</head>
<body>
<div class="login-container slide-up">
    <div class="card">
        <div class="login-header">
            <h1><c:out value="${roleName}"/>登录</h1>
            <p>云借阅图书管理系统</p>
        </div>
        <div class="card-body login-body">
            <c:if test="${not empty msg}">
                <div class="alert alert-danger fade-in">
                    <span class="toast-icon">✕</span>
                    <span><c:out value="${msg}"/></span>
                </div>
            </c:if>
            <form id="loginForm" action="${pageContext.request.contextPath}${loginAction}" method="post">
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
                    <a href="#" data-action="show-toast" data-toast-message="忘记密码功能请联系管理员">忘记密码？</a>
                </div>
                <button type="submit" class="btn btn-primary btn-lg login-submit">登 录</button>
            </form>
            <div class="back-link">
                <a href="${pageContext.request.contextPath}/">← 返回首页</a>
            </div>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/static/js/common.js"></script>
<script src="${pageContext.request.contextPath}/static/js/pages/login.js"></script>
</body>
</html>
