/* Login form validation */

document.addEventListener('DOMContentLoaded', function() {
    var loginForm = document.getElementById('loginForm');
    if (loginForm && typeof FormValidator !== 'undefined') {
        new FormValidator(loginForm, {
            rules: {
                username: [
                    { required: true, message: '请输入用户名' },
                    { minLength: 3, message: '用户名至少需要3个字符' }
                ],
                password: [
                    { required: true, message: '请输入密码' },
                    { minLength: 6, message: '密码至少需要6个字符' }
                ]
            }
        });
    }

    document.addEventListener('click', function(e) {
        var toastEl = e.target.closest('[data-action="show-toast"]');
        if (toastEl) {
            e.preventDefault();
            var message = toastEl.getAttribute('data-toast-message');
            if (message && typeof toast !== 'undefined') {
                toast.info(message);
            }
        }
    });
});
