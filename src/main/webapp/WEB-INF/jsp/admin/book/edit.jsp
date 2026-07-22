<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<tags:layout role="admin" pageTitle="编辑图书 - 管理员后台" activePage="book-list" account="${loginAdmin}" pageCss="/static/css/pages/book-edit.css">

    <div class="form-title">编辑图书信息</div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger"><c:out value="${error}"/></div>
    </c:if>

    <c:if test="${not empty message}">
        <div class="alert alert-success"><c:out value="${message}"/></div>
    </c:if>

    <form action="${pageContext.request.contextPath}/admin/book/edit" method="post">
        <input type="hidden" name="_csrf" value="${_csrf_token}">
        <input type="hidden" name="id" value="${book.id}">
        <tags:book-form-fields book="${book}" editMode="true"/>
        <div class="form-group">
            <label for="status" class="form-label">图书状态</label>
            <select id="status" name="status">
                <option value="1" ${book.status == 1 ? 'selected' : ''}>可借</option>
                <option value="0" ${book.status == 0 ? 'selected' : ''}>不可借</option>
            </select>
        </div>
        <div class="form-group">
            <label class="form-label">图书封面</label>
            <c:if test="${not empty book.cover}">
                <div class="cover-preview">
                    <img src="${pageContext.request.contextPath}${book.cover}" alt="封面" class="cover-preview-img" onerror="this.src='${pageContext.request.contextPath}/static/images/no-cover.png'; this.onerror=null;">
                </div>
            </c:if>
            <c:if test="${empty book.cover}">
                <div class="cover-preview"><span>暂无封面</span></div>
            </c:if>
            <div class="cover-upload-row">
                <input type="file" name="coverFile" accept="image/*">
                <button type="button" data-action="upload-cover" data-csrf="${_csrf_token}" data-upload-url="${pageContext.request.contextPath}/admin/book/uploadCover/${book.id}" class="btn btn-primary">上传封面</button>
            </div>
        </div>
        <div class="btn-group">
            <button type="submit" class="btn btn-success">提交</button>
            <a href="${pageContext.request.contextPath}/admin/book/list" class="btn btn-secondary">返回列表</a>
        </div>
    </form>

    <script src="${pageContext.request.contextPath}/static/js/pages/book-edit.js"></script>
</tags:layout>
