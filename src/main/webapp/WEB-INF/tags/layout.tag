<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ attribute name="role" required="true" rtexprvalue="true"%>
<%@ attribute name="pageTitle" required="true"%>
<%@ attribute name="headerTitle" required="false"%>
<%@ attribute name="activePage" required="true"%>
<%@ attribute name="account" type="java.lang.Object" required="true" rtexprvalue="true"%>
<%@ attribute name="pageCss" required="false" rtexprvalue="true"%>
<!DOCTYPE html>
<html lang="zh-CN" class="${role}-theme">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${pageTitle}"/></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bootstrap-theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <c:if test="${role == 'admin'}">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin-theme.css">
    </c:if>
    <c:if test="${role == 'user'}">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user-theme.css">
    </c:if>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/components/pagination.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/components/table-utils.css">
    <c:if test="${not empty pageCss}">
        <link rel="stylesheet" href="${pageContext.request.contextPath}${pageCss}">
    </c:if>
</head>
<body>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<tags:header role="${role}" account="${account}" headerTitle="${headerTitle}"/>
<tags:sidebar role="${role}" activePage="${activePage}"/>

<div class="main-container">
    <div class="content">
        <jsp:doBody/>
    </div>
</div>
<script src="${pageContext.request.contextPath}/static/js/layout.js"></script>
</body>
</html>
