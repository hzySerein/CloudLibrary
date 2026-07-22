/* Profile form validation */

document.addEventListener('DOMContentLoaded', function() {
    var profileForm = document.getElementById('profileForm');
    if (profileForm && typeof FormValidator !== 'undefined') {
        new FormValidator(profileForm, {
            rules: {
                username: [{ required: true, message: '请输入用户名' }, { minLength: 3, message: '用户名至少需要3个字符' }],
                name: [{ required: true, message: '请输入姓名' }],
                phone: [{ phone: true, message: '请输入有效的手机号码' }],
                oldPassword: [{ minLength: 6, message: '密码至少需要6个字符' }],
                password: [{ minLength: 6, message: '密码至少需要6个字符' }]
            },
            onSubmit: function(form) {
                var password = form.querySelector('#password').value;
                var confirmPassword = form.querySelector('#confirmPassword').value;
                var oldPassword = form.querySelector('#oldPassword').value;
                if (password || confirmPassword) {
                    if (!oldPassword) { toast.error('修改密码需要输入旧密码'); return false; }
                    if (password !== confirmPassword) { toast.error('新密码与确认密码不一致'); return false; }
                }
                form.submit();
            }
        });
    }
});
