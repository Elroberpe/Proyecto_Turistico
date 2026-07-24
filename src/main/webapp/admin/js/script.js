document.addEventListener('DOMContentLoaded', function () {
    const sidebarToggle = document.getElementById('sidebarCollapse');
    const sidebar = document.getElementById('sidebar');

    if (sidebarToggle) {
        sidebarToggle.addEventListener('click', function () {
            sidebar.classList.toggle('active');
            if(sidebar.style.marginLeft === '-250px') {
                sidebar.style.marginLeft = '0';
            } else {
                sidebar.style.marginLeft = '-250px';
            }
        });
    }

    // Modal forms prevention of default submission for visual demo
    /*const forms = document.querySelectorAll('form');
    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            alert('Acción simulada. Conectar con el Servlet de Java para guardar los datos.');
            const modals = document.querySelectorAll('.modal.show');
            modals.forEach(modal => {
                const modalInstance = bootstrap.Modal.getInstance(modal);
                if(modalInstance) modalInstance.hide();
            });
        });
    });*/
});
