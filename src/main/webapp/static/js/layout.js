document.addEventListener('click', function(e) {
    var toggleBtn = e.target.closest('[data-action="toggle-mobile-menu"]');
    if (toggleBtn) {
        var sidebar = document.querySelector('.sidebar');
        if (sidebar) sidebar.classList.toggle('mobile-open');
        return;
    }

    var sidebar = document.querySelector('.sidebar');
    var menuToggle = document.querySelector('.mobile-menu-toggle');
    if (sidebar && menuToggle && !sidebar.contains(e.target) && !menuToggle.contains(e.target)) {
        sidebar.classList.remove('mobile-open');
    }
});

document.addEventListener('change', function(e) {
    if (e.target.matches('[data-action="auto-submit"]')) {
        e.target.form.submit();
    }
});
