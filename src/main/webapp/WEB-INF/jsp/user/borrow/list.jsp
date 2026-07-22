<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<tags:layout role="user" pageTitle="我的借阅 - 用户中心" activePage="borrow-list" account="${loginUser}" pageCss="/static/css/pages/borrow-history.css">

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

    <div class="table-container borrow-history-container">
        <div class="table-responsive">
            <table class="table borrow-history-table">
                <thead>
                    <tr>
                        <th class="col-book">图书名称</th>
                        <th class="col-borrow-time">借阅时间</th>
                        <th class="col-due-time">应归还时间</th>
                        <th class="col-return-time">实际归还时间</th>
                        <th class="col-overdue">逾期天数</th>
                        <th class="col-status">状态</th>
                        <th class="col-actions">操作</th>
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
                                        <span class="detail-sub">作者：<c:out value="${book.author}"/></span>
                                    </c:when>
                                    <c:otherwise>图书ID: ${borrow.bookId}</c:otherwise>
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
                                    <c:otherwise><span class="badge badge-success">未逾期</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${borrow.status == 0}"><span class="badge badge-warning">未归还</span></c:when>
                                    <c:when test="${borrow.status == 1}"><span class="badge badge-success">已归还</span></c:when>
                                    <c:when test="${borrow.status == 2}"><span class="badge badge-info">待确认</span></c:when>
                                </c:choose>
                            </td>
                            <td>
                                <div class="operate-actions">
                                    <c:if test="${borrow.status == 0}">
                                        <c:set var="overdueDays" value="${overdueDaysMap[borrow.id]}" />
                                        <c:set var="book" value="${bookMap[borrow.bookId]}" />
                                        <a href="#" data-action="return-book" data-borrow-id="${borrow.id}" data-book-name="${fn:escapeXml(book.name)}" data-overdue="${overdueDays != null ? overdueDays : 0}" class="btn btn-accent btn-sm">申请归还</a>
                                    </c:if>
                                    <c:if test="${borrow.status == 1}">
                                        <span class="status-returned">已归还</span>
                                    </c:if>
                                    <c:if test="${borrow.status == 2}">
                                        <span class="status-pending">待管理员确认</span>
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

    <tags:pagination pageData="${pageUtil}" baseUrl="${pageContext.request.contextPath}/user/borrow/list" keyword="${keyword}"/>

    <script src="${pageContext.request.contextPath}/static/js/common.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/pages/borrow-history.js"></script>
    <script>
        BorrowHistory.init('${pageContext.request.contextPath}', '${_csrf_token}');
    </script>
</tags:layout>
