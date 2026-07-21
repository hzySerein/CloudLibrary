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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css">
    <style>
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; margin-bottom: 28px; }
        .kpi-card {
            background: #ffffff;
            border-radius: var(--border-radius-lg, 16px);
            padding: 24px;
            border: 1px solid var(--border-color, #e2e8f0);
            box-shadow: var(--card-shadow, 0 4px 12px rgba(0,0,0,0.05));
            display: flex;
            align-items: center;
            justify-content: space-between;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .kpi-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--hover-shadow, 0 10px 20px rgba(54, 87, 124, 0.12));
        }
        .kpi-info { display: flex; flex-direction: column; gap: 6px; }
        .kpi-label { color: var(--text-muted, #64748b); font-size: 13px; font-weight: 500; }
        .kpi-value { font-size: 26px; font-weight: 800; color: var(--text-dark, #0f172a); }
        .kpi-icon {
            width: 54px;
            height: 54px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 26px;
        }
        .kpi-icon.blue { background: rgba(59, 130, 246, 0.12); color: #3b82f6; }
        .kpi-icon.green { background: rgba(16, 185, 129, 0.12); color: #10b981; }
        .kpi-icon.purple { background: rgba(139, 92, 246, 0.12); color: #8b5cf6; }
        .kpi-icon.orange { background: rgba(245, 158, 11, 0.12); color: #f59e0b; }

        .chart-card {
            padding: 24px;
            background-color: #ffffff;
            border-radius: var(--border-radius-lg, 16px);
            border: 1px solid var(--border-color, #e2e8f0);
            box-shadow: var(--card-shadow, 0 4px 12px rgba(0,0,0,0.05));
            margin-bottom: 28px;
        }
        .chart-card h3 {
            font-size: 16px;
            font-weight: 700;
            color: var(--text-dark, #0f172a);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .chart-content {
            min-height: 280px;
            background-color: #ffffff;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--text-muted, #64748b);
        }

        .rankings-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 24px;
            margin-bottom: 28px;
        }
        .ranking-card {
            background-color: #ffffff;
            border-radius: var(--border-radius-lg, 16px);
            border: 1px solid var(--border-color, #e2e8f0);
            box-shadow: var(--card-shadow, 0 4px 12px rgba(0,0,0,0.05));
            padding: 24px;
        }
        .ranking-card h3 {
            font-size: 16px;
            font-weight: 700;
            color: var(--text-dark, #0f172a);
            margin-bottom: 18px;
            border-bottom: 2px solid var(--border-color, #e2e8f0);
            padding-bottom: 10px;
        }
        .ranking-list { list-style: none; }
        .ranking-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #f1f5f9;
        }
        .ranking-item:last-child { border-bottom: none; }
        .ranking-number {
            font-weight: 700;
            color: var(--primary-color, #36577c);
            width: 38px;
            font-size: 14px;
        }
        .ranking-number.top1 { color: #f59e0b; }
        .ranking-number.top2 { color: #64748b; }
        .ranking-number.top3 { color: #b45309; }
        .ranking-info { flex: 1; font-weight: 600; color: var(--text-dark, #334155); font-size: 14px; }
        .ranking-count {
            font-weight: 700;
            color: var(--primary-color, #36577c);
            background: rgba(54, 87, 124, 0.1);
            padding: 3px 12px;
            border-radius: 20px;
            font-size: 12px;
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

        <!-- 核心数据 KPI 卡片 -->
        <div class="stats-grid">
            <div class="kpi-card">
                <div class="kpi-info">
                    <span class="kpi-label">总图书数量</span>
                    <span class="kpi-value">${totalBook}</span>
                </div>
                <div class="kpi-icon blue">📚</div>
            </div>
            <div class="kpi-card">
                <div class="kpi-info">
                    <span class="kpi-label">总用户数量</span>
                    <span class="kpi-value">${totalUser}</span>
                </div>
                <div class="kpi-icon green">👥</div>
            </div>
            <div class="kpi-card">
                <div class="kpi-info">
                    <span class="kpi-label">总借阅次数</span>
                    <span class="kpi-value">${totalBorrow}</span>
                </div>
                <div class="kpi-icon purple">📖</div>
            </div>
            <div class="kpi-card">
                <div class="kpi-info">
                    <span class="kpi-label">未归还图书</span>
                    <span class="kpi-value">${unReturnBorrow}</span>
                </div>
                <div class="kpi-icon orange">⏰</div>
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
        
        // 渐变填充背景
        var gradient = ctx.createLinearGradient(0, 0, 0, 300);
        gradient.addColorStop(0, 'rgba(54, 87, 124, 0.35)');
        gradient.addColorStop(1, 'rgba(54, 87, 124, 0.01)');
        
        var chart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: '借阅次数',
                    data: data,
                    borderColor: '#36577c',
                    backgroundColor: gradient,
                    borderWidth: 3,
                    pointBackgroundColor: '#36577c',
                    pointBorderColor: '#ffffff',
                    pointBorderWidth: 2,
                    pointRadius: 5,
                    pointHoverRadius: 7,
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: true,
                        labels: { font: { family: 'inherit', size: 13, weight: '600' } }
                    }
                },
                scales: {
                    x: { grid: { display: false } },
                    y: {
                        beginAtZero: true,
                        grid: { color: 'rgba(226, 232, 240, 0.6)' },
                        ticks: {
                            stepSize: 1,
                            font: { family: 'inherit', size: 12 }
                        }
                    }
                }
            }
        });
    });
</script>
<script src="${pageContext.request.contextPath}/static/js/layout.js"></script>
</body>
</html>