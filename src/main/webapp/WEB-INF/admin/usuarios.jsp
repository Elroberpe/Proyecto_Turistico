<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.turismo.modelo.Usuario" %>
<%
    List<Usuario> usuarios = (List<Usuario>) request.getAttribute("usuarios");
    if (usuarios == null) {
        response.sendRedirect(request.getContextPath() + "/admin/usuarios");
        return;
    }

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
    <title>Panel Admin - Usuarios</title>
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
                <li class="active"><a href="<%=request.getContextPath()%>/admin/usuarios"><i class="bi bi-people me-2"></i> Usuarios</a></li>
                <li><a href="<%=request.getContextPath()%>/admin/reservas"><i class="bi bi-calendar-check me-2"></i> Reservas</a></li>
                <li><a href="<%=request.getContextPath()%>/admin/pagos"><i class="bi bi-credit-card me-2"></i> Pagos</a></li>
            </ul>
        </nav>

        <!-- Page Content -->
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
                <h2>Gestión de Usuarios</h2>
                <button class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#usuarioModal">
                    <i class="bi bi-person-plus"></i> Nuevo Usuario
                </button>
            </div>
            
            <div class="card p-4">
                <div class="table-responsive">
                    <table class="table table-hover table-custom align-middle">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Nombres</th>
                                <th>Apellidos</th>
                                <th>Email</th>
                                <th>Teléfono</th>
                                <th>Rol</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (usuarios.isEmpty()) { %>
                                <tr>
                                    <td colspan="7" class="text-center text-muted">No hay usuarios registrados.</td>
                                </tr>
                            <% } else { %>
                                <% for (Usuario u : usuarios) { %>
                                <tr>
                                    <td><%= u.getIdUsuario() %></td>
                                    <td><%= u.getNombre() %></td>
                                    <td><%= u.getApellidos() %></td>
                                    <td><%= u.getEmail() %></td>
                                    <td><%= u.getTelefono() != null ? u.getTelefono() : "-" %></td>
                                    <td>
                                        <span class="badge <%= u.getIdRol() == 2 ? "bg-primary" : "bg-secondary" %>">
                                            <%= u.getIdRol() == 2 ? "Administrador" : "Cliente" %>
                                        </span>
                                    </td>
                                    <td>
                                        <button class="btn btn-sm btn-secondary-custom" 
                                                data-bs-toggle="modal" 
                                                data-bs-target="#editModal<%= u.getIdUsuario() %>">
                                            <i class="bi bi-pencil"></i>
                                        </button>
                                        <a href="<%=request.getContextPath()%>/admin/usuarios?action=eliminar&id=<%= u.getIdUsuario() %>" 
                                           class="btn btn-sm btn-danger" 
                                           onclick="return confirm('¿Eliminar el usuario <%= u.getNombre() %>?')">
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
    <!-- MODAL CREAR USUARIO -->
    <!-- ======================================== -->
    <div class="modal fade" id="usuarioModal" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header bg-primary-custom text-white">
            <h5 class="modal-title">Nuevo Usuario</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <form action="<%=request.getContextPath()%>/admin/usuarios" method="post">
              <input type="hidden" name="action" value="crear">
              <div class="row">
                  <div class="col-md-6 mb-3">
                    <label class="form-label">Nombres</label>
                    <input type="text" class="form-control" name="nombre" required>
                  </div>
                  <div class="col-md-6 mb-3">
                    <label class="form-label">Apellidos</label>
                    <input type="text" class="form-control" name="apellidos" required>
                  </div>
              </div>
              <div class="row">
                  <div class="col-md-6 mb-3">
                    <label class="form-label">Correo Electrónico</label>
                    <input type="email" class="form-control" name="email" required>
                  </div>
                  <div class="col-md-6 mb-3">
                    <label class="form-label">Teléfono</label>
                    <input type="text" class="form-control" name="telefono">
                  </div>
              </div>
              <div class="row">
                  <div class="col-md-6 mb-3">
                    <label class="form-label">Contraseña</label>
                    <input type="password" class="form-control" name="password" required>
                  </div>
                  <div class="col-md-6 mb-3">
                    <label class="form-label">Rol</label>
                    <select class="form-select" name="id_rol" required>
                        <option value="2">Administrador</option>
                        <option value="1">Cliente</option>
                    </select>
                  </div>
              </div>
              <div class="text-end mt-3">
                  <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancelar</button>
                  <button type="submit" class="btn btn-primary-custom">Guardar Usuario</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>

    <!-- ========================================== -->
    <!-- MODALES EDITAR (uno por cada usuario) 		-->
    <!-- ========================================== -->
    <% for (Usuario u : usuarios) { %>
    <div class="modal fade" id="editModal<%= u.getIdUsuario() %>" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-warning text-white">
                    <h5 class="modal-title">Editar Usuario: <%= u.getNombre() %></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="<%=request.getContextPath()%>/admin/usuarios" method="post">
                        <input type="hidden" name="action" value="editar">
                        <input type="hidden" name="id" value="<%= u.getIdUsuario() %>">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Nombres</label>
                                <input type="text" class="form-control" name="nombre" value="<%= u.getNombre() %>" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Apellidos</label>
                                <input type="text" class="form-control" name="apellidos" value="<%= u.getApellidos() %>" required>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Email</label>
                                <input type="email" class="form-control" name="email" value="<%= u.getEmail() %>" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Teléfono</label>
                                <input type="text" class="form-control" name="telefono" value="<%= u.getTelefono() != null ? u.getTelefono() : "" %>">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Rol</label>
                                <select class="form-select" name="id_rol">
                                    <option value="2" <%= u.getIdRol() == 2 ? "selected" : "" %>>Administrador</option>
                                    <option value="1" <%= u.getIdRol() == 1 ? "selected" : "" %>>Cliente</option>
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
    <% } %>

    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"></script>
</body>
</html>
