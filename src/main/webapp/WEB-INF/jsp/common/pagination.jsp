<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:if test="${not empty pageUtil && pageUtil.totalPage > 0}">
    <c:set var="baseUrl" value="${param.pageUrl}" />
    <div class="pagination" style="display: flex !important; flex-direction: row !important; justify-content: space-between !important; align-items: center !important; flex-wrap: nowrap !important; width: 100% !important; padding: 12px 16px !important; margin-top: 20px !important; background: #ffffff !important; border-radius: 8px !important; border: 1px solid #e2e8f0 !important; box-sizing: border-box !important;">
        <!-- 左侧页码 -->
        <div class="pagination-links" style="display: flex !important; flex-direction: row !important; align-items: center !important; gap: 6px !important; white-space: nowrap !important;">
            <c:if test="${pageUtil.hasPrevious()}">
                <a href="${baseUrl}?page=1&size=${pageUtil.pageSize}<c:if test="${not empty keyword}">&keyword=${fn:escapeXml(keyword)}</c:if>" class="pagination-btn" style="display: inline-flex !important; align-items: center !important; justify-content: center !important; min-width: 30px !important; height: 30px !important; padding: 0 8px !important; background: #ffffff !important; color: #475569 !important; border: 1px solid #cbd5e1 !important; border-radius: 4px !important; font-size: 13px !important; text-decoration: none !important;">首页</a>
                <a href="${baseUrl}?page=${pageUtil.currentPage - 1}&size=${pageUtil.pageSize}<c:if test="${not empty keyword}">&keyword=${fn:escapeXml(keyword)}</c:if>" class="pagination-btn" style="display: inline-flex !important; align-items: center !important; justify-content: center !important; min-width: 30px !important; height: 30px !important; padding: 0 8px !important; background: #ffffff !important; color: #475569 !important; border: 1px solid #cbd5e1 !important; border-radius: 4px !important; font-size: 13px !important; text-decoration: none !important;">上一页</a>
            </c:if>
            <c:forEach begin="${pageUtil.startPage}" end="${pageUtil.endPage}" var="i">
                <c:choose>
                    <c:when test="${i == pageUtil.currentPage}">
                        <span class="pagination-num active" style="display: inline-flex !important; align-items: center !important; justify-content: center !important; min-width: 30px !important; height: 30px !important; padding: 0 8px !important; background: #2d486b !important; color: #ffffff !important; border: 1px solid #2d486b !important; border-radius: 4px !important; font-size: 13px !important; font-weight: 600 !important; box-shadow: none !important;">${i}</span>
                    </c:when>
                    <c:otherwise>
                        <a href="${baseUrl}?page=${i}&size=${pageUtil.pageSize}<c:if test="${not empty keyword}">&keyword=${fn:escapeXml(keyword)}</c:if>" class="pagination-num" style="display: inline-flex !important; align-items: center !important; justify-content: center !important; min-width: 30px !important; height: 30px !important; padding: 0 8px !important; background: #ffffff !important; color: #334155 !important; border: 1px solid #cbd5e1 !important; border-radius: 4px !important; font-size: 13px !important; text-decoration: none !important;">${i}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
            <c:if test="${pageUtil.hasNext()}">
                <a href="${baseUrl}?page=${pageUtil.currentPage + 1}&size=${pageUtil.pageSize}<c:if test="${not empty keyword}">&keyword=${fn:escapeXml(keyword)}</c:if>" class="pagination-btn" style="display: inline-flex !important; align-items: center !important; justify-content: center !important; min-width: 30px !important; height: 30px !important; padding: 0 8px !important; background: #ffffff !important; color: #475569 !important; border: 1px solid #cbd5e1 !important; border-radius: 4px !important; font-size: 13px !important; text-decoration: none !important;">下一页</a>
                <a href="${baseUrl}?page=${pageUtil.totalPage}&size=${pageUtil.pageSize}<c:if test="${not empty keyword}">&keyword=${fn:escapeXml(keyword)}</c:if>" class="pagination-btn" style="display: inline-flex !important; align-items: center !important; justify-content: center !important; min-width: 30px !important; height: 30px !important; padding: 0 8px !important; background: #ffffff !important; color: #475569 !important; border: 1px solid #cbd5e1 !important; border-radius: 4px !important; font-size: 13px !important; text-decoration: none !important;">末页</a>
            </c:if>
        </div>

        <!-- 中间信息 -->
        <div class="pagination-info" style="white-space: nowrap !important; text-align: center !important; font-size: 13px !important; color: #475569 !important; margin: 0 12px !important; height: 30px !important; line-height: 30px !important; display: flex !important; align-items: center !important; justify-content: center !important; border: none !important; background: transparent !important;">
            共 ${pageUtil.totalCount} 条记录，第 ${pageUtil.currentPage} / ${pageUtil.totalPage} 页
        </div>

        <!-- 右侧跳转与每页显示条数控制 -->
        <div class="pagination-controls" style="display: flex !important; flex-direction: row !important; align-items: center !important; gap: 12px !important; white-space: nowrap !important; height: 30px !important;">
            <form method="get" action="${baseUrl}" class="pagination-form" style="display: inline-flex !important; flex-direction: row !important; align-items: center !important; gap: 6px !important; margin: 0 !important; padding: 0 !important; height: 30px !important;">
                <span class="pagination-label" style="display: inline-flex !important; align-items: center !important; margin: 0 !important; padding: 0 !important; white-space: nowrap !important; font-size: 13px !important; color: #334155 !important; border: none !important; background: transparent !important; background-color: transparent !important; box-shadow: none !important; height: 30px !important; line-height: 30px !important; min-width: auto !important;">跳转：</span>
                <input type="number" name="page" class="pagination-input" min="1" max="${pageUtil.totalPage}" value="${pageUtil.currentPage}" style="display: inline-block !important; width: 44px !important; height: 30px !important; padding: 0 4px !important; text-align: center !important; border: 1px solid #cbd5e1 !important; border-radius: 4px !important; font-size: 13px !important; background: #ffffff !important; color: #0f172a !important; margin: 0 !important; box-sizing: border-box !important; outline: none !important; vertical-align: middle !important;">
                <input type="hidden" name="size" value="${pageUtil.pageSize}">
                <c:if test="${not empty keyword}">
                    <input type="hidden" name="keyword" value="${fn:escapeXml(keyword)}">
                </c:if>
                <button type="submit" class="pagination-go-btn" style="display: inline-flex !important; align-items: center !important; justify-content: center !important; height: 30px !important; padding: 0 12px !important; background: #2d486b !important; color: #ffffff !important; border: none !important; border-radius: 4px !important; font-size: 12px !important; font-weight: 600 !important; cursor: pointer !important; margin: 0 !important; line-height: 1 !important; vertical-align: middle !important;">GO</button>
            </form>
            <form method="get" action="${baseUrl}" class="pagination-form" style="display: inline-flex !important; flex-direction: row !important; align-items: center !important; gap: 6px !important; margin: 0 !important; padding: 0 !important; height: 30px !important;">
                <span class="pagination-label" style="display: inline-flex !important; align-items: center !important; margin: 0 !important; padding: 0 !important; white-space: nowrap !important; font-size: 13px !important; color: #334155 !important; border: none !important; background: transparent !important; background-color: transparent !important; box-shadow: none !important; height: 30px !important; line-height: 30px !important; min-width: auto !important;">每页：</span>
                <select name="size" class="pagination-select" onchange="this.form.submit()" style="display: inline-block !important; height: 30px !important; padding: 0 6px !important; border: 1px solid #cbd5e1 !important; border-radius: 4px !important; font-size: 13px !important; background: #ffffff !important; color: #0f172a !important; margin: 0 !important; box-sizing: border-box !important; outline: none !important; cursor: pointer !important; vertical-align: middle !important;">
                    <option value="5" ${pageUtil.pageSize == 5 ? 'selected' : ''}>5条</option>
                    <option value="10" ${pageUtil.pageSize == 10 ? 'selected' : ''}>10条</option>
                    <option value="20" ${pageUtil.pageSize == 20 ? 'selected' : ''}>20条</option>
                    <option value="50" ${pageUtil.pageSize == 50 ? 'selected' : ''}>50条</option>
                </select>
                <input type="hidden" name="page" value="1">
                <c:if test="${not empty keyword}">
                    <input type="hidden" name="keyword" value="${fn:escapeXml(keyword)}">
                </c:if>
            </form>
        </div>
    </div>
</c:if>
