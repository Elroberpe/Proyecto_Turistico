<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sierra | Perú Chasqui</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="assets/css/style.css?v=2.0">
</head>
<body data-region="sierra">
    <jsp:include page="componentes/navbar.jsp"></jsp:include>

    <!-- HEADER DE REGION -->
    <header class="region-header" style="background-image: url('assets/img/sierra/cusco_noche.jpeg');">
        <div class="text-center">
            <span class="badge bg-primary text-white px-3 py-2 rounded-pill mb-3 shadow" style="font-family: 'Inter', sans-serif;">Tocando el cielo andino</span>
            <h1>Sierra Peruana</h1>
        </div>
    </header>

    <!-- CATALOGO -->
    <section class="packages-section" style="border-radius: 30px 30px 0 0; margin-top: -30px; position: relative; z-index: 10;">
        <div class="container">
            <div class="section-title">
                <span class="text-uppercase fw-bold" style="color: var(--primary); letter-spacing: 2px; font-size: 0.85rem;">Aventura de Altura</span>
                <h2>Paquetes en la Sierra</h2>
                <p>Maravíllate con el imponente imperio Inca, paisajes montañosos que roban el aliento y tradiciones milenarias vivas.</p>
            </div>
            <div class="row g-4" id="destinosContainer">
                <!-- Se renderiza desde JS (region.js) -->
            </div>
        </div>
    </section>

    <jsp:include page="componentes/modal_reserva.jsp"></jsp:include>
    <jsp:include page="componentes/footer.jsp"></jsp:include>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="assets/js/region.js"></script>
</body>
</html>
