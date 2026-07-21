<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN" class="admin-theme">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>添加图书 - 管理员后台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bootstrap-theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin-theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css">
</head>
<body>
<jsp:include page="../../common/admin-header.jsp">
    <jsp:param name="title" value="云借阅系统 - 管理员后台 - 添加图书"/>
</jsp:include>
<jsp:include page="../../common/admin-sidebar.jsp">
    <jsp:param name="activePage" value="book-list"/>
</jsp:include>
<div class="main-container">
    <div class="content">
        <div class="form-title">新增图书</div>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger"><c:out value="${error}"/></div>
        </c:if>

        <c:if test="${not empty message}">
            <div class="alert alert-success"><c:out value="${message}"/></div>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/admin/book/add" method="post" enctype="multipart/form-data">
            <input type="hidden" name="_csrf" value="${_csrf_token}">
            <div class="form-group">
                <label for="name" class="form-label">图书名称</label>
                <input type="text" id="name" name="name" required placeholder="请输入图书名称">
            </div>
            <div class="form-group">
                <label for="author" class="form-label">作者</label>
                <input type="text" id="author" name="author" required placeholder="请输入作者">
            </div>
            <div class="form-group">
                <label for="isbn" class="form-label">ISBN编号</label>
                <input type="text" id="isbn" name="isbn" required placeholder="请输入ISBN">
            </div>
            <div class="form-group">
                <label for="stock" class="form-label">库存数量</label>
                <input type="number" id="stock" name="stock" required min="0" placeholder="请输入库存数量">
            </div>
            <div class="form-group">
                <label for="type" class="form-label">图书类型</label>
                <select id="type" name="type" required>
                    <option value="">请选择图书类型</option>
                    <option value="计算机">计算机</option>
                    <option value="科幻">科幻</option>
                    <option value="文学">文学</option>
                    <option value="历史">历史</option>
                    <option value="其他">其他</option>
                </select>
            </div>
            <div class="form-group">
                <label for="description" class="form-label">图书介绍</label>
                <textarea id="description" name="description" rows="5" placeholder="请输入图书介绍"></textarea>
            </div>
            <div class="form-group">
                <label for="coverFile" class="form-label">图书封面</label>
                <input type="file" id="coverFile" name="coverFile" accept="image/*">
            </div>
            <div class="btn-group">
                <button type="submit" class="btn btn-success">提交</button>
                <a href="${pageContext.request.contextPath}/admin/book/list" class="btn btn-secondary">返回列表</a>
            </div>
        </form>
    </div>
</div>
<script src="${pageContext.request.contextPath}/static/js/layout.js"></script>
</body>
</html>