<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:if test="${empty pagos}">
    <c:redirect url="/admin/pagos"/>
</c:if>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel Admin - Pagos</title>
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
                            <c:choose>
                                <c:when test="${empty pagos}">
                                    <tr>
                                        <td colspan="8" class="text-center text-muted">No hay pagos registrados.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${pagos}" var="p">
                                        <tr>
                                            <td>${p.idPago}</td>
                                            <td>${p.nombreCliente}</td>
                                            <td>${p.nombrePaquete}</td>
                                            <td><span class="badge bg-secondary">${p.nombreMetodo}</span></td>
                                            <td>S/ ${p.monto}</td>
                                            <td>
                                                <span class="badge ${p.estado == 'pagado' ? 'bg-success' : 
                                                                     p.estado == 'rechazado' ? 'bg-danger' : 'bg-warning text-dark'}">
                                                    ${p.estado}
                                                </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty p.fechaPago}">
                                                        <fmt:formatDate value="${p.fechaPago}" pattern="yyyy-MM-dd HH:mm"/>
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${p.estado == 'reembolsado' || p.estado == 'rechazado'}">
                                                        <button class="btn btn-sm btn-secondary" disabled title="Este pago no se puede editar"><i class="bi bi-pencil"></i></button>
                                                        <button class="btn btn-sm btn-secondary" disabled title="Pago ya finalizado/rechazado"><i class="bi bi-x-circle"></i></button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button class="btn btn-sm btn-secondary-custom btn-editar" 
                                                                data-id="${p.idPago}"
                                                                data-reserva="${p.idReserva}"
                                                                data-metodo="${p.idMetodo}"
                                                                data-monto="${p.monto}"
                                                                data-estado="${p.estado}"
                                                                data-bs-toggle="modal" 
                                                                data-bs-target="#pagoModal"
                                                                title="Editar Pago">
                                                            <i class="bi bi-pencil"></i>
                                                        </button>
                                                        <button class="btn btn-sm btn-danger btn-anular" data-id="${p.idPago}" title="Rechazar/Anular Pago">
                                                            <i class="bi bi-x-circle"></i>
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
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
                    <form action="${pageContext.request.contextPath}/admin/pagos" method="post">
                        <input type="hidden" id="actionPago" name="action" value="crear">
                        <input type="hidden" id="idPago" name="id">
                        <div class="row">
                            <div class="col-md-6 mb-3" id="reservaPagoContainer">
                                <label class="form-label">Reserva</label>
                                <select class="form-select" name="id_reserva" id="idReserva" required>
                                    <option value="">Seleccionar reserva</option>
                                    <c:forEach items="${reservasPendientes}" var="r">
                                        <option value="${r.idReserva}" data-monto="${r.precioTotal}">
                                            #${r.idReserva} - ${r.nombreUsuario} - S/ ${r.precioTotal}
                                        </option>
                                    </c:forEach>
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
                                    <option value="reembolsado">Reembolsado</option>
                                    <option value="rechazado">Rechazado</option>
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

    <form id="formEliminar" action="${pageContext.request.contextPath}/admin/pagos" method="post">
        <input type="hidden" name="action" value="anular">
        <input type="hidden" id="idEliminar" name="id">
    </form>

    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="${pageContext.request.contextPath}/assets/admin/js/script.js"></script>
    <script src="${pageContext.request.contextPath}/assets/admin/js/pagos.js"></script>
</body>
</html>