<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:if test="${empty paquetes}">
    <c:redirect url="/admin/paquetes"/>
</c:if>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel Admin Turístico - Paquetes</title>
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

            <c:if test="${not empty sessionScope.mensaje}">
                <div class="alert alert-success alert-dismissible fade show mb-4" role="alert">
                    ${sessionScope.mensaje}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="mensaje" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
                    ${sessionScope.error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="error" scope="session"/>
            </c:if>

            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Gestión de Paquetes</h2>
                <button id="btnNuevo" class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#paqueteModal">
                    <i class="bi bi-plus-circle"></i> Nuevo Paquete
                </button>
            </div>
            
            <div class="card p-4">
                <div class="table-responsive">
                    <table class="table table-hover table-custom align-middle">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Categoría</th>
                                <th>Nombre</th>
                                <th>Destino</th>
                                <th>Precio (S/)</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty paquetes}">
                                    <tr>
                                        <td colspan="7" class="text-center text-muted">No hay paquetes registrados.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${paquetes}" var="paquete">
                                        <tr>
                                            <td>${paquete.idPaquete}</td>
                                            <td>${not empty paquete.categoriaNombre ? paquete.categoriaNombre : 'Sin categoría'}</td>
                                            <td>${paquete.nombre}</td>
                                            <td>${paquete.destino}</td>
                                            <td>${paquete.precioSoles}</td>
                                            <td>
                                                <span class="badge ${paquete.estado == 'activo' ? 'bg-success' : 'bg-danger'}">
                                                    ${paquete.estado}
                                                </span>
                                            </td>
                                            <td>
                                                <button class="btn btn-sm btn-secondary-custom btn-editar" 
                                                        data-id="${paquete.idPaquete}"
                                                        data-nombre="${paquete.nombre}"
                                                        data-categoria="${paquete.idCategoria}"
                                                        data-destino="${paquete.destino}"
                                                        data-precio="${paquete.precioSoles}"
                                                        data-descripcion="${not empty paquete.descripcion ? paquete.descripcion : ''}"
                                                        data-imagen="${not empty paquete.imagenUrl ? paquete.imagenUrl : ''}"
                                                        data-estado="${paquete.estado}"
                                                        data-bs-toggle="modal" data-bs-target="#paqueteModal"><i class="bi bi-pencil"></i></button>
                                                <button class="btn btn-sm btn-danger btn-eliminar" data-id="${paquete.idPaquete}" data-nombre="${paquete.nombre}">
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

    <!-- Modal Formulario Paquete -->
    <div class="modal fade" id="paqueteModal" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header bg-primary-custom text-white">
            <h5 class="modal-title" id="modalTitle">Detalle de Paquete</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <form action="${pageContext.request.contextPath}/admin/paquetes" method="post">
                <input id="action" type="hidden" name="action" value="crear">
                <input type="hidden" id="id" name="id">
            
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="nombre" class="form-label">Nombre del Paquete</label>
                        <input id="nombre" type="text" class="form-control" name="nombre" required>
                    </div>
            
                    <div class="col-md-6 mb-3">
                        <label for="idCategoria" class="form-label">Categoría</label>
                        <select id="idCategoria" class="form-select" name="id_categoria" required>
                            <option value="">Seleccione Categoría</option>
                            <c:forEach items="${categorias}" var="categoria">
                                <option value="${categoria.idCategoria}">
                                    ${categoria.nombre}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
            
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="destino" class="form-label">Destino</label>
                        <input id="destino" type="text" class="form-control" name="destino" required>
                    </div>
            
                    <div class="col-md-6 mb-3">
                        <label for="precioSoles" class="form-label">Precio (Soles)</label>
                        <input id="precioSoles" type="number" step="0.01" class="form-control" name="precio_soles" required>
                    </div>
                </div>
            
                <div class="mb-3">
                    <label for="descripcion" class="form-label">Descripción</label>
                    <textarea id="descripcion" class="form-control" name="descripcion" rows="3" required></textarea>
                </div>
            
                <div class="row">
                    <div class="col-md-8 mb-3">
                        <label for="imagenUrl" class="form-label">URL de Imagen</label>
                        <input id="imagenUrl" type="text" class="form-control" name="imagenUrl" placeholder="https://ejemplo.com/imagen.jpg">
                    </div>
            
                    <div class="col-md-4 mb-3">
                        <label for="estado" class="form-label">Estado</label>
                        <select id="estado" class="form-select" name="estado" required>
                            <option value="activo">Activo</option>
                            <option value="inactivo">Inactivo</option>
                        </select>
                    </div>
                </div>
            
                <div class="text-end mt-3">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">
                        Cancelar
                    </button>
            
                    <button type="submit" class="btn btn-primary-custom">
                        Guardar Paquete
                    </button>
                </div>
            </form>
          </div>
        </div>
      </div>
    </div>
    
    <form id="formEliminar" action="${pageContext.request.contextPath}/admin/paquetes" method="post">
        <input type="hidden" name="action" value="eliminar">
        <input type="hidden" id="idEliminar" name="id">
    </form>

    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="${pageContext.request.contextPath}/assets/admin/js/script.js"></script>
    <script src="${pageContext.request.contextPath}/assets/admin/js/paquetes.js"></script>
</body>
</html>
