/**
 * User list — confirm dialog for delete action.
 * Uses data-confirm-message on forms, event delegation (no inline onsubmit).
 */
(function() {
    'use strict';

    document.addEventListener('DOMContentLoaded', function() {
        var container = document.querySelector('.table-container');
        if (!container) return;

        container.addEventListener('submit', function(e) {
            var form = e.target;
            if (form.tagName !== 'FORM') return;

            var message = form.getAttribute('data-confirm-message');
            if (message && !confirm(message)) {
                e.preventDefault();
            }
        });
    });
})();
