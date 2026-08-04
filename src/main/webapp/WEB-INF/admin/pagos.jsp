<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.turismo.modelo.Pago, com.turismo.modelo.Reserva" %>
<%
    List<Pago> pagos = (List<Pago>) request.getAttribute("pagos");
    if (pagos == null) {
        response.sendRedirect(request.getContextPath() + "/admin/pagos");
        return;
    }

    // Obtener reservas pendientes
    List<Reserva> reservasPendientes = (List<Reserva>) request.getAttribute("reservasPendientes");

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
    <title>Panel Admin - Pagos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/admin/css/style.css">
</head>
<body>
    <div class="d-flex">
        <nav id="sidebar">
            <div class="sidebar-header">
                <h3 class="text-white m-0"><i class="bi bi-airplane-engines"></i> AdminTours</h3>
            </div>
            <ul class="list-unstyled components">
                <li><a href="<%=request.getContextPath()%>/admin/dashboard"><i class="bi bi-house-door me-2"></i> Dashboard</a></li>
                <li><a href="<%=request.getContextPath()%>/admin/categorias"><i class="bi bi-tags me-2"></i> Categorías</a></li>
                <li><a href="<%=request.getContextPath()%>/admin/paquetes"><i class="bi bi-box-seam me-2"></i> Paquetes</a></li>
                <li><a href="<%=request.getContextPath()%>/admin/clientes"><i class="bi bi-person-badge me-2"></i> Clientes</a></li>
                <li><a href="<%=request.getContextPath()%>/admin/usuarios"><i class="bi bi-people me-2"></i> Usuarios</a></li>
                <li><a href="<%=request.getContextPath()%>/admin/reservas"><i class="bi bi-calendar-check me-2"></i> Reservas</a></li>
                <li class="active"><a href="<%=request.getContextPath()%>/admin/pagos"><i class="bi bi-credit-card me-2"></i> Pagos</a></li>
            </ul>
        </nav>

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

            <!-- Mensajes -->
            <% if (mensaje != null) { %>
                <div class="alert alert-success alert-dismissible fade show">
                    <i class="bi bi-check-circle me-2"></i> <%= mensaje %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>
            <% if (error != null) { %>
                <div class="alert alert-danger alert-dismissible fade show">
                    <i class="bi bi-exclamation-triangle me-2"></i> <%= error %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Gestión de Pagos</h2>
                <button id="btnNuevo" class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#pagoModal">
                    <i class="bi bi-plus-circle"></i> Nuevo Pago
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
                                <th>Método</th>
                                <th>Monto</th>
                                <th>Estado</th>
                                <th>Fecha</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (pagos.isEmpty()) { %>
                                <tr>
                                    <td colspan="8" class="text-center text-muted">No hay pagos registrados.</td>
                                </tr>
                            <% } else { %>
                                <% for (Pago p : pagos) { %>
                                <tr>
                                    <td><%= p.getIdPago() %></td>
                                    <td><%= p.getNombreCliente() %></td>
                                    <td><%= p.getNombrePaquete() %></td>
                                    <td><span class="badge bg-secondary"><%= p.getNombreMetodo() %></span></td>
                                    <td>S/ <%= p.getMonto() %></td>
                                    <td>
                                        <span class="badge <%= "pagado".equals(p.getEstado()) ? "bg-success" : 
                                                         "rechazado".equals(p.getEstado()) ? "bg-danger" : "bg-warning text-dark" %>">
                                            <%= p.getEstado() %>
                                        </span>
                                    </td>
                                    <td><%= p.getFechaPago() != null ? p.getFechaPago() : "-" %></td>
                                    <td>
                                        <button class="btn btn-sm btn-secondary-custom btn-editar" 
                                                data-id="<%= p.getIdPago() %>"
                                                data-reserva="<%= p.getIdReserva() %>"
                                                data-metodo="<%= p.getIdMetodo() %>"
                                                data-monto="<%= p.getMonto() %>"
                                                data-estado="<%= p.getEstado() %>"
                                                data-bs-toggle="modal" 
                                                data-bs-target="#pagoModal">
                                            <i class="bi bi-pencil"></i>
                                        </button>
                                        <button class="btn btn-sm btn-danger btn-eliminar" data-id="<%= p.getIdPago() %>">
                                            <i class="bi bi-trash"></i>
                                        </button>
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
    <!-- MODAL ÚNICO PAGO (CREAR / EDITAR) -->
    <!-- ======================================== -->
    <div class="modal fade" id="pagoModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-primary-custom text-white" id="pagoModalHeader">
                    <h5 class="modal-title" id="pagoModalTitle">Nuevo Pago</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="<%=request.getContextPath()%>/admin/pagos" method="post">
                        <input type="hidden" id="actionPago" name="action" value="crear">
                        <input type="hidden" id="idPago" name="id">
                        <div class="row">
                            <div class="col-md-6 mb-3" id="reservaPagoContainer">
                                <label class="form-label">Reserva</label>
                                <select class="form-select" name="id_reserva" id="idReserva" required>
                                    <option value="">Seleccionar reserva</option>
                                    <% if (reservasPendientes != null) {
                                        for (Reserva r : reservasPendientes) { %>
                                        <option value="<%= r.getIdReserva() %>" data-monto="<%= r.getPrecioTotal() %>">
                                            #<%= r.getIdReserva() %> - <%= r.getNombreUsuario() %> - S/ <%= r.getPrecioTotal() %>
                                        </option>
                                    <%  }
                                    } %>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Monto (S/)</label>
                                <input type="number" step="0.01" class="form-control" name="monto" id="montoPago" readonly>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Método de Pago</label>
                                <select class="form-select" id="metodoPago" name="id_metodo" required>
                                    <option value="1">Tarjeta</option>
                                    <option value="2">Yape</option>
                                    <option value="3">Plin</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Estado</label>
                                <select class="form-select" id="estadoPago" name="estado" required>
                                    <option value="pagado">Pagado</option>
                                    <option value="rechazado">Rechazado</option>
                                    <option value="reembolsado">Reembolsado</option>
                                </select>
                            </div>
                        </div>
                        <div class="text-end mt-3">
                            <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancelar</button>
                            <button type="submit" class="btn btn-primary-custom" id="btnGuardarPago">Guardar</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <form id="formEliminar" action="<%=request.getContextPath()%>/admin/pagos" method="post">
        <input type="hidden" name="action" value="eliminar">
        <input type="hidden" id="idEliminar" name="id">
    </form>

    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        // Auto-completar monto al seleccionar reserva
        document.addEventListener('DOMContentLoaded', function() {
            const selectReserva = document.getElementById('idReserva');
            const montoInput = document.getElementById('montoPago');
            
            if (selectReserva && montoInput) {
                selectReserva.addEventListener('change', function() {
                    const selectedOption = this.options[this.selectedIndex];
                    const monto = selectedOption.getAttribute('data-monto');
                    if (monto) {
                        montoInput.value = monto;
                    } else {
                        montoInput.value = '';
                    }
                });
            }
        });

        // Limpiar modal para Nuevo Pago
        document.getElementById("btnNuevo").addEventListener("click", function () {
            document.getElementById("actionPago").value = "crear";
            document.getElementById("idPago").value = "";
            document.getElementById("reservaPagoContainer").style.display = "block";
            document.getElementById("idReserva").required = true;
            document.getElementById("idReserva").selectedIndex = 0;
            document.getElementById("montoPago").value = "";
            document.getElementById("montoPago").readOnly = true;
            document.getElementById("metodoPago").value = "1";
            document.getElementById("estadoPago").value = "pagado";
            document.getElementById("pagoModalTitle").textContent = "Nuevo Pago";
            document.getElementById("btnGuardarPago").className = "btn btn-primary-custom";
        });

        // Llenar modal para Editar Pago
        document.querySelectorAll(".btn-editar").forEach(function (btn) {
            btn.addEventListener("click", function () {
                document.getElementById("actionPago").value = "editar";
                document.getElementById("idPago").value = this.dataset.id;
                document.getElementById("reservaPagoContainer").style.display = "none";
                document.getElementById("idReserva").required = false;
                document.getElementById("metodoPago").value = this.dataset.metodo;
                document.getElementById("montoPago").value = this.dataset.monto;
                document.getElementById("montoPago").readOnly = false;
                document.getElementById("estadoPago").value = this.dataset.estado;
                document.getElementById("pagoModalTitle").textContent = "Editar Pago #" + this.dataset.id;
                document.getElementById("btnGuardarPago").className = "btn btn-warning";
            });
        });

        // Eliminar con SweetAlert2
        document.querySelectorAll(".btn-eliminar").forEach(function (btn) {
            btn.addEventListener("click", function () {
                let id = this.dataset.id;
                Swal.fire({
                    title: "¿Eliminar el pago #" + id + "?",
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