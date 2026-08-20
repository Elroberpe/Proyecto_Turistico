<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:if test="${empty sessionScope.usuario}">
    <c:redirect url="/login"/>
</c:if>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chasqui PERÚ | Mis Reservas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/style.css?v=2.0">
</head>
<body>

    <!-- NAVBAR -->
    <jsp:include page="componentes/navbar.jsp"></jsp:include>

    <!-- CONTENIDO PRINCIPAL -->
    <div class="container py-5" style="margin-top: 100px; min-height: 75vh;">
        
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="fw-bold text-dark mb-1">
                    <i class="bi bi-journal-bookmark text-primary me-2"></i> Mis Reservas
                </h2>
                <p class="text-muted small mb-0">Gestiona y revisa el estado de todos tus viajes contratados</p>
            </div>
            <a href="index.jsp" class="btn text-primary rounded-pill btn-sm">
                Explorar Más Paquetes
            </a>
        </div>

        <!-- ALERTAS DE SESIÓN -->
        <c:if test="${not empty sessionScope.mensaje}">
            <div class="alert alert-success alert-dismissible fade show shadow-sm rounded-4 mb-4" role="alert">
                ${sessionScope.mensaje}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="mensaje" scope="session"/>
        </c:if>

        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm rounded-4 mb-4" role="alert">
                ${sessionScope.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="error" scope="session"/>
        </c:if>

        <!-- LISTADO DE RESERVAS -->
        <c:choose>
            <c:when test="${empty reservas}">
                <div class="bg-white text-center p-5 shadow-sm rounded-4 border-0">
                    <div class="mb-3 text-muted">
                        <i class="bi bi-ticket-perforated fs-1"></i>
                    </div>
                    <h4 class="fw-bold text-dark">No tienes reservas activas</h4>
                    <p class="text-muted small mb-4">Explora nuestros paquetes turísticos y planea tu próxima aventura en el Perú.</p>
                    <a href="index.jsp" class="btn btn-primary-custom rounded-pill px-4 fw-bold">
                        Ver Destinos Turísticos
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="bg-light text-muted small text-uppercase">
                                <tr>
                                    <th class="ps-4">ID</th>
                                    <th>Paquete Turístico</th>
                                    <th>Fecha Reserva</th>
                                    <th>Tipo Viaje</th>
                                    <th>Fecha Salida</th>
                                    <th>Fecha Retorno</th>
                                    <th>Pasajeros</th>
                                    <th>Total (S/)</th>
                                    <th>Estado</th>
                                    <th class="text-end pe-4">Acción</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${reservas}" var="r">
                                    <c:set var="viajeIniciado" value="${not empty r.fechaSalida and not empty fechaHoy and not r.fechaSalida.after(fechaHoy)}"/>
                                    <c:set var="esCancelable" value="${(r.estado == 'pagada' or r.estado == 'pendiente') and not viajeIniciado}"/>
                                    <c:set var="total" value="${r.precioTotal != null ? r.precioTotal : 0}"/>
                                    <c:set var="subtotal" value="${total / 1.18}"/>
                                    <c:set var="igv" value="${total - subtotal}"/>
                                    <tr>
                                        <td class="ps-4 fw-bold text-muted">#${r.idReserva}</td>
                                        <td class="fw-bold text-dark">
                                            ${not empty r.nombrePaquete ? r.nombrePaquete : 'Paquete #'.concat(r.idPaquete)}
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty r.fechaReserva}">
                                                    <fmt:formatDate value="${r.fechaReserva}" pattern="dd/MM/yyyy"/>
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <span class="badge bg-light text-dark border">
                                                ${r.tipoViaje == 'idavuelta' || r.tipoViaje == 'roundtrip' ? 'Ida y Vuelta' : 'Solo Ida'}
                                            </span>
                                        </td>
                                        <td>${r.fechaSalida}</td>
                                        <td>${not empty r.fechaRetorno ? r.fechaRetorno : '-'}</td>
                                        <td class="text-center">${r.numPasajeros}</td>
                                        <td class="fw-bold text-primary">S/ <fmt:formatNumber value="${total}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${r.estado.equalsIgnoreCase('cancelada')}">
                                                    <span class="badge bg-danger px-3">Cancelada</span>
                                                </c:when>
                                                <c:when test="${r.estado.equalsIgnoreCase('completado') or r.estado.equalsIgnoreCase('completada')}">
                                                    <span class="badge bg-info text-dark px-3">Completado</span>
                                                </c:when>
                                                <c:when test="${r.estado.equalsIgnoreCase('pagada')}">
                                                    <span class="badge bg-success px-3">Pagada</span>
                                                </c:when>
                                                <c:when test="${r.estado.equalsIgnoreCase('pendiente')}">
                                                    <span class="badge bg-warning text-dark px-3">Pendiente</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary px-3">${r.estado}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end pe-4">
                                            <div class="d-inline-flex gap-1 align-items-center">
                                                <button type="button" class="btn btn-sm btn-secondary"
                                                        data-bs-toggle="modal" data-bs-target="#modalDetalle${r.idReserva}">
                                                    <i class="bi bi-receipt me-1"></i> Ver
                                                </button>
                                                <button type="button" class="btn btn-sm ${esCancelable ? 'btn-danger btn-cancelar' : 'btn-secondary'}"
                                                        data-id="${r.idReserva}"
                                                        data-paquete="${not empty r.nombrePaquete ? r.nombrePaquete : 'Paquete #'.concat(r.idPaquete)}"
                                                        ${esCancelable ? '' : 'disabled title="No se puede cancelar"'}>
                                                    <i class="bi bi-x-lg me-1"></i> Cancelar
                                                </button>
                                            </div>
                                        </td>
                                    </tr>

                                    <!-- MODAL DETALLE DE LA RESERVA (REUTILIZANDO PAYMENT-CARD) -->
                                    <div class="modal fade" id="modalDetalle${r.idReserva}" tabindex="-1" aria-labelledby="modalDetalleLabel${r.idReserva}" aria-hidden="true">
                                        <div class="modal-dialog modal-dialog-centered">
                                            <div class="modal-content border-0 shadow-lg" style="border-radius: var(--radius-md, 16px); overflow: hidden;">
                                                <div class="modal-header border-0 pb-0 justify-content-end">
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <div class="modal-body px-4 pt-0 pb-4">
                                                    <div class="text-center mb-4 pb-3 border-bottom">
                                                        <div class="d-inline-block bg-primary text-white p-3 rounded-circle mb-3 shadow-sm" style="background-color: var(--primary) !important;">
                                                            <i class="bi bi-receipt fs-3"></i>
                                                        </div>
                                                        <h3 class="text-dark fw-bold mb-0" id="modalDetalleLabel${r.idReserva}">Detalle de Reserva</h3>
                                                        <p class="text-muted small mb-0">ID Reserva: #${r.idReserva}</p>
                                                    </div>
                                                    <div class="invoice-detail px-2">
                                                        <div class="d-flex justify-content-between align-items-center mb-3">
                                                            <span class="text-muted"><i class="bi bi-geo-alt me-2 text-primary"></i>Destino:</span>
                                                            <span class="fw-bold text-end">${not empty r.nombrePaquete ? r.nombrePaquete : 'Paquete #'.concat(r.idPaquete)}</span>
                                                        </div>
                                                        <div class="d-flex justify-content-between align-items-center mb-3">
                                                            <span class="text-muted"><i class="bi bi-arrow-left-right me-2 text-primary"></i>Tipo:</span>
                                                            <span class="fw-bold">${r.tipoViaje == 'idavuelta' || r.tipoViaje == 'roundtrip' ? 'Ida y Vuelta' : 'Solo Ida'}</span>
                                                        </div>
                                                        <div class="d-flex justify-content-between align-items-center mb-3">
                                                            <span class="text-muted"><i class="bi bi-calendar-check me-2 text-primary"></i>Salida:</span>
                                                            <span class="fw-bold">${r.fechaSalida}</span>
                                                        </div>
                                                        <c:if test="${not empty r.fechaRetorno}">
                                                            <div class="d-flex justify-content-between align-items-center mb-3">
                                                                <span class="text-muted"><i class="bi bi-calendar-x me-2 text-primary"></i>Retorno:</span>
                                                                <span class="fw-bold">${r.fechaRetorno}</span>
                                                            </div>
                                                        </c:if>
                                                        <div class="d-flex justify-content-between align-items-center mb-3">
                                                            <span class="text-muted"><i class="bi bi-people me-2 text-primary"></i>Pasajeros:</span>
                                                            <span class="fw-bold">${r.numPasajeros}</span>
                                                        </div>
                                                        <div class="d-flex justify-content-between align-items-center mb-4">
                                                            <span class="text-muted"><i class="bi bi-info-circle me-2 text-primary"></i>Estado:</span>
                                                            <span>
                                                                <c:choose>
                                                                    <c:when test="${r.estado.equalsIgnoreCase('cancelada')}">
                                                                        <span class="badge bg-danger rounded-pill px-3">Cancelada</span>
                                                                    </c:when>
                                                                    <c:when test="${r.estado.equalsIgnoreCase('completado') or r.estado.equalsIgnoreCase('completada')}">
                                                                        <span class="badge bg-info text-dark rounded-pill px-3">Completado</span>
                                                                    </c:when>
                                                                    <c:when test="${r.estado.equalsIgnoreCase('pagada')}">
                                                                        <span class="badge bg-success rounded-pill px-3">Pagada</span>
                                                                    </c:when>
                                                                    <c:when test="${r.estado.equalsIgnoreCase('pendiente')}">
                                                                        <span class="badge bg-warning text-dark rounded-pill px-3">Pendiente</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge bg-secondary rounded-pill px-3">${r.estado}</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </span>
                                                        </div>

                                                        <div class="p-3 bg-light rounded-4 mb-4">
                                                            <div class="d-flex justify-content-between mb-2">
                                                                <span class="text-muted small">Subtotal:</span>
                                                                <span class="fw-semibold text-dark">S/ <fmt:formatNumber value="${subtotal}" minFractionDigits="2" maxFractionDigits="2"/></span>
                                                            </div>
                                                            <div class="d-flex justify-content-between mb-3 border-bottom pb-2">
                                                                <span class="text-muted small">IGV (18%):</span>
                                                                <span class="fw-semibold text-dark">S/ <fmt:formatNumber value="${igv}" minFractionDigits="2" maxFractionDigits="2"/></span>
                                                            </div>
                                                            <div class="d-flex justify-content-between align-items-center mt-2">
                                                                <span class="fw-bold text-dark fs-5">TOTAL</span>
                                                                <span class="fw-bold fs-4 text-primary">S/ <fmt:formatNumber value="${total}" minFractionDigits="2" maxFractionDigits="2"/></span>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <c:choose>
                                                        <c:when test="${r.estado.equalsIgnoreCase('cancelada')}">
                                                             <div class="alert alert-danger d-flex align-items-center border-0 small shadow-sm mb-3" role="alert">
                                                                 <i class="bi bi-x-octagon fs-4 me-2"></i>
                                                                 <div>Esta reserva ha sido cancelada.</div>
                                                             </div>
                                                         </c:when>
                                                         <c:when test="${r.estado.equalsIgnoreCase('completado') or r.estado.equalsIgnoreCase('completada')}">
                                                             <div class="alert alert-info d-flex align-items-center border-0 small shadow-sm mb-3" role="alert">
                                                                 <i class="bi bi-check2-all fs-4 me-2"></i>
                                                                 <div>Viaje concluido exitosamente.</div>
                                                             </div>
                                                         </c:when>
                                                         <c:when test="${r.estado.equalsIgnoreCase('pagada')}">
                                                             <div class="alert alert-success d-flex align-items-center border-0 small shadow-sm mb-3" role="alert">
                                                                 <i class="bi bi-shield-check fs-4 me-2"></i>
                                                                 <div>Reserva confirmada y pagada con éxito.</div>
                                                             </div>
                                                         </c:when>
                                                         <c:when test="${r.estado.equalsIgnoreCase('pendiente')}">
                                                             <div class="alert alert-warning d-flex align-items-center border-0 small shadow-sm mb-3" role="alert">
                                                                 <i class="bi bi-hourglass-split fs-4 me-2"></i>
                                                                 <div>Reserva pendiente de pago.</div>
                                                             </div>
                                                         </c:when>
                                                         <c:otherwise>
                                                             <div class="alert alert-secondary d-flex align-items-center border-0 small shadow-sm mb-3" role="alert">
                                                                 <div>Estado de reserva: ${r.estado}.</div>
                                                             </div>
                                                         </c:otherwise>
                                                     </c:choose>

                                                    <div class="d-flex justify-content-end gap-2 mt-3">
                                                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">
                                                            Cerrar
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>

    </div>

    <!-- FORMULARIO OCULTO PARA CANCELAR RESERVA -->
    <form id="formCancelar" action="${pageContext.request.contextPath}/mis-reservas" method="post">
        <input type="hidden" name="action" value="cancelar">
        <input type="hidden" id="idCancelar" name="id">
    </form>

    <!-- FOOTER Y SCRIPTS -->
    <jsp:include page="componentes/footer.jsp"></jsp:include>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        document.querySelectorAll(".btn-cancelar").forEach(function (btn) {
            btn.addEventListener("click", function () {
                let id = this.dataset.id;
                let paquete = this.dataset.paquete || "la reserva";
                Swal.fire({
                    title: "¿Cancelar reserva #" + id + "?",
                    text: "Esta acción cancelará tu reserva para " + paquete + ". ¿Deseas continuar?",
                    icon: "warning",
                    showCancelButton: true,
                    confirmButtonColor: "#d33",
                    cancelButtonColor: "#6c757d",
                    confirmButtonText: "Sí, cancelar",
                    cancelButtonText: "No, mantener"
                }).then((result) => {
                    if (result.isConfirmed) {
                        document.getElementById("idCancelar").value = id;
                        document.getElementById("formCancelar").submit();
                    }
                });
            });
        });
    </script>
</body>
</html>
