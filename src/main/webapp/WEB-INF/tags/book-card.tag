<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ attribute name="book" type="org.cloudlibrary.entity.Book" required="true" rtexprvalue="true"%>
<div class="book-card ${book.stock <= 0 || book.status != 1 ? 'out-of-stock' : ''}">
    <div class="card-cover" data-action="show-book-detail" data-book-id="${book.id}">
        <c:choose>
            <c:when test="${not empty book.cover}">
                <img src="${pageContext.request.contextPath}${book.cover}" alt="${fn:escapeXml(book.name)}" onerror="this.onerror=null;this.parentNode.innerHTML='<div class=\'default-cover\'><span>📚</span></div>'">
            </c:when>
            <c:otherwise>
                <div class="default-cover"><span>📚</span></div>
            </c:otherwise>
        </c:choose>
    </div>
    <div class="book-info">
        <h3><c:out value="${book.name}"/></h3>
        <p>作者：<c:out value="${book.author}"/></p>
        <p>ISBN：<c:out value="${book.isbn}"/></p>
        <c:choose>
            <c:when test="${book.stock == 0}"><span class="stock-info out-stock">库存不足</span></c:when>
            <c:when test="${book.stock <= 5}"><span class="stock-info low-stock">仅剩 ${book.stock} 本</span></c:when>
            <c:otherwise><span class="stock-info in-stock">库存：${book.stock} 本</span></c:otherwise>
        </c:choose>
    </div>
    <div class="book-actions">
        <c:choose>
            <c:when test="${book.stock > 0 && book.status == 1}">
                <button type="button" class="borrow-btn" data-action="show-borrow-form" data-book-id="${book.id}" data-book-name="${fn:escapeXml(book.name)}" data-book-stock="${book.stock}">立即借阅</button>
            </c:when>
            <c:when test="${book.status != 1}">
                <button type="button" class="borrow-btn disabled" disabled>图书已禁用</button>
            </c:when>
            <c:otherwise>
                <button type="button" class="borrow-btn disabled" disabled>库存不足</button>
            </c:otherwise>
        </c:choose>
    </div>
</div>
