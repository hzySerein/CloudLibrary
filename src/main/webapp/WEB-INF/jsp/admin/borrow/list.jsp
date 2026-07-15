<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="zh-CN" class="admin-theme">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>借阅管理 - 管理员后台</title>
    <%!
        // 定义一个函数来格式化日期时间
        public String formatChineseDateTime(java.util.Date date) {
            if (date == null) return "-";
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy年MM月dd日 HH:mm:ss");
            return sdf.format(date);
        }
        
        // 定义一个函数来格式化日期
        public String formatChineseDate(java.util.Date date) {
            if (date == null) return "-";
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy年MM月dd日");
            return sdf.format(date);
        }
    %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bootstrap-theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin-theme.css">
</head>
<body>
<jsp:include page="../../common/admin-header.jsp">
    <jsp:param name="title" value="云借阅系统 - 管理员后台"/>
</jsp:include>
<jsp:include page="../../common/admin-sidebar.jsp">
    <jsp:param name="activePage" value="borrow-list"/>
</jsp:include>

<div class="main-container">
    <div class="content">
        <div class="form-title">借阅列表</div>
        <div class="top-bar">
            <div>
                <form method="get" action="${pageContext.request.contextPath}/admin/borrow/list" style="display: inline-block; margin-right: 10px;">
                    <input type="text" name="keyword" aria-label="搜索借阅记录" placeholder="请输入图书名称或用户名" value="${fn:escapeXml(keyword)}">
                    <button type="submit">搜索</button>
                    <c:if test="${not empty keyword}">
                        <a href="${pageContext.request.contextPath}/admin/borrow/list" style="margin-left: 10px; color: #666;">清空搜索</a>
                    </c:if>
                </form>
            </div>
        </div>
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>用户信息</th>
                <th>图书信息</th>
                <th>借阅时间</th>
                <th>应归还时间</th>
                <th>实际归还时间</th>
                <th>状态</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${pageUtil.list}" var="borrow">
                <tr>
                    <td>${borrow.id}</td>
                    <td>
                        <c:set var="user" value="${userMap[borrow.userId]}" />
                        <c:choose>
                            <c:when test="${user != null}">
                                <strong><c:out value="${user.name}"/></strong><br/>
                                <span style="color: #666; font-size: 12px;"><c:out value="${user.username}"/></span>
                            </c:when>
                            <c:otherwise>
                                用户ID: ${borrow.userId}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:set var="book" value="${bookMap[borrow.bookId]}" />
                        <c:choose>
                            <c:when test="${book != null}">
                                <strong><c:out value="${book.name}"/></strong><br/>
                                <span style="color: #666; font-size: 12px;"><c:out value="${book.author}"/></span>
                            </c:when>
                            <c:otherwise>
                                图书ID: ${borrow.bookId}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td><%= formatChineseDateTime(((org.cloudlibrary.entity.Borrow) pageContext.getAttribute("borrow")).getBorrowTime()) %></td>
                    <td><%= formatChineseDate(((org.cloudlibrary.entity.Borrow) pageContext.getAttribute("borrow")).getDueTime()) %></td>
                    <td><%= formatChineseDateTime(((org.cloudlibrary.entity.Borrow) pageContext.getAttribute("borrow")).getReturnTime()) %></td>
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
                    <td class="operate">
                        <c:if test="${borrow.status == 2}">
                            <form action="${pageContext.request.contextPath}/admin/borrow/confirmReturn/${borrow.id}" method="post" style="display:inline;" onsubmit="return confirm('确认该图书已归还吗？')">
                                <input type="hidden" name="_csrf" value="${_csrf_token}">
                                <button type="submit" class="btn-link">确认归还</button>
                            </form>
                        </c:if>
                        <c:if test="${borrow.status != 2 && borrow.status != 1}">
                            <form action="${pageContext.request.contextPath}/admin/borrow/forceReturn/${borrow.id}" method="post" style="display:inline;" onsubmit="return confirm('强制归还该图书吗？')">
                                <input type="hidden" name="_csrf" value="${_csrf_token}">
                                <button type="submit" class="btn-link">强制归还</button>
                            </form>
                        </c:if>
                        <c:if test="${borrow.status == 1 || borrow.status == 2}">
                            <span style="color: #999;">-</span>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        
        <!-- 分页导航 -->
        <c:if test="${pageUtil.totalPage > 0}">
            <div class="pagination">
                <div class="pagination-info">
                    共 ${pageUtil.totalCount} 条记录，第 ${pageUtil.currentPage} / ${pageUtil.totalPage} 页
                </div>
                <div class="pagination-links">
                    <c:if test="${pageUtil.hasPrevious()}">
                        <a href="${pageContext.request.contextPath}/admin/borrow/list?page=1&size=${pageUtil.pageSize}">首页</a>
                        <a href="${pageContext.request.contextPath}/admin/borrow/list?page=${pageUtil.currentPage - 1}&size=${pageUtil.pageSize}">上一页</a>
                    </c:if>
                    
                    <c:forEach begin="${pageUtil.startPage}" end="${pageUtil.endPage}" var="i">
                        <c:choose>
                            <c:when test="${i == pageUtil.currentPage}">
                                <span class="active">${i}</span>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/admin/borrow/list?page=${i}&size=${pageUtil.pageSize}">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    
                    <c:if test="${pageUtil.hasNext()}">
                        <a href="${pageContext.request.contextPath}/admin/borrow/list?page=${pageUtil.currentPage + 1}&size=${pageUtil.pageSize}">下一页</a>
                        <a href="${pageContext.request.contextPath}/admin/borrow/list?page=${pageUtil.totalPage}&size=${pageUtil.pageSize}">末页</a>
                    </c:if>
                </div>
                
                <div class="pagination-form">
                    <form method="get" action="${pageContext.request.contextPath}/admin/borrow/list">
                        <label for="pageInput">跳转到：</label>
                        <input type="number" id="pageInput" name="page" min="1" max="${pageUtil.totalPage}" value="${pageUtil.currentPage}">
                        <input type="hidden" name="size" value="${pageUtil.pageSize}">
                        <button type="submit">跳转</button>
                    </form>
                    <form method="get" action="${pageContext.request.contextPath}/admin/borrow/list">
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