<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="zh-CN" class="user-theme">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>修改个人信息 - 用户中心</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bootstrap-theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user-theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css">
    <style>
        .profile-container {
            display: grid;
            grid-template-columns: 300px 1fr;
            gap: 24px;
        }

        .profile-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            padding: 24px;
            text-align: center;
        }

        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 48px;
            color: white;
            box-shadow: 0 4px 12px rgba(61, 90, 128, 0.3);
        }

        .profile-name {
            font-size: 20px;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 8px;
        }

        .profile-username {
            font-size: 14px;
            color: var(--text-muted);
            margin-bottom: 20px;
        }

        .profile-info {
            text-align: left;
            padding-top: 20px;
            border-top: 1px solid var(--border-color);
        }

        .profile-info-item {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid var(--border-color);
        }

        .profile-info-item:last-child {
            border-bottom: none;
        }

        .profile-info-label {
            color: var(--text-muted);
            font-size: 14px;
        }

        .profile-info-value {
            color: var(--text-dark);
            font-weight: 500;
            font-size: 14px;
        }

        .form-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            padding: 30px;
        }

        .form-card-header {
            margin-bottom: 24px;
            padding-bottom: 16px;
            border-bottom: 2px solid var(--border-color);
        }

        .form-card-title {
            font-size: 20px;
            font-weight: 600;
            color: var(--text-dark);
        }

        .form-card-subtitle {
            font-size: 14px;
            color: var(--text-muted);
            margin-top: 4px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        @media (max-width: 768px) {
            .profile-container {
                grid-template-columns: 1fr;
            }

            .form-row {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<jsp:include page="../common/user-header.jsp">
    <jsp:param name="title" value="云借阅系统 - 用户中心"/>
</jsp:include>
<jsp:include page="../common/user-sidebar.jsp">
    <jsp:param name="activePage" value="profile"/>
</jsp:include>

<div class="main-container">
    <div class="content">
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
                <div class="profile-avatar">
                    👤
                </div>
                <div class="profile-name"><c:out value="${user.name}"/></div>
                <div class="profile-username">@<c:out value="${user.username}"/></div>
                <div class="profile-info">
                    <div class="profile-info-item">
                        <span class="profile-info-label">用户名</span>
                        <span class="profile-info-value"><c:out value="${user.username}"/></span>
                    </div>
                    <div class="profile-info-item">
                        <span class="profile-info-label">姓名</span>
                        <span class="profile-info-value"><c:out value="${user.name}"/></span>
                    </div>
                    <div class="profile-info-item">
                        <span class="profile-info-label">联系电话</span>
                        <span class="profile-info-value"><c:out value="${user.phone}"/></span>
                    </div>
                </div>
            </div>
            
            <div class="form-card">
                <div class="form-card-header">
                    <div class="form-card-title">修改个人信息</div>
                    <div class="form-card-subtitle">更新您的账户信息和密码</div>
                </div>
                
                <form id="profileForm" action="${pageContext.request.contextPath}/user/profile" method="post">
                    <input type="hidden" name="_csrf" value="${_csrf_token}">
                    <input type="hidden" name="id" value="${user.id}">
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="username">用户名</label>
                            <input type="text" id="username" name="username" class="form-control" value="${fn:escapeXml(user.username)}" required placeholder="请输入用户名">
                            <div class="invalid-feedback"></div>
                        </div>
                        <div class="form-group">
                            <label for="name">姓名</label>
                            <input type="text" id="name" name="name" class="form-control" value="${fn:escapeXml(user.name)}" required placeholder="请输入姓名">
                            <div class="invalid-feedback"></div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="phone">联系电话</label>
                        <input type="text" id="phone" name="phone" class="form-control" value="${fn:escapeXml(user.phone)}" placeholder="请输入联系电话">
                        <div class="invalid-feedback"></div>
                    </div>
                    
                    <div style="margin: 30px 0; padding: 20px 0; border-top: 1px solid var(--border-color); border-bottom: 1px solid var(--border-color);">
                        <h3 style="font-size: 16px; font-weight: 600; color: var(--text-dark); margin-bottom: 16px;">修改密码</h3>
                        <div style="font-size: 13px; color: var(--text-muted); margin-bottom: 20px;">如不需要修改密码，请留空以下字段</div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="oldPassword">旧密码</label>
                                <input type="password" id="oldPassword" name="oldPassword" class="form-control" placeholder="请输入旧密码">
                                <div class="invalid-feedback"></div>
                            </div>
                            <div class="form-group"></div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="password">新密码</label>
                                <input type="password" id="password" name="password" class="form-control" placeholder="请输入新密码（至少6位）">
                                <div class="invalid-feedback"></div>
                            </div>
                            <div class="form-group">
                                <label for="confirmPassword">确认新密码</label>
                                <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" placeholder="请再次输入新密码">
                                <div class="invalid-feedback"></div>
                            </div>
                        </div>
                    </div>
                    
                    <div style="display: flex; gap: 12px; justify-content: flex-end;">
                        <a href="${pageContext.request.contextPath}/user/index" class="btn btn-outline">取消</a>
                        <button type="submit" class="btn btn-primary">保存修改</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/static/js/common.js"></script>
<script>
    const profileForm = document.getElementById('profileForm');
    new FormValidator(profileForm, {
        rules: {
            username: [
                { required: true, message: '请输入用户名' },
                { minLength: 3, message: '用户名至少需要3个字符' }
            ],
            name: [
                { required: true, message: '请输入姓名' }
            ],
            phone: [
                { phone: true, message: '请输入有效的手机号码' }
            ],
            oldPassword: [
                { minLength: 6, message: '密码至少需要6个字符' }
            ],
            password: [
                { minLength: 6, message: '密码至少需要6个字符' }
            ]
        },
        onSubmit: function(form) {
            const password = form.querySelector('#password').value;
            const confirmPassword = form.querySelector('#confirmPassword').value;
            const oldPassword = form.querySelector('#oldPassword').value;
            
            if (password || confirmPassword) {
                if (!oldPassword) {
                    toast.error('修改密码需要输入旧密码');
                    return false;
                }
                if (password !== confirmPassword) {
                    toast.error('新密码与确认密码不一致');
                    return false;
                }
            }
            
            form.submit();
        }
    });
</script>
<script src="${pageContext.request.contextPath}/static/js/layout.js"></script>
</body>
</html>