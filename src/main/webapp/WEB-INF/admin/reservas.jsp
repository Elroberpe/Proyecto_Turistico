<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:if test="${empty reservas}">
    <c:redirect url="/admin/reservas"/>
</c:if>
<jsp:useBean id="now" class="java.util.Date"/>
<fmt:formatDate value="${now}" pattern="yyyy-MM-dd" var="minDate"/>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel Admin - Reservas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/admin/css/style.css">
</head>
<body>
    <div class="d-flex">
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
                                <th>Fecha Reserva</th>
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
                            <c:choose>
                                <c:when test="${empty reservas}">
                                    <tr><td colspan="11" class="text-center text-muted">No hay reservas registradas.</td></tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${reservas}" var="r">
                                        <tr>
                                            <td>#${r.idReserva}</td>
                                            <td>${not empty r.nombreUsuario ? r.nombreUsuario : 'ID #'.concat(r.idUsuario)}</td>
                                            <td>${not empty r.nombrePaquete ? r.nombrePaquete : 'ID #'.concat(r.idPaquete)}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty r.fechaReserva}">
                                                        <fmt:formatDate value="${r.fechaReserva}" pattern="dd/MM/yyyy"/>
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${r.tipoViaje == 'idavuelta' || r.tipoViaje == 'roundtrip' ? 'Ida y Vuelta' : 'Solo Ida'}</td>
                                            <td>${r.fechaSalida}</td>
                                            <td>${not empty r.fechaRetorno ? r.fechaRetorno : '-'}</td>
                                            <td>${r.numPasajeros}</td>
                                            <td class="fw-bold">S/ ${r.precioTotal}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${r.estado.equalsIgnoreCase('completado') or r.estado.equalsIgnoreCase('completada')}">
                                                        <span class="badge bg-info text-dark">Completado</span>
                                                    </c:when>
                                                    <c:when test="${r.estado.equalsIgnoreCase('pagada')}">
                                                        <span class="badge bg-success">Pagada</span>
                                                    </c:when>
                                                    <c:when test="${r.estado.equalsIgnoreCase('pendiente')}">
                                                        <span class="badge bg-warning text-dark">Pendiente</span>
                                                    </c:when>
                                                    <c:when test="${r.estado.equalsIgnoreCase('cancelada')}">
                                                        <span class="badge bg-danger">Cancelada</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">${r.estado}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${r.estado.equalsIgnoreCase('pendiente')}">
                                                        <button class="btn btn-sm btn-secondary-custom btn-editar" 
                                                                data-id="${r.idReserva}"
                                                                data-usuario="${r.idUsuario}"
                                                                data-paquete="${r.idPaquete}"
                                                                data-tipoviaje="${r.tipoViaje}"
                                                                data-pasajeros="${r.numPasajeros}"
                                                                data-salida="${r.fechaSalida}"
                                                                data-retorno="${not empty r.fechaRetorno ? r.fechaRetorno : ''}"
                                                                data-total="${r.precioTotal}"
                                                                data-estado="${r.estado}"
                                                                data-bs-toggle="modal" data-bs-target="#reservaModal"
                                                                title="Editar Reserva">
                                                            <i class="bi bi-pencil"></i>
                                                        </button>
                                                        <button class="btn btn-sm btn-danger btn-eliminar" data-id="${r.idReserva}" title="Eliminar Reserva">
                                                            <i class="bi bi-trash"></i>
                                                        </button>
                                                    </c:when>
                                                    <c:when test="${r.estado.equalsIgnoreCase('completado') or r.estado.equalsIgnoreCase('completada')}">
                                                        <button class="btn btn-sm btn-secondary" disabled title="Reserva completada"><i class="bi bi-pencil"></i></button>
                                                        <button class="btn btn-sm btn-secondary" disabled title="No se puede eliminar una reserva completada"><i class="bi bi-trash"></i></button>
                                                    </c:when>
                                                    <c:when test="${r.estado.equalsIgnoreCase('pagada')}">
                                                        <button class="btn btn-sm btn-secondary" disabled title="Reserva pagada (gestionada desde Pagos)"><i class="bi bi-pencil"></i></button>
                                                        <button class="btn btn-sm btn-secondary" disabled title="No se puede eliminar una reserva pagada"><i class="bi bi-trash"></i></button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button class="btn btn-sm btn-secondary" disabled title="Reserva cancelada"><i class="bi bi-pencil"></i></button>
                                                        <button class="btn btn-sm btn-secondary" disabled title="No se puede eliminar una reserva cancelada"><i class="bi bi-trash"></i></button>
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
    <!-- MODAL ÚNICO (NUEVA / EDICIÓN)           -->
    <!-- ======================================== -->
    <div class="modal fade" id="reservaModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-primary-custom text-white">
                    <h5 class="modal-title" id="reservaModalTitle">Nueva Reserva</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="${pageContext.request.contextPath}/admin/reservas" method="post" id="formReserva">
                        <input type="hidden" id="actionReserva" name="action" value="crear">
                        <input type="hidden" id="idReserva" name="id">

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Cliente</label>
                                <select class="form-select" id="usuarioReserva" name="id_usuario" required>
                                    <option value="">Seleccionar cliente</option>
                                    <c:forEach items="${usuarios}" var="u">
                                        <option value="${u.idUsuario}">
                                            ${u.nombre} ${u.apellidos} (${u.email})
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Filtrar por Región</label>
                                <select class="form-select" id="filtroCategoria">
                                    <option value="0">Todas las regiones</option>
                                    <c:forEach items="${categorias}" var="cat">
                                        <option value="${cat.idCategoria}">${cat.nombre}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Paquete Turístico</label>
                                <select class="form-select" id="paqueteReserva" name="id_paquete" required>
                                    <option value="">Seleccionar paquete</option>
                                    <c:forEach items="${paquetes}" var="p">
                                        <option value="${p.idPaquete}" 
                                                data-precio="${p.precioSoles}"
                                                data-categoria="${p.idCategoria}">
                                            ${p.nombre} - S/ ${p.precioSoles}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Tipo de Viaje</label>
                                <select class="form-select" id="tipoViajeReserva" name="tipo_viaje" required>
                                    <option value="idavuelta">Ida y Vuelta</option>
                                    <option value="ida">Solo Ida</option>
                                </select>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Pasajeros</label>
                                <input type="number" class="form-control" id="numPasajerosReserva" name="num_pasajeros" min="1" value="1" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Precio Total (S/)</label>
                                <input type="number" step="0.01" class="form-control bg-light" id="precioTotalReserva" name="precio_total" required placeholder="0.00" readonly>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Fecha Salida</label>
                                <input type="date" class="form-control" id="fechaSalidaReserva" name="fecha_salida" required
                                       min="${minDate}">
                            </div>
                            <div class="col-md-6 mb-3" id="divFechaRetorno">
                                <label class="form-label">Fecha Retorno <span id="retornoObligatorio" style="color:red;">*</span></label>
                                <input type="date" class="form-control" id="fechaRetornoReserva" name="fecha_retorno">
                            </div>
                        </div>

                        <div class="row">
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

    <form id="formEliminar" action="${pageContext.request.contextPath}/admin/reservas" method="post">
        <input type="hidden" name="action" value="eliminar">
        <input type="hidden" id="idEliminar" name="id">
    </form>

    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="${pageContext.request.contextPath}/assets/admin/js/script.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/calculo-reserva.js?v=1.0"></script>
    <script src="${pageContext.request.contextPath}/assets/admin/js/reservas.js?v=1.1"></script>
</body>
</html>
