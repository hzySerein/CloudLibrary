<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="zh-CN" class="admin-theme">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>图书管理 - 管理员后台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bootstrap-theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin-theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css">
    <style>
        .book-cover {
            width: 60px;
            height: 80px;
            object-fit: cover;
            border-radius: 6px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }

        .book-cover:hover {
            transform: scale(1.1);
        }

        .table-container {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            overflow: hidden;
        }

        .table-responsive {
            border-radius: 8px;
        }

        .top-bar {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            margin-bottom: 20px;
        }

        .search-box {
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: wrap;
        }

        .search-input {
            flex: 1;
            min-width: 200px;
            max-width: 400px;
        }

        .operate-actions {
            display: inline-flex;
            gap: 6px;
            flex-wrap: wrap;
            align-items: center;
        }

        .operate-actions a {
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 12px;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .operate-actions a:hover {
            transform: translateY(-2px);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: var(--text-muted);
        }

        .empty-state-icon {
            font-size: 64px;
            margin-bottom: 16px;
            opacity: 0.5;
        }

        .empty-state-text {
            font-size: 16px;
            margin-bottom: 8px;
        }

        .empty-state-subtext {
            font-size: 14px;
            opacity: 0.8;
        }
    </style>
</head>
<body>
<jsp:include page="../../common/admin-header.jsp">
    <jsp:param name="title" value="云借阅系统 - 管理员后台"/>
</jsp:include>
<jsp:include page="../../common/admin-sidebar.jsp">
    <jsp:param name="activePage" value="book-list"/>
</jsp:include>

<div class="main-container">
    <div class="content">
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
        
        <div class="top-bar">
            <div class="search-box">
                <form method="get" action="${pageContext.request.contextPath}/admin/book/list" style="display: flex; gap: 10px; align-items: center; flex: 1;">
                    <input type="text" name="keyword" class="form-control search-input" aria-label="搜索图书" placeholder="请输入书名、作者或ISBN" value="${fn:escapeXml(keyword)}">
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
        
        <div class="table-container">
            <div class="table-responsive">
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
                            <th style="width: 220px;">操作</th>
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
                                            <form action="${pageContext.request.contextPath}/admin/book/disable/${book.id}" method="post" style="display:inline;" onsubmit="return confirm('确认禁用该图书吗？')">
                                                <input type="hidden" name="_csrf" value="${_csrf_token}">
                                                <button type="submit" class="btn btn-warning btn-sm">禁用</button>
                                            </form>
                                        </c:if>
                                        <c:if test="${book.status == 0}">
                                            <form action="${pageContext.request.contextPath}/admin/book/enable/${book.id}" method="post" style="display:inline;" onsubmit="return confirm('确认启用该图书吗？')">
                                                <input type="hidden" name="_csrf" value="${_csrf_token}">
                                                <button type="submit" class="btn btn-success btn-sm">启用</button>
                                            </form>
                                        </c:if>
                                        <form action="${pageContext.request.contextPath}/admin/book/delete/${book.id}" method="post" style="display:inline;" onsubmit="return confirm('确认删除该图书吗？\n注意：此操作不可恢复！')">
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
        
        <jsp:include page="../../common/pagination.jsp">
            <jsp:param name="pageUrl" value="${pageContext.request.contextPath}/admin/book/list"/>
        </jsp:include>
    </div>
</div>
<script src="${pageContext.request.contextPath}/static/js/common.js"></script>
<script src="${pageContext.request.contextPath}/static/js/layout.js"></script>
</body>
</html>