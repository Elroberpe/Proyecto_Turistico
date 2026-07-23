<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Selva | Perú Chasqui</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="assets/css/style.css?v=2.0">
</head>
<body data-region="selva">
    <jsp:include page="componentes/navbar.jsp"></jsp:include>

    <!-- HEADER DE REGION -->
    <header class="region-header bg-selva">
        <div class="text-center">
            <span class="badge bg-primary text-white px-3 py-2 rounded-pill mb-3 shadow badge-hero">El corazón del Amazonas</span>
            <h1>Selva Peruana</h1>
        </div>
    </header>

    <!-- CATALOGO -->
    <section class="packages-section packages-section-custom">
        <div class="container">
            <div class="section-title">
                <span class="text-uppercase fw-bold text-subtitle">Naturaleza Pura</span>
                <h2>Paquetes en la Selva</h2>
                <p>Navega el río más caudaloso del mundo, descubre especies exóticas y alójate en lodges de ensueño inmersos en la naturaleza.</p>
            </div>
            <div class="row g-4" id="destinosContainer">
                <!-- Se renderiza desde JS (region.js) -->
            </div>
        </div>
    </section>

    <jsp:include page="componentes/modal_reserva.jsp"></jsp:include>
    <jsp:include page="componentes/footer.jsp"></jsp:include>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="assets/js/booking-modal.js?v=2.1"></script>
    <script src="assets/js/region.js?v=2.1"></script>
</body>
</html>
