<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN" class="user-theme">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的逾期记录 - 云借阅系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bootstrap-theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user-theme.css">
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
                    <table>
                        <thead>
                            <tr>
                                <th>借阅ID</th>
                                <th>图书ID</th>
                                <th>借阅时间</th>
                                <th>应还时间</th>
                                <th>实际归还时间</th>
                                <th>状态</th>
                                <th>逾期天数</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${pageUtil.list}" var="borrow">
                                <tr>
                                    <td>${borrow.id}</td>
                                    <td>${borrow.bookId}</td>
                                    <td><fmt:formatDate value="${borrow.borrowTime}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                                    <td><fmt:formatDate value="${borrow.dueTime}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${borrow.returnTime != null}">
                                                <fmt:formatDate value="${borrow.returnTime}" pattern="yyyy-MM-dd HH:mm:ss" />
                                            </c:when>
                                            <c:otherwise>
                                                未归还
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="status ${borrow.status == 1 ? 'status-enable' : borrow.status == 0 ? 'status-disable' : 'status-info'}">
                                            <c:choose>
                                                <c:when test="${borrow.status == 0}">未归还</c:when>
                                                <c:when test="${borrow.status == 1}">已归还</c:when>
                                                <c:when test="${borrow.status == 2}">待确认归还</c:when>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td>${borrow.overdueDays gt 0 ? borrow.overdueDays : 0}天</td>
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
        
        <c:if test="${pageUtil.totalPage > 0}">
            <div class="pagination">
                <div class="pagination-info">
                    共 ${pageUtil.totalCount} 条记录，第 ${pageUtil.currentPage} / ${pageUtil.totalPage} 页
                </div>
                <div class="pagination-links">
                    <c:if test="${pageUtil.hasPrevious()}">
                        <a href="${pageContext.request.contextPath}/user/overdue/list?page=1&size=${pageUtil.pageSize}">首页</a>
                        <a href="${pageContext.request.contextPath}/user/overdue/list?page=${pageUtil.currentPage - 1}&size=${pageUtil.pageSize}">上一页</a>
                    </c:if>
                    
                    <c:forEach begin="${pageUtil.startPage}" end="${pageUtil.endPage}" var="i">
                        <c:choose>
                            <c:when test="${i == pageUtil.currentPage}">
                                <span class="active">${i}</span>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/user/overdue/list?page=${i}&size=${pageUtil.pageSize}">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    
                    <c:if test="${pageUtil.hasNext()}">
                        <a href="${pageContext.request.contextPath}/user/overdue/list?page=${pageUtil.currentPage + 1}&size=${pageUtil.pageSize}">下一页</a>
                        <a href="${pageContext.request.contextPath}/user/overdue/list?page=${pageUtil.totalPage}&size=${pageUtil.pageSize}">末页</a>
                    </c:if>
                </div>
            </div>
        </c:if>
    </div>
</div>
</body>
</html>