<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<tags:layout role="admin" pageTitle="系统统计 - 管理员后台" activePage="stats" account="${loginAdmin}" pageCss="/static/css/pages/stats.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <div class="stats-title">系统数据总览</div>

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
                <div class="type-ratio-container">
                    <c:forEach items="${bookTypeRatio}" var="entry" varStatus="status">
                        <div class="type-ratio-item">
                            <span><c:out value="${entry.key}"/>：</span>
                            <span>${entry.value} 本 (
                                <c:choose>
                                    <c:when test="${totalBook > 0}">
                                        ${String.format("%.2f", entry.value * 100.0 / totalBook)}
                                    </c:when>
                                    <c:otherwise>0.00</c:otherwise>
                                </c:choose>%)</span>
                            <div class="progress-track">
                                <c:choose>
                                    <c:when test="${totalBook > 0}">
                                        <c:set var="width" value="${entry.value * 100.0 / totalBook}" />
                                        <div class="progress-bar" data-width="${width}"></div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="progress-bar"></div>
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

    <div class="chart-card">
        <h3>借阅趋势（近6个月）</h3>
        <div class="chart-content chart-content-trend">
            <c:if test="${not empty borrowTrend}">
                <canvas id="borrowTrendChart"></canvas>
            </c:if>
            <c:if test="${empty borrowTrend}">
                <span>暂无借阅趋势数据</span>
            </c:if>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/static/js/pages/stats.js"></script>
    <script>
        (function() {
            var labels = [];
            var data = [];
            <c:forEach items="${borrowTrend}" var="entry">
                labels.push('${fn:escapeXml(entry.month)}');
                data.push(${fn:escapeXml(entry.count)});
            </c:forEach>
            if (labels.length > 0) {
                StatsPage.initTrendChart(labels, data);
            }
        })();
    </script>
</tags:layout>
