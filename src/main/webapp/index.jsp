<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes">
    <title>Perú Chasqui | Tu aventura comienza aquí</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <!-- ==================== NAVBAR ==================== -->
    <nav class="navbar navbar-expand-lg fixed-top">
        <div class="container">
            <a class="navbar-brand fw-bold" href="index.html">
                <span class="text-primary">Chasqui</span> PERÚ
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link active" href="index.html">Inicio</a></li>
                    <li class="nav-item"><a class="nav-link" href="costa.html">Costa</a></li>
                    <li class="nav-item"><a class="nav-link" href="sierra.html">Sierra</a></li>
                    <li class="nav-item"><a class="nav-link" href="selva.html">Selva</a></li>
                    <li class="nav-item"><a class="nav-link" href="contacto.html">Contacto</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- ==================== CARRUSEL ==================== -->
    <div id="mainCarousel" class="carousel slide" data-bs-ride="carousel">
        <div class="carousel-indicators">
            <button type="button" data-bs-target="#mainCarousel" data-bs-slide-to="0" class="active"></button>
            <button type="button" data-bs-target="#mainCarousel" data-bs-slide-to="1"></button>
            <button type="button" data-bs-target="#mainCarousel" data-bs-slide-to="2"></button>
        </div>
        <div class="carousel-inner">
            <div class="carousel-item active">
                <img src="img/pimentel.webp" class="d-block w-100" alt="Costa Peruana">
                <div class="carousel-caption">
                    <h1>Descubre la <span class="accent-text">Costa</span></h1>
                    <p>Playas paradisíacas, surf y la mejor gastronomía del Pacífico</p>
                    <a href="costa.html" class="btn btn-primary">Explorar Costa →</a>
                </div>
            </div>
            <div class="carousel-item">
                <img src="img/cusco_noche.jpeg" class="d-block w-100" alt="Sierra Peruana">
                <div class="carousel-caption">
                    <h1>Aventura en la <span class="accent-text">Sierra</span></h1>
                    <p>Montañas, el mítico Machu Picchu y cultura viva</p>
                    <a href="sierra.html" class="btn btn-primary">Explorar Sierra →</a>
                </div>
            </div>
            <div class="carousel-item">
                <img src="img/iquitos_carrusel.jpg" class="d-block w-100" alt="Selva Peruana">
                <div class="carousel-caption">
                    <h1>Magia en la <span class="accent-text">Selva</span></h1>
                    <p>Amazonía, ríos serpenteantes y biodiversidad única</p>
                    <a href="selva.html" class="btn btn-primary">Explorar Selva →</a>
                </div>
            </div>
        </div>
        <button class="carousel-control-prev" type="button" data-bs-target="#mainCarousel" data-bs-slide="prev">
            <span class="carousel-control-prev-icon"></span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#mainCarousel" data-bs-slide="next">
            <span class="carousel-control-next-icon"></span>
        </button>
    </div>

    <!-- ==================== BUSCADOR ==================== -->
    <section class="search-section">
        <div class="container">
            <div class="search-card">
                <h3 class="text-center mb-4"><i class="bi bi-calendar-heart me-2"></i> Planifica tu viaje desde Lima</h3>
                <form id="bookingForm" class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label"><i class="bi bi-arrow-left-right me-1"></i> Tipo de viaje</label>
                        <select id="tipoViaje" class="form-select" required>
                            <option value="roundtrip">Ida y Vuelta</option>
                            <option value="oneway">Solo Ida</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label"><i class="bi bi-geo-alt me-1"></i> Destino</label>
                        <select id="destinoSelect" class="form-select" required>
                            <option value="">Selecciona un destino</option>
                        </select>
                        <div id="destinoPreview" class="preview-box"></div>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label"><i class="bi bi-calendar-check me-1"></i> Salida</label>
                        <input type="date" id="fechaSalida" class="form-control" required>
                    </div>
                    <div class="col-md-2" id="retornoGroup">
                        <label class="form-label"><i class="bi bi-calendar-x me-1"></i> Retorno</label>
                        <input type="date" id="fechaRetorno" class="form-control">
                    </div>
                    <div class="col-md-2">
                        <label class="form-label"><i class="bi bi-people me-1"></i> Pasajeros</label>
                        <select id="pasajerosSelect" class="form-select">
                            <option value="1">1 pasajero</option>
                            <option value="2">2 pasajeros</option>
                            <option value="3">3 pasajeros</option>
                            <option value="4">4 pasajeros</option>
                            <option value="5">5 pasajeros</option>
                            <option value="6">6 pasajeros</option>
                        </select>
                    </div>
                    <div class="col-12 mt-3 d-flex justify-content-between align-items-center flex-wrap">
                        <div class="price-display">
                            <span class="fw-bold">Precio estimado: </span>
                            <span id="precioSoles" class="price-soles">S/ 0.00</span>
                            <span id="precioUSD" class="price-usd">($0.00 USD)</span>
                        </div>
                        <button type="submit" class="btn btn-primary btn-lg px-5">
                            <i class="bi bi-search"></i> Reservar Ahora
                        </button>
                    </div>
                    <div id="validationMsg" class="text-danger small mt-2"></div>
                </form>
            </div>
        </div>
    </section>

    <!-- ==================== BENEFICIOS ==================== -->
    <section class="benefits-section">
        <div class="container">
            <div class="row text-center g-4">
                <div class="col-md-4">
                    <div class="benefit-card">
                        <i class="bi bi-person-bounding-box"></i>
                        <h4>Las mejores ofertas</h4>
                        <p>Descuentos exclusivos y paquetes diseñados para ti</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="benefit-card">
                        <i class="bi bi-credit-card-2-front"></i>
                        <h4>Compra fácil y segura</h4>
                        <p>Pagos protegidos con múltiples métodos</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="benefit-card">
                        <i class="bi bi-people"></i>
                        <h4>Expertos en viajes</h4>
                        <p>Más de 10 años conectando viajeros con el Perú</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ==================== PAQUETES DESTACADOS ==================== -->
    <section class="packages-section">
        <div class="container">
            <div class="section-header">
                <h2>Paquetes Destacados</h2>
                <p>Los destinos más solicitados por nuestros viajeros</p>
            </div>
            <div class="row g-4" id="paquetesContainer"></div>
        </div>
    </section>

    <!-- ==================== ASESORES ==================== -->
    <section class="team-section">
        <div class="container">
            <div class="section-header">
                <h2>Asesores de Viaje</h2>
                <p>Expertos apasionados por el Perú, listos para asesorarte</p>
            </div>
            <div class="row g-4" id="teamContainer"></div>
        </div>
    </section>

    <!-- ==================== FOOTER ==================== -->
    <footer class="footer">
        <div class="container">
            <div class="row">
                <div class="col-md-4">
                    <h5><span class="text-primary">Chasqui</span> PERÚ</h5>
                    <p>Tu aventura comienza aquí. Más de 10 años conectando viajeros con el Perú profundo.</p>
                </div>
                <div class="col-md-4">
                    <h5>Enlaces rápidos</h5>
                    <ul>
                        <li><a href="index.html">Inicio</a></li>
                        <li><a href="costa.html">Costa</a></li>
                        <li><a href="sierra.html">Sierra</a></li>
                        <li><a href="selva.html">Selva</a></li>
                        <li><a href="contacto.html">Contacto</a></li>
                    </ul>
                </div>
                <div class="col-md-4">
                    <h5>Síguenos</h5>
                    <div class="social-links">
                        <a href="#"><i class="bi bi-facebook"></i></a>
                        <a href="#"><i class="bi bi-instagram"></i></a>
                        <a href="#"><i class="bi bi-twitter"></i></a>
                        <a href="#"><i class="bi bi-whatsapp"></i></a>
                    </div>
                </div>
            </div>
            <hr>
            <div class="text-center">
                <p>&copy; 2026 Chasqui PERÚ - Todos los derechos reservados</p>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/data.js"></script>
    <script src="js/main.js"></script>
</body>
</html>