<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<tags:layout role="admin" pageTitle="添加用户 - 管理员后台" activePage="user-list" account="${loginAdmin}">
    <div class="form-title">新增普通用户</div>
    <form action="${pageContext.request.contextPath}/admin/user/add" method="post">
        <input type="hidden" name="_csrf" value="${_csrf_token}">
        <tags:user-form-fields/>
        <div class="btn-group">
            <button type="submit" class="btn btn-success">提交</button>
            <a href="${pageContext.request.contextPath}/admin/user/list" class="btn btn-secondary">返回列表</a>
        </div>
    </form>
</tags:layout>
