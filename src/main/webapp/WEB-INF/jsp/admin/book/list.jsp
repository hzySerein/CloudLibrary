<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<tags:layout role="admin" pageTitle="图书管理 - 管理员后台" activePage="book-list" account="${loginAdmin}" pageCss="/static/css/pages/book-list.css">

    <h2 class="form-title">图书列表</h2>

    <c:if test="${not empty message}">
        <div class="alert alert-success fade-in">
            <span class="toast-icon">✓</span>
            <span><c:out value="${message}"/></span>
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger fade-in">
            <span class="toast-icon">✕</span>
            <span><c:out value="${error}"/></span>
        </div>
    </c:if>
    <c:if test="${param.error == 'has_borrows'}">
        <div class="alert alert-danger fade-in">
            <span class="toast-icon">✕</span>
            <span>该图书存在借阅记录，无法删除。请先处理完所有借阅记录后再删除。</span>
        </div>
    </c:if>

    <div class="book-list-top-bar">
        <div class="book-list-search">
            <form method="get" action="${pageContext.request.contextPath}/admin/book/list" class="book-list-search-form">
                <input type="text" name="keyword" class="form-control book-list-search-input" aria-label="搜索图书" placeholder="请输入书名、作者或ISBN" value="${fn:escapeXml(keyword)}">
                <button type="submit" class="btn btn-primary">搜索</button>
                <c:if test="${not empty keyword}">
                    <a href="${pageContext.request.contextPath}/admin/book/list" class="btn btn-outline">清空</a>
                </c:if>
            </form>
            <a href="${pageContext.request.contextPath}/admin/book/toAdd">
                <button class="btn btn-accent">+ 添加图书</button>
            </a>
        </div>
    </div>

    <div class="book-list-table-container">
        <div class="book-list-table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>封面</th>
                        <th>图书名称</th>
                        <th>作者</th>
                        <th>ISBN</th>
                        <th>库存数量</th>
                        <th>图书类型</th>
                        <th>状态</th>
                        <th class="col-ops">操作</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${pageUtil.list}" var="book">
                        <tr>
                            <td>${book.id}</td>
                            <td>
                                <c:if test="${not empty book.cover}">
                                    <img src="${pageContext.request.contextPath}${book.cover}" alt="${fn:escapeXml(book.name)}" class="book-cover" onerror="this.src='${pageContext.request.contextPath}/static/images/no-cover.png'; this.onerror=null;">
                                </c:if>
                                <c:if test="${empty book.cover}">
                                    <span class="text-muted">无封面</span>
                                </c:if>
                            </td>
                            <td><strong><c:out value="${book.name}"/></strong></td>
                            <td><c:out value="${book.author}"/></td>
                            <td><c:out value="${book.isbn}"/></td>
                            <td><c:out value="${book.stock}"/></td>
                            <td><c:out value="${book.type}"/></td>
                            <td>
                                <c:if test="${book.status == 1}">
                                    <span class="badge badge-success">启用</span>
                                </c:if>
                                <c:if test="${book.status == 0}">
                                    <span class="badge badge-danger">禁用</span>
                                </c:if>
                            </td>
                            <td>
                                <div class="operate-actions">
                                    <a href="${pageContext.request.contextPath}/admin/book/toEdit/${book.id}" class="btn btn-info btn-sm">编辑</a>
                                    <c:if test="${book.status == 1}">
                                        <form action="${pageContext.request.contextPath}/admin/book/disable/${book.id}" method="post" data-confirm-message="确认禁用该图书吗？">
                                            <input type="hidden" name="_csrf" value="${_csrf_token}">
                                            <button type="submit" class="btn btn-warning btn-sm">禁用</button>
                                        </form>
                                    </c:if>
                                    <c:if test="${book.status == 0}">
                                        <form action="${pageContext.request.contextPath}/admin/book/enable/${book.id}" method="post" data-confirm-message="确认启用该图书吗？">
                                            <input type="hidden" name="_csrf" value="${_csrf_token}">
                                            <button type="submit" class="btn btn-success btn-sm">启用</button>
                                        </form>
                                    </c:if>
                                    <form action="${pageContext.request.contextPath}/admin/book/delete/${book.id}" method="post" data-confirm-message="确认删除该图书吗？&#10;注意：此操作不可恢复！">
                                        <input type="hidden" name="_csrf" value="${_csrf_token}">
                                        <button type="submit" class="btn btn-danger btn-sm">删除</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty pageUtil.list}">
                        <tr>
                            <td colspan="9">
                                <div class="empty-state">
                                    <div class="empty-state-icon">📚</div>
                                    <div class="empty-state-text">暂无图书记录</div>
                                    <div class="empty-state-subtext">点击"添加图书"按钮添加第一本图书</div>
                                </div>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <tags:pagination pageData="${pageUtil}" baseUrl="${pageContext.request.contextPath}/admin/book/list" keyword="${keyword}"/>
    <script src="${pageContext.request.contextPath}/static/js/common.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/pages/book-list.js"></script>
</tags:layout>
