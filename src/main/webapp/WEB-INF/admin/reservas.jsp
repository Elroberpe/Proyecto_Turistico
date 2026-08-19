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
                                                    <c:when test="${r.estado.equalsIgnoreCase('pagada')}">
                                                        <button class="btn btn-sm btn-secondary" disabled><i class="bi bi-pencil"></i></button>
                                                    </c:when>
                                                    <c:otherwise>
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
                                                                data-bs-toggle="modal" data-bs-target="#reservaModal">
                                                            <i class="bi bi-pencil"></i>
                                                        </button>
                                                        <button class="btn btn-sm btn-danger btn-eliminar" data-id="${r.idReserva}">
                                                            <i class="bi bi-trash"></i>
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
                                <input type="number" step="0.01" class="form-control" id="precioTotalReserva" name="precio_total" required placeholder="0.00">
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
    <script>

        // MOSTRAR/OCULTAR RETORNO
        const tipoViajeSelect = document.getElementById('tipoViajeReserva');
        const retornoInput = document.getElementById('fechaRetornoReserva');
        const retornoObligatorio = document.getElementById('retornoObligatorio');
        const divRetorno = document.getElementById('divFechaRetorno');

        function toggleRetorno() {
            const esIdaVuelta = tipoViajeSelect.value === 'idavuelta';
            if (esIdaVuelta) {
                retornoObligatorio.style.display = 'inline';
                retornoInput.setAttribute('required', 'required');
                divRetorno.querySelector('label').innerHTML = 'Fecha Retorno <span style="color:red;">*</span>';
                divRetorno.style.display = 'block';
            } else {
                retornoObligatorio.style.display = 'none';
                retornoInput.removeAttribute('required');
                divRetorno.querySelector('label').innerHTML = 'Fecha Retorno';
                divRetorno.style.display = 'none';
                retornoInput.value = '';
            }
        }
        tipoViajeSelect.addEventListener('change', toggleRetorno);


        function calcularTotal() {
            const select = document.getElementById("paqueteReserva");
            const pasajeros = parseInt(document.getElementById("numPasajerosReserva").value) || 1;
            const selectedOpt = select.options[select.selectedIndex];
            let precioUnitario = 0;
            if (selectedOpt && selectedOpt.value !== "") {
                precioUnitario = parseFloat(selectedOpt.getAttribute("data-precio")) || 0;
            }
            const total = precioUnitario * pasajeros;
            document.getElementById("precioTotalReserva").value = total.toFixed(2);
        }
        document.getElementById("paqueteReserva").addEventListener("change", calcularTotal);
        document.getElementById("numPasajerosReserva").addEventListener("input", calcularTotal);

        
        // FILTRO POR CATEGORÍA
        document.getElementById("filtroCategoria").addEventListener("change", function() {
            const catId = parseInt(this.value);
            const options = document.getElementById("paqueteReserva").options;
            for (let i = 0; i < options.length; i++) {
                const opt = options[i];
                if (opt.value === "") continue;
                const optCat = parseInt(opt.getAttribute("data-categoria"));
                opt.style.display = (catId === 0 || optCat === catId) ? "" : "none";
            }
            const selected = document.getElementById("paqueteReserva");
            if (selected.selectedIndex > 0) {
                const selectedOpt = selected.options[selected.selectedIndex];
                if (selectedOpt.style.display === "none") {
                    selected.selectedIndex = 0;
                }
            }
            calcularTotal();
        });

        // VALIDACIONES DE FECHAS EN CLIENTE
        const salidaInput = document.getElementById("fechaSalidaReserva");
        const retornoInput2 = document.getElementById("fechaRetornoReserva");

        salidaInput.addEventListener("change", function() {
            const salida = this.value;
            if (salida) {
                retornoInput2.setAttribute("min", salida);
                if (retornoInput2.value && retornoInput2.value < salida) {
                    retornoInput2.value = "";
                    alert("La fecha de retorno no puede ser anterior a la fecha de salida.");
                }
            }
        });

        retornoInput2.addEventListener("change", function() {
            const salida = salidaInput.value;
            if (salida && this.value < salida) {
                this.value = "";
                alert("La fecha de retorno no puede ser anterior a la fecha de salida.");
            }
        });

        // NUEVA RESERVA
        document.getElementById("btnNuevo").addEventListener("click", function() {
            document.getElementById("actionReserva").value = "crear";
            document.getElementById("idReserva").value = "";
            document.getElementById("usuarioReserva").selectedIndex = 0;
            document.getElementById("filtroCategoria").value = "0";
            document.getElementById("filtroCategoria").dispatchEvent(new Event("change"));
            document.getElementById("paqueteReserva").selectedIndex = 0;
            document.getElementById("tipoViajeReserva").value = "idavuelta";
            document.getElementById("numPasajerosReserva").value = "1";
            document.getElementById("fechaSalidaReserva").value = "";
            document.getElementById("fechaRetornoReserva").value = "";
            document.getElementById("precioTotalReserva").value = "";
            document.getElementById("estadoReservaContainer").style.display = "none";
            document.getElementById("reservaModalTitle").textContent = "Nueva Reserva";
            document.getElementById("btnGuardarReserva").className = "btn btn-primary-custom";
            toggleRetorno();
            calcularTotal();
        });


        // EDITAR RESERVA
        document.querySelectorAll(".btn-editar").forEach(function(btn) {
            btn.addEventListener("click", function() {
                document.getElementById("actionReserva").value = "editar";
                document.getElementById("idReserva").value = this.dataset.id;
                document.getElementById("usuarioReserva").value = this.dataset.usuario;

                const paqueteId = this.dataset.paquete;
                const paqueteSelect = document.getElementById("paqueteReserva");
                let categoriaId = 0;
                for (let opt of paqueteSelect.options) {
                    if (opt.value == paqueteId) {
                        categoriaId = parseInt(opt.getAttribute("data-categoria"));
                        break;
                    }
                }
                const filtro = document.getElementById("filtroCategoria");
                filtro.value = categoriaId > 0 ? categoriaId : "0";
                filtro.dispatchEvent(new Event("change"));
                paqueteSelect.value = paqueteId;


                const tipo = (this.dataset.tipoviaje === "roundtrip" || this.dataset.tipoviaje === "idavuelta") ? "idavuelta" : "ida";
                document.getElementById("tipoViajeReserva").value = tipo;

                document.getElementById("numPasajerosReserva").value = this.dataset.pasajeros;
                document.getElementById("fechaSalidaReserva").value = this.dataset.salida;
                document.getElementById("fechaRetornoReserva").value = this.dataset.retorno;
                document.getElementById("precioTotalReserva").value = this.dataset.total;
                document.getElementById("estadoReservaContainer").style.display = "block";
                document.getElementById("estadoReserva").value = this.dataset.estado;
                document.getElementById("reservaModalTitle").textContent = "Editar Reserva #" + this.dataset.id;
                document.getElementById("btnGuardarReserva").className = "btn btn-primary-custom";                
                toggleRetorno();
                calcularTotal();
            });
        });

        // ELIMINAR CON SWEETALERT
        document.querySelectorAll(".btn-eliminar").forEach(function(btn) {
            btn.addEventListener("click", function() {
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
        toggleRetorno();
    </script>
</body>
</html>
