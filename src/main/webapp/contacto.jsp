<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contacto | Perú Chasqui</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/style.css?v=2.0">
</head>
<body style="background-color: var(--light-gray);">

    <jsp:include page="componentes/navbar.jsp"></jsp:include>

    <!-- HEADER SÓLIDO / GRADIENTE SIN IMAGEN -->
    <section class="py-5 text-center text-white" style="background: linear-gradient(135deg, var(--dark), #1f2937); margin-top: 76px;">
        <div class="container py-5">
            <span class="badge bg-primary text-white px-3 py-2 rounded-pill mb-3 shadow" style="font-family: 'Inter', sans-serif;">Atención Personalizada 24/7</span>
            <h1 class="display-4 fw-bold" style="font-family: 'Outfit', sans-serif;">Ponte en Contacto</h1>
            <p class="lead opacity-75 mx-auto" style="max-width: 600px; font-weight: 300;">
                ¿Tienes dudas sobre un paquete o deseas un viaje a tu medida? Nuestros expertos están listos para ayudarte.
            </p>
        </div>
    </section>

    <!-- SECCIÓN PRINCIPAL -->
    <section class="py-5" style="margin-top: -40px; position: relative; z-index: 10;">
        <div class="container">
            <div class="row g-4 justify-content-center">
                <!-- FORMULARIO -->
                <div class="col-lg-7">
                    <div class="card-tour h-100 border-0" style="background: white; border-radius: 20px;">
                        <div class="body p-5">
                            <h3 class="fw-bold mb-4" style="color: var(--dark); font-family: 'Outfit', sans-serif;">
                                <i class="bi bi-envelope-paper-fill text-primary me-2"></i> Envíanos un mensaje
                            </h3>
                            <form id="contactForm">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold text-muted small text-uppercase">Nombre Completo</label>
                                        <input type="text" id="nombre" class="form-control form-control-lg bg-light border-0" placeholder="Ej. Juan Pérez" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold text-muted small text-uppercase">Correo Electrónico</label>
                                        <input type="email" id="email" class="form-control form-control-lg bg-light border-0" placeholder="juan@correo.com" required>
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label fw-bold text-muted small text-uppercase">Teléfono (Opcional)</label>
                                        <input type="tel" id="telefono" class="form-control form-control-lg bg-light border-0" placeholder="987654321">
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label fw-bold text-muted small text-uppercase">Tu Mensaje</label>
                                        <textarea id="mensaje" class="form-control bg-light border-0" rows="5" placeholder="¿En qué te podemos ayudar hoy?" required></textarea>
                                    </div>
                                    <div class="col-12 mt-4">
                                        <button type="submit" class="btn btn-primary-custom btn-lg w-100 py-3 fw-bold rounded-pill shadow-sm">
                                            Enviar Mensaje <i class="bi bi-send ms-2"></i>
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- INFORMACIÓN DE CONTACTO -->
                <div class="col-lg-5">
                    <div class="card-tour h-100 border-0" style="background: white; border-radius: 20px;">
                        <div class="body p-5">
                            <h3 class="fw-bold mb-4" style="color: var(--dark); font-family: 'Outfit', sans-serif;">
                                <i class="bi bi-geo-alt-fill text-danger me-2"></i> Nuestras Sedes
                            </h3>
                            
                            <div class="d-flex mb-4">
                                <div class="icon-wrap bg-light rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 50px; height: 50px; flex-shrink: 0;">
                                    <i class="bi bi-building fs-5 text-primary"></i>
                                </div>
                                <div>
                                    <h5 class="fw-bold mb-1">Sede Lima (Principal)</h5>
                                    <p class="text-muted mb-0">Av. José Larco 123, Of. 405<br>Miraflores, Lima - Perú</p>
                                </div>
                            </div>
                            
                            <div class="d-flex mb-4">
                                <div class="icon-wrap bg-light rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 50px; height: 50px; flex-shrink: 0;">
                                    <i class="bi bi-building fs-5 text-primary"></i>
                                </div>
                                <div>
                                    <h5 class="fw-bold mb-1">Sede Cusco</h5>
                                    <p class="text-muted mb-0">Calle Plateros 345<br>Plaza de Armas, Cusco - Perú</p>
                                </div>
                            </div>

                            <hr class="my-4 text-muted">

                            <h5 class="fw-bold mb-3">Vías de Contacto Rápido</h5>
                            <ul class="list-unstyled text-muted mb-4">
                                <li class="mb-2"><i class="bi bi-telephone-fill me-2 text-primary"></i> +51 1 234 5678</li>
                                <li class="mb-2"><i class="bi bi-whatsapp me-2 text-success"></i> +51 987 654 321</li>
                                <li><i class="bi bi-envelope-fill me-2 text-warning"></i> reservas@peruchasqui.com</li>
                            </ul>

                            <h5 class="fw-bold mb-3">Síguenos en Redes</h5>
                            <div class="d-flex gap-2">
                                <a href="#" class="btn btn-light rounded-circle" style="width: 45px; height: 45px; display: flex; align-items: center; justify-content: center;"><i class="bi bi-facebook fs-5" style="color: #1877F2;"></i></a>
                                <a href="#" class="btn btn-light rounded-circle" style="width: 45px; height: 45px; display: flex; align-items: center; justify-content: center;"><i class="bi bi-instagram fs-5" style="color: #E4405F;"></i></a>
                                <a href="#" class="btn btn-light rounded-circle" style="width: 45px; height: 45px; display: flex; align-items: center; justify-content: center;"><i class="bi bi-tiktok fs-5" style="color: #000000;"></i></a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- COMPONENTES COMPARTIDOS -->
    <jsp:include page="componentes/modal_reserva.jsp"></jsp:include>
    <jsp:include page="componentes/footer.jsp"></jsp:include>

    <!-- SCRIPTS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="assets/js/contacto.js"></script>
    <!-- Incluimos booking-modal para que funcione el modal desde el footer/navbar -->
    <script src="assets/js/booking-modal.js"></script>
</body>
</html>
