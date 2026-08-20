<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:if test="${empty categorias}">
    <c:redirect url="/admin/categorias"/>
</c:if>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Turístico - Categorías de Paquetes</title>
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
                <h2>Categorías de Paquetes</h2>
                <button id="btnNuevo" class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#categoriaModal">
                    <i class="bi bi-plus-circle"></i> Nueva Categoría
                </button>
            </div>

            <div class="card p-4">
                <div class="table-responsive">
                    <table class="table table-hover table-custom align-middle">
                        <thead>
                            <tr>
                                <th>ID Categoría</th>
                                <th>Nombre</th>
                                <th>Descripción</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty categorias}">
                                    <tr>
                                        <td colspan="4" class="text-center text-muted">No hay categorías registradas.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${categorias}" var="categoria">
                                        <tr>
                                            <td>${categoria.idCategoria}</td>
                                            <td>${categoria.nombre}</td>
                                            <td>${categoria.descripcion}</td>
                                            <td>
                                                <button class="btn btn-sm btn-secondary-custom btn-editar"
                                                        data-id="${categoria.idCategoria}"
                                                        data-nombre="${categoria.nombre}"
                                                        data-descripcion="${categoria.descripcion}"
                                                        data-bs-toggle="modal"
                                                        data-bs-target="#categoriaModal">
                                                    <i class="bi bi-pencil"></i>
                                                </button>
                                                <button data-id="${categoria.idCategoria}"
                                                        class="btn btn-sm btn-danger btn-eliminar">
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

    <!-- Modal Formulario Categoría -->
    <div class="modal fade" id="categoriaModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-primary-custom text-white">
                    <h5 class="modal-title">Detalle de Categoría</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="${pageContext.request.contextPath}/admin/categorias" method="post">
                        <input id="accion" type="hidden" name="accion" value="guardar">
                        <input id="idCategoria" type="hidden" name="id">
                        <div class="mb-3">
                            <label class="form-label">Nombre de Categoría</label>
                            <input id="nombre" type="text" class="form-control" name="nombre" placeholder="Ej. Selva" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Descripción</label>
                            <textarea id="descripcion" class="form-control" name="descripcion" rows="3" required></textarea>
                        </div>
                        <div class="text-end mt-3">
                            <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancelar</button>
                            <button type="submit" class="btn btn-primary-custom">Guardar Cambios</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <form id="formEliminar" action="${pageContext.request.contextPath}/admin/categorias" method="post">
        <input type="hidden" name="accion" value="eliminar">
        <input type="hidden" id="idEliminar" name="id">
    </form>

    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="${pageContext.request.contextPath}/assets/admin/js/script.js"></script>
    <script src="${pageContext.request.contextPath}/assets/admin/js/categorias.js"></script>
</body>
</html>