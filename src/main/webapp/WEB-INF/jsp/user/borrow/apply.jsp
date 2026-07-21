<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="zh-CN" class="user-theme">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>借阅图书 - 用户中心</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bootstrap-theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user-theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css">
    <style>
        .book-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
            gap: 24px;
            margin-top: 20px;
        }

        .book-card {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
            border: 1px solid var(--border-color);
            display: flex;
            flex-direction: column;
        }

        .book-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(61, 90, 128, 0.2);
        }

        .book-card.out-of-stock {
            opacity: 0.6;
        }

        .card-cover {
            height: 280px;
            overflow: hidden;
            position: relative;
            background-color: var(--bg-light);
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
            background: linear-gradient(135deg, var(--bg-gray) 0%, var(--bg-light) 100%);
            color: var(--text-muted);
        }

        .default-cover span {
            font-size: 64px;
        }

        .book-info {
            padding: 18px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }

        .book-info h3 {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 10px;
            color: var(--text-dark);
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .book-info p {
            font-size: 13px;
            color: var(--text-muted);
            margin-bottom: 6px;
        }

        .book-info .stock-info {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }

        .book-info .stock-info.in-stock {
            background-color: rgba(40, 167, 69, 0.1);
            color: var(--success);
        }

        .book-info .stock-info.low-stock {
            background-color: rgba(255, 193, 7, 0.1);
            color: #856404;
        }

        .book-info .stock-info.out-stock {
            background-color: rgba(220, 53, 69, 0.1);
            color: var(--danger);
        }

        .book-actions {
            padding: 0 18px 18px;
        }

        .borrow-btn {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, var(--accent-color) 0%, var(--accent-dark) 100%);
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .borrow-btn:hover:not(.disabled) {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(238, 108, 77, 0.4);
        }

        .borrow-btn.disabled {
            background: var(--text-muted);
            cursor: not-allowed;
            opacity: 0.6;
        }

        .search-bar {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            margin-bottom: 20px;
        }

        .search-box {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .search-input {
            flex: 1;
            max-width: 400px;
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1001;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(5px);
        }

        .modal-content {
            background-color: #fefefe;
            margin: 10% auto;
            padding: 0;
            border: none;
            border-radius: 12px;
            width: 90%;
            max-width: 800px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            animation: modalopen 0.4s;
        }

        @keyframes modalopen {
            from {opacity: 0; transform: translateY(-60px);}
            to {opacity: 1; transform: translateY(0);}
        }

        .modal-header {
            padding: 20px;
            background: linear-gradient(135deg, var(--accent-color) 0%, var(--accent-dark) 100%);
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
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .book-detail-info {
            flex: 2;
        }

        .book-detail-info h3 {
            font-size: 24px;
            margin-bottom: 15px;
            color: var(--text-dark);
        }

        .book-detail-info p {
            margin-bottom: 10px;
            color: var(--text-muted);
        }

        .book-description {
            margin-top: 15px;
            padding: 15px;
            background-color: var(--bg-light);
            border-radius: 8px;
            max-height: 200px;
            overflow-y: auto;
        }

        @media (max-width: 768px) {
            .book-detail-content {
                flex-direction: column;
            }
            .book-detail-cover {
                flex: none;
            }
            .book-detail-cover img {
                max-height: 200px;
            }
        }
    </style>
</head>
<body>
<jsp:include page="../../common/user-header.jsp">
    <jsp:param name="title" value="云借阅系统 - 用户中心"/>
</jsp:include>
<jsp:include page="../../common/user-sidebar.jsp">
    <jsp:param name="activePage" value="borrow-apply"/>
</jsp:include>

<div class="main-container">
    <div class="content">
        <h2 class="form-title">借阅图书申请</h2>

        <c:if test="${param.error == 'stock'}">
            <div class="alert alert-danger fade-in">
                <span class="toast-icon">✕</span>
                <span>该图书库存不足，无法借阅！</span>
            </div>
        </c:if>
        <c:if test="${param.error == 'disabled'}">
            <div class="alert alert-danger fade-in">
                <span class="toast-icon">✕</span>
                <span>该图书已被禁用或下架，暂无法借阅！</span>
            </div>
        </c:if>
        <c:if test="${param.error == 'system'}">
            <div class="alert alert-danger fade-in">
                <span class="toast-icon">✕</span>
                <span>系统处理异常，借阅失败，请稍后重试！</span>
            </div>
        </c:if>

        <div class="search-bar">
            <form action="${pageContext.request.contextPath}/user/borrow/apply" method="get" class="search-box">
                <input type="text" name="keyword" class="form-control search-input" aria-label="搜索图书" placeholder="请输入图书名称或作者" value="${fn:escapeXml(keyword)}">
                <button type="submit" class="btn btn-primary">搜索</button>
                <c:if test="${not empty keyword}">
                    <a href="${pageContext.request.contextPath}/user/borrow/apply" class="btn btn-outline">清空</a>
                </c:if>
            </form>
        </div>

        <div class="book-grid">
            <c:forEach items="${books}" var="book">
                <div class="book-card ${book.stock <= 0 ? 'out-of-stock' : ''}">
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
                        <p>ISBN：<c:out value="${book.isbn}"/></p>
                        <c:choose>
                            <c:when test="${book.stock == 0}">
                                <span class="stock-info out-stock">库存不足</span>
                            </c:when>
                            <c:when test="${book.stock <= 5}">
                                <span class="stock-info low-stock">仅剩 ${book.stock} 本</span>
                            </c:when>
                            <c:otherwise>
                                <span class="stock-info in-stock">库存：${book.stock} 本</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="book-actions">
                        <c:choose>
                            <c:when test="${book.stock > 0}">
                                <button type="button" class="borrow-btn" data-book-id="${book.id}" data-book-name="${fn:escapeXml(book.name)}" data-book-stock="${book.stock}" onclick="showBorrowForm(this)">立即借阅</button>
                            </c:when>
                            <c:otherwise>
                                <button type="button" class="borrow-btn disabled" disabled>库存不足</button>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:forEach>
            <c:if test="${empty books}">
                <div style="grid-column: 1 / -1;">
                    <div class="empty-state">
                        <div class="empty-state-icon">📚</div>
                        <div class="empty-state-text">暂无图书</div>
                        <div class="empty-state-subtext">请稍后再试或联系管理员添加图书</div>
                    </div>
                </div>
            </c:if>
        </div>

        <jsp:include page="../../common/pagination.jsp">
            <jsp:param name="pageUrl" value="${pageContext.request.contextPath}/user/borrow/apply"/>
        </jsp:include>
        
        <div style="margin-top: 24px; text-align: center;">
            <a href="${pageContext.request.contextPath}/user/borrow/list" class="btn btn-outline">查看我的借阅</a>
        </div>
    </div>
</div>

<!-- 图书详情模态框 -->
<div id="bookDetailModal" class="modal" role="dialog" aria-modal="true" aria-labelledby="bookDetailTitle">
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
            <div style="text-align: center;">
                <button type="button" class="btn btn-outline" onclick="closeBookDetail()">关闭</button>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/static/js/common.js"></script>
<script>
    function showBorrowForm(btn) {
        var bookId = btn.getAttribute('data-book-id');
        var bookName = btn.getAttribute('data-book-name');
        var bookStock = btn.getAttribute('data-book-stock');
        // 转义HTML特殊字符，防止XSS
        function escapeHtml(str) {
            var div = document.createElement('div');
            div.appendChild(document.createTextNode(str));
            return div.innerHTML;
        }
        var safeName = escapeHtml(bookName);
        const modal = new Modal({
            title: '借阅图书',
            content: `
                <form id="borrowForm" action="${pageContext.request.contextPath}/user/borrow/apply" method="post">
                    <input type="hidden" name="_csrf" value="${_csrf_token}">
                    <input type="hidden" name="bookId" value="` + escapeHtml(bookId) + `">
                    <div class="form-group">
                        <label>图书名称</label>
                        <input type="text" class="form-control" value="` + safeName + `" readonly>
                    </div>
                    <div class="form-group">
                        <label>当前库存</label>
                        <input type="text" class="form-control" value="` + escapeHtml(bookStock) + ` 本" readonly>
                    </div>
                    <div class="form-group">
                        <label for="dueTime">应归还时间 <span style="color: var(--danger);">*</span></label>
                        <input type="date" id="dueTime" name="dueTime" class="form-control" required min="${currentDate}">
                        <div class="invalid-feedback"></div>
                    </div>
                    <div class="alert alert-info">
                        <span class="toast-icon">ℹ</span>
                        <span>借阅期限一般为30天，请合理安排阅读时间</span>
                    </div>
                </form>
            `,
            footer: `
                <button type="button" class="btn btn-outline modal-cancel">取消</button>
                <button type="button" class="btn btn-accent modal-confirm">确认借阅</button>
            `,
            onConfirm: () => {
                const dueTime = document.getElementById('dueTime').value;
                if (!dueTime) {
                    toast.error('请选择应归还时间');
                    return false;
                }
                document.getElementById('borrowForm').submit();
            }
        });
        modal.show();
    }

    function showBookDetail(bookId) {
        document.getElementById('detailName').textContent = '加载中...';
        document.getElementById('detailAuthor').textContent = '';
        document.getElementById('detailIsbn').textContent = '';
        document.getElementById('detailType').textContent = '';
        document.getElementById('detailStock').textContent = '';
        document.getElementById('detailDescription').innerHTML = '';
        document.getElementById('bookDetailModal').style.display = 'block';

        fetch('${pageContext.request.contextPath}/user/borrow/book/detail/' + bookId)
            .then(response => {
                if (!response.ok) {
                    throw new Error('网络响应失败: ' + response.status);
                }
                return response.json();
            })
            .then(book => {
                if (!book || (book.hasOwnProperty('id') && book.id === null)) {
                    document.getElementById('detailName').textContent = '未找到该图书';
                    return;
                }

                document.getElementById('detailName').textContent = book.name || '暂无';
                document.getElementById('detailAuthor').textContent = book.author || '暂无';
                document.getElementById('detailIsbn').textContent = book.isbn || '暂无';
                document.getElementById('detailType').textContent = book.type || '暂无';
                document.getElementById('detailStock').textContent = book.stock !== undefined ? book.stock : '暂无';

                const descriptionElement = document.getElementById('detailDescription');
                if (book.description && book.description.trim() !== '') {
                    descriptionElement.textContent = book.description;
                } else {
                    descriptionElement.innerHTML = '<i>暂无图书介绍</i>';
                }

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

    function closeBookDetail() {
        document.getElementById('bookDetailModal').style.display = 'none';
    }

    window.addEventListener('click', function(event) {
        var detailModal = document.getElementById('bookDetailModal');
        if (event.target == detailModal) {
            detailModal.style.display = 'none';
        }
    });
</script>
<script src="${pageContext.request.contextPath}/static/js/layout.js"></script>
</body>
</html>