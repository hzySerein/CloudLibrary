<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<tags:layout role="admin" pageTitle="逾期管理 - 管理员后台" activePage="overdue-list" account="${loginAdmin}" pageCss="/static/css/pages/overdue-list.css">
    <h2 class="form-title">逾期记录管理</h2>

    <div class="table-container">
        <c:choose>
            <c:when test="${pageUtil.totalCount > 0}">
                <table class="table overdue-table overdue-table-admin">
                    <thead>
                        <tr>
                            <th class="col-id">借阅ID</th>
                            <th class="col-book-name">图书名称</th>
                            <th class="col-user-id">用户ID</th>
                            <th class="col-borrower">借阅人</th>
                            <th class="col-borrow-time">借阅时间</th>
                            <th class="col-due-time">应归还时间</th>
                            <th class="col-return-time">实际归还时间</th>
                            <th class="col-status">状态</th>
                            <th class="col-overdue">逾期天数</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${pageUtil.list}" var="borrow">
                            <tr>
                                <td>${borrow.id}</td>
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
                                <td>${borrow.userId}</td>
                                <td>
                                    <c:set var="user" value="${userMap[borrow.userId]}" />
                                    <c:choose>
                                        <c:when test="${user != null}">
                                            <c:out value="${user.name}"/>
                                        </c:when>
                                        <c:otherwise>
                                            未知用户
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
                                            <span class="overdue-not-returned">未归还</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${borrow.status == 0}"><span class="status status-disable">逾期未还</span></c:when>
                                        <c:when test="${borrow.status == 1}"><span class="status status-enable">已归还</span></c:when>
                                        <c:when test="${borrow.status == 2}"><span class="status status-info">待确认</span></c:when>
                                    </c:choose>
                                </td>
                                <td><span class="overdue-days-danger">${borrow.overdueDays gt 0 ? borrow.overdueDays : 0} 天</span></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="text-center text-muted overdue-empty">
                    <p class="overdue-empty-title">暂无逾期记录</p>
                    <small>当前没有正在逾期的借阅记录</small>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <tags:pagination pageData="${pageUtil}" baseUrl="${pageContext.request.contextPath}/admin/overdue/list" keyword="${keyword}"/>
</tags:layout>
