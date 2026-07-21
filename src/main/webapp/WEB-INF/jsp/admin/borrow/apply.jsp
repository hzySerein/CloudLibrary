<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="zh-CN" class="admin-theme">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>借阅图书 - 管理员中心</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bootstrap-theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin-theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css">
    <style>
        /* 图书卡片样式 */
        .book-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 25px;
        }
        .book-card {
            background: #fff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            border: 1px solid #eee;
            display: flex;
            flex-direction: column;
        }
        .book-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.12);
        }
        .book-card.out-of-stock {
            opacity: 0.7;
        }
        .card-cover {
            height: 280px;
            overflow: hidden;
            position: relative;
            background-color: #f8f9fa;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
        }
        .card-cover img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }
        .book-card:hover .card-cover img {
            transform: scale(1.05);
        }
        .default-cover {
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #f0f0f0;
            color: #aaa;
        }
        .default-cover span {
            font-size: 60px;
        }
        .book-info {
            padding: 15px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }
        .book-info h3 {
            font-size: 16px;
            margin-bottom: 8px;
            color: #333;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .book-info p {
            font-size: 14px;
            color: #666;
            margin-bottom: 5px;
        }
        .book-actions {
            padding: 0 15px 15px;
        }
        .borrow-btn {
            width: 100%;
            padding: 10px;
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s;
            box-shadow: 0 4px 10px rgba(0, 123, 255, 0.3);
        }
        .borrow-btn:hover:not(.disabled) {
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(0, 123, 255, 0.4);
        }
        .borrow-btn.disabled {
            background: #ccc;
            cursor: not-allowed;
        }
        
        /* 模态框样式 */
        .modal {
            display: none;
            position: fixed;
            z-index: 1001;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }
        .modal-content {
            background-color: #fefefe;
            margin: 10% auto;
            padding: 0;
            border: none;
            border-radius: 12px;
            width: 90%;
            max-width: 500px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            animation: modalopen 0.4s;
        }
        @keyframes modalopen {
            from {opacity: 0; transform: translateY(-60px);}
            to {opacity: 1; transform: translateY(0);}
        }
        .modal-header {
            padding: 20px;
            background: #007bff;
            color: white;
            border-radius: 12px 12px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .modal-header h3 {
            margin: 0;
            font-weight: 500;
        }
        .close {
            color: white;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
            transition: transform 0.2s;
        }
        .close:hover {
            transform: scale(1.2);
        }
        .modal-body {
            padding: 30px;
        }
        
        /* 图书详情模态框样式 */
        .book-detail-modal .modal-content {
            max-width: 800px;
        }
        .book-detail-content {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }
        .book-detail-cover {
            flex: 1;
            text-align: center;
        }
        .book-detail-cover img {
            max-width: 100%;
            max-height: 300px;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .book-detail-info {
            flex: 2;
        }
        .book-detail-info h3 {
            font-size: 24px;
            margin-bottom: 15px;
            color: #333;
        }
        .book-detail-info p {
            margin-bottom: 10px;
            color: #666;
        }
        .book-description {
            margin-top: 15px;
            padding: 15px;
            background-color: #f8f9fa;
            border-radius: 8px;
            max-height: 200px;
            overflow-y: auto;
        }
        
        .error-msg {
            background: #fee;
            color: #c33;
            padding: 12px 18px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
            border-left: 4px solid #dc3545;
            animation: shake 0.5s;
        }
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }
    </style>
</head>
<body>
<jsp:include page="../../common/admin-header.jsp">
    <jsp:param name="title" value="云借阅系统 - 管理员中心"/>
</jsp:include>
<jsp:include page="../../common/admin-sidebar.jsp">
    <jsp:param name="activePage" value="borrow-apply"/>
</jsp:include>

<div class="main-container">

    <!-- 主内容区 -->
    <div class="content">
        <div class="form-title">借阅图书申请</div>

        <c:if test="${param.error == 'stock'}">
            <div class="alert alert-danger">该图书库存不足，无法借阅！</div>
        </c:if>
        <c:if test="${param.error == 'disabled' || param.error == 'book_disabled'}">
            <div class="alert alert-danger">该图书已被禁用或下架，无法借阅！</div>
        </c:if>
        <c:if test="${param.error == 'system'}">
            <div class="alert alert-danger">系统处理异常，借阅失败，请稍后重试！</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/admin/borrow/apply" method="get">
            <div class="form-group">
                <label class="form-label">搜索图书</label>
                <div style="display: flex; gap: 10px;">
                    <input type="text" name="keyword" aria-label="搜索图书" placeholder="请输入图书名称、作者或ISBN" value="${fn:escapeXml(keyword)}"
                           style="flex: 1; margin-right: 10px;">
                    <button type="submit" class="btn btn-primary">搜索</button>
                    <c:if test="${not empty keyword}">
                        <a href="${pageContext.request.contextPath}/admin/borrow/apply" 
                           class="btn btn-secondary">清空</a>
                    </c:if>
                </div>
            </div>
        </form>

        <form action="${pageContext.request.contextPath}/admin/borrow/apply" method="post">
            <input type="hidden" name="_csrf" value="${_csrf_token}">
            <div class="form-group">
                <label class="form-label">选择图书</label>
                <div class="book-grid">
                    <c:forEach items="${pageUtil.list}" var="book">
                        <div class="book-card ${book.stock <= 0 || book.status != 1 ? 'out-of-stock' : ''}">
                            <div class="card-cover" onclick="showBookDetail(${book.id})">
                                <c:choose>
                                    <c:when test="${not empty book.cover}">
                                        <img src="${pageContext.request.contextPath}${book.cover}" alt="${fn:escapeXml(book.name)}" onerror="this.parentNode.innerHTML='<div class=\'default-cover\'><span>📚</span></div>'">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="default-cover">
                                            <span>📚</span>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="book-info">
                                <h3><c:out value="${book.name}"/></h3>
                                <p>作者：<c:out value="${book.author}"/></p>
                                <p>库存：${book.stock}本</p>
                            </div>
                            <div class="book-actions">
                                <c:choose>
                                    <c:when test="${book.stock > 0 && book.status == 1}">
                                        <button type="button" class="borrow-btn" data-book-id="${book.id}" data-book-name="${fn:escapeXml(book.name)}" onclick="showBorrowForm(this)">借阅</button>
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
                    </c:forEach>
                </div>
            </div>
        </form>

        <!-- 借阅表单模态框 -->
        <div id="borrowModal" class="modal" role="dialog" aria-modal="true" aria-labelledby="borrowModalTitle">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 id="borrowModalTitle">借阅图书</h3>
                    <span class="close" onclick="closeBorrowForm()">&times;</span>
                </div>
                <div class="modal-body">
                    <form id="borrowForm" action="${pageContext.request.contextPath}/admin/borrow/apply" method="post">
                        <input type="hidden" name="_csrf" value="${_csrf_token}">
                        <input type="hidden" id="modalBookId" name="bookId">
                        <div class="form-group">
                            <label class="form-label">图书名称</label>
                            <input type="text" id="modalBookName" readonly class="form-control">
                        </div>
                        <div class="form-group">
                            <label for="modalDueTime" class="form-label">应归还时间</label>
                            <input type="date" id="modalDueTime" name="dueTime" required min="${currentDate}" class="form-control">
                        </div>
                        <div class="btn-group">
                            <button type="submit" class="btn btn-success">确认借阅</button>
                            <button type="button" class="btn btn-secondary" onclick="closeBorrowForm()">取消</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- 图书详情模态框 -->
        <div id="bookDetailModal" class="modal book-detail-modal" role="dialog" aria-modal="true" aria-labelledby="bookDetailTitle">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 id="bookDetailTitle">图书详情</h3>
                    <span class="close" onclick="closeBookDetail()">&times;</span>
                </div>
                <div class="modal-body">
                    <div class="book-detail-content">
                        <div class="book-detail-cover">
                            <img id="detailCover" src="" alt="图书封面">
                        </div>
                        <div class="book-detail-info">
                            <h3 id="detailName"></h3>
                            <p>作者：<span id="detailAuthor"></span></p>
                            <p>ISBN：<span id="detailIsbn"></span></p>
                            <p>类型：<span id="detailType"></span></p>
                            <p>库存：<span id="detailStock"></span>本</p>
                            <div class="book-description">
                                <p id="detailDescription"></p>
                            </div>
                        </div>
                    </div>
                    <div class="btn-group">
                        <button type="button" class="btn btn-secondary" onclick="closeBookDetail()">关闭</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="btn-group" style="margin-top: 30px;">
            <a href="${pageContext.request.contextPath}/admin/borrow/my" class="btn btn-secondary">我的借阅</a>
        </div>
        
        <jsp:include page="../../common/pagination.jsp">
            <jsp:param name="pageUrl" value="${pageContext.request.contextPath}/admin/borrow/apply"/>
        </jsp:include>
    </div>
</div>

<script>
    // 显示借阅表单
    function showBorrowForm(btn) {
        var bookId = btn.getAttribute('data-book-id');
        var bookName = btn.getAttribute('data-book-name');
        document.getElementById('modalBookId').value = bookId;
        document.getElementById('modalBookName').value = bookName;
        document.getElementById('borrowModal').style.display = 'block';
    }

    // 关闭借阅表单
    function closeBorrowForm() {
        document.getElementById('borrowModal').style.display = 'none';
    }

    // 点击模态框外部关闭
    window.addEventListener('click', function(event) {
        var borrowModal = document.getElementById('borrowModal');
        var detailModal = document.getElementById('bookDetailModal');
        if (event.target == borrowModal) {
            borrowModal.style.display = 'none';
        }
        if (event.target == detailModal) {
            detailModal.style.display = 'none';
        }
    });
    
    // 显示图书详情
    function showBookDetail(bookId) {
        // 显示加载提示
        document.getElementById('detailName').textContent = '加载中...';
        document.getElementById('detailAuthor').textContent = '';
        document.getElementById('detailIsbn').textContent = '';
        document.getElementById('detailType').textContent = '';
        document.getElementById('detailStock').textContent = '';
        document.getElementById('detailDescription').innerHTML = '';
        document.getElementById('bookDetailModal').style.display = 'block';
        
        // 查找对应的图书元素
        fetch('${pageContext.request.contextPath}/admin/book/detail/' + bookId)
            .then(response => {
                if (!response.ok) {
                    throw new Error('网络响应失败: ' + response.status);
                }
                return response.json();
            })
            .then(book => {
                // 检查是否是有效对象
                if (!book || (book.hasOwnProperty('id') && book.id === null)) {
                    document.getElementById('detailName').textContent = '未找到该图书';
                    return;
                }
                
                document.getElementById('detailName').textContent = book.name || '暂无';
                document.getElementById('detailAuthor').textContent = book.author || '暂无';
                document.getElementById('detailIsbn').textContent = book.isbn || '暂无';
                document.getElementById('detailType').textContent = book.type || '暂无';
                document.getElementById('detailStock').textContent = book.stock !== undefined ? book.stock : '暂无';
                
                // 处理描述信息
                const descriptionElement = document.getElementById('detailDescription');
                if (book.description && book.description.trim() !== '') {
                    descriptionElement.textContent = book.description;
                } else {
                    descriptionElement.innerHTML = '<i>暂无图书介绍</i>';
                }
                
                // 处理封面图片
                const coverContainer = document.querySelector('.book-detail-cover');
                if (book.cover) {
                    coverContainer.innerHTML = '<img id="detailCover" src="${pageContext.request.contextPath}' + book.cover + '" alt="' + (book.name || '图书封面') + '" onerror="this.onerror=null;this.parentNode.innerHTML=\'<div class=\\\'default-cover\\\'><span>📚</span></div>\'">';
                } else {
                    coverContainer.innerHTML = '<div class="default-cover"><span>📚</span></div>';
                }
            })
            .catch(error => {
                console.error('获取图书详情失败:', error);
                document.getElementById('detailName').textContent = '加载失败';
                document.getElementById('detailDescription').innerHTML = '错误信息: ' + error.message;
            });
    }
    
    // 关闭图书详情
    function closeBookDetail() {
        document.getElementById('bookDetailModal').style.display = 'none';
    }
</script>
<script src="${pageContext.request.contextPath}/static/js/layout.js"></script>
</body>
</html>