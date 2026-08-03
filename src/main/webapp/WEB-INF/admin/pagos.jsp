<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.turismo.modelo.Pago, com.turismo.modelo.Reserva" %>
<%
    List<Pago> pagos = (List<Pago>) request.getAttribute("pagos");
    if (pagos == null) {
        response.sendRedirect(request.getContextPath() + "/admin/pagos");
        return;
    }

    // ✅ Obtener reservas pendientes
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
                <button class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#pagoModal">
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
                                        <button class="btn btn-sm btn-secondary-custom" 
                                                data-bs-toggle="modal" 
                                                data-bs-target="#editModal<%= p.getIdPago() %>">
                                            <i class="bi bi-pencil"></i>
                                        </button>
                                        <a href="<%=request.getContextPath()%>/admin/pagos?action=eliminar&id=<%= p.getIdPago() %>" 
                                           class="btn btn-sm btn-danger" 
                                           onclick="return confirm('¿Eliminar el pago #<%= p.getIdPago() %>?')">
                                            <i class="bi bi-trash"></i>
                                        </a>
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
    <!-- MODAL CREAR PAGO -->
    <!-- ======================================== -->
    <div class="modal fade" id="pagoModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-primary-custom text-white">
                    <h5 class="modal-title">Nuevo Pago</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="<%=request.getContextPath()%>/admin/pagos" method="post">
                        <input type="hidden" name="action" value="crear">
                        <div class="row">
                            <div class="col-md-6 mb-3">
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
                                <select class="form-select" name="id_metodo" required>
                                    <option value="1">Tarjeta</option>
                                    <option value="2">Yape</option>
                                    <option value="3">Plin</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Estado</label>
                                <select class="form-select" name="estado" required>
                                    <option value="pagado">Pagado</option>
                                    <option value="rechazado">Rechazado</option>
                                    <option value="reembolsado">Reembolsado</option>
                                </select>
                            </div>
                        </div>
                        <div class="text-end mt-3">
                            <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancelar</button>
                            <button type="submit" class="btn btn-primary-custom">Guardar</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- ======================================== -->
    <!-- MODALES EDITAR -->
    <!-- ======================================== -->
    <% for (Pago p : pagos) { %>
    <div class="modal fade" id="editModal<%= p.getIdPago() %>" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-warning text-white">
                    <h5 class="modal-title">Editar Pago #<%= p.getIdPago() %></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="<%=request.getContextPath()%>/admin/pagos" method="post">
                        <input type="hidden" name="action" value="editar">
                        <input type="hidden" name="id" value="<%= p.getIdPago() %>">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Método de Pago</label>
                                <select class="form-select" name="id_metodo" required>
                                    <option value="1" <%= p.getIdMetodo() == 1 ? "selected" : "" %>>Tarjeta</option>
                                    <option value="2" <%= p.getIdMetodo() == 2 ? "selected" : "" %>>Yape</option>
                                    <option value="3" <%= p.getIdMetodo() == 3 ? "selected" : "" %>>Plin</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Monto (S/)</label>
                                <input type="number" step="0.01" class="form-control" name="monto" value="<%= p.getMonto() %>" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Estado</label>
                            <select class="form-select" name="estado" required>
                                <option value="pagado" <%= "pagado".equals(p.getEstado()) ? "selected" : "" %>>Pagado</option>
                                <option value="rechazado" <%= "rechazado".equals(p.getEstado()) ? "selected" : "" %>>Rechazado</option>
                                <option value="reembolsado" <%= "reembolsado".equals(p.getEstado()) ? "selected" : "" %>>Reembolsado</option>
                            </select>
                            <small class="text-muted">⚠️ Cambiar el estado actualizará automáticamente el estado de la reserva.</small>
                        </div>
                        <div class="text-end mt-3">
                            <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancelar</button>
                            <button type="submit" class="btn btn-warning">Actualizar</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <% } %>

    <script>
        // ✅ Auto-completar monto al seleccionar reserva
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
    </script>

    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"></script>
    <script src="js/script.js"></script>
</body>
</html>