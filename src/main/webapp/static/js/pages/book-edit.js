/**
 * Book cover upload logic for the book edit page.
 */
(function() {
    'use strict';

    document.addEventListener('click', function(e) {
        var btn = e.target.closest('[data-action="upload-cover"]');
        if (!btn) return;

        var csrfToken = btn.getAttribute('data-csrf');
        var uploadUrl = btn.getAttribute('data-upload-url');
        var fileInput = document.querySelector('input[name="coverFile"]');
        var file = fileInput.files[0];

        if (!file) {
            alert('请选择要上传的文件');
            return;
        }

        var formData = new FormData();
        formData.append('coverFile', file);
        formData.append('_csrf', csrfToken);

        var originalText = btn.textContent;
        btn.textContent = '上传中...';
        btn.disabled = true;

        fetch(uploadUrl, {
            method: 'POST',
            body: formData
        })
        .then(function(response) {
            return response.text().then(function(text) {
                if (response.ok) {
                    alert('封面上传成功');
                    location.reload();
                } else {
                    throw new Error(text || '封面上传失败');
                }
            });
        })
        .catch(function(error) {
            console.error('Error:', error);
            alert('封面上传出错: ' + error.message);
        })
        .finally(function() {
            btn.textContent = originalText;
            btn.disabled = false;
        });
    });
})();
