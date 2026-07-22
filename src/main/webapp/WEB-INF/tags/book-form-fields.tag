<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ attribute name="book" type="java.lang.Object" required="false" rtexprvalue="true"%>
<%@ attribute name="editMode" required="false" type="java.lang.Boolean" rtexprvalue="true"%>
<div class="form-group">
    <label for="name" class="form-label">图书名称</label>
    <input type="text" id="name" name="name" value="${not empty book ? fn:escapeXml(book.name) : ''}" required placeholder="请输入图书名称">
</div>
<div class="form-group">
    <label for="author" class="form-label">作者</label>
    <input type="text" id="author" name="author" value="${not empty book ? fn:escapeXml(book.author) : ''}" required placeholder="请输入作者">
</div>
<div class="form-group">
    <label for="isbn" class="form-label">ISBN编号</label>
    <input type="text" id="isbn" name="isbn" value="${not empty book ? fn:escapeXml(book.isbn) : ''}" required placeholder="请输入ISBN">
</div>
<div class="form-group">
    <label for="stock" class="form-label">库存数量</label>
    <input type="number" id="stock" name="stock" value="${not empty book ? fn:escapeXml(book.stock) : ''}" required min="0" placeholder="请输入库存数量">
</div>
<div class="form-group">
    <label for="type" class="form-label">图书类型</label>
    <select id="type" name="type" required>
        <c:if test="${not editMode}">
            <option value="">请选择图书类型</option>
        </c:if>
        <option value="计算机" ${not empty book && book.type == '计算机' ? 'selected' : ''}>计算机</option>
        <option value="科幻" ${not empty book && book.type == '科幻' ? 'selected' : ''}>科幻</option>
        <option value="文学" ${not empty book && book.type == '文学' ? 'selected' : ''}>文学</option>
        <option value="历史" ${not empty book && book.type == '历史' ? 'selected' : ''}>历史</option>
        <option value="其他" ${not empty book && book.type == '其他' ? 'selected' : ''}>其他</option>
    </select>
</div>
<div class="form-group">
    <label for="description" class="form-label">图书介绍</label>
    <textarea id="description" name="description" rows="5" placeholder="请输入图书介绍">${not empty book ? fn:escapeXml(book.description) : ''}</textarea>
</div>
