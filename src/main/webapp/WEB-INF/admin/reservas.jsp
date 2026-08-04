<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.turismo.modelo.Reserva, com.turismo.modelo.Usuario, com.turismo.modelo.Paquete" %>
<%
    List<Reserva> reservas = (List<Reserva>) request.getAttribute("reservas");
    if (reservas == null) {
        response.sendRedirect(request.getContextPath() + "/admin/reservas");
        return;
    }

    List<Usuario> usuarios = (List<Usuario>) request.getAttribute("usuarios");
    List<Paquete> paquetes = (List<Paquete>) request.getAttribute("paquetes");

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
    <title>Panel Admin - Reservas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/admin/css/style.css">
</head>
<body>
    <div class="d-flex">
        <!-- Sidebar Reutilizable -->
        <jsp:include page="componentes/sidebar.jsp" />

        <div id="content">
            <nav class="navbar navbar-expand-lg navbar-light bg-white rounded shadow-sm mb-4 p-3">
                <div class="container-fluid">
                    <button type="button" id="sidebarCollapse" class="btn btn-primary-custom">
                        <i class="bi bi-list"></i>
                    </button>
                    <div class="ms-auto">
                        <span class="me-3 fw-bold">Bienvenido, Admin</span>
                    </div>
                </div>
            </nav>

            <!-- Mensajes de éxito/error -->
            <% if (mensaje != null) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle me-2"></i> <%= mensaje %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>
            <% if (error != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle me-2"></i> <%= error %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Gestión de Reservas</h2>
                <button id="btnNuevo" class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#reservaModal">
                    <i class="bi bi-calendar-plus"></i> Nueva Reserva
                </button>
            </div>

            <div class="card p-4">
                <div class="table-responsive">
                    <table class="table table-hover table-custom align-middle">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Cliente</th>
                                <th>Paquete</th>
                                <th>Tipo Viaje</th>
                                <th>Salida</th>
                                <th>Retorno</th>
                                <th>Pasajeros</th>
                                <th>Total (S/)</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (reservas.isEmpty()) { %>
                                <tr>
                                    <td colspan="10" class="text-center text-muted">No hay reservas registradas.</td>
                                </tr>
                            <% } else { %>
                                <% for (Reserva r : reservas) { %>
                                <tr>
                                    <td>#<%= r.getIdReserva() %></td>
                                    <td><%= r.getNombreUsuario() != null ? r.getNombreUsuario() : "ID #" + r.getIdUsuario() %></td>
                                    <td><%= r.getNombrePaquete() != null ? r.getNombrePaquete() : "ID #" + r.getIdPaquete() %></td>
                                    <td><%= ("idavuelta".equalsIgnoreCase(r.getTipoViaje()) || "roundtrip".equalsIgnoreCase(r.getTipoViaje())) ? "Ida y Vuelta" : "Solo Ida" %></td>
                                    <td><%= r.getFechaSalida() %></td>
                                    <td><%= r.getFechaRetorno() != null ? r.getFechaRetorno() : "-" %></td>
                                    <td><%= r.getNumPasajeros() %></td>
                                    <td class="fw-bold">S/ <%= r.getPrecioTotal() %></td>
                                    <td>
                                        <% if ("pagada".equalsIgnoreCase(r.getEstado())) { %>
                                            <span class="badge bg-success">Pagada</span>
                                        <% } else if ("pendiente".equalsIgnoreCase(r.getEstado())) { %>
                                            <span class="badge bg-warning text-dark">Pendiente</span>
                                        <% } else if ("cancelada".equalsIgnoreCase(r.getEstado())) { %>
                                            <span class="badge bg-danger">Cancelada</span>
                                        <% } else { %>
                                            <span class="badge bg-secondary"><%= r.getEstado() %></span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <% if ("pagada".equalsIgnoreCase(r.getEstado())) { %>
                                            <button class="btn btn-sm btn-secondary" disabled title="No se puede editar una reserva pagada desde aquí">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                        <% } else { %>
                                            <button class="btn btn-sm btn-secondary-custom btn-editar" 
                                                    data-id="<%= r.getIdReserva() %>"
                                                    data-usuario="<%= r.getIdUsuario() %>"
                                                    data-paquete="<%= r.getIdPaquete() %>"
                                                    data-tipoviaje="<%= r.getTipoViaje() %>"
                                                    data-pasajeros="<%= r.getNumPasajeros() %>"
                                                    data-salida="<%= r.getFechaSalida() %>"
                                                    data-retorno="<%= r.getFechaRetorno() != null ? r.getFechaRetorno() : "" %>"
                                                    data-total="<%= r.getPrecioTotal() %>"
                                                    data-estado="<%= r.getEstado() %>"
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#reservaModal">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <button class="btn btn-sm btn-danger btn-eliminar" data-id="<%= r.getIdReserva() %>">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        <% } %>
                                    </td>
                                </tr>
                                <% } %>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- ======================================== -->
    <!-- MODAL ÚNICO RESERVA (CREAR / EDITAR) -->
    <!-- ======================================== -->
    <div class="modal fade" id="reservaModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-primary-custom text-white" id="reservaModalHeader">
                    <h5 class="modal-title" id="reservaModalTitle">Nueva Reserva</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="<%=request.getContextPath()%>/admin/reservas" method="post">
                        <input type="hidden" id="actionReserva" name="action" value="crear">
                        <input type="hidden" id="idReserva" name="id">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Cliente</label>
                                <select class="form-select" id="usuarioReserva" name="id_usuario" required>
                                    <option value="">Seleccionar cliente</option>
                                    <% if (usuarios != null) {
                                        for (Usuario u : usuarios) { %>
                                        <option value="<%= u.getIdUsuario() %>">
                                            <%= u.getNombre() %> <%= u.getApellidos() %> (<%= u.getEmail() %>)
                                        </option>
                                    <%  }
                                    } %>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Paquete Turístico</label>
                                <select class="form-select" id="paqueteReserva" name="id_paquete" required>
                                    <option value="">Seleccionar paquete</option>
                                    <% if (paquetes != null) {
                                        for (Paquete p : paquetes) { %>
                                        <option value="<%= p.getIdPaquete() %>">
                                            <%= p.getNombre() %> - S/ <%= p.getPrecioSoles() %>
                                        </option>
                                    <%  }
                                    } %>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Tipo de Viaje</label>
                                <select class="form-select" id="tipoViajeReserva" name="tipo_viaje" required>
                                    <option value="idavuelta">Ida y Vuelta</option>
                                    <option value="ida">Solo Ida</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Pasajeros</label>
                                <input type="number" class="form-control" id="numPasajerosReserva" name="num_pasajeros" min="1" value="1" required>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Fecha Salida</label>
                                <input type="date" class="form-control" id="fechaSalidaReserva" name="fecha_salida" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Fecha Retorno</label>
                                <input type="date" class="form-control" id="fechaRetornoReserva" name="fecha_retorno">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Precio Total (S/)</label>
                                <input type="number" step="0.01" class="form-control" id="precioTotalReserva" name="precio_total" required placeholder="0.00">
                            </div>
                            <div class="col-md-6 mb-3" id="estadoReservaContainer" style="display: none;">
                                <label class="form-label">Estado</label>
                                <select class="form-select" id="estadoReserva" name="estado">
                                    <option value="pendiente">Pendiente</option>
                                    <option value="cancelada">Cancelada</option>
                                </select>
                            </div>
                        </div>
                        <div class="text-end mt-3">
                            <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancelar</button>
                            <button type="submit" class="btn btn-primary-custom" id="btnGuardarReserva">Guardar Reserva</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <form id="formEliminar" action="<%=request.getContextPath()%>/admin/reservas" method="post">
        <input type="hidden" name="action" value="eliminar">
        <input type="hidden" id="idEliminar" name="id">
    </form>

    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="<%=request.getContextPath()%>/assets/admin/js/script.js"></script>
    <script>
        // Limpiar modal para nueva reserva
        document.getElementById("btnNuevo").addEventListener("click", function () {
            document.getElementById("actionReserva").value = "crear";
            document.getElementById("idReserva").value = "";
            document.getElementById("usuarioReserva").selectedIndex = 0;
            document.getElementById("paqueteReserva").selectedIndex = 0;
            document.getElementById("tipoViajeReserva").value = "idavuelta";
            document.getElementById("numPasajerosReserva").value = "1";
            document.getElementById("fechaSalidaReserva").value = "";
            document.getElementById("fechaRetornoReserva").value = "";
            document.getElementById("precioTotalReserva").value = "";
            document.getElementById("estadoReservaContainer").style.display = "none";
            document.getElementById("reservaModalTitle").textContent = "Nueva Reserva";
            document.getElementById("btnGuardarReserva").className = "btn btn-primary-custom";
        });

        // Llenar modal para editar reserva
        document.querySelectorAll(".btn-editar").forEach(function (btn) {
            btn.addEventListener("click", function () {
                document.getElementById("actionReserva").value = "editar";
                document.getElementById("idReserva").value = this.dataset.id;
                document.getElementById("usuarioReserva").value = this.dataset.usuario;
                document.getElementById("paqueteReserva").value = this.dataset.paquete;
                let tipo = this.dataset.tipoviaje;
                if (tipo === "roundtrip" || tipo === "idavuelta") {
                    document.getElementById("tipoViajeReserva").value = "idavuelta";
                } else {
                    document.getElementById("tipoViajeReserva").value = "ida";
                }
                document.getElementById("numPasajerosReserva").value = this.dataset.pasajeros;
                document.getElementById("fechaSalidaReserva").value = this.dataset.salida;
                document.getElementById("fechaRetornoReserva").value = this.dataset.retorno;
                document.getElementById("precioTotalReserva").value = this.dataset.total;
                document.getElementById("estadoReservaContainer").style.display = "block";
                document.getElementById("estadoReserva").value = this.dataset.estado;
                document.getElementById("reservaModalTitle").textContent = "Editar Reserva #" + this.dataset.id;
                document.getElementById("btnGuardarReserva").className = "btn btn-primary-custom";
            });
        });

        // Eliminar con SweetAlert2
        document.querySelectorAll(".btn-eliminar").forEach(function (btn) {
            btn.addEventListener("click", function () {
                let id = this.dataset.id;
                Swal.fire({
                    title: "¿Eliminar reserva #" + id + "?",
                    text: "Esta acción no se puede deshacer.",
                    icon: "warning",
                    showCancelButton: true,
                    confirmButtonText: "Sí, eliminar",
                    cancelButtonText: "Cancelar"
                }).then((result) => {
                    if (result.isConfirmed) {
                        document.getElementById("idEliminar").value = id;
                        document.getElementById("formEliminar").submit();
                    }
                });
            });
        });
    </script>
</body>
</html>