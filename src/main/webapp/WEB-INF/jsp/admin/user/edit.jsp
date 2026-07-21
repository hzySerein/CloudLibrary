<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="zh-CN" class="admin-theme">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>编辑用户 - 管理员后台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bootstrap-theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin-theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css">
</head>
<body>
<jsp:include page="../../common/admin-header.jsp">
    <jsp:param name="title" value="云借阅系统 - 管理员后台 - 编辑用户"/>
</jsp:include>
<jsp:include page="../../common/admin-sidebar.jsp">
    <jsp:param name="activePage" value="user-list"/>
</jsp:include>
<div class="main-container">
    <div class="content">
        <div class="form-title">编辑用户信息</div>
        <form action="${pageContext.request.contextPath}/admin/user/edit" method="post">
            <input type="hidden" name="_csrf" value="${_csrf_token}">
            <input type="hidden" name="id" value="${user.id}">
            <div class="form-group">
                <label for="username" class="form-label">用户账号</label>
                <input type="text" id="username" name="username" value="${fn:escapeXml(user.username)}" required placeholder="请输入账号">
            </div>
            <div class="form-group">
                <label for="password" class="form-label">用户密码</label>
                <input type="password" id="password" name="password" placeholder="留空则不修改密码">
            </div>
            <div class="form-group">
                <label for="name" class="form-label">用户姓名</label>
                <input type="text" id="name" name="name" value="${fn:escapeXml(user.name)}" required placeholder="请输入姓名">
            </div>
            <div class="form-group">
                <label for="phone" class="form-label">联系电话</label>
                <input type="text" id="phone" name="phone" value="${fn:escapeXml(user.phone)}" placeholder="请输入电话">
            </div>
            <div class="form-group">
                <label for="status" class="form-label">用户状态</label>
                <select id="status" name="status">
                    <option value="1" ${user.status == 1 ? 'selected' : ''}>正常</option>
                    <option value="0" ${user.status == 0 ? 'selected' : ''}>禁用</option>
                </select>
            </div>
            <div class="btn-group">
                <button type="submit" class="btn btn-success">提交</button>
                <a href="${pageContext.request.contextPath}/admin/user/list" class="btn btn-secondary">返回列表</a>
            </div>
        </form>
    </div>
</div>
<script src="${pageContext.request.contextPath}/static/js/layout.js"></script>
</body>
</html>