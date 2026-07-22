<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chasqui PERÚ | Destinos de Selva</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body data-region="selva">

    <jsp:include page="componentes/navbar.jsp"></jsp:include>

    <div class="page-header">
        <div class="container">
            <h1 class="display-4 fw-bold">🌴 Selva Peruana</h1>
            <p class="lead">Aventura amazónica, ríos y biodiversidad única</p>
        </div>
    </div>

    <section class="packages-section">
        <div class="container">
            <div class="section-header">
                <h2>🦜 Nuestros Destinos de Selva</h2>
                <p>Descubre la magia de la Amazonía peruana</p>
            </div>
            <div class="row g-4" id="destinosContainer"></div>
        </div>
    </section>

    <jsp:include page="componentes/modal_reserva.jsp"></jsp:include>

    <jsp:include page="componentes/footer.jsp"></jsp:include>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    <script src="assets/js/data.js"></script>
    <script src="assets/js/region.js"></script>
</body>
</html>
