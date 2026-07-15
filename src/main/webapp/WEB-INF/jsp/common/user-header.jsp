<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bootstrap-theme.css">
<div class="header">
    <div class="header-left">
        <button class="mobile-menu-toggle" aria-label="切换菜单" onclick="toggleMobileMenu()">
            <span></span>
            <span></span>
            <span></span>
        </button>
        <h2><c:out value="${title}"/></h2>
    </div>
    <div class="user-info">
        <span class="user-name">欢迎您：<c:out value="${loginUser.name}"/></span>
        <a href="${pageContext.request.contextPath}/user/profile" class="user-action">个人中心</a>
        <form action="${pageContext.request.contextPath}/user/logout" method="post" style="display:inline;">
            <input type="hidden" name="_csrf" value="${_csrf_token}">
            <button type="submit" class="user-action logout" style="background:none;border:none;cursor:pointer;">退出登录</button>
        </form>
    </div>
</div>
<style>
    .header {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        background: linear-gradient(135deg, #3d5a80 0%, #2d4a6f 100%);
        color: white;
        padding: 0 24px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        z-index: 1000;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        height: 64px;
    }

    .header-left {
        display: flex;
        align-items: center;
        gap: 16px;
    }

    .header h2 {
        font-size: 18px;
        font-weight: 600;
        margin: 0;
    }

    .mobile-menu-toggle {
        display: none;
        flex-direction: column;
        gap: 5px;
        background: none;
        border: none;
        cursor: pointer;
        padding: 8px;
    }

    .mobile-menu-toggle span {
        width: 24px;
        height: 2px;
        background: white;
        border-radius: 2px;
        transition: all 0.3s ease;
    }

    .user-info {
        display: flex;
        align-items: center;
        gap: 16px;
        font-size: 14px;
    }

    .user-name {
        display: none;
    }

    .user-info a {
        color: white;
        text-decoration: none;
        padding: 8px 16px;
        border-radius: 6px;
        background-color: rgba(255, 255, 255, 0.15);
        transition: all 0.3s ease;
        font-size: 13px;
    }

    .user-info a:hover {
        background-color: rgba(255, 255, 255, 0.25);
        transform: translateY(-2px);
    }

    .user-info a.logout {
        background-color: rgba(220, 53, 69, 0.2);
    }

    .user-info a.logout:hover {
        background-color: rgba(220, 53, 69, 0.3);
    }

    @media (max-width: 768px) {
        .header {
            padding: 0 16px;
        }

        .header h2 {
            font-size: 16px;
        }

        .mobile-menu-toggle {
            display: flex;
        }

        .user-name {
            display: block;
            font-size: 13px;
            max-width: 100px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .user-info a {
            padding: 6px 12px;
            font-size: 12px;
        }

        .user-info a:not(.logout) {
            display: none;
        }
    }

    @media (max-width: 480px) {
        .user-name {
            display: none;
        }
    }
</style>
<script>
    function toggleMobileMenu() {
        const sidebar = document.querySelector('.sidebar');
        sidebar.classList.toggle('mobile-open');
    }

    document.addEventListener('click', function(e) {
        const sidebar = document.querySelector('.sidebar');
        const menuToggle = document.querySelector('.mobile-menu-toggle');
        
        if (!sidebar.contains(e.target) && !menuToggle.contains(e.target)) {
            sidebar.classList.remove('mobile-open');
        }
    });
</script>
