<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh-CN" class="user-theme">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的逾期记录 - 云借阅系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bootstrap-theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user-theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css">
    <style>
        .table-container {
            overflow-x: auto;
        }
    </style>
</head>
<body>
<jsp:include page="../../common/user-header.jsp">
    <jsp:param name="title" value="云借阅系统 - 用户中心"/>
</jsp:include>
<jsp:include page="../../common/user-sidebar.jsp">
    <jsp:param name="activePage" value="overdue-list"/>
</jsp:include>

<div class="main-container">
    <div class="content">
        <h2 class="form-title">我的逾期记录</h2>
        
        <div class="table-container">
            <c:choose>
                <c:when test="${pageUtil.totalCount > 0}">
                    <table class="table" style="min-width: 950px;">
                        <thead>
                            <tr>
                                <th style="min-width: 200px;">图书名称</th>
                                <th style="min-width: 170px;">借阅时间</th>
                                <th style="min-width: 140px;">应归还时间</th>
                                <th style="min-width: 170px;">实际归还时间</th>
                                <th style="min-width: 80px; text-align: center;">状态</th>
                                <th style="min-width: 90px; text-align: center;">逾期天数</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${pageUtil.list}" var="borrow">
                                <tr>
                                    <td>
                                        <c:choose>
                                            <c:when test="${borrow.book != null}">
                                                <c:out value="${borrow.book.name}"/>
                                            </c:when>
                                            <c:otherwise>
                                                图书ID: ${borrow.bookId}
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><fmt:formatDate value="${borrow.borrowTime}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                                    <td><fmt:formatDate value="${borrow.dueTime}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${borrow.returnTime != null}">
                                                <fmt:formatDate value="${borrow.returnTime}" pattern="yyyy-MM-dd HH:mm:ss" />
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #94a3b8;">未归还</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${borrow.status == 0}">
                                                <span class="status status-disable">逾期未还</span>
                                            </c:when>
                                            <c:when test="${borrow.status == 1}">
                                                <span class="status status-enable">已归还</span>
                                            </c:when>
                                            <c:when test="${borrow.status == 2}">
                                                <span class="status status-info">待确认</span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    <td><span style="color: #c5221f; font-weight: bold;">${borrow.overdueDays gt 0 ? borrow.overdueDays : 0} 天</span></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="text-center text-muted" style="padding: 40px;">
                        <p style="font-size: 16px;">暂无逾期记录</p>
                        <small>当前没有正在逾期的借阅记录</small>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        
        <jsp:include page="../../common/pagination.jsp">
            <jsp:param name="pageUrl" value="${pageContext.request.contextPath}/user/overdue/list"/>
        </jsp:include>
    </div>
</div>
<script src="${pageContext.request.contextPath}/static/js/layout.js"></script>
</body>
</html>