<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.turismo.modelo.Paquete" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Costa | Perú Chasqui</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="assets/css/style.css?v=2.0">
</head>
<body data-region="costa">
    <jsp:include page="componentes/navbar.jsp"></jsp:include>

    <!-- HEADER DE REGION -->
    <header class="region-header bg-costa">
        <div class="text-center">
            <span class="badge bg-primary text-white px-3 py-2 rounded-pill mb-3 shadow badge-hero">Descubre la magia del mar</span>
            <h1>Costa Peruana</h1>
        </div>
    </header>

    <!-- CATALOGO -->
    <section class="packages-section packages-section-custom">
        <div class="container">
            <div class="section-title">
                <span class="text-uppercase fw-bold text-subtitle">Sol y Olas</span>
                <h2>Paquetes en la Costa</h2>
                <p>Las mejores playas, atardeceres dorados, desiertos interminables y la gastronomía marina que conquistó al mundo.</p>
            </div>
            <div class="row g-4" id="destinosContainer">
                <% 
                    List<Paquete> lista = (List<Paquete>) request.getAttribute("paquetes");
                    if(lista != null && !lista.isEmpty()) {
                        for(Paquete p : lista) {
                %>
                <div class="col-md-4">
                    <div class="card-tour">
                        <div class="img-wrap">
                            <img src="<%= p.getImagenUrl() %>" alt="<%= p.getNombre() %>">
                            <span class="badge-region"><i class="bi bi-geo-alt"></i> <%= p.getDestino() %></span>
                        </div>
                        <div class="body">
                            <h3><%= p.getNombre() %></h3>
                            <div class="meta mb-2">"<%= p.getDescripcion() %>"</div>
                            <div class="d-flex justify-content-between align-items-end mt-3">
                                <div class="precio">S/ <%= String.format(java.util.Locale.US, "%.2f", p.getPrecioSoles()) %><small> / persona</small></div>
                                <button class="btn-card-action" data-bs-toggle="modal" data-bs-target="#modalReserva" data-id="<%= p.getIdPaquete() %>" data-nombre="<%= p.getNombre() %>" data-precio="<%= p.getPrecioSoles() %>">Seleccionar <i class="bi bi-arrow-right"></i></button>
                            </div>
                        </div>
                    </div>
                </div>
                <% 
                        }
                    } else {
                %>
                <div class="col-12 text-center text-muted">
                    No hay paquetes disponibles para esta región.
                </div>
                <% 
                    }
                %>
            </div>
        </div>
    </section>

    <jsp:include page="componentes/modal_reserva.jsp"></jsp:include>
    <jsp:include page="componentes/footer.jsp"></jsp:include>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="assets/js/booking-modal.js?v=2.1"></script>
    <!-- <script src="assets/js/region.js?v=2.1"></script> -->
</body>
</html>
