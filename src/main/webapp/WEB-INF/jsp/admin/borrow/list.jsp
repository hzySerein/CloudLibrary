<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<tags:layout role="admin" pageTitle="借阅管理 - 管理员后台" activePage="borrow-list" account="${loginAdmin}" pageCss="/static/css/pages/admin-borrow-list.css">

    <div class="form-title">借阅列表</div>
    <div class="top-bar">
        <div class="search-box">
            <form method="get" action="${pageContext.request.contextPath}/admin/borrow/list" class="borrow-search-form">
                <input type="text" name="keyword" class="form-control search-input" aria-label="搜索借阅记录" placeholder="请输入图书名称或用户名" value="${fn:escapeXml(keyword)}">
                <button type="submit" class="btn btn-primary">搜索</button>
                <c:if test="${not empty keyword}">
                    <a href="${pageContext.request.contextPath}/admin/borrow/list" class="btn btn-secondary">清空搜索</a>
                </c:if>
            </form>
        </div>
    </div>
    <div class="borrow-table-container">
        <div class="borrow-table-scroll">
            <table class="borrow-table">
                <thead>
                <tr>
                    <th class="col-id">ID</th>
                    <th class="col-user">用户信息</th>
                    <th class="col-book">图书信息</th>
                    <th class="col-borrow-time">借阅时间</th>
                    <th class="col-due-time">应归还时间</th>
                    <th class="col-return-time">实际归还时间</th>
                    <th class="col-status">状态</th>
                    <th class="col-actions">操作</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${pageUtil.list}" var="borrow">
                    <tr>
                        <td>${borrow.id}</td>
                        <td class="cell-detail">
                            <c:set var="user" value="${userMap[borrow.userId]}" />
                            <c:choose>
                                <c:when test="${user != null}">
                                    <strong><c:out value="${user.name}"/></strong><br/>
                                    <span class="detail-sub"><c:out value="${user.username}"/></span>
                                </c:when>
                                <c:otherwise>
                                    用户ID: ${borrow.userId}
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="cell-detail">
                            <c:set var="book" value="${bookMap[borrow.bookId]}" />
                            <c:choose>
                                <c:when test="${book != null}">
                                    <strong><c:out value="${book.name}"/></strong><br/>
                                    <span class="detail-sub"><c:out value="${book.author}"/></span>
                                </c:when>
                                <c:otherwise>
                                    图书ID: ${borrow.bookId}
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td><c:choose><c:when test="${not empty borrow.borrowTime}"><fmt:formatDate value="${borrow.borrowTime}" pattern="yyyy年MM月dd日 HH:mm:ss"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
                        <td><c:choose><c:when test="${not empty borrow.dueTime}"><fmt:formatDate value="${borrow.dueTime}" pattern="yyyy年MM月dd日"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
                        <td><c:choose><c:when test="${not empty borrow.returnTime}"><fmt:formatDate value="${borrow.returnTime}" pattern="yyyy年MM月dd日 HH:mm:ss"/></c:when><c:otherwise>-</c:otherwise></c:choose></td>
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
                            <div class="borrow-actions">
                                <c:if test="${borrow.status == 2}">
                                    <form action="${pageContext.request.contextPath}/admin/borrow/confirmReturn/${borrow.id}" method="post" data-confirm-message="确认该图书已归还吗？">
                                        <input type="hidden" name="_csrf" value="${_csrf_token}">
                                        <button type="submit" class="btn btn-success btn-sm">确认归还</button>
                                    </form>
                                </c:if>
                                <c:if test="${borrow.status != 2 && borrow.status != 1}">
                                    <form action="${pageContext.request.contextPath}/admin/borrow/forceReturn/${borrow.id}" method="post" data-confirm-message="强制归还该图书吗？">
                                        <input type="hidden" name="_csrf" value="${_csrf_token}">
                                        <button type="submit" class="btn btn-warning btn-sm">强制归还</button>
                                    </form>
                                </c:if>
                                <c:if test="${borrow.status == 1}">
                                    <span class="completed-label">已完成</span>
                                </c:if>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty pageUtil.list}">
                    <tr class="borrow-empty">
                        <td colspan="8">暂无借阅记录</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <tags:pagination pageData="${pageUtil}" baseUrl="${pageContext.request.contextPath}/admin/borrow/list" keyword="${keyword}"/>

    <script src="${pageContext.request.contextPath}/static/js/components/confirm-handler.js"></script>
</tags:layout>
