<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<tags:layout role="admin" pageTitle="我的借阅 - 管理员中心" activePage="borrow-my" account="${loginAdmin}" pageCss="/static/css/pages/borrow-history.css">

    <h2 class="form-title">我的借阅记录</h2>

    <div class="top-bar">
        <form method="get" action="${pageContext.request.contextPath}/admin/borrow/my" class="borrow-history-search-form">
            <input type="text" name="keyword" class="form-control borrow-history-search-input" aria-label="搜索借阅记录" placeholder="请输入图书名称或作者" value="${fn:escapeXml(keyword)}">
            <button type="submit" class="btn btn-primary">搜索</button>
            <c:if test="${not empty keyword}">
                <a href="${pageContext.request.contextPath}/admin/borrow/my" class="btn btn-secondary">清空搜索</a>
            </c:if>
        </form>
    </div>

    <div class="table-container">
        <table class="borrow-history-table">
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
                                    <span class="overdue-days">逾期${overdueDays}天</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="no-overdue">未逾期</span>
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
                                    <form action="${pageContext.request.contextPath}/admin/borrow/return/${borrow.id}" method="post" data-confirm-message="确认申请归还该图书吗？">
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
                                    <span class="status-returned">已归还</span>
                                </c:if>
                                <c:if test="${borrow.status == 2}">
                                    <span class="status-pending">待确认</span>
                                </c:if>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty pageUtil.list}">
                    <tr>
                        <td colspan="7" class="user-list-empty">暂无借阅记录</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <tags:pagination pageData="${pageUtil}" baseUrl="${pageContext.request.contextPath}/admin/borrow/my" keyword="${keyword}"/>
    <script src="${pageContext.request.contextPath}/static/js/components/confirm-handler.js"></script>
</tags:layout>
