<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<tags:layout role="${role}" pageTitle="个人中心 - ${accountProfile.roleName}中心" activePage="profile" account="${accountProfile}" pageCss="/static/css/pages/profile.css">

    <h2 class="form-title">个人中心</h2>

    <c:if test="${not empty param.error}">
        <div class="alert alert-danger fade-in">
            <span class="toast-icon">✕</span>
            <c:choose>
                <c:when test="${param.error == 'oldpwd'}">旧密码输入错误！</c:when>
                <c:when test="${param.error == 'confirm'}">新密码与确认密码不一致！</c:when>
                <c:otherwise>修改失败，请重试！</c:otherwise>
            </c:choose>
        </div>
    </c:if>

    <div class="profile-container">
        <div class="profile-card">
            <div class="profile-avatar"><c:out value="${accountProfile.avatarIcon}" escapeXml="false"/></div>
            <div class="profile-name"><c:out value="${accountProfile.name}"/></div>
            <div class="profile-username">@<c:out value="${accountProfile.username}"/></div>
            <div class="profile-info">
                <div class="profile-info-item">
                    <span class="profile-info-label">用户名</span>
                    <span class="profile-info-value"><c:out value="${accountProfile.username}"/></span>
                </div>
                <div class="profile-info-item">
                    <span class="profile-info-label">姓名</span>
                    <span class="profile-info-value"><c:out value="${accountProfile.name}"/></span>
                </div>
                <div class="profile-info-item">
                    <span class="profile-info-label">联系电话</span>
                    <span class="profile-info-value"><c:out value="${accountProfile.phone}"/></span>
                </div>
            </div>
        </div>

        <div class="form-card">
            <div class="form-card-header">
                <div class="form-card-title">修改个人信息</div>
                <div class="form-card-subtitle">更新您的账户信息和密码</div>
            </div>

            <form id="profileForm" action="${pageContext.request.contextPath}${accountProfile.profileAction}" method="post">
                <input type="hidden" name="_csrf" value="${_csrf_token}">
                <input type="hidden" name="id" value="${accountProfile.id}">
                <div class="form-row">
                    <div class="form-group">
                        <label for="username">用户名</label>
                        <input type="text" id="username" name="username" class="form-control" value="${fn:escapeXml(accountProfile.username)}" required placeholder="请输入用户名">
                    </div>
                    <div class="form-group">
                        <label for="name">姓名</label>
                        <input type="text" id="name" name="name" class="form-control" value="${fn:escapeXml(accountProfile.name)}" required placeholder="请输入姓名">
                    </div>
                </div>
                <div class="form-group">
                    <label for="phone">联系电话</label>
                    <input type="text" id="phone" name="phone" class="form-control" value="${fn:escapeXml(accountProfile.phone)}" placeholder="请输入联系电话">
                </div>
                <div class="profile-password-section">
                    <h3 class="profile-password-title">修改密码</h3>
                    <div class="profile-password-hint">如不需要修改密码，请留空以下字段</div>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="oldPassword">旧密码</label>
                            <input type="password" id="oldPassword" name="oldPassword" class="form-control" placeholder="请输入旧密码">
                        </div>
                        <div class="form-group"></div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="password">新密码</label>
                            <input type="password" id="password" name="password" class="form-control" placeholder="请输入新密码（至少6位）">
                        </div>
                        <div class="form-group">
                            <label for="confirmPassword">确认新密码</label>
                            <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" placeholder="请再次输入新密码">
                        </div>
                    </div>
                </div>
                <div class="profile-form-actions">
                    <a href="${pageContext.request.contextPath}${accountProfile.cancelUrl}" class="btn btn-outline">取消</a>
                    <button type="submit" class="btn btn-primary">保存修改</button>
                </div>
            </form>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/static/js/common.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/pages/profile.js"></script>
</tags:layout>
