<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="zh-CN" class="admin-theme">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>编辑图书 - 管理员后台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bootstrap-theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin-theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css">
    <script>
        function uploadCover(event) {
            var fileInput = document.querySelector('input[name="coverFile"]');
            var file = fileInput.files[0];
            
            if (!file) {
                alert('请选择要上传的文件');
                return;
            }
            
            var formData = new FormData();
            formData.append('coverFile', file);
            formData.append('_csrf', '${_csrf_token}');
            
            // 显示上传中提示
            var uploadBtn = event.target;
            var originalText = uploadBtn.textContent;
            uploadBtn.textContent = '上传中...';
            uploadBtn.disabled = true;
            
            fetch('${pageContext.request.contextPath}/admin/book/uploadCover/${book.id}', {
                method: 'POST',
                body: formData
            })
            .then(response => {
                return response.text().then(text => {
                    if (response.ok) {
                        alert('封面上传成功');
                        // 刷新页面以显示新封面
                        location.reload();
                    } else {
                        throw new Error(text || '封面上传失败');
                    }
                });
            })
            .catch(error => {
                console.error('Error:', error);
                alert('封面上传出错: ' + error.message);
            })
            .finally(() => {
                // 恢复按钮状态
                uploadBtn.textContent = originalText;
                uploadBtn.disabled = false;
            });
        }
    </script>
</head>
<body>
<jsp:include page="../../common/admin-header.jsp">
    <jsp:param name="title" value="云借阅系统 - 管理员后台 - 编辑图书"/>
</jsp:include>
<jsp:include page="../../common/admin-sidebar.jsp">
    <jsp:param name="activePage" value="book-list"/>
</jsp:include>
<div class="main-container">
    <div class="content">
        <div class="form-title">编辑图书信息</div>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger"><c:out value="${error}"/></div>
        </c:if>

        <c:if test="${not empty message}">
            <div class="alert alert-success"><c:out value="${message}"/></div>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/admin/book/edit" method="post">
            <input type="hidden" name="_csrf" value="${_csrf_token}">
            <input type="hidden" name="id" value="${book.id}">
            <div class="form-group">
                <label for="name" class="form-label">图书名称</label>
                <input type="text" id="name" name="name" value="${fn:escapeXml(book.name)}" required placeholder="请输入图书名称">
            </div>
            <div class="form-group">
                <label for="author" class="form-label">作者</label>
                <input type="text" id="author" name="author" value="${fn:escapeXml(book.author)}" required placeholder="请输入作者">
            </div>
            <div class="form-group">
                <label for="isbn" class="form-label">ISBN编号</label>
                <input type="text" id="isbn" name="isbn" value="${fn:escapeXml(book.isbn)}" required placeholder="请输入ISBN">
            </div>
            <div class="form-group">
                <label for="stock" class="form-label">库存数量</label>
                <input type="number" id="stock" name="stock" value="${fn:escapeXml(book.stock)}" required min="0" placeholder="请输入库存数量">
            </div>
            <div class="form-group">
                <label for="type" class="form-label">图书类型</label>
                <select id="type" name="type" required>
                    <option value="计算机" ${book.type == '计算机' ? 'selected' : ''}>计算机</option>
                    <option value="科幻" ${book.type == '科幻' ? 'selected' : ''}>科幻</option>
                    <option value="文学" ${book.type == '文学' ? 'selected' : ''}>文学</option>
                    <option value="历史" ${book.type == '历史' ? 'selected' : ''}>历史</option>
                    <option value="其他" ${book.type == '其他' ? 'selected' : ''}>其他</option>
                </select>
            </div>
            <div class="form-group">
                <label for="description" class="form-label">图书介绍</label>
                <textarea id="description" name="description" rows="5" placeholder="请输入图书介绍">${fn:escapeXml(book.description)}</textarea>
            </div>
            <div class="form-group">
                <label for="status" class="form-label">图书状态</label>
                <select id="status" name="status">
                    <option value="1" ${book.status == 1 ? 'selected' : ''}>可借</option>
                    <option value="0" ${book.status == 0 ? 'selected' : ''}>不可借</option>
                </select>
            </div>
            <div class="form-group">
                <label class="form-label">图书封面</label>
                <c:if test="${not empty book.cover}">
                    <div style="margin-bottom: 10px;">
                        <img src="${pageContext.request.contextPath}${book.cover}" alt="封面" style="max-width: 200px; max-height: 300px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);" onerror="this.src='${pageContext.request.contextPath}/static/images/no-cover.png'; this.onerror=null;">
                    </div>
                </c:if>
                <c:if test="${empty book.cover}">
                    <div style="margin-bottom: 10px;">
                        <span>暂无封面</span>
                    </div>
                </c:if>
                <div style="display: flex; gap: 10px; align-items: flex-end;">
                    <input type="file" name="coverFile" accept="image/*">
                    <button type="button" onclick="uploadCover(event)" class="btn btn-primary">上传封面</button>
                </div>
            </div>
            <div class="btn-group">
                <button type="submit" class="btn btn-success">提交</button>
                <a href="${pageContext.request.contextPath}/admin/book/list" class="btn btn-secondary">返回列表</a>
            </div>
        </form>
    </div>
</div>
<script src="${pageContext.request.contextPath}/static/js/layout.js"></script>
</body>
</html>