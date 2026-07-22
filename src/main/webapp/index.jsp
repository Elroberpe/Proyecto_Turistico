<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, user-scalable=yes">
<title>Perú Chasqui | Tu aventura comienza aquí</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link
	href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,300;9..144,500;9..144,600;9..144,700&family=Work+Sans:wght@400;500;600&display=swap"
	rel="stylesheet">
<link rel="stylesheet" href="assets/css/style.css">
</head>
<body>

	<!-- ==================== NAVBAR ==================== -->
	<jsp:include page="componentes/navbar.jsp"></jsp:include>


	<!-- ==================== CARRUSEL ==================== -->
	<div id="mainCarousel" class="carousel slide" data-bs-ride="carousel">
		<div class="carousel-indicators">
			<button type="button" data-bs-target="#mainCarousel"
				data-bs-slide-to="0" class="active"></button>
			<button type="button" data-bs-target="#mainCarousel"
				data-bs-slide-to="1"></button>
			<button type="button" data-bs-target="#mainCarousel"
				data-bs-slide-to="2"></button>
		</div>
		<div class="carousel-inner">
			<div class="carousel-item active">
				<img src="https://picsum.photos/seed/costaperu/1600/900"
					class="d-block w-100" alt="Costa Peruana">
				<div class="carousel-caption">
					<h1>
						Descubre la <span class="accent-text">Costa</span>
					</h1>
					<p>Playas paradisíacas, surf y la mejor gastronomía del
						Pacífico</p>
					<a href="costa.jsp" class="btn btn-terracota">Explorar Costa →</a>
				</div>
			</div>
			<div class="carousel-item">
				<img src="https://picsum.photos/seed/cusconoche/1600/900"
					class="d-block w-100" alt="Sierra Peruana">
				<div class="carousel-caption">
					<h1>
						Aventura en la <span class="accent-text">Sierra</span>
					</h1>
					<p>Montañas, el mítico Machu Picchu y cultura viva</p>
					<a href="sierra.jsp" class="btn btn-terracota">Explorar Sierra
						→</a>
				</div>
			</div>
			<div class="carousel-item">
				<img src="https://picsum.photos/seed/iquitosselva/1600/900"
					class="d-block w-100" alt="Selva Peruana">
				<div class="carousel-caption">
					<h1>
						Magia en la <span class="accent-text">Selva</span>
					</h1>
					<p>Amazonía, ríos serpenteantes y biodiversidad única</p>
					<a href="selva.jsp" class="btn btn-terracota">Explorar Selva →</a>
				</div>
			</div>
		</div>
		<button class="carousel-control-prev" type="button"
			data-bs-target="#mainCarousel" data-bs-slide="prev">
			<span class="carousel-control-prev-icon"></span>
		</button>
		<button class="carousel-control-next" type="button"
			data-bs-target="#mainCarousel" data-bs-slide="next">
			<span class="carousel-control-next-icon"></span>
		</button>
	</div>

	<!-- ==================== BUSCADOR ==================== -->

	<!-- ==================== BENEFICIOS ==================== -->
	<section class="benefits-section py-5 bg-white">
		<div class="container">
			<div class="row text-center g-4">
				<div class="col-md-4">
					<div
						class="card benefit-card h-100 border-0 shadow-sm rounded-4 p-4">
						<div class="card-body">
							<i
								class="bi bi-person-bounding-box display-5 text-terracota mb-3"></i>
							<h4 class="h5 fw-semibold mb-2">Las mejores ofertas</h4>
							<p class="text-muted small mb-0">Descuentos exclusivos y
								paquetes diseñados para ti</p>
						</div>
					</div>
				</div>
				<div class="col-md-4">
					<div
						class="card benefit-card h-100 border-0 shadow-sm rounded-4 p-4">
						<div class="card-body">
							<i
								class="bi bi-credit-card-2-front display-5 text-terracota mb-3"></i>
							<h4 class="h5 fw-semibold mb-2">Compra fácil y segura</h4>
							<p class="text-muted small mb-0">Pagos protegidos con
								múltiples métodos</p>
						</div>
					</div>
				</div>
				<div class="col-md-4">
					<div
						class="card benefit-card h-100 border-0 shadow-sm rounded-4 p-4">
						<div class="card-body">
							<i class="bi bi-people display-5 text-terracota mb-3"></i>
							<h4 class="h5 fw-semibold mb-2">Expertos en viajes</h4>
							<p class="text-muted small mb-0">Más de 10 años conectando
								viajeros con el Perú</p>
						</div>
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
	<jsp:include page="componentes/modal_reserva.jsp"></jsp:include>
	<jsp:include page="componentes/footer.jsp"></jsp:include>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
	<script src="assets/js/main.js"></script>
</body>
</html>

