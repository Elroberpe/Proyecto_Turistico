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
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body data-region="costa">

    <jsp:include page="componentes/navbar.jsp"></jsp:include>
    
   <!-- ==================== HERO COSTA ==================== -->
	<header class="region-hero" style="background-image: url('https://picsum.photos/seed/costaperu/1920/1080');">
		<div class="region-hero-overlay"></div>
		<div class="container position-relative">
			<nav aria-label="breadcrumb" class="mb-3">
				<ol class="breadcrumb region-breadcrumb mb-0">
					<li class="breadcrumb-item"><a href="index.jsp">Inicio</a></li>
					<li class="breadcrumb-item active" aria-current="page">Costa</li>
				</ol>
			</nav>
	
			<span class="badge region-badge rounded-pill mb-3">
				<i class="bi bi-water me-1"></i> Región Costa
			</span>
	
			<h1 class="display-4 fw-bold text-white mb-3">
				Descubre la <span class="accent-text">Costa</span> Peruana
			</h1>
			<p class="lead text-white-50 col-lg-7 mb-4">
				Playas paradisíacas, surf de clase mundial y la mejor gastronomía
				del Pacífico. Desde Máncora hasta Paracas, un litoral lleno de sol.
			</p>
	
			<div class="d-flex flex-wrap gap-3 mb-4">
				<span class="hero-stat"><i class="bi bi-sun me-2"></i>300+ días de sol</span>
				<span class="hero-stat"><i class="bi bi-water me-2"></i>15 playas top</span>
				<span class="hero-stat"><i class="bi bi-egg-fried me-2"></i>Gastronomía premiada</span>
			</div>
	
			<a href="#destinosContainer" class="btn btn-terracota btn-lg rounded-pill px-4">
				Ver destinos <i class="bi bi-arrow-down ms-1"></i>
			</a>
		</div>
	</header>

 	<!-- ==================== DESTINOS DE COSTA ==================== -->
	<section class="packages-section py-5">
		<div class="container">
			<div class="section-header text-center mx-auto mb-5" style="max-width: 640px;">
				<span class="badge region-badge rounded-pill mb-3">
					<i class="bi bi-water me-1"></i> Costa
				</span>
				<h2 class="fw-bold mb-2">Nuestros Destinos de Costa</h2>
				<p class="text-muted mb-0">
					Descubre los mejores lugares para disfrutar del sol y la playa
				</p>
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