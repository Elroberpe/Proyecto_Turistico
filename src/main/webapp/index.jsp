<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, user-scalable=yes">
<title>Perù Chasqui | Tu aventura comienza aquÃ­</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@400;500;600;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet" href="css/style.css">
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
				<img src="img/pimentel.webp" class="d-block w-100"
					alt="Costa Peruana">
				<div class="carousel-caption">
					<h1>
						Descubre la <span class="accent-text">Costa</span>
					</h1>
					<p>Playas paradisÃ­acas, surf y la mejor gastronomÃ­a del
						PacÃ­fico</p>
					<a href="costa.html" class="btn btn-primary">Explorar Costa â</a>
				</div>
			</div>
			<div class="carousel-item">
				<img src="img/cusco_noche.jpeg" class="d-block w-100"
					alt="Sierra Peruana">
				<div class="carousel-caption">
					<h1>
						Aventura en la <span class="accent-text">Sierra</span>
					</h1>
					<p>MontaÃ±as, el mÃ­tico Machu Picchu y cultura viva</p>
					<a href="sierra.html" class="btn btn-primary">Explorar Sierra
						â</a>
				</div>
			</div>
			<div class="carousel-item">
				<img src="img/iquitos_carrusel.jpg" class="d-block w-100"
					alt="Selva Peruana">
				<div class="carousel-caption">
					<h1>
						Magia en la <span class="accent-text">Selva</span>
					</h1>
					<p>Amazonìa, rÃ­os serpenteantes y biodiversidad Ãºnica</p>
					<a href="selva.html" class="btn btn-primary">Explorar Selva â</a>
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
	<section class="search-section">
		<div class="container">
			<div class="search-card">
				<h3 class="text-center mb-4">
					<i class="bi bi-calendar-heart me-2"></i> Planifica tu viaje desde
					Lima
				</h3>
				<form id="bookingForm" class="row g-3">
					<div class="col-md-3">
						<label class="form-label"><i
							class="bi bi-arrow-left-right me-1"></i> Tipo de viaje</label> <select
							id="tipoViaje" class="form-select" required>
							<option value="roundtrip">Ida y Vuelta</option>
							<option value="oneway">Solo Ida</option>
						</select>
					</div>
					<div class="col-md-3">
						<label class="form-label"><i class="bi bi-geo-alt me-1"></i>
							Destino</label> <select id="destinoSelect" class="form-select" required>
							<option value="">Selecciona un destino</option>
						</select>
						<div id="destinoPreview" class="preview-box"></div>
					</div>
					<div class="col-md-2">
						<label class="form-label"><i
							class="bi bi-calendar-check me-1"></i> Salida</label> <input type="date"
							id="fechaSalida" class="form-control" required>
					</div>
					<div class="col-md-2" id="retornoGroup">
						<label class="form-label"><i class="bi bi-calendar-x me-1"></i>
							Retorno</label> <input type="date" id="fechaRetorno" class="form-control">
					</div>
					<div class="col-md-2">
						<label class="form-label"><i class="bi bi-people me-1"></i>
							Pasajeros</label> <select id="pasajerosSelect" class="form-select">
							<option value="1">1 pasajero</option>
							<option value="2">2 pasajeros</option>
							<option value="3">3 pasajeros</option>
							<option value="4">4 pasajeros</option>
							<option value="5">5 pasajeros</option>
							<option value="6">6 pasajeros</option>
						</select>
					</div>
					<div
						class="col-12 mt-3 d-flex justify-content-between align-items-center flex-wrap">
						<div class="price-display">
							<span class="fw-bold">Precio estimado: </span> <span
								id="precioSoles" class="price-soles">S/ 0.00</span> <span
								id="precioUSD" class="price-usd">($0.00 USD)</span>
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
						<p>Descuentos exclusivos y paquetes diseÃ±ados para ti</p>
					</div>
				</div>
				<div class="col-md-4">
					<div class="benefit-card">
						<i class="bi bi-credit-card-2-front"></i>
						<h4>Compra fÃ¡cil y segura</h4>
						<p>Pagos protegidos con mÃºltiples mÃ©todos</p>
					</div>
				</div>
				<div class="col-md-4">
					<div class="benefit-card">
						<i class="bi bi-people"></i>
						<h4>Expertos en viajes</h4>
						<p>MÃ¡s de 10 aÃ±os conectando viajeros con el PerÃº</p>
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
				<p>Los destinos mÃ¡s solicitados por nuestros viajeros</p>
			</div>
			<div class="row g-4" id="paquetesContainer"></div>
		</div>
	</section>

	<!-- ==================== ASESORES ==================== -->
	<section class="team-section">
		<div class="container">
			<div class="section-header">
				<h2>Asesores de Viaje</h2>
				<p>Expertos apasionados por el PerÃº, listos para asesorarte</p>
			</div>
			<div class="row g-4" id="teamContainer"></div>
		</div>
	</section>

	<!-- ==================== FOOTER ==================== -->
	<jsp:include page="componentes/footer.jsp"></jsp:include>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
	<script src="js/data.js"></script>
	<script src="js/main.js"></script>
</body>
</html>