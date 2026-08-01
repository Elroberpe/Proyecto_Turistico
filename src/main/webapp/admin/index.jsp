<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel Admin Turìstico - Dashboard</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="d-flex">
        <!-- Sidebar -->
        <nav id="sidebar">
            <div class="sidebar-header">
                <h3 class="text-white m-0"><i class="bi bi-airplane-engines"></i> AdminTours</h3>
            </div>
            <ul class="list-unstyled components">
                <li class="active"><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-house-door me-2"></i> Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/categorias"><i class="bi bi-tags me-2"></i> Categorìas</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/paquetes"><i class="bi bi-box-seam me-2"></i> Paquetes</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/clientes"><i class="bi bi-person-badge me-2"></i> Clientes</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/usuarios"><i class="bi bi-people me-2"></i> Usuarios</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/reservas"><i class="bi bi-calendar-check me-2"></i> Reservas</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/pagos"><i class="bi bi-credit-card me-2"></i> Pagos</a></li>
            </ul>
        </nav>

        <!-- Page Content -->
        <div id="content">
            <nav class="navbar navbar-expand-lg navbar-light bg-white rounded shadow-sm mb-4 p-3">
                <div class="container-fluid">
                    <button type="button" id="sidebarCollapse" class="btn btn-primary-custom">
                        <i class="bi bi-list"></i>
                    </button>
                    <div class="ms-auto d-flex align-items-center">
                        <span class="me-3 fw-bold text-main">Bienvenido, Admin</span>
                        <img src="https://ui-avatars.com/api/?name=Admin&background=0d9488&color=fff" alt="Avatar" class="rounded-circle" width="40">
                    </div>
                </div>
            </nav>

            <h2 class="mb-4">Resumen General</h2>
            
            <div class="row">
                <div class="col-md-3 mb-4">
                    <div class="card text-center p-4 border-0 shadow-sm">
                        <h1 class="text-primary-custom"><i class="bi bi-box-seam"></i></h1>
                        <h3 class="mt-2">120</h3>
                        <p class="text-muted">Paquetes Activos</p>
                    </div>
                </div>
                <div class="col-md-3 mb-4">
                    <div class="card text-center p-4 border-0 shadow-sm">
                        <h1 class="text-secondary-custom"><i class="bi bi-person-badge"></i></h1>
                        <h3 class="mt-2">450</h3>
                        <p class="text-muted">Clientes Registrados</p>
                    </div>
                </div>
                <div class="col-md-3 mb-4">
                    <div class="card text-center p-4 border-0 shadow-sm">
                        <h1 class="text-primary-custom"><i class="bi bi-calendar-check"></i></h1>
                        <h3 class="mt-2">85</h3>
                        <p class="text-muted">Reservas del Mes</p>
                    </div>
                </div>
                <div class="col-md-3 mb-4">
                    <div class="card text-center p-4 border-0 shadow-sm">
                        <h1 class="text-success"><i class="bi bi-cash-coin"></i></h1>
                        <h3 class="mt-2">$15,400</h3>
                        <p class="text-muted">Ingresos</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS and Popper -->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"></script>
    <!-- Custom JS -->
    <script src="js/script.js"></script>
</body>
</html>
