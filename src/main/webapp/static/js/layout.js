function toggleMobileMenu() {
    var sidebar = document.querySelector('.sidebar');
    if (sidebar) sidebar.classList.toggle('mobile-open');
}

document.addEventListener('click', function(e) {
    var sidebar = document.querySelector('.sidebar');
    var menuToggle = document.querySelector('.mobile-menu-toggle');
    if (sidebar && menuToggle && !sidebar.contains(e.target) && !menuToggle.contains(e.target)) {
        sidebar.classList.remove('mobile-open');
    }
});
