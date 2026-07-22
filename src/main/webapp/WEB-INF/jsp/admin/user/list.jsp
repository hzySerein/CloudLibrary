<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<tags:layout role="admin" pageTitle="用户管理 - 管理员后台" activePage="user-list" account="${loginAdmin}" pageCss="/static/css/pages/user-list.css">
    <div class="form-title">用户列表</div>
    <c:if test="${param.error == 'has_borrows'}">
        <div class="alert alert-danger user-list-alert">
            <span>✕</span> 该用户存在借阅记录，无法删除。请先处理完所有借阅记录后再删除。
        </div>
    </c:if>
    <div class="top-bar">
        <div class="user-list-top-bar">
            <form method="get" action="${pageContext.request.contextPath}/admin/user/list" class="user-list-search-form">
                <input type="text" name="keyword" class="form-control user-list-search-input" aria-label="搜索用户" placeholder="请输入用户名或邮箱" value="${fn:escapeXml(keyword)}">
                <button type="submit" class="btn btn-primary">搜索</button>
                <c:if test="${not empty keyword}">
                    <a href="${pageContext.request.contextPath}/admin/user/list" class="btn btn-secondary">清空搜索</a>
                </c:if>
            </form>
            <a href="${pageContext.request.contextPath}/admin/user/toAdd"><button type="button" class="btn btn-accent">+ 添加用户</button></a>
        </div>
    </div>
    <div class="table-container">
        <div class="table-responsive">
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>用户名</th>
                    <th>姓名</th>
                    <th>联系电话</th>
                    <th>角色</th>
                    <th>创建时间</th>
                    <th class="col-ops-user">操作</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${pageUtil.list}" var="user">
                    <tr>
                        <td><c:out value="${user.id}"/></td>
                        <td><strong><c:out value="${user.username}"/></strong></td>
                        <td><c:out value="${user.name}"/></td>
                        <td><c:out value="${user.phone}"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${user.role == 'admin'}">
                                    <span class="badge badge-info">管理员</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-success">普通用户</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty user.createTime}">
                                    <fmt:formatDate value="${user.createTime}" pattern="yyyy年MM月dd日 HH:mm:ss" />
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="operate-actions">
                                <c:if test="${user.role != 'admin'}">
                                    <a href="${pageContext.request.contextPath}/admin/user/toEdit/${user.id}" class="btn btn-info btn-sm">编辑</a>
                                    <form action="${pageContext.request.contextPath}/admin/user/delete/${user.id}" method="post" data-confirm-message="确认删除该用户吗？">
                                        <input type="hidden" name="_csrf" value="${_csrf_token}">
                                        <button type="submit" class="btn btn-danger btn-sm">删除</button>
                                    </form>
                                </c:if>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty pageUtil.list}">
                    <tr>
                        <td colspan="7" class="user-list-empty">暂无用户记录</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <tags:pagination pageData="${pageUtil}" baseUrl="${pageContext.request.contextPath}/admin/user/list" keyword="${keyword}"/>
    <script src="${pageContext.request.contextPath}/static/js/pages/user-list.js"></script>
</tags:layout>
