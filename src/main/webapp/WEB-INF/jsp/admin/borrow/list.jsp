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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css">
    <style>
        .borrow-table {
            width: 100% !important;
            border-collapse: collapse !important;
            border-spacing: 0 !important;
        }
        .borrow-table th, .borrow-table td {
            vertical-align: middle !important;
            padding: 14px 16px !important;
            border-bottom: 1px solid #e2e8f0 !important;
            box-sizing: border-box !important;
            display: table-cell !important;
        }
        .borrow-table form {
            display: inline-block !important;
            margin: 0 !important;
            padding: 0 !important;
            line-height: 1 !important;
        }
        .borrow-table form input[type="hidden"] {
            display: none !important;
        }
    </style>
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
            <div class="search-box">
                <form method="get" action="${pageContext.request.contextPath}/admin/borrow/list" style="display: flex; gap: 10px; align-items: center; flex: 1;">
                    <input type="text" name="keyword" class="form-control search-input" aria-label="搜索借阅记录" placeholder="请输入图书名称或用户名" value="${fn:escapeXml(keyword)}">
                    <button type="submit" class="btn btn-primary">搜索</button>
                    <c:if test="${not empty keyword}">
                        <a href="${pageContext.request.contextPath}/admin/borrow/list" class="btn btn-secondary">清空搜索</a>
                    </c:if>
                </form>
            </div>
        </div>
        <div class="table-container" style="width: 100% !important; overflow-x: auto !important;">
            <div class="table-responsive" style="width: 100% !important; overflow-x: auto !important;">
                <table class="borrow-table" style="width: 100% !important; border-collapse: collapse !important; border-spacing: 0 !important; min-width: 980px !important;">
                    <thead>
                    <tr>
                        <th style="min-width: 60px; padding: 14px 16px !important; vertical-align: middle !important; border-bottom: 2px solid #e2e8f0 !important; font-weight: 600 !important;">ID</th>
                        <th style="min-width: 140px; padding: 14px 16px !important; vertical-align: middle !important; border-bottom: 2px solid #e2e8f0 !important; font-weight: 600 !important;">用户信息</th>
                        <th style="min-width: 200px; padding: 14px 16px !important; vertical-align: middle !important; border-bottom: 2px solid #e2e8f0 !important; font-weight: 600 !important;">图书信息</th>
                        <th style="min-width: 160px; padding: 14px 16px !important; vertical-align: middle !important; border-bottom: 2px solid #e2e8f0 !important; font-weight: 600 !important;">借阅时间</th>
                        <th style="min-width: 130px; padding: 14px 16px !important; vertical-align: middle !important; border-bottom: 2px solid #e2e8f0 !important; font-weight: 600 !important;">应归还时间</th>
                        <th style="min-width: 160px; padding: 14px 16px !important; vertical-align: middle !important; border-bottom: 2px solid #e2e8f0 !important; font-weight: 600 !important;">实际归还时间</th>
                        <th style="min-width: 80px; text-align: center; padding: 14px 16px !important; vertical-align: middle !important; border-bottom: 2px solid #e2e8f0 !important; font-weight: 600 !important;">状态</th>
                        <th style="min-width: 140px; text-align: center; padding: 14px 16px !important; vertical-align: middle !important; border-bottom: 2px solid #e2e8f0 !important; font-weight: 600 !important;">操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${pageUtil.list}" var="borrow">
                        <tr style="border-bottom: 1px solid #e2e8f0 !important;">
                            <td style="padding: 14px 16px !important; vertical-align: middle !important; border-bottom: 1px solid #e2e8f0 !important; box-sizing: border-box !important;">${borrow.id}</td>
                            <td style="white-space: normal; min-width: 120px; padding: 14px 16px !important; vertical-align: middle !important; border-bottom: 1px solid #e2e8f0 !important; box-sizing: border-box !important;">
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
                            <td style="white-space: normal; min-width: 150px; padding: 14px 16px !important; vertical-align: middle !important; border-bottom: 1px solid #e2e8f0 !important; box-sizing: border-box !important;">
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
                            <td style="padding: 14px 16px !important; vertical-align: middle !important; border-bottom: 1px solid #e2e8f0 !important; box-sizing: border-box !important;"><%= formatChineseDateTime(((org.cloudlibrary.entity.Borrow) pageContext.getAttribute("borrow")).getBorrowTime()) %></td>
                            <td style="padding: 14px 16px !important; vertical-align: middle !important; border-bottom: 1px solid #e2e8f0 !important; box-sizing: border-box !important;"><%= formatChineseDate(((org.cloudlibrary.entity.Borrow) pageContext.getAttribute("borrow")).getDueTime()) %></td>
                            <td style="padding: 14px 16px !important; vertical-align: middle !important; border-bottom: 1px solid #e2e8f0 !important; box-sizing: border-box !important;"><%= formatChineseDateTime(((org.cloudlibrary.entity.Borrow) pageContext.getAttribute("borrow")).getReturnTime()) %></td>
                            <td style="padding: 14px 16px !important; vertical-align: middle !important; border-bottom: 1px solid #e2e8f0 !important; box-sizing: border-box !important;">
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
                            <td style="padding: 14px 16px !important; vertical-align: middle !important; text-align: center !important; border-bottom: 1px solid #e2e8f0 !important; box-sizing: border-box !important;">
                                <div style="display: inline-flex !important; align-items: center !important; justify-content: center !important; gap: 6px !important; width: 100% !important; border: none !important; background: transparent !important; margin: 0 !important; padding: 0 !important;">
                                    <c:if test="${borrow.status == 2}">
                                        <form action="${pageContext.request.contextPath}/admin/borrow/confirmReturn/${borrow.id}" method="post" style="display:inline-block !important;margin:0 !important;" onsubmit="return confirm('确认该图书已归还吗？')">
                                            <input type="hidden" name="_csrf" value="${_csrf_token}">
                                            <button type="submit" class="btn btn-success btn-sm">确认归还</button>
                                        </form>
                                    </c:if>
                                    <c:if test="${borrow.status != 2 && borrow.status != 1}">
                                        <form action="${pageContext.request.contextPath}/admin/borrow/forceReturn/${borrow.id}" method="post" style="display:inline-block !important;margin:0 !important;" onsubmit="return confirm('强制归还该图书吗？')">
                                            <input type="hidden" name="_csrf" value="${_csrf_token}">
                                            <button type="submit" class="btn btn-warning btn-sm">强制归还</button>
                                        </form>
                                    </c:if>
                                    <c:if test="${borrow.status == 1}">
                                        <span style="color: #94a3b8; font-size: 13px; border: none !important; background: transparent !important;">已完成</span>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty pageUtil.list}">
                        <tr>
                            <td colspan="8" style="color: #94a3b8; text-align: center; padding: 40px !important; border-bottom: 1px solid #e2e8f0 !important;">暂无借阅记录</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>
        
        <jsp:include page="../../common/pagination.jsp">
            <jsp:param name="pageUrl" value="${pageContext.request.contextPath}/admin/borrow/list"/>
        </jsp:include>
    </div>
</div>
<script src="${pageContext.request.contextPath}/static/js/layout.js"></script>
</body>
</html>