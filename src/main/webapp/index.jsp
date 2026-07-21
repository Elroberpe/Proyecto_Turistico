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
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@400;500;600;700&display=swap"
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
				<img src="assets/img/pimentel.webp" class="d-block w-100"
					alt="Costa Peruana">
				<div class="carousel-caption">
					<h1>
						Descubre la <span class="accent-text">Costa</span>
					</h1>
					<p>Playas paradisíacas, surf y la mejor gastronomía del
						Pacífico</p>
					<a href="costa.jsp" class="btn btn-primary">Explorar Costa →</a>
				</div>
			</div>
			<div class="carousel-item">
				<img src="assets/img/cusco_noche.jpeg" class="d-block w-100"
					alt="Sierra Peruana">
				<div class="carousel-caption">
					<h1>
						Aventura en la <span class="accent-text">Sierra</span>
					</h1>
					<p>Montañas, el mítico Machu Picchu y cultura viva</p>
					<a href="sierra.html" class="btn btn-primary">Explorar Sierra
						→</a>
				</div>
			</div>
			<div class="carousel-item">
				<img src="assets/img/iquitos_carrusel.jpg" class="d-block w-100"
					alt="Selva Peruana">
				<div class="carousel-caption">
					<h1>
						Magia en la <span class="accent-text">Selva</span>
					</h1>
					<p>Amazonía, ríos serpenteantes y biodiversidad única</p>
					<a href="selva.html" class="btn btn-primary">Explorar Selva →</a>
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
	<jsp:include page="componentes/buscador.jsp"></jsp:include>
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
	<jsp:include page="componentes/footer.jsp"></jsp:include>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
	<script src="assets/js/data.js"></script>
	<script src="assets/js/main.js"></script>
</body>
</html>
