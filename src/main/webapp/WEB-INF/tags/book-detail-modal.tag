<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div id="bookDetailModal" class="modal book-detail-modal" role="dialog" aria-modal="true" aria-labelledby="bookDetailTitle">
    <div class="modal-content">
        <div class="modal-header">
            <h3 id="bookDetailTitle">图书详情</h3>
            <span class="close" data-action="close-book-detail">&times;</span>
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
                <button type="button" class="btn btn-secondary" data-action="close-book-detail">关闭</button>
            </div>
        </div>
    </div>
</div>
