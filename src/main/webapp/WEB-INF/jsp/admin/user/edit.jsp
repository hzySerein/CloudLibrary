<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<tags:layout role="admin" pageTitle="编辑用户 - 管理员后台" activePage="user-list" account="${loginAdmin}">
    <div class="form-title">编辑用户信息</div>
    <form action="${pageContext.request.contextPath}/admin/user/edit" method="post">
        <input type="hidden" name="_csrf" value="${_csrf_token}">
        <input type="hidden" name="id" value="${user.id}">
        <tags:user-form-fields user="${user}" editMode="true"/>
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
</tags:layout>
