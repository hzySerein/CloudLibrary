<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN" class="admin-theme">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户管理 - 管理员后台</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bootstrap-theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin-theme.css">
</head>
<body>
<jsp:include page="../../common/admin-header.jsp">
    <jsp:param name="title" value="云借阅系统 - 管理员后台"/>
</jsp:include>
<jsp:include page="../../common/admin-sidebar.jsp">
    <jsp:param name="activePage" value="user-list"/>
</jsp:include>

<div class="main-container">
    <div class="content">
        <div class="form-title">用户列表</div>
        <c:if test="${param.error == 'has_borrows'}">
            <div class="alert alert-danger" style="margin-bottom: 15px;">
                <span>✕</span> 该用户存在借阅记录，无法删除。请先处理完所有借阅记录后再删除。
            </div>
        </c:if>
        <div class="top-bar">
            <div>
                <form method="get" action="${pageContext.request.contextPath}/admin/user/list" style="display: inline-block; margin-right: 10px;">
                    <input type="text" name="keyword" aria-label="搜索用户" placeholder="请输入用户名或邮箱" value="${fn:escapeXml(keyword)}">
                    <button type="submit">搜索</button>
                    <c:if test="${not empty keyword}">
                        <a href="${pageContext.request.contextPath}/admin/user/list" style="margin-left: 10px; color: #666;">清空搜索</a>
                    </c:if>
                </form>
                <a href="${pageContext.request.contextPath}/admin/user/toAdd"><button>添加用户</button></a>
            </div>
        </div>
        <div style="overflow-x: auto;">
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>用户名</th>
                    <th>姓名</th>
                    <th>联系电话</th>
                    <th>角色</th>
                    <th>创建时间</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${pageUtil.list}" var="user">
                    <tr>
                        <td><c:out value="${user.id}"/></td>
                        <td><c:out value="${user.username}"/></td>
                        <td><c:out value="${user.name}"/></td>
                        <td><c:out value="${user.phone}"/></td>
                        <td>${user.role == 'admin' ? '管理员' : '普通用户'}</td>
                        <td>
    <c:choose>
        <c:when test="${not empty user.createTime}">
            <fmt:formatDate value="${user.createTime}" pattern="yyyy年MM月dd日 HH:mm:ss" />
        </c:when>
        <c:otherwise>-</c:otherwise>
    </c:choose>
</td>
                        <td class="operate">
                            <a href="${pageContext.request.contextPath}/admin/user/toEdit/${user.id}">编辑</a>
                            <c:if test="${user.role != 'admin'}">
                                <form action="${pageContext.request.contextPath}/admin/user/delete/${user.id}" method="post" style="display:inline;" onsubmit="return confirm('确认删除该用户吗？')">
                                    <input type="hidden" name="_csrf" value="${_csrf_token}">
                                    <button type="submit" class="btn-link">删除</button>
                                </form>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
        
        <!-- 分页导航 -->
        <c:if test="${pageUtil.totalPage > 0}">
            <div class="pagination">
                <div class="pagination-info">
                    共 ${pageUtil.totalCount} 条记录，第 ${pageUtil.currentPage} / ${pageUtil.totalPage} 页
                </div>
                <div class="pagination-links">
                    <c:if test="${pageUtil.hasPrevious()}">
                        <a href="${pageContext.request.contextPath}/admin/user/list?page=1&size=${pageUtil.pageSize}">首页</a>
                        <a href="${pageContext.request.contextPath}/admin/user/list?page=${pageUtil.currentPage - 1}&size=${pageUtil.pageSize}">上一页</a>
                    </c:if>
                    
                    <c:forEach begin="${pageUtil.startPage}" end="${pageUtil.endPage}" var="i">
                        <c:choose>
                            <c:when test="${i == pageUtil.currentPage}">
                                <span class="active">${i}</span>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/admin/user/list?page=${i}&size=${pageUtil.pageSize}">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    
                    <c:if test="${pageUtil.hasNext()}">
                        <a href="${pageContext.request.contextPath}/admin/user/list?page=${pageUtil.currentPage + 1}&size=${pageUtil.pageSize}">下一页</a>
                        <a href="${pageContext.request.contextPath}/admin/user/list?page=${pageUtil.totalPage}&size=${pageUtil.pageSize}">末页</a>
                    </c:if>
                </div>
                
                <div class="pagination-form">
                    <form method="get" action="${pageContext.request.contextPath}/admin/user/list">
                        <label for="pageInput">跳转到：</label>
                        <input type="number" id="pageInput" name="page" min="1" max="${pageUtil.totalPage}" value="${pageUtil.currentPage}">
                        <input type="hidden" name="size" value="${pageUtil.pageSize}">
                        <button type="submit">跳转</button>
                    </form>
                    <form method="get" action="${pageContext.request.contextPath}/admin/user/list">
                        <label for="sizeSelect">每页显示：</label>
                        <select id="sizeSelect" name="size" onchange="this.form.submit()">
                            <option value="5" ${pageUtil.pageSize == 5 ? 'selected' : ''}>5条</option>
                            <option value="10" ${pageUtil.pageSize == 10 ? 'selected' : ''}>10条</option>
                            <option value="20" ${pageUtil.pageSize == 20 ? 'selected' : ''}>20条</option>
                            <option value="50" ${pageUtil.pageSize == 50 ? 'selected' : ''}>50条</option>
                        </select>
                        <input type="hidden" name="page" value="1">
                    </form>
                </div>
            </div>
        </c:if>
    </div>
</div>
</body>
</html>