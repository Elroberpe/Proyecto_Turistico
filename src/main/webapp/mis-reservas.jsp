<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.turismo.modelo.Reserva"%>
<%@ page import="com.turismo.modelo.Usuario"%>
<%@ page import="java.util.List"%>
<%
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
    if (usuarioSesion == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Reserva> reservas = (List<Reserva>) request.getAttribute("reservas");
    String mensaje = (String) session.getAttribute("mensaje");
    String error = (String) session.getAttribute("error");
    session.removeAttribute("mensaje");
    session.removeAttribute("error");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chasqui PERÚ | Mis Reservas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/style.css?v=2.0">
</head>
<body style="background-color: var(--light-gray);">

    <!-- NAVBAR -->
    <jsp:include page="componentes/navbar.jsp"></jsp:include>

    <!-- CONTENIDO PRINCIPAL -->
    <div class="container py-5" style="margin-top: 100px; min-height: 75vh;">
        
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="fw-bold text-dark mb-1">
                    <i class="bi bi-journal-bookmark text-primary me-2"></i> Mis Reservas
                </h2>
                <p class="text-muted small mb-0">Gestiona y revisa el estado de todos tus viajes contratados</p>
            </div>
            <a href="index.jsp" class="btn btn-outline-primary rounded-pill btn-sm">
                <i class="bi bi-plus-circle me-1"></i> Explorar Más Paquetes
            </a>
        </div>

        <!-- ALERTAS DE SESIÓN -->
        <% if (mensaje != null) { %>
            <div class="alert alert-success alert-dismissible fade show shadow-sm rounded-4 mb-4" role="alert">
                <%= mensaje %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <% if (error != null) { %>
            <div class="alert alert-danger alert-dismissible fade show shadow-sm rounded-4 mb-4" role="alert">
                <%= error %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <!-- LISTADO DE RESERVAS -->
        <% if (reservas == null || reservas.isEmpty()) { %>
            <div class="bg-white text-center p-5 shadow-sm rounded-4 border-0">
                <div class="mb-3 text-muted">
                    <i class="bi bi-ticket-perforated fs-1"></i>
                </div>
                <h4 class="fw-bold text-dark">No tienes reservas activas</h4>
                <p class="text-muted small mb-4">Explora nuestros paquetes turísticos y planea tu próxima aventura en el Perú.</p>
                <a href="index.jsp" class="btn btn-primary-custom rounded-pill px-4 fw-bold">
                    Ver Destinos Turísticos
                </a>
            </div>
        <% } else { %>
            <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="bg-light text-muted small text-uppercase">
                            <tr>
                                <th class="ps-4">ID</th>
                                <th>Paquete Turístico</th>
                                <th>Tipo Viaje</th>
                                <th>Fecha Salida</th>
                                <th>Fecha Retorno</th>
                                <th>Pasajeros</th>
                                <th>Total (S/)</th>
                                <th>Estado</th>
                                <th class="text-end pe-4">Acción</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Reserva r : reservas) { 
                                boolean esCancelable = !"cancelada".equalsIgnoreCase(r.getEstado());
                            %>
                                <tr>
                                    <td class="ps-4 fw-bold text-muted">#<%= r.getIdReserva() %></td>
                                    <td class="fw-bold text-dark">
                                        <i class="bi bi-geo-alt text-primary me-1"></i>
                                        <%= r.getNombrePaquete() != null ? r.getNombrePaquete() : "Paquete #" + r.getIdPaquete() %>
                                    </td>
                                    <td>
                                        <span class="badge bg-light text-dark border">
                                            <%= ("idavuelta".equalsIgnoreCase(r.getTipoViaje()) || "roundtrip".equalsIgnoreCase(r.getTipoViaje())) ? "Ida y Vuelta" : "Solo Ida" %>
                                        </span>
                                    </td>
                                    <td><%= r.getFechaSalida() %></td>
                                    <td><%= r.getFechaRetorno() != null ? r.getFechaRetorno() : "-" %></td>
                                    <td class="text-center"><%= r.getNumPasajeros() %></td>
                                    <td class="fw-bold text-primary">S/ <%= r.getPrecioTotal() %></td>
                                    <td>
                                        <% if ("pagada".equalsIgnoreCase(r.getEstado())) { %>
                                            <span class="badge bg-success rounded-pill px-3">
                                                <i class="bi bi-check-circle me-1"></i> Pagada
                                            </span>
                                        <% } else if ("pendiente".equalsIgnoreCase(r.getEstado())) { %>
                                            <span class="badge bg-warning text-dark rounded-pill px-3">
                                                <i class="bi bi-clock me-1"></i> Pendiente
                                            </span>
                                        <% } else { %>
                                            <span class="badge bg-danger rounded-pill px-3">
                                                <i class="bi bi-x-circle me-1"></i> Cancelada
                                            </span>
                                        <% } %>
                                    </td>
                                    <td class="text-end pe-4">
                                        <% if (esCancelable) { %>
                                            <button type="button" class="btn btn-outline-danger btn-sm rounded-pill px-3"
                                                    data-bs-toggle="modal" data-bs-target="#modalCancelar<%= r.getIdReserva() %>">
                                                <i class="bi bi-x-lg me-1"></i> Cancelar
                                            </button>
                                        <% } else { %>
                                            <span class="text-muted small fst-italic">Sin acciones</span>
                                        <% } %>
                                    </td>
                                </tr>

                                <!-- MODAL CONFIRMAR CANCELACIÓN PARA ESTA RESERVA -->
                                <% if (esCancelable) { %>
                                    <div class="modal fade" id="modalCancelar<%= r.getIdReserva() %>" tabindex="-1" aria-hidden="true">
                                        <div class="modal-dialog modal-dialog-centered">
                                            <div class="modal-content border-0 shadow-lg" style="border-radius: 16px;">
                                                <div class="modal-header bg-danger text-white border-0">
                                                    <h5 class="modal-title fw-bold">
                                                        <i class="bi bi-exclamation-triangle me-2"></i> Confirmar Cancelación
                                                    </h5>
                                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                                </div>
                                                <div class="modal-body p-4 text-center">
                                                    <p class="fs-6 text-dark mb-2">
                                                        ¿Estás seguro de que deseas cancelar la reserva <strong>#<%= r.getIdReserva() %></strong> para <strong><%= r.getNombrePaquete() %></strong>?
                                                    </p>
                                                    
                                                </div>
                                                <div class="modal-footer border-0 bg-light">
                                                    <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Mantener</button>
                                                    <form action="<%= request.getContextPath() %>/mis-reservas" method="post" class="d-inline">
                                                        <input type="hidden" name="action" value="cancelar">
                                                        <input type="hidden" name="id" value="<%= r.getIdReserva() %>">
                                                        <button type="submit" class="btn btn-danger rounded-pill px-4 fw-bold">
                                                           Cancelar Reserva
                                                        </button>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                <% } %>

                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        <% } %>

    </div>

    <!-- FOOTER Y SCRIPTS -->
    <jsp:include page="componentes/footer.jsp"></jsp:include>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
