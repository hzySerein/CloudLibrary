<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<tags:layout role="${role}" pageTitle="借阅图书 - ${roleName}中心" activePage="borrow-apply" account="${account}" pageCss="/static/css/components/book-catalog.css">

    <h2 class="form-title">借阅图书申请</h2>

    <c:if test="${param.error == 'stock'}">
        <div class="alert alert-danger fade-in"><span class="toast-icon">✕</span><span>该图书库存不足，无法借阅！</span></div>
    </c:if>
    <c:if test="${param.error == 'disabled' || param.error == 'book_disabled'}">
        <div class="alert alert-danger fade-in"><span class="toast-icon">✕</span><span>该图书已被禁用或下架，暂无法借阅！</span></div>
    </c:if>
    <c:if test="${param.error == 'system'}">
        <div class="alert alert-danger fade-in"><span class="toast-icon">✕</span><span>系统处理异常，借阅失败，请稍后重试！</span></div>
    </c:if>

    <div class="search-bar">
        <form action="${pageContext.request.contextPath}${applyUrl}" method="get" class="search-box">
            <input type="text" name="keyword" class="form-control search-input" aria-label="搜索图书" placeholder="请输入图书名称、作者或ISBN" value="${fn:escapeXml(keyword)}">
            <button type="submit" class="btn btn-primary">搜索</button>
            <c:if test="${not empty keyword}">
                <a href="${pageContext.request.contextPath}${applyUrl}" class="btn btn-outline">清空</a>
            </c:if>
        </form>
    </div>

    <div class="book-grid">
        <c:forEach items="${pageUtil.list}" var="book">
            <tags:book-card book="${book}"/>
        </c:forEach>
        <c:if test="${empty pageUtil.list}">
            <div class="book-catalog-empty">
                <div class="empty-state">
                    <div class="empty-state-icon">📚</div>
                    <div class="empty-state-text">暂无图书</div>
                    <div class="empty-state-subtext">请稍后再试或联系管理员添加图书</div>
                </div>
            </div>
        </c:if>
    </div>

    <tags:pagination pageData="${pageUtil}" baseUrl="${pageContext.request.contextPath}${applyUrl}" keyword="${keyword}"/>

    <div class="book-catalog-actions">
        <a href="${pageContext.request.contextPath}${borrowListUrl}" class="btn btn-outline">查看我的借阅</a>
    </div>

    <tags:book-detail-modal/>

    <script src="${pageContext.request.contextPath}/static/js/common.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/pages/borrow-apply.js"></script>
    <script>
        BorrowApply.init({
            contextPath: '${pageContext.request.contextPath}',
            detailUrl: '${pageContext.request.contextPath}${detailUrl}',
            applyUrl: '${pageContext.request.contextPath}${applyUrl}',
            csrfToken: '${_csrf_token}',
            currentDate: '${currentDate}'
        });
    </script>
</tags:layout>
