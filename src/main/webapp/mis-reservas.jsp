<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.turismo.modelo.Reserva"%>
<%@ page import="com.turismo.modelo.Usuario"%>
<%@ page import="java.util.List"%>
<%@ page import="java.math.BigDecimal"%>
<%@ page import="java.math.RoundingMode"%>
<%
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
    if (usuarioSesion == null) {
        response.sendRedirect(request.getContextPath() + "/login");
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
<body >

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
            <a href="index.jsp" class="btn text-primary rounded-pill btn-sm">
                Explorar Más Paquetes
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
                                <th>Fecha Reserva</th>
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
                                BigDecimal total = r.getPrecioTotal() != null ? r.getPrecioTotal() : BigDecimal.ZERO;
                                BigDecimal subtotal = total.divide(new BigDecimal("1.18"), 2, RoundingMode.HALF_UP);
                                BigDecimal igv = total.subtract(subtotal);
                            %>
                                <tr>
                                    <td class="ps-4 fw-bold text-muted">#<%= r.getIdReserva() %></td>
                                    <td class="fw-bold text-dark">
                                     
                                        <%= r.getNombrePaquete() != null ? r.getNombrePaquete() : "Paquete #" + r.getIdPaquete() %>
                                    </td>
                                    <td>
                                        <%= r.getFechaReserva() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(r.getFechaReserva()) : "-" %>
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
                                            <span class="badge bg-success px-3">
                                                 Pagada
                                            </span>
                                        <% } else if ("pendiente".equalsIgnoreCase(r.getEstado())) { %>
                                            <span class="badge bg-warning text-dark px-3">
                                                 Pendiente
                                            </span>
                                        <% } else { %>
                                            <span class="badge bg-danger px-3">
                                                 Cancelada
                                            </span>
                                        <% } %>
                                    </td>
                                    <td class="text-end pe-4">
                                        <div class="d-inline-flex gap-1 align-items-center">
                                            <button type="button" class="btn btn-sm btn-secondary"
                                                    data-bs-toggle="modal" data-bs-target="#modalDetalle<%= r.getIdReserva() %>">
                                                <i class="bi bi-receipt me-1"></i> Ver
                                            </button>
                                            <% if (esCancelable) { %>
                                                <button type="button" class="btn btn-sm btn-danger btn-cancelar"
                                                        data-id="<%= r.getIdReserva() %>"
                                                        data-paquete="<%= r.getNombrePaquete() != null ? r.getNombrePaquete() : "Paquete #" + r.getIdPaquete() %>">
                                                    <i class="bi bi-x-lg me-1"></i> Cancelar
                                                </button>
                                            <% } %>
                                        </div>
                                    </td>
                                </tr>

                                <!-- MODAL DETALLE DE LA RESERVA (REUTILIZANDO PAYMENT-CARD) -->
                                <div class="modal fade" id="modalDetalle<%= r.getIdReserva() %>" tabindex="-1" aria-labelledby="modalDetalleLabel<%= r.getIdReserva() %>" aria-hidden="true">
                                    <div class="modal-dialog modal-dialog-centered">
                                        <div class="modal-content border-0 shadow-lg" style="border-radius: var(--radius-md, 16px); overflow: hidden;">
                                            <div class="modal-header border-0 pb-0 justify-content-end">
                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body px-4 pt-0 pb-4">
                                                <div class="text-center mb-4 pb-3 border-bottom">
                                                    <div class="d-inline-block bg-primary text-white p-3 rounded-circle mb-3 shadow-sm" style="background-color: var(--primary) !important;">
                                                        <i class="bi bi-receipt fs-3"></i>
                                                    </div>
                                                    <h3 class="text-dark fw-bold mb-0" id="modalDetalleLabel<%= r.getIdReserva() %>">Detalle de Reserva</h3>
                                                    <p class="text-muted small mb-0">ID Reserva: #<%= r.getIdReserva() %></p>
                                                </div>
                                                <div class="invoice-detail px-2">
                                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                                        <span class="text-muted"><i class="bi bi-geo-alt me-2 text-primary"></i>Destino:</span>
                                                        <span class="fw-bold text-end"><%= r.getNombrePaquete() != null ? r.getNombrePaquete() : "Paquete #" + r.getIdPaquete() %></span>
                                                    </div>
                                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                                        <span class="text-muted"><i class="bi bi-arrow-left-right me-2 text-primary"></i>Tipo:</span>
                                                        <span class="fw-bold"><%= ("idavuelta".equalsIgnoreCase(r.getTipoViaje()) || "roundtrip".equalsIgnoreCase(r.getTipoViaje())) ? "Ida y Vuelta" : "Solo Ida" %></span>
                                                    </div>
                                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                                        <span class="text-muted"><i class="bi bi-calendar-check me-2 text-primary"></i>Salida:</span>
                                                        <span class="fw-bold"><%= r.getFechaSalida() %></span>
                                                    </div>
                                                    <% if (r.getFechaRetorno() != null) { %>
                                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                                        <span class="text-muted"><i class="bi bi-calendar-x me-2 text-primary"></i>Retorno:</span>
                                                        <span class="fw-bold"><%= r.getFechaRetorno() %></span>
                                                    </div>
                                                    <% } %>
                                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                                        <span class="text-muted"><i class="bi bi-people me-2 text-primary"></i>Pasajeros:</span>
                                                        <span class="fw-bold"><%= r.getNumPasajeros() %></span>
                                                    </div>
                                                    <div class="d-flex justify-content-between align-items-center mb-4">
                                                        <span class="text-muted"><i class="bi bi-info-circle me-2 text-primary"></i>Estado:</span>
                                                        <span>
                                                            <% if ("pagada".equalsIgnoreCase(r.getEstado())) { %>
                                                                <span class="badge bg-success rounded-pill px-3">
                                                                    Pagada
                                                                </span>
                                                            <% } else if ("pendiente".equalsIgnoreCase(r.getEstado())) { %>
                                                                <span class="badge bg-warning text-dark rounded-pill px-3">
                                                                    Pendiente
                                                                </span>
                                                            <% } else { %>
                                                                <span class="badge bg-danger rounded-pill px-3">
                                                                     Cancelada
                                                                </span>
                                                            <% } %>
                                                        </span>
                                                    </div>

                                                    <div class="p-3 bg-light rounded-4 mb-4">
                                                        <div class="d-flex justify-content-between mb-2">
                                                            <span class="text-muted small">Subtotal:</span>
                                                            <span class="fw-semibold text-dark">S/ <%= String.format(java.util.Locale.US, "%.2f", subtotal) %></span>
                                                        </div>
                                                        <div class="d-flex justify-content-between mb-3 border-bottom pb-2">
                                                            <span class="text-muted small">IGV (18%):</span>
                                                            <span class="fw-semibold text-dark">S/ <%= String.format(java.util.Locale.US, "%.2f", igv) %></span>
                                                        </div>
                                                        <div class="d-flex justify-content-between align-items-center mt-2">
                                                            <span class="fw-bold text-dark fs-5">TOTAL</span>
                                                            <span class="fw-bold fs-4 text-primary">S/ <%= String.format(java.util.Locale.US, "%.2f", total) %></span>
                                                        </div>
                                                    </div>
                                                </div>

                                                <% if ("pagada".equalsIgnoreCase(r.getEstado())) { %>
                                                    <div class="alert alert-success d-flex align-items-center border-0 small shadow-sm mb-3" role="alert">
                                                        <i class="bi bi-shield-check fs-4 me-2"></i>
                                                        <div>
                                                            Reserva confirmada y pagada con éxito.
                                                        </div>
                                                    </div>
                                                <% } else if ("pendiente".equalsIgnoreCase(r.getEstado())) { %>
                                                    <div class="alert alert-warning d-flex align-items-center border-0 small shadow-sm mb-3" role="alert">
                                                        <i class="bi bi-hourglass-split fs-4 me-2"></i>
                                                        <div>
                                                            Reserva pendiente de pago.
                                                        </div>
                                                    </div>
                                                <% } else { %>
                                                    <div class="alert alert-danger d-flex align-items-center border-0 small shadow-sm mb-3" role="alert">
                                                        <i class="bi bi-x-octagon fs-4 me-2"></i>
                                                        <div>
                                                            Esta reserva ha sido cancelada.
                                                        </div>
                                                    </div>
                                                <% } %>

                                                <div class="d-flex justify-content-end gap-2 mt-3">
                                                    <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">
                                                        Cerrar
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        <% } %>

    </div>

    <!-- FORMULARIO OCULTO PARA CANCELAR RESERVA -->
    <form id="formCancelar" action="<%= request.getContextPath() %>/mis-reservas" method="post">
        <input type="hidden" name="action" value="cancelar">
        <input type="hidden" id="idCancelar" name="id">
    </form>

    <!-- FOOTER Y SCRIPTS -->
    <jsp:include page="componentes/footer.jsp"></jsp:include>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        document.querySelectorAll(".btn-cancelar").forEach(function (btn) {
            btn.addEventListener("click", function () {
                let id = this.dataset.id;
                let paquete = this.dataset.paquete || "la reserva";
                Swal.fire({
                    title: "¿Cancelar reserva #" + id + "?",
                    text: "Esta acción cancelará tu reserva para " + paquete + ". ¿Deseas continuar?",
                    icon: "warning",
                    showCancelButton: true,
                    confirmButtonColor: "#dc3545",
                    cancelButtonColor: "#6c757d",
                    confirmButtonText: "Sí, cancelar",
                    cancelButtonText: "No, mantener"
                }).then((result) => {
                    if (result.isConfirmed) {
                        document.getElementById("idCancelar").value = id;
                        document.getElementById("formCancelar").submit();
                    }
                });
            });
        });
    </script>
</body>
</html>
