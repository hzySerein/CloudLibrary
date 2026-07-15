<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="zh-CN" class="admin-theme">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>修改个人信息 - 管理员后台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bootstrap-theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin-theme.css">
</head>
<body>
<jsp:include page="../common/admin-header.jsp">
    <jsp:param name="title" value="云借阅系统 - 管理员后台"/>
</jsp:include>
<jsp:include page="../common/admin-sidebar.jsp">
    <jsp:param name="activePage" value="profile"/>
</jsp:include>

<div class="main-container">
    <div class="content">
        <h2 class="form-title">修改个人信息</h2>
        <form action="${pageContext.request.contextPath}/admin/profile" method="post">
            <input type="hidden" name="_csrf" value="${_csrf_token}">
            <input type="hidden" name="id" value="${admin.id}">
            <div class="form-group">
                <label for="username">用户名</label>
                <input type="text" id="username" name="username" value="${fn:escapeXml(admin.username)}" required placeholder="请输入用户名">
            </div>
            <div class="form-group">
                <label for="name">姓名</label>
                <input type="text" id="name" name="name" value="${fn:escapeXml(admin.name)}" required placeholder="请输入姓名">
            </div>
            <div class="form-group">
                <button type="submit">保存修改</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>