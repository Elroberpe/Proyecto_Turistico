document.addEventListener('DOMContentLoaded', function () {
    const sidebarToggle = document.getElementById('sidebarCollapse');
    const sidebar = document.getElementById('sidebar');

    if (sidebarToggle && sidebar) {
        sidebarToggle.addEventListener('click', function () {
            sidebar.classList.toggle('active');
        });
    }
});
