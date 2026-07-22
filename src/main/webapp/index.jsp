<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Perú Chasqui | Diseño Ultra Moderno</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>
    <jsp:include page="componentes/navbar.jsp"></jsp:include>

    <!-- HERO SECTION -->
    <section class="hero-section">
        <video class="hero-video-bg" autoplay muted loop playsinline>
            <source src="https://assets.mixkit.co/videos/preview/mixkit-beautiful-landscape-of-machu-picchu-4279-large.mp4" type="video/mp4">
            <!-- fallback image if video doesn't load -->
            <img src="https://picsum.photos/seed/peru/1920/1080" alt="Peru" class="hero-video-bg">
        </video>
        <div class="hero-content">
            <span class="badge bg-primary text-white px-3 py-2 rounded-pill mb-3 shadow" style="font-family: 'Inter', sans-serif;">Descubre lo inexplorado</span>
            <h1>Aventuras que cambian la <span style="color: var(--primary);">vida</span></h1>
            <p>Conecta con la magia del Perú. Explora destinos únicos con el confort y seguridad que te mereces.</p>
            <div class="d-flex justify-content-center gap-3">
                <a href="#destinos" class="btn btn-primary-custom px-4 py-3 fs-5">Ver Destinos <i class="bi bi-arrow-down ms-2"></i></a>
            </div>
        </div>
    </section>

    <!-- BENEFICIOS -->
    <section class="py-5" style="background: var(--white); margin-top: -30px; position: relative; z-index: 10; border-radius: 30px 30px 0 0; box-shadow: 0 -10px 30px rgba(0,0,0,0.05);">
        <div class="container py-5">
            <div class="row g-4 text-center">
                <div class="col-md-4">
                    <div class="p-4 rounded-4" style="transition: all 0.3s; cursor: default;" onmouseover="this.style.transform='translateY(-5px)'" onmouseout="this.style.transform='translateY(0)'">
                        <div class="d-inline-flex align-items-center justify-content-center text-white rounded-circle mb-4" style="width: 80px; height: 80px; background: linear-gradient(135deg, var(--primary), var(--primary-hover));">
                            <i class="bi bi-shield-check fs-1"></i>
                        </div>
                        <h4 class="fw-bold mb-3">Viaje Seguro</h4>
                        <p class="text-muted">Protocolos internacionales de seguridad en todos nuestros tours y desplazamientos.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="p-4 rounded-4" style="transition: all 0.3s; cursor: default;" onmouseover="this.style.transform='translateY(-5px)'" onmouseout="this.style.transform='translateY(0)'">
                        <div class="d-inline-flex align-items-center justify-content-center text-white rounded-circle mb-4" style="width: 80px; height: 80px; background: linear-gradient(135deg, var(--primary), var(--primary-hover));">
                            <i class="bi bi-compass fs-1"></i>
                        </div>
                        <h4 class="fw-bold mb-3">Guías Expertos</h4>
                        <p class="text-muted">Acompañamiento por profesionales locales expertos conocedores de cada región.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="p-4 rounded-4" style="transition: all 0.3s; cursor: default;" onmouseover="this.style.transform='translateY(-5px)'" onmouseout="this.style.transform='translateY(0)'">
                        <div class="d-inline-flex align-items-center justify-content-center text-white rounded-circle mb-4" style="width: 80px; height: 80px; background: linear-gradient(135deg, var(--primary), var(--primary-hover));">
                            <i class="bi bi-star fs-1"></i>
                        </div>
                        <h4 class="fw-bold mb-3">Experiencia Premium</h4>
                        <p class="text-muted">Alojamientos de primera categoría y atención ultra-personalizada 24/7.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- PAQUETES DESTACADOS -->
    <section id="destinos" class="packages-section">
        <div class="container">
            <div class="section-title">
                <span class="text-uppercase fw-bold" style="color: var(--primary); letter-spacing: 2px; font-size: 0.85rem;">Lo más pedido</span>
                <h2>Destinos Exclusivos</h2>
                <p>Nuestra selección curada de las mejores experiencias a lo largo del Perú. Encuentra el viaje perfecto que estabas esperando.</p>
            </div>
            <!-- Contenedor dinámico (JS rellena esto si está implementado para el index o mostramos estáticos si no) -->
            <div class="row g-4 justify-content-center">
                <!-- Fallback Content (En caso que region.js no opere en index) -->
                <div class="col-lg-4 col-md-6">
                    <div class="card-tour">
                        <div class="img-wrap">
                            <img src="https://picsum.photos/seed/cusco/800/600" alt="Cusco">
                            <span class="badge-region">Sierra</span>
                        </div>
                        <div class="body">
                            <h3>Aventura Andina</h3>
                            <div class="meta"><i class="bi bi-geo-alt me-1"></i> Cusco, Perú</div>
                            <div class="precio-container">
                                <div class="precio">S/ 1,250.00 <br><small> / persona</small></div>
                                <a href="sierra.jsp" class="btn btn-outline-dark rounded-pill btn-sm fw-bold px-3 py-2">Ver más</a>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="col-lg-4 col-md-6">
                    <div class="card-tour">
                        <div class="img-wrap">
                            <img src="https://picsum.photos/seed/iquitos/800/600" alt="Iquitos">
                            <span class="badge-region">Selva</span>
                        </div>
                        <div class="body">
                            <h3>Ruta Amazónica</h3>
                            <div class="meta"><i class="bi bi-geo-alt me-1"></i> Iquitos, Perú</div>
                            <div class="precio-container">
                                <div class="precio">S/ 980.00 <br><small> / persona</small></div>
                                <a href="selva.jsp" class="btn btn-outline-dark rounded-pill btn-sm fw-bold px-3 py-2">Ver más</a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4 col-md-6">
                    <div class="card-tour">
                        <div class="img-wrap">
                            <img src="https://picsum.photos/seed/paracas/800/600" alt="Paracas">
                            <span class="badge-region">Costa</span>
                        </div>
                        <div class="body">
                            <h3>Sol y Olas</h3>
                            <div class="meta"><i class="bi bi-geo-alt me-1"></i> Ica, Perú</div>
                            <div class="precio-container">
                                <div class="precio">S/ 650.00 <br><small> / persona</small></div>
                                <a href="costa.jsp" class="btn btn-outline-dark rounded-pill btn-sm fw-bold px-3 py-2">Ver más</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="text-center mt-5">
                <a href="sierra.jsp" class="btn btn-primary-custom px-5 py-3">Explorar todo el catálogo</a>
            </div>
        </div>
    </section>

    <!-- CALL TO ACTION -->
    <section class="py-5" style="background: linear-gradient(135deg, var(--dark), #1f2937); color: white;">
        <div class="container py-5 text-center">
            <h2 class="display-5 fw-bold text-white mb-4" style="font-family: 'Outfit', sans-serif;">¿Listo para la aventura de tu vida?</h2>
            <p class="lead mb-5 opacity-75" style="font-weight: 300; max-width: 600px; margin: 0 auto;">Nuestros asesores están disponibles para diseñar y perfeccionar el itinerario ideal para ti y tu familia.</p>
            <a href="contacto.html" class="btn btn-primary-custom btn-lg rounded-pill px-5 py-3 fw-bold shadow-lg">Contactar Asesor <i class="bi bi-chat-right-text ms-2"></i></a>
        </div>
    </section>

    <jsp:include page="componentes/modal_reserva.jsp"></jsp:include>
    <jsp:include page="componentes/footer.jsp"></jsp:include>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    <script src="assets/js/data.js"></script>
    <script src="assets/js/region.js"></script>
</body>
</html>
