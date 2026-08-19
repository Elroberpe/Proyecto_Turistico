<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:if test="${empty clientes}">
    <c:redirect url="/admin/clientes"/>
</c:if>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel Admin - Clientes</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/admin/css/style.css">
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

            <!-- Mensajes -->
            <c:if test="${not empty sessionScope.mensaje}">
                <div class="alert alert-success alert-dismissible fade show">
                    <i class="bi bi-check-circle me-2"></i> ${sessionScope.mensaje}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="mensaje" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-danger alert-dismissible fade show">
                    <i class="bi bi-exclamation-triangle me-2"></i> ${sessionScope.error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="error" scope="session"/>
            </c:if>

            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Gestión de Clientes</h2>
                <button id="btnNuevo" class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#clienteModal">
                    <i class="bi bi-plus-circle"></i> Nuevo Cliente
                </button>
            </div>

            <div class="card p-4">
                <div class="table-responsive">
                    <table class="table table-hover table-custom align-middle">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Nombre</th>
                                <th>Apellidos</th>
                                <th>Email</th>
                                <th>Teléfono</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty clientes}">
                                    <tr>
                                        <td colspan="6" class="text-center text-muted">No hay clientes registrados.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${clientes}" var="u">
                                        <tr>
                                            <td>${u.idUsuario}</td>
                                            <td>${u.nombre}</td>
                                            <td>${u.apellidos}</td>
                                            <td>${u.email}</td>
                                            <td>${not empty u.telefono ? u.telefono : '-'}</td>
                                            <td>
                                                <button class="btn btn-sm btn-secondary-custom btn-editar" 
                                                        data-id="${u.idUsuario}"
                                                        data-nombre="${u.nombre}"
                                                        data-apellidos="${u.apellidos}"
                                                        data-email="${u.email}"
                                                        data-telefono="${not empty u.telefono ? u.telefono : ''}"
                                                        data-bs-toggle="modal" 
                                                        data-bs-target="#clienteModal">
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
    <!-- MODAL ÚNICO CLIENTE (CREAR / EDITAR) -->
    <!-- ======================================== -->
    <div class="modal fade" id="clienteModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-primary-custom text-white">
                    <h5 class="modal-title" id="clienteModalTitle">Nuevo Cliente</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="${pageContext.request.contextPath}/admin/clientes" method="post">
                        <input type="hidden" id="actionCliente" name="action" value="crear">
                        <input type="hidden" id="idCliente" name="id">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Nombre</label>
                                <input type="text" class="form-control" id="nombreCliente" name="nombre" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Apellidos</label>
                                <input type="text" class="form-control" id="apellidosCliente" name="apellidos" required>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Email</label>
                                <input type="email" class="form-control" id="emailCliente" name="email" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Teléfono</label>
                                <input type="text" class="form-control" id="telefonoCliente" name="telefono">
                            </div>
                        </div>
                        <div class="row" id="passwordContainerCliente">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Contraseña</label>
                                <input type="password" class="form-control" id="passwordCliente" name="password">
                            </div>
                        </div>
                        <div class="text-end mt-3">
                            <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancelar</button>
                            <button type="submit" class="btn btn-primary-custom" id="btnGuardarCliente">Guardar</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <form id="formEliminar" action="${pageContext.request.contextPath}/admin/clientes" method="post">
        <input type="hidden" name="action" value="eliminar">
        <input type="hidden" id="idEliminar" name="id">
    </form>

    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="${pageContext.request.contextPath}/assets/admin/js/script.js"></script>
    <script>
        // Limpiar campos para Nuevo Cliente
        document.getElementById("btnNuevo").addEventListener("click", function () {
            document.getElementById("actionCliente").value = "crear";
            document.getElementById("idCliente").value = "";
            document.getElementById("nombreCliente").value = "";
            document.getElementById("apellidosCliente").value = "";
            document.getElementById("emailCliente").value = "";
            document.getElementById("telefonoCliente").value = "";
            document.getElementById("passwordCliente").value = "";
            document.getElementById("passwordCliente").required = true;
            document.getElementById("passwordContainerCliente").style.display = "block";
            document.getElementById("clienteModalTitle").textContent = "Nuevo Cliente";
            document.getElementById("btnGuardarCliente").className = "btn btn-primary-custom";
        });

        // Llenar campos para Editar Cliente
        document.querySelectorAll(".btn-editar").forEach(boton => {
            boton.addEventListener("click", function () {
                document.getElementById("actionCliente").value = "editar";
                document.getElementById("idCliente").value = this.dataset.id;
                document.getElementById("nombreCliente").value = this.dataset.nombre;
                document.getElementById("apellidosCliente").value = this.dataset.apellidos;
                document.getElementById("emailCliente").value = this.dataset.email;
                document.getElementById("telefonoCliente").value = this.dataset.telefono;
                document.getElementById("passwordCliente").required = false;
                document.getElementById("passwordContainerCliente").style.display = "none";
                document.getElementById("clienteModalTitle").textContent = "Editar Cliente: " + this.dataset.nombre;
                document.getElementById("btnGuardarCliente").className = "btn btn-warning";
            });
        });

        // Eliminar con SweetAlert2
        document.querySelectorAll(".btn-eliminar").forEach(boton => {
            boton.addEventListener("click", function () {
                let id = this.dataset.id;
                let nombre = this.dataset.nombre || "el cliente";
                Swal.fire({
                    title: "¿Eliminar cliente?",
                    text: "Esta acción eliminará a " + nombre + ". ¿Deseas continuar?",
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