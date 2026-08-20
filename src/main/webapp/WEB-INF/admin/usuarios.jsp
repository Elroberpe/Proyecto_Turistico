<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:if test="${empty usuarios}">
    <c:redirect url="/admin/usuarios"/>
</c:if>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel Admin - Usuarios</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/admin/css/style.css">
</head>
<body>
    <div class="d-flex">
        <!-- Sidebar Reutilizable -->
        <jsp:include page="componentes/sidebar.jsp" />

        <!-- Page Content -->
        <div id="content">
            <jsp:include page="componentes/topbar.jsp" />

            <!-- Mensajes de éxito/error -->
            <c:if test="${not empty sessionScope.mensaje}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle me-2"></i> ${sessionScope.mensaje}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="mensaje" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle me-2"></i> ${sessionScope.error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="error" scope="session"/>
            </c:if>

            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Gestión de Usuarios</h2>
                <button id="btnNuevo" class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#usuarioModal">
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
                            <c:choose>
                                <c:when test="${empty usuarios}">
                                    <tr>
                                        <td colspan="7" class="text-center text-muted">No hay usuarios registrados.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${usuarios}" var="u">
                                        <tr>
                                            <td>${u.idUsuario}</td>
                                            <td>${u.nombre}</td>
                                            <td>${u.apellidos}</td>
                                            <td>${u.email}</td>
                                            <td>${not empty u.telefono ? u.telefono : '-'}</td>
                                            <td>
                                                <span class="badge ${u.idRol == 2 ? 'bg-primary' : 'bg-secondary'}">
                                                    ${u.idRol == 2 ? 'Administrador' : 'Cliente'}
                                                </span>
                                            </td>
                                            <td>
                                                <button class="btn btn-sm btn-secondary-custom btn-editar" 
                                                        data-id="${u.idUsuario}"
                                                        data-nombre="${u.nombre}"
                                                        data-apellidos="${u.apellidos}"
                                                        data-email="${u.email}"
                                                        data-telefono="${not empty u.telefono ? u.telefono : ''}"
                                                        data-rol="${u.idRol}"
                                                        data-bs-toggle="modal" 
                                                        data-bs-target="#usuarioModal">
                                                    <i class="bi bi-pencil"></i>
                                                </button>
                                                <button class="btn btn-sm btn-danger btn-eliminar" data-id="${u.idUsuario}" data-nombre="${u.nombre}">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- ======================================== -->
    <!-- MODAL ÚNICO USUARIO (CREAR / EDITAR) -->
    <!-- ======================================== -->
    <div class="modal fade" id="usuarioModal" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header bg-primary-custom text-white" id="modalHeader">
            <h5 class="modal-title" id="usuarioModalTitle">Nuevo Usuario</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <form action="${pageContext.request.contextPath}/admin/usuarios" method="post">
              <input type="hidden" id="actionUsuario" name="action" value="crear">
              <input type="hidden" id="idUsuario" name="id">
              <div class="row">
                  <div class="col-md-6 mb-3">
                    <label class="form-label">Nombres</label>
                    <input type="text" class="form-control" id="nombreUsuario" name="nombre" required>
                  </div>
                  <div class="col-md-6 mb-3">
                    <label class="form-label">Apellidos</label>
                    <input type="text" class="form-control" id="apellidosUsuario" name="apellidos" required>
                  </div>
              </div>
              <div class="row">
                  <div class="col-md-6 mb-3">
                    <label class="form-label">Correo Electrónico</label>
                    <input type="email" class="form-control" id="emailUsuario" name="email" required>
                  </div>
                  <div class="col-md-6 mb-3">
                    <label class="form-label">Teléfono</label>
                    <input type="text" class="form-control" id="telefonoUsuario" name="telefono">
                  </div>
              </div>
              <div class="row">
                  <div class="col-md-6 mb-3" id="passwordContainer">
                    <label class="form-label">Contraseña</label>
                    <input type="password" class="form-control" id="passwordUsuario" name="password">
                  </div>
                  <div class="col-md-6 mb-3">
                    <label class="form-label">Rol</label>
                    <select class="form-select" id="rolUsuario" name="id_rol" required>
                        <option value="2">Administrador</option>
                        <option value="1">Cliente</option>
                    </select>
                  </div>
              </div>
              <div class="text-end mt-3">
                  <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancelar</button>
                  <button type="submit" class="btn btn-primary-custom" id="btnGuardarModal">Guardar Usuario</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>

    <form id="formEliminar" action="${pageContext.request.contextPath}/admin/usuarios" method="post">
        <input type="hidden" name="action" value="eliminar">
        <input type="hidden" id="idEliminar" name="id">
    </form>

    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="${pageContext.request.contextPath}/assets/admin/js/script.js"></script>
    <script src="${pageContext.request.contextPath}/assets/admin/js/usuarios.js"></script>
</body>
</html>
