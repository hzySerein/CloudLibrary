<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<tags:layout role="admin" pageTitle="添加图书 - 管理员后台" activePage="book-list" account="${loginAdmin}">
    <div class="form-title">新增图书</div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger"><c:out value="${error}"/></div>
    </c:if>

    <c:if test="${not empty message}">
        <div class="alert alert-success"><c:out value="${message}"/></div>
    </c:if>

    <form action="${pageContext.request.contextPath}/admin/book/add" method="post" enctype="multipart/form-data">
        <input type="hidden" name="_csrf" value="${_csrf_token}">
        <tags:book-form-fields/>
        <div class="form-group">
            <label for="coverFile" class="form-label">图书封面</label>
            <input type="file" id="coverFile" name="coverFile" accept="image/*">
        </div>
        <div class="btn-group">
            <button type="submit" class="btn btn-success">提交</button>
            <a href="${pageContext.request.contextPath}/admin/book/list" class="btn btn-secondary">返回列表</a>
        </div>
    </form>
</tags:layout>
