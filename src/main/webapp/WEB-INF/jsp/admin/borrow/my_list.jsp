<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="zh-CN" class="admin-theme">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的借阅 - 管理员中心</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bootstrap-theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin-theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css">
    <style>
        /* 针对本页面的特殊样式 */
        .status-normal { color: #28a745; }
        .status-overdue { color: #dc3545; font-weight: bold; }
        .status-returned { color: #6c757d; }
    </style>
</head>
<body>
<jsp:include page="../../common/admin-header.jsp">
    <jsp:param name="title" value="云借阅系统 - 管理员中心"/>
</jsp:include>
<jsp:include page="../../common/admin-sidebar.jsp">
    <jsp:param name="activePage" value="borrow-my"/>
</jsp:include>

<div class="main-container">
    <div class="content">
        <h2 class="form-title">我的借阅记录</h2>
        
        <div class="top-bar">
            <form method="get" action="${pageContext.request.contextPath}/admin/borrow/my" style="display: flex; gap: 10px; align-items: center;">
                <input type="text" name="keyword" class="form-control" style="max-width: 360px;" aria-label="搜索借阅记录" placeholder="请输入图书名称或作者" value="${fn:escapeXml(keyword)}">
                <button type="submit" class="btn btn-primary">搜索</button>
                <c:if test="${not empty keyword}">
                    <a href="${pageContext.request.contextPath}/admin/borrow/my" class="btn btn-secondary">清空搜索</a>
                </c:if>
            </form>
        </div>

        <div class="table-container">
            <table style="min-width: 950px;">
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
                                        <span style="color: #666; font-size: 12px;">作者：<c:out value="${book.author}"/></span>
                                    </c:when>
                                    <c:otherwise>
                                        图书ID: ${borrow.bookId}
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${borrow.borrowTime != null}">
                                        <fmt:formatDate value="${borrow.borrowTime}" pattern="yyyy年MM月dd日 HH:mm"/>
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${borrow.dueTime != null}">
                                        <fmt:formatDate value="${borrow.dueTime}" pattern="yyyy年MM月dd日"/>
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${borrow.returnTime != null}">
                                        <fmt:formatDate value="${borrow.returnTime}" pattern="yyyy年MM月dd日 HH:mm"/>
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:set var="overdueDays" value="${overdueDaysMap[borrow.id]}" />
                                <c:choose>
                                    <c:when test="${overdueDays > 0}">
                                        <span style="color: #dc3545; font-weight: 600;">逾期${overdueDays}天</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: #28a745;">未逾期</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${borrow.status == 0}">
                                        <span class="status status-disable">未归还</span>
                                    </c:when>
                                    <c:when test="${borrow.status == 1}">
                                        <span class="status status-enable">已归还</span>
                                    </c:when>
                                    <c:when test="${borrow.status == 2}">
                                        <span class="status status-info">待确认</span>
                                    </c:when>
                                </c:choose>
                            </td>
                            <td>
                                <div class="operate-actions">
                                    <c:if test="${borrow.status == 0}">
                                        <c:set var="overdueDays" value="${overdueDaysMap[borrow.id]}" />
                                        <form action="${pageContext.request.contextPath}/admin/borrow/return/${borrow.id}" method="post" style="display:inline;" onsubmit="return confirm('确认申请归还该图书吗？')">
                                            <input type="hidden" name="_csrf" value="${_csrf_token}">
                                            <c:choose>
                                                <c:when test="${overdueDays > 0}">
                                                    <button type="submit" class="btn btn-warning">申请归还</button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button type="submit" class="btn btn-primary">申请归还</button>
                                                </c:otherwise>
                                            </c:choose>
                                        </form>
                                    </c:if>
                                    <c:if test="${borrow.status == 1}">
                                        <span style="color: #6c757d;">已归还</span>
                                    </c:if>
                                    <c:if test="${borrow.status == 2}">
                                        <span style="color: #17a2b8;">待确认</span>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty pageUtil.list}">
                        <tr>
                            <td colspan="7" style="color: #999; text-align: center;">暂无借阅记录</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
        
        <jsp:include page="../../common/pagination.jsp">
            <jsp:param name="pageUrl" value="${pageContext.request.contextPath}/admin/borrow/my"/>
        </jsp:include>
    </div>
</div>
<script src="${pageContext.request.contextPath}/static/js/layout.js"></script>
</body>
</html>