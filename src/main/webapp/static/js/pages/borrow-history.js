/**
 * Borrow history — return modal for user/borrow/list.
 * Uses data-* attributes and event delegation (no inline onclick).
 */
(function() {
    'use strict';

    window.BorrowHistory = {
        init: function(contextPath, csrfToken) {
            var container = document.querySelector('.borrow-history-container');
            if (!container) return;

            container.addEventListener('click', function(e) {
                var btn = e.target.closest('[data-action="return-book"]');
                if (!btn) return;
                e.preventDefault();

                var borrowId = btn.getAttribute('data-borrow-id');
                var bookName = btn.getAttribute('data-book-name');
                var overdueDays = parseInt(btn.getAttribute('data-overdue')) || 0;

                var message = '确认申请归还《' + bookName + '》吗？';
                if (overdueDays > 0) {
                    message += '\n\n注意：该图书已逾期 ' + overdueDays + ' 天，请尽快归还！';
                }

                if (typeof Modal !== 'undefined') {
                    Modal.confirm(message, { title: '申请归还' }).then(function(confirmed) {
                        if (confirmed) {
                            submitReturnForm(borrowId, contextPath, csrfToken);
                        }
                    });
                } else if (confirm(message)) {
                    submitReturnForm(borrowId, contextPath, csrfToken);
                }
            });
        }
    };

    function submitReturnForm(borrowId, contextPath, csrfToken) {
        var form = document.createElement('form');
        form.method = 'POST';
        form.action = contextPath + '/user/borrow/return/' + borrowId;
        var csrfInput = document.createElement('input');
        csrfInput.type = 'hidden';
        csrfInput.name = '_csrf';
        csrfInput.value = csrfToken;
        form.appendChild(csrfInput);
        document.body.appendChild(form);
        form.submit();
    }
})();
