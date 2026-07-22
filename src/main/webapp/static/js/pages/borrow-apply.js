/**
 * Borrow apply page — book detail modal and borrow form logic.
 * Uses data-* attributes for server-provided URLs; never injects user text via innerHTML.
 */
(function() {
    'use strict';

    var config = {};
    var borrowModal = null;  // Reuse single Modal instance

    function init(cfg) {
        config.contextPath = cfg.contextPath || '';
        config.detailUrl = cfg.detailUrl || '';
        config.applyUrl = cfg.applyUrl || '';
        config.csrfToken = cfg.csrfToken || '';
        config.currentDate = cfg.currentDate || '';

        // Close book detail modal on overlay click (borrow modal handled by Modal class)
        window.addEventListener('click', function(event) {
            var detailModal = document.getElementById('bookDetailModal');
            if (detailModal && event.target === detailModal) {
                detailModal.classList.remove('show');
            }
        });

        // Close book detail on Escape (borrow modal Escape handled by Modal class)
        window.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                closeBookDetail();
            }
        });

        // Keep modal content in view on scroll
        window.addEventListener('scroll', function() {
            var detailModal = document.getElementById('bookDetailModal');
            if (detailModal && detailModal.classList.contains('show')) {
                detailModal.style.paddingTop = (window.scrollY + window.innerHeight * 0.12) + 'px';
            }
        });

        // Event delegation for data-action handlers
        document.addEventListener('click', function(e) {
            var actionEl = e.target.closest('[data-action]');
            if (!actionEl) return;
            var action = actionEl.getAttribute('data-action');
            if (action === 'show-book-detail') {
                showBookDetail(actionEl.getAttribute('data-book-id'));
            } else if (action === 'show-borrow-form') {
                showBorrowForm(actionEl);
            } else if (action === 'close-book-detail') {
                closeBookDetail();
            }
        });
    }

    function showBorrowForm(btn) {
        var bookId = btn.getAttribute('data-book-id');
        var bookName = btn.getAttribute('data-book-name');
        var bookStock = btn.getAttribute('data-book-stock');

        if (typeof Modal === 'undefined') return;

        // Reuse or create single Modal instance
        if (!borrowModal) {
            borrowModal = new Modal({
                title: '借阅图书',
                content: buildBorrowFormContent(bookId, bookName, bookStock),
                footer: buildBorrowFormFooter(),
                onConfirm: function() {
                    // Scope queries to modal DOM, not global document
                    var modalEl = borrowModal.element;
                    if (!modalEl) return false;
                    var dueTime = modalEl.querySelector('#dueTime');
                    var form = modalEl.querySelector('#borrowForm');
                    if (!dueTime || !dueTime.value) {
                        toast.error('请选择应归还时间');
                        return false;
                    }
                    if (form) form.submit();
                }
            });
        } else {
            // Update existing modal content for the new book
            var newContent = buildBorrowFormContent(bookId, bookName, bookStock);
            borrowModal.setContent(newContent);
        }

        borrowModal.show();
    }

    function buildBorrowFormContent(bookId, bookName, bookStock) {
        var form = document.createElement('form');
        form.id = 'borrowForm';
        form.action = config.applyUrl;
        form.method = 'post';

        // CSRF token — set via property, not innerHTML
        var csrfInput = document.createElement('input');
        csrfInput.type = 'hidden';
        csrfInput.name = '_csrf';
        csrfInput.value = config.csrfToken;
        form.appendChild(csrfInput);

        // Book ID — set via property
        var bookIdInput = document.createElement('input');
        bookIdInput.type = 'hidden';
        bookIdInput.name = 'bookId';
        bookIdInput.value = bookId;
        form.appendChild(bookIdInput);

        // Book name — textContent, never innerHTML
        form.appendChild(buildReadonlyGroup('图书名称', bookName));
        // Stock — textContent
        form.appendChild(buildReadonlyGroup('当前库存', bookStock + ' 本'));

        // Due date group
        var dateGroup = document.createElement('div');
        dateGroup.className = 'form-group';

        var dateLabel = document.createElement('label');
        dateLabel.setAttribute('for', 'dueTime');
        dateLabel.textContent = '应归还时间 *';
        dateGroup.appendChild(dateLabel);

        var dateInput = document.createElement('input');
        dateInput.type = 'date';
        dateInput.id = 'dueTime';
        dateInput.name = 'dueTime';
        dateInput.className = 'form-control';
        dateInput.required = true;
        dateInput.min = config.currentDate;
        dateGroup.appendChild(dateInput);
        form.appendChild(dateGroup);

        // Info alert — built via DOM, no user data in innerHTML
        var alert = document.createElement('div');
        alert.className = 'alert alert-info';
        var infoIcon = document.createElement('span');
        infoIcon.className = 'toast-icon';
        infoIcon.textContent = '\u2139';
        var infoText = document.createElement('span');
        infoText.textContent = '借阅期限一般为30天，请合理安排阅读时间';
        alert.appendChild(infoIcon);
        alert.appendChild(infoText);
        form.appendChild(alert);

        return form;
    }

    function buildBorrowFormFooter() {
        var footer = document.createElement('div');
        var cancelBtn = document.createElement('button');
        cancelBtn.type = 'button';
        cancelBtn.className = 'btn btn-outline modal-cancel';
        cancelBtn.textContent = '取消';
        var confirmBtn = document.createElement('button');
        confirmBtn.type = 'button';
        confirmBtn.className = 'btn btn-accent modal-confirm';
        confirmBtn.textContent = '确认借阅';
        footer.appendChild(cancelBtn);
        footer.appendChild(confirmBtn);
        return footer;
    }

    function buildReadonlyGroup(label, value) {
        var group = document.createElement('div');
        group.className = 'form-group';
        var lbl = document.createElement('label');
        lbl.textContent = label;
        group.appendChild(lbl);
        var input = document.createElement('input');
        input.type = 'text';
        input.className = 'form-control';
        input.value = value;
        input.readOnly = true;
        group.appendChild(input);
        return group;
    }

    function closeBorrowForm() {
        if (borrowModal) {
            borrowModal.hide();
        }
    }

    function showBookDetail(bookId) {
        var detailName = document.getElementById('detailName');
        var detailAuthor = document.getElementById('detailAuthor');
        var detailIsbn = document.getElementById('detailIsbn');
        var detailType = document.getElementById('detailType');
        var detailStock = document.getElementById('detailStock');
        var detailDescription = document.getElementById('detailDescription');
        var detailCover = document.getElementById('detailCover');
        var coverContainer = document.querySelector('.book-detail-cover');
        var detailModal = document.getElementById('bookDetailModal');

        if (!detailModal) return;

        detailName.textContent = '加载中...';
        detailAuthor.textContent = '';
        detailIsbn.textContent = '';
        detailType.textContent = '';
        detailStock.textContent = '';
        detailDescription.textContent = '';
        if (detailCover) detailCover.style.display = 'none';
        var docHeight = Math.max(document.body.scrollHeight, document.documentElement.scrollHeight, window.innerHeight);
        detailModal.style.top = '0';
        detailModal.style.height = docHeight + 'px';
        detailModal.style.paddingTop = (window.scrollY + window.innerHeight * 0.12) + 'px';
        detailModal.classList.add('show');

        fetch(config.detailUrl + bookId)
            .then(function(response) {
                if (!response.ok) throw new Error('网络响应失败: ' + response.status);
                return response.json();
            })
            .then(function(book) {
                if (!book || (book.hasOwnProperty('id') && book.id === null)) {
                    detailName.textContent = '未找到该图书';
                    return;
                }
                detailName.textContent = book.name || '暂无';
                detailAuthor.textContent = book.author || '暂无';
                detailIsbn.textContent = book.isbn || '暂无';
                detailType.textContent = book.type || '暂无';
                detailStock.textContent = book.stock !== undefined ? String(book.stock) : '暂无';

                if (book.description && book.description.trim() !== '') {
                    detailDescription.textContent = book.description;
                } else {
                    detailDescription.textContent = '暂无简介';
                }

                if (coverContainer) {
                    if (book.cover) {
                        coverContainer.innerHTML = '';
                        var img = document.createElement('img');
                        img.id = 'detailCover';
                        img.src = config.contextPath + book.cover;
                        img.alt = '图书封面';
                        img.onerror = function() {
                            this.onerror = null;
                            coverContainer.innerHTML = '<div class="default-cover"><span>📚</span></div>';
                        };
                        coverContainer.appendChild(img);
                    } else {
                        coverContainer.innerHTML = '<div class="default-cover"><span>📚</span></div>';
                    }
                }
            })
            .catch(function(error) {
                detailName.textContent = '加载失败';
                detailDescription.textContent = '错误信息: ' + error.message;
            });
    }

    function closeBookDetail() {
        var detailModal = document.getElementById('bookDetailModal');
        if (detailModal) detailModal.classList.remove('show');
    }

    // Expose API
    window.BorrowApply = {
        init: init,
        showBorrowForm: showBorrowForm,
        closeBorrowForm: closeBorrowForm,
        showBookDetail: showBookDetail,
        closeBookDetail: closeBookDetail
    };
})();
