<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="zh-CN" class="admin-theme">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>系统统计 - 管理员后台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bootstrap-theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin-theme.css">
    <style>
        .stats-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 30px; margin-bottom: 40px; }
        .stats-card { padding: 20px; background-color: #f8f9fa; border-radius: 8px; }
        .stats-card h3 { font-size: 16px; color: #333; margin-bottom: 20px; }
        .stats-item { display: flex; justify-content: space-between; padding: 10px 0; border-bottom: 1px solid #eee; margin-bottom: 10px; }
        .stats-item:last-child { border-bottom: none; margin-bottom: 0; }
        .stats-label { color: #666; }
        .stats-value { font-weight: bold; color: #007bff; }
        .chart-card { padding: 20px; background-color: #f8f9fa; border-radius: 8px; margin-bottom: 30px; }
        .chart-card h3 { font-size: 16px; color: #333; margin-bottom: 20px; }
        .chart-content { height: 300px; background-color: white; border: 1px solid #eee; border-radius: 5px; display: flex; align-items: center; justify-content: center; color: #999; }
        .rankings-container {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 30px;
            margin-bottom: 40px;
        }
        .ranking-card {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
        }
        .ranking-card h3 {
            font-size: 16px;
            color: #333;
            margin-bottom: 20px;
        }
        .ranking-list {
            list-style: none;
        }
        .ranking-item {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }
        .ranking-item:last-child {
            border-bottom: none;
        }
        .ranking-number {
            font-weight: bold;
            color: #007bff;
            width: 30px;
        }
        .ranking-info {
            flex: 1;
        }
        .ranking-count {
            font-weight: bold;
            color: #28a745;
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<jsp:include page="../../common/admin-header.jsp">
    <jsp:param name="title" value="云借阅系统 - 管理员后台"/>
</jsp:include>
<jsp:include page="../../common/admin-sidebar.jsp">
    <jsp:param name="activePage" value="stats"/>
</jsp:include>

<div class="main-container">

    <div class="content">
        <div class="stats-title">系统数据总览</div>

        <!-- 核心数据统计 -->
        <div class="stats-grid">
            <div class="stats-card">
                <h3>基础数据</h3>
                <div class="stats-item">
                    <span class="stats-label">总图书数量：</span>
                    <span class="stats-value">${totalBook} 本</span>
                </div>
                <div class="stats-item">
                    <span class="stats-label">总用户数量：</span>
                    <span class="stats-value">${totalUser} 人</span>
                </div>
                <div class="stats-item">
                    <span class="stats-label">总借阅次数：</span>
                    <span class="stats-value">${totalBorrow} 次</span>
                </div>
                <div class="stats-item">
                    <span class="stats-label">未归还图书：</span>
                    <span class="stats-value">${unReturnBorrow} 本</span>
                </div>
            </div>
        </div>

        <!-- 排行榜 -->
        <div class="rankings-container">
            <div class="ranking-card">
                <h3>热门图书排行榜 Top 10</h3>
                <ul class="ranking-list">
                    <c:forEach items="${topBooks}" var="book" varStatus="status">
                        <li class="ranking-item">
                            <span class="ranking-number">#${status.index + 1}</span>
                            <div class="ranking-info"><c:out value="${book.name}"/></div>
                            <span class="ranking-count">${book.borrowCount}次</span>
                        </li>
                    </c:forEach>
                </ul>
            </div>
            <div class="ranking-card">
                <h3>活跃用户排行榜 Top 10</h3>
                <ul class="ranking-list">
                    <c:forEach items="${activeUsers}" var="user" varStatus="status">
                        <li class="ranking-item">
                            <span class="ranking-number">#${status.index + 1}</span>
                            <div class="ranking-info"><c:out value="${user.name}"/></div>
                            <span class="ranking-count">${user.borrowCount}次</span>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </div>

       <!-- 修改图书类型占比部分的代码 -->
<div class="chart-card">
    <h3>图书类型占比</h3>
    <div class="chart-content">
        <c:if test="${not empty bookTypeRatio}">
            <div style="width: 100%; text-align: left; padding: 20px;">
                <c:forEach items="${bookTypeRatio}" var="entry" varStatus="status">
                    <div style="margin-bottom: 10px;">
                        <span><c:out value="${entry.key}"/>：</span>
                        <span>${entry.value} 本 (
                            <c:choose>
                                <c:when test="${totalBook > 0}">
                                    ${String.format("%.2f", entry.value * 100.0 / totalBook)}
                                </c:when>
                                <c:otherwise>
                                    0.00
                                </c:otherwise>
                            </c:choose>%)</span>
                        <div style="width: 300px; height: 15px; background-color: #eee; margin-top: 5px; border-radius: 7px; overflow: hidden; position: relative;">
                            <c:choose>
                                <c:when test="${totalBook > 0}">
                                    <c:set var="width" value="${entry.value * 100.0 / totalBook}" />
                                    <!-- 使用data属性存储宽度值，通过JavaScript设置 -->
                                    <div class="progress-bar" data-width="${width}" style="height: 100%; width: 0%; background-color: #007bff; transition: width 0.3s ease;"></div>
                                </c:when>
                                <c:otherwise>
                                    <div style="height: 100%; width: 0%; background-color: #007bff;"></div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
        <c:if test="${empty bookTypeRatio}">
            暂无图书类型数据
        </c:if>
    </div>
</div>

<!-- 借阅趋势图表 -->
<div class="chart-card">
    <h3>借阅趋势（近6个月）</h3>
    <div class="chart-content" style="height: 300px; padding: 20px;">
        <c:if test="${not empty borrowTrend}">
            <canvas id="borrowTrendChart"></canvas>
        </c:if>
        <c:if test="${empty borrowTrend}">
            <span>暂无借阅趋势数据</span>
        </c:if>
    </div>
</div>

<script>
    // 借阅趋势图表
    document.addEventListener('DOMContentLoaded', function() {
        // 设置进度条宽度
        var progressBars = document.querySelectorAll('.progress-bar');
        progressBars.forEach(function(bar) {
            var width = bar.getAttribute('data-width');
            if (width) {
                bar.style.width = width + '%';
            }
        });
        
        var chartEl = document.getElementById('borrowTrendChart');
        if (!chartEl) return;
        var ctx = chartEl.getContext('2d');

        // 准备数据
        var labels = [];
        var data = [];
        
        <c:forEach items="${borrowTrend}" var="entry">
            labels.push('${fn:escapeXml(entry.month)}');
            data.push(${fn:escapeXml(entry.count)});
        </c:forEach>
        
        var chart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: '借阅次数',
                    data: data,
                    borderColor: '#007bff',
                    backgroundColor: 'rgba(0, 123, 255, 0.1)',
                    borderWidth: 2,
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            stepSize: 1
                        }
                    }
                }
            }
        });
    });
</script>
</body>
</html>