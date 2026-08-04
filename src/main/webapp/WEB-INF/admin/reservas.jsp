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
        <!-- Sidebar -->
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
                <li class="active"><a href="<%=request.getContextPath()%>/admin/reservas"><i class="bi bi-calendar-check me-2"></i> Reservas</a></li>
                <li><a href="<%=request.getContextPath()%>/admin/pagos"><i class="bi bi-credit-card me-2"></i> Pagos</a></li>
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
                <button class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#reservaModal">
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
                                            <button class="btn btn-sm btn-secondary-custom" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#editModal<%= r.getIdReserva() %>">
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
    <!-- MODAL CREAR RESERVA -->
    <!-- ======================================== -->
    <div class="modal fade" id="reservaModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-primary-custom text-white">
                    <h5 class="modal-title">Nueva Reserva</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="<%=request.getContextPath()%>/admin/reservas" method="post">
                        <input type="hidden" name="action" value="crear">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Cliente</label>
                                <select class="form-select" name="id_usuario" required>
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
                                <select class="form-select" name="id_paquete" required>
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
                                <select class="form-select" name="tipo_viaje" required>
                                    <option value="idavuelta">Ida y Vuelta</option>
                                    <option value="ida">Solo Ida</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Pasajeros</label>
                                <input type="number" class="form-control" name="num_pasajeros" min="1" value="1" required>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Fecha Salida</label>
                                <input type="date" class="form-control" name="fecha_salida" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Fecha Retorno</label>
                                <input type="date" class="form-control" name="fecha_retorno">
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Precio Total (S/)</label>
                            <input type="number" step="0.01" class="form-control" name="precio_total" required placeholder="0.00">
                        </div>
                        <div class="text-end mt-3">
                            <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancelar</button>
                            <button type="submit" class="btn btn-primary-custom">Guardar Reserva</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- ========================================== -->
    <!-- MODALES EDITAR (uno por cada reserva) 		-->
    <!-- ========================================== -->
    <% for (Reserva r : reservas) { 
        if (!"pagada".equalsIgnoreCase(r.getEstado())) { %>
    <div class="modal fade" id="editModal<%= r.getIdReserva() %>" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-warning text-white">
                    <h5 class="modal-title">Editar Reserva #<%= r.getIdReserva() %></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="<%=request.getContextPath()%>/admin/reservas" method="post">
                        <input type="hidden" name="action" value="editar">
                        <input type="hidden" name="id" value="<%= r.getIdReserva() %>">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Cliente</label>
                                <select class="form-select" name="id_usuario" required>
                                    <% if (usuarios != null) {
                                        for (Usuario u : usuarios) { %>
                                        <option value="<%= u.getIdUsuario() %>" <%= (u.getIdUsuario() == r.getIdUsuario()) ? "selected" : "" %>>
                                            <%= u.getNombre() %> <%= u.getApellidos() %>
                                        </option>
                                    <%  }
                                    } %>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Paquete Turístico</label>
                                <select class="form-select" name="id_paquete" required>
                                    <% if (paquetes != null) {
                                        for (Paquete p : paquetes) { %>
                                        <option value="<%= p.getIdPaquete() %>" <%= (p.getIdPaquete() == r.getIdPaquete()) ? "selected" : "" %>>
                                            <%= p.getNombre() %>
                                        </option>
                                    <%  }
                                    } %>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Tipo de Viaje</label>
                                <select class="form-select" name="tipo_viaje" required>
                                    <option value="idavuelta" <%= ("idavuelta".equalsIgnoreCase(r.getTipoViaje()) || "roundtrip".equalsIgnoreCase(r.getTipoViaje())) ? "selected" : "" %>>Ida y Vuelta</option>
                                    <option value="ida" <%= ("ida".equalsIgnoreCase(r.getTipoViaje()) || "oneway".equalsIgnoreCase(r.getTipoViaje())) ? "selected" : "" %>>Solo Ida</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Pasajeros</label>
                                <input type="number" class="form-control" name="num_pasajeros" value="<%= r.getNumPasajeros() %>" min="1" required>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Fecha Salida</label>
                                <input type="date" class="form-control" name="fecha_salida" value="<%= r.getFechaSalida() %>" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Fecha Retorno</label>
                                <input type="date" class="form-control" name="fecha_retorno" value="<%= r.getFechaRetorno() != null ? r.getFechaRetorno() : "" %>">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Precio Total (S/)</label>
                                <input type="number" step="0.01" class="form-control" name="precio_total" value="<%= r.getPrecioTotal() %>" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Estado</label>
                                <select class="form-select" name="estado" required>
                                    <option value="pendiente" <%= "pendiente".equalsIgnoreCase(r.getEstado()) ? "selected" : "" %>>Pendiente</option>
                                    <option value="cancelada" <%= "cancelada".equalsIgnoreCase(r.getEstado()) ? "selected" : "" %>>Cancelada</option>
                                </select>
                            </div>
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
    <%  } 
    } %>

    <form id="formEliminar" action="<%=request.getContextPath()%>/admin/reservas" method="post">
        <input type="hidden" name="action" value="eliminar">
        <input type="hidden" id="idEliminar" name="id">
    </form>

    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
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