<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="zh-CN" class="user-theme">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的借阅 - 用户中心</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bootstrap-theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user-theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css">
    <style>
        .table-container {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            overflow: hidden;
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
<jsp:include page="../../common/user-header.jsp">
    <jsp:param name="title" value="云借阅系统 - 用户中心"/>
</jsp:include>
<jsp:include page="../../common/user-sidebar.jsp">
    <jsp:param name="activePage" value="borrow-list"/>
</jsp:include>

<div class="main-container">
    <div class="content">
        <h2 class="form-title">我的借阅记录</h2>
        
        <div class="top-bar">
            <form method="get" action="${pageContext.request.contextPath}/user/borrow/list" class="search-box">
                <input type="text" name="keyword" class="form-control search-input" aria-label="搜索借阅记录" placeholder="请输入图书名称或作者" value="${fn:escapeXml(keyword)}">
                <button type="submit" class="btn btn-primary">搜索</button>
                <c:if test="${not empty keyword}">
                    <a href="${pageContext.request.contextPath}/user/borrow/list" class="btn btn-outline">清空</a>
                </c:if>
            </form>
        </div>
        
        <div class="table-container">
            <div class="table-responsive">
                <table class="table" style="min-width: 950px;">
                    <thead>
                        <tr>
                            <th style="min-width: 200px;">图书名称</th>
                            <th style="min-width: 170px;">借阅时间</th>
                            <th style="min-width: 140px;">应归还时间</th>
                            <th style="min-width: 170px;">实际归还时间</th>
                            <th style="min-width: 90px; text-align: center;">逾期天数</th>
                            <th style="min-width: 80px; text-align: center;">状态</th>
                            <th style="min-width: 100px; text-align: center;">操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${pageUtil.list}" var="borrow">
                            <tr>
                                <td>
                                    <c:set var="book" value="${bookMap[borrow.bookId]}" />
                                    <c:choose>
                                        <c:when test="${book != null}">
                                            <strong><c:out value="${book.name}"/></strong><br/>
                                            <span style="font-size: 12px; color: var(--text-muted);">作者：<c:out value="${book.author}"/></span>
                                        </c:when>
                                        <c:otherwise>
                                            图书ID: ${borrow.bookId}
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td><fmt:formatDate value="${borrow.borrowTime}" pattern="yyyy年MM月dd日 HH:mm:ss"/></td>
                                <td><fmt:formatDate value="${borrow.dueTime}" pattern="yyyy年MM月dd日"/></td>
                                <td><fmt:formatDate value="${borrow.returnTime}" pattern="yyyy年MM月dd日 HH:mm:ss"/></td>
                                <td>
                                    <c:set var="overdueDays" value="${overdueDaysMap[borrow.id]}" />
                                    <c:choose>
                                        <c:when test="${overdueDays != null && overdueDays > 0}">
                                            <span class="badge badge-danger">逾期${overdueDays}天</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-success">未逾期</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${borrow.status == 0}">
                                            <span class="badge badge-warning">未归还</span>
                                        </c:when>
                                        <c:when test="${borrow.status == 1}">
                                            <span class="badge badge-success">已归还</span>
                                        </c:when>
                                        <c:when test="${borrow.status == 2}">
                                            <span class="badge badge-info">待确认</span>
                                        </c:when>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="operate-actions">
                                        <c:if test="${borrow.status == 0}">
                                            <c:set var="overdueDays" value="${overdueDaysMap[borrow.id]}" />
                                            <c:set var="book" value="${bookMap[borrow.bookId]}" />
                                            <a href="javascript:void(0)" data-borrow-id="${borrow.id}" data-book-name="${fn:escapeXml(book.name)}" data-overdue="${overdueDays != null ? overdueDays : 0}" onclick="showReturnModal(this)" class="btn btn-accent btn-sm">申请归还</a>
                                        </c:if>
                                        <c:if test="${borrow.status == 1}">
                                            <span style="color: var(--text-muted); font-size: 12px;">已归还</span>
                                        </c:if>
                                        <c:if test="${borrow.status == 2}">
                                            <span style="color: var(--info); font-size: 12px;">待管理员确认</span>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty pageUtil.list}">
                            <tr>
                                <td colspan="7">
                                    <div class="empty-state">
                                        <div class="empty-state-icon">📚</div>
                                        <div class="empty-state-text">暂无借阅记录</div>
                                        <div class="empty-state-subtext">去借阅一本图书吧！</div>
                                    </div>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
        
        <jsp:include page="../../common/pagination.jsp">
            <jsp:param name="pageUrl" value="${pageContext.request.contextPath}/user/borrow/list"/>
        </jsp:include>
    </div>
</div>

<script src="${pageContext.request.contextPath}/static/js/common.js"></script>
<script>
    function showReturnModal(btn) {
        var borrowId = btn.getAttribute('data-borrow-id');
        var bookName = btn.getAttribute('data-book-name');
        var overdueDays = parseInt(btn.getAttribute('data-overdue')) || 0;
        let message = '确认申请归还《' + bookName + '》吗？';
        if (overdueDays > 0) {
            message += '\n\n注意：该图书已逾期 ' + overdueDays + ' 天，请尽快归还！';
        }
        
        Modal.confirm(message, {
            title: '申请归还'
        }).then(confirmed => {
            if (confirmed) {
                // 动态创建POST表单提交（替代GET请求）
                var form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/user/borrow/return/' + borrowId;
                var csrfInput = document.createElement('input');
                csrfInput.type = 'hidden';
                csrfInput.name = '_csrf';
                csrfInput.value = '${_csrf_token}';
                form.appendChild(csrfInput);
                document.body.appendChild(form);
                form.submit();
            }
        });
    }
</script>
<script src="${pageContext.request.contextPath}/static/js/layout.js"></script>
</body>
</html>