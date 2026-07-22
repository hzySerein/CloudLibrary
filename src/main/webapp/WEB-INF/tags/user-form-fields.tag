<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ attribute name="user" type="java.lang.Object" required="false" rtexprvalue="true"%>
<%@ attribute name="editMode" required="false" type="java.lang.Boolean" rtexprvalue="true"%>
<div class="form-group">
    <label for="username" class="form-label">用户账号</label>
    <input type="text" id="username" name="username" value="${not empty user ? fn:escapeXml(user.username) : ''}" required placeholder="请输入账号">
</div>
<div class="form-group">
    <label for="password" class="form-label">用户密码</label>
    <c:choose>
        <c:when test="${editMode}">
            <input type="password" id="password" name="password" placeholder="留空则不修改密码">
        </c:when>
        <c:otherwise>
            <input type="password" id="password" name="password" required placeholder="请输入密码">
        </c:otherwise>
    </c:choose>
</div>
<div class="form-group">
    <label for="name" class="form-label">用户姓名</label>
    <input type="text" id="name" name="name" value="${not empty user ? fn:escapeXml(user.name) : ''}" required placeholder="请输入姓名">
</div>
<div class="form-group">
    <label for="phone" class="form-label">联系电话</label>
    <input type="text" id="phone" name="phone" value="${not empty user ? fn:escapeXml(user.phone) : ''}" placeholder="请输入电话">
</div>
