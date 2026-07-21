<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chasqui PERÚ | Destinos de Costa</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body data-region="costa">

    <jsp:include page="componentes/navbar.jsp"></jsp:include>
    
    <div class="page-header">
        <div class="container">
            <h1 class="display-4 fw-bold">🌊 Costa Peruana</h1>
            <p class="lead">Playas paradisíacas, surf y la mejor gastronomía del Pacífico</p>
        </div>
    </div>

    <section class="search-section">
        <div class="container">
            <div class="search-card">
                <h3 class="text-center mb-4"><i class="bi bi-calendar-heart"></i> Planifica tu viaje desde Lima</h3>
                <form id="bookingForm" class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label">Tipo de viaje</label>
                        <select id="tipoViaje" class="form-select">
                            <option value="roundtrip">Ida y Vuelta</option>
                            <option value="oneway">Solo Ida</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Destino</label>
                        <select id="destinoSelect" class="form-select">
                            <option value="">Selecciona un destino</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Salida</label>
                        <input type="date" id="fechaSalida" class="form-control">
                    </div>
                    <div class="col-md-2" id="retornoGroup">
                        <label class="form-label">Retorno</label>
                        <input type="date" id="fechaRetorno" class="form-control">
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Pasajeros</label>
                        <select id="pasajerosSelect" class="form-select">
                            <option value="1">1 pasajero</option>
                            <option value="2">2</option>
                            <option value="3">3</option>
                            <option value="4">4</option>
                            <option value="5">5</option>
                        </select>
                    </div>
                    <div class="col-12 mt-3 d-flex justify-content-between">
                        <div><span class="fw-bold">Precio: </span><span id="precioSoles" class="price-soles">S/ 0.00</span></div>
                        <button type="submit" class="btn btn-primary">Reservar Ahora</button>
                    </div>
                </form>
            </div>
        </div>
    </section>

    <section class="packages-section">
        <div class="container">
            <div class="section-header">
                <h2>🏖️ Nuestros Destinos de Costa</h2>
                <p>Descubre los mejores lugares para disfrutar del sol y la playa</p>
            </div>
            <div class="row g-4" id="destinosContainer"></div>
        </div>
    </section>

   <jsp:include page="componentes/footer.jsp"></jsp:include>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/data.js"></script>
    <script src="js/region.js"></script>
</body>
</html>