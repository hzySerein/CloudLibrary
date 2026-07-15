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
    <style>
        /* 针对本页面的特殊样式 */
        .status-normal { color: #28a745; }
        .status-overdue { color: #dc3545; font-weight: bold; }
        .status-returned { color: #6c757d; }
        .search-box { margin-bottom: 20px; }
        .search-box input { padding: 10px; border: 2px solid #e0e0e0; border-radius: 8px; width: 300px; }
        .search-box button { padding: 10px 20px; background-color: #007bff; color: white; border: none; border-radius: 8px; cursor: pointer; margin-left: 10px; }
        .search-box a { margin-left: 10px; color: #666; }
        
        /* 分页样式 */
        .pagination-form {
            margin-top: 15px;
            display: flex;
            justify-content: center;
            gap: 15px;
            flex-wrap: wrap;
        }
        .pagination-form input, .pagination-form select, .pagination-form button {
            padding: 6px 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .pagination-form button {
            background-color: #007bff;
            color: white;
            cursor: pointer;
            border: none;
        }
        .pagination-form button:hover {
            background-color: #0056b3;
        }
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
        
        <div class="search-box">
            <form method="get" action="${pageContext.request.contextPath}/admin/borrow/my">
                <input type="text" name="keyword" aria-label="搜索借阅记录" placeholder="请输入图书名称或作者" value="${fn:escapeXml(keyword)}">
                <button type="submit">搜索</button>
                <c:if test="${not empty keyword}">
                    <a href="${pageContext.request.contextPath}/admin/borrow/my">清空搜索</a>
                </c:if>
            </form>
        </div>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>图书名称</th>
                        <th>借阅时间</th>
                        <th>应归还时间</th>
                        <th>实际归还时间</th>
                        <th>逾期天数</th>
                        <th>状态</th>
                        <th>操作</th>
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
                                    <span style="color: #999;">已归还</span>
                                </c:if>
                                <c:if test="${borrow.status == 2}">
                                    <span style="color: #007bff;">待管理员确认</span>
                                </c:if>
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
        
        <!-- 分页导航 -->
        <c:if test="${pageUtil.totalPage > 0}">
            <div class="pagination">
                <div class="pagination-info">
                    共 ${pageUtil.totalCount} 条记录，第 ${pageUtil.currentPage} / ${pageUtil.totalPage} 页
                </div>
                <div class="pagination-links">
                    <c:if test="${pageUtil.hasPrevious()}">
                        <a href="${pageContext.request.contextPath}/admin/borrow/my?page=1&size=${pageUtil.pageSize}">首页</a>
                        <a href="${pageContext.request.contextPath}/admin/borrow/my?page=${pageUtil.currentPage - 1}&size=${pageUtil.pageSize}">上一页</a>
                    </c:if>
                    
                    <c:forEach begin="${pageUtil.startPage}" end="${pageUtil.endPage}" var="i">
                        <c:choose>
                            <c:when test="${i == pageUtil.currentPage}">
                                <span class="active">${i}</span>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/admin/borrow/my?page=${i}&size=${pageUtil.pageSize}">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    
                    <c:if test="${pageUtil.hasNext()}">
                        <a href="${pageContext.request.contextPath}/admin/borrow/my?page=${pageUtil.currentPage + 1}&size=${pageUtil.pageSize}">下一页</a>
                        <a href="${pageContext.request.contextPath}/admin/borrow/my?page=${pageUtil.totalPage}&size=${pageUtil.pageSize}">末页</a>
                    </c:if>
                </div>
                
                <div class="pagination-form">
                    <form method="get" action="${pageContext.request.contextPath}/admin/borrow/my" style="display: inline-block;">
                        <label for="pageInput">跳转到：</label>
                        <input type="number" id="pageInput" name="page" min="1" max="${pageUtil.totalPage}" value="${pageUtil.currentPage}" style="width: 60px;">
                        <input type="hidden" name="size" value="${pageUtil.pageSize}">
                        <button type="submit">跳转</button>
                    </form>
                    <form method="get" action="${pageContext.request.contextPath}/admin/borrow/my" style="display: inline-block;">
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