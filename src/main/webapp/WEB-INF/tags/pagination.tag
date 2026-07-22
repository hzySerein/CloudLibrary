<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ attribute name="pageData" type="org.cloudlibrary.util.PageUtil" required="true"%>
<%@ attribute name="baseUrl" required="true"%>
<%@ attribute name="keyword" required="false" rtexprvalue="true"%>

<c:if test="${not empty pageData && pageData.totalPage > 0}">
    <div class="pagination">
        <div class="pagination-links">
            <c:if test="${pageData.hasPrevious()}">
                <c:url var="firstUrl" value="${baseUrl}">
                    <c:param name="page" value="1"/>
                    <c:param name="size" value="${pageData.pageSize}"/>
                    <c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}"/></c:if>
                </c:url>
                <c:url var="prevUrl" value="${baseUrl}">
                    <c:param name="page" value="${pageData.currentPage - 1}"/>
                    <c:param name="size" value="${pageData.pageSize}"/>
                    <c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}"/></c:if>
                </c:url>
                <a href="${firstUrl}" class="pagination-btn">首页</a>
                <a href="${prevUrl}" class="pagination-btn">上一页</a>
            </c:if>
            <c:forEach begin="${pageData.startPage}" end="${pageData.endPage}" var="i">
                <c:choose>
                    <c:when test="${i == pageData.currentPage}">
                        <span class="pagination-num active">${i}</span>
                    </c:when>
                    <c:otherwise>
                        <c:url var="pageUrl" value="${baseUrl}">
                            <c:param name="page" value="${i}"/>
                            <c:param name="size" value="${pageData.pageSize}"/>
                            <c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}"/></c:if>
                        </c:url>
                        <a href="${pageUrl}" class="pagination-num">${i}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
            <c:if test="${pageData.hasNext()}">
                <c:url var="nextUrl" value="${baseUrl}">
                    <c:param name="page" value="${pageData.currentPage + 1}"/>
                    <c:param name="size" value="${pageData.pageSize}"/>
                    <c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}"/></c:if>
                </c:url>
                <c:url var="lastUrl" value="${baseUrl}">
                    <c:param name="page" value="${pageData.totalPage}"/>
                    <c:param name="size" value="${pageData.pageSize}"/>
                    <c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}"/></c:if>
                </c:url>
                <a href="${nextUrl}" class="pagination-btn">下一页</a>
                <a href="${lastUrl}" class="pagination-btn">末页</a>
            </c:if>
        </div>

        <div class="pagination-info">
            共 ${pageData.totalCount} 条记录，第 ${pageData.currentPage} / ${pageData.totalPage} 页
        </div>

        <div class="pagination-controls">
            <form method="get" action="${baseUrl}" class="pagination-form">
                <span class="pagination-label">跳转：</span>
                <input type="number" name="page" class="pagination-input" min="1" max="${pageData.totalPage}" value="${pageData.currentPage}">
                <input type="hidden" name="size" value="${pageData.pageSize}">
                <c:if test="${not empty keyword}">
                    <input type="hidden" name="keyword" value="${fn:escapeXml(keyword)}">
                </c:if>
                <button type="submit" class="pagination-go-btn">GO</button>
            </form>
            <form method="get" action="${baseUrl}" class="pagination-form">
                <span class="pagination-label">每页：</span>
                <select name="size" class="pagination-select" data-action="auto-submit">
                    <option value="5" ${pageData.pageSize == 5 ? 'selected' : ''}>5条</option>
                    <option value="10" ${pageData.pageSize == 10 ? 'selected' : ''}>10条</option>
                    <option value="20" ${pageData.pageSize == 20 ? 'selected' : ''}>20条</option>
                    <option value="50" ${pageData.pageSize == 50 ? 'selected' : ''}>50条</option>
                </select>
                <input type="hidden" name="page" value="1">
                <c:if test="${not empty keyword}">
                    <input type="hidden" name="keyword" value="${fn:escapeXml(keyword)}">
                </c:if>
            </form>
        </div>
    </div>
</c:if>
