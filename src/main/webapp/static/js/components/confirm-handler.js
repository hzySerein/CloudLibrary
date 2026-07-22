/**
 * Shared confirm handler for forms with data-confirm-message attribute.
 * Include this script on any page that uses data-confirm-message on forms.
 */
(function() {
    'use strict';

    document.addEventListener('submit', function(e) {
        var form = e.target;
        if (form.tagName !== 'FORM') return;

        var message = form.getAttribute('data-confirm-message');
        if (message && !confirm(message)) {
            e.preventDefault();
        }
    });
})();
