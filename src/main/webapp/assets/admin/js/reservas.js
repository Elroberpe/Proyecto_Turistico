// ==========================================
// GESTIÓN DE RESERVAS (ADMIN)
// ==========================================

document.addEventListener('DOMContentLoaded', function () {
    const tipoViajeSelect = document.getElementById('tipoViajeReserva');
    const retornoInput = document.getElementById('fechaRetornoReserva');
    const retornoObligatorio = document.getElementById('retornoObligatorio');
    const divRetorno = document.getElementById('divFechaRetorno');
    const paqueteSelect = document.getElementById("paqueteReserva");
    const pasajerosInput = document.getElementById("numPasajerosReserva");
    const precioTotalInput = document.getElementById("precioTotalReserva");
    const filtroCategoria = document.getElementById("filtroCategoria");
    const salidaInput = document.getElementById("fechaSalidaReserva");
    const btnNuevo = document.getElementById("btnNuevo");
    const actionReserva = document.getElementById("actionReserva");
    const idReserva = document.getElementById("idReserva");
    const usuarioReserva = document.getElementById("usuarioReserva");
    const estadoReservaContainer = document.getElementById("estadoReservaContainer");
    const estadoReserva = document.getElementById("estadoReserva");
    const reservaModalTitle = document.getElementById("reservaModalTitle");
    const btnGuardarReserva = document.getElementById("btnGuardarReserva");
    const formEliminar = document.getElementById("formEliminar");
    const idEliminar = document.getElementById("idEliminar");

    // MOSTRAR/OCULTAR RETORNO
    function toggleRetorno() {
        if (!tipoViajeSelect || !retornoInput || !divRetorno) return;
        const esIdaVuelta = tipoViajeSelect.value === 'idavuelta';
        if (esIdaVuelta) {
            if (retornoObligatorio) retornoObligatorio.style.display = 'inline';
            retornoInput.setAttribute('required', 'required');
            const label = divRetorno.querySelector('label');
            if (label) label.innerHTML = 'Fecha Retorno <span style="color:red;">*</span>';
            divRetorno.style.display = 'block';
        } else {
            if (retornoObligatorio) retornoObligatorio.style.display = 'none';
            retornoInput.removeAttribute('required');
            const label = divRetorno.querySelector('label');
            if (label) label.innerHTML = 'Fecha Retorno';
            divRetorno.style.display = 'none';
            retornoInput.value = '';
        }
    }

    if (tipoViajeSelect) {
        tipoViajeSelect.addEventListener('change', function () {
            toggleRetorno();
            calcularTotal();
        });
    }

    // CALCULAR PRECIO TOTAL REUTILIZANDO LA LÓGICA COMPARTIDA (NOCHES + IGV 18%)
    function calcularTotal() {
        if (!paqueteSelect || !pasajerosInput || !precioTotalInput) return;
        const pasajeros = parseInt(pasajerosInput.value, 10) || 1;
        const selectedOpt = paqueteSelect.options[paqueteSelect.selectedIndex];
        let precioUnitario = 0;
        if (selectedOpt && selectedOpt.value !== "") {
            precioUnitario = parseFloat(selectedOpt.getAttribute("data-precio")) || 0;
        }

        if (typeof window.calcularCotizacionReserva === 'function') {
            const cotizacion = window.calcularCotizacionReserva({
                precioBase: precioUnitario,
                tipoViaje: tipoViajeSelect ? tipoViajeSelect.value : 'idavuelta',
                fechaSalida: salidaInput ? salidaInput.value : '',
                fechaRetorno: retornoInput ? retornoInput.value : '',
                pasajeros: pasajeros
            });
            precioTotalInput.value = cotizacion.total.toFixed(2);
        } else {
            const total = precioUnitario * pasajeros * 1.18;
            precioTotalInput.value = total.toFixed(2);
        }
    }

    if (paqueteSelect) {
        paqueteSelect.addEventListener("change", calcularTotal);
    }
    if (pasajerosInput) {
        pasajerosInput.addEventListener("input", calcularTotal);
    }

    // FILTRO POR CATEGORÍA
    if (filtroCategoria && paqueteSelect) {
        filtroCategoria.addEventListener("change", function () {
            const catId = parseInt(this.value);
            const options = paqueteSelect.options;
            for (let i = 0; i < options.length; i++) {
                const opt = options[i];
                if (opt.value === "") continue;
                const optCat = parseInt(opt.getAttribute("data-categoria"));
                opt.style.display = (catId === 0 || optCat === catId) ? "" : "none";
            }
            if (paqueteSelect.selectedIndex > 0) {
                const selectedOpt = paqueteSelect.options[paqueteSelect.selectedIndex];
                if (selectedOpt.style.display === "none") {
                    paqueteSelect.selectedIndex = 0;
                }
            }
            calcularTotal();
        });
    }

    // VALIDACIONES DE FECHAS EN CLIENTE Y RECÁLCULO
    if (salidaInput && retornoInput) {
        salidaInput.addEventListener("change", function () {
            const salida = this.value;
            if (salida) {
                retornoInput.setAttribute("min", salida);
                if (retornoInput.value && retornoInput.value < salida) {
                    retornoInput.value = "";
                    Swal.fire({
                        title: "Fecha inválida",
                        text: "La fecha de retorno no puede ser anterior a la fecha de salida.",
                        icon: "warning"
                    });
                }
            }
            calcularTotal();
        });

        retornoInput.addEventListener("change", function () {
            const salida = salidaInput.value;
            if (salida && this.value < salida) {
                this.value = "";
                Swal.fire({
                    title: "Fecha inválida",
                    text: "La fecha de retorno no puede ser anterior a la fecha de salida.",
                    icon: "warning"
                });
            }
            calcularTotal();
        });
    }

    // NUEVA RESERVA
    if (btnNuevo) {
        btnNuevo.addEventListener("click", function () {
            if (actionReserva) actionReserva.value = "crear";
            if (idReserva) idReserva.value = "";
            if (usuarioReserva) usuarioReserva.selectedIndex = 0;
            if (filtroCategoria) {
                filtroCategoria.value = "0";
                filtroCategoria.dispatchEvent(new Event("change"));
            }
            if (paqueteSelect) paqueteSelect.selectedIndex = 0;
            if (tipoViajeSelect) tipoViajeSelect.value = "idavuelta";
            if (pasajerosInput) pasajerosInput.value = "1";
            if (salidaInput) salidaInput.value = "";
            if (retornoInput) retornoInput.value = "";
            if (precioTotalInput) precioTotalInput.value = "";
            if (estadoReservaContainer) estadoReservaContainer.style.display = "none";
            if (reservaModalTitle) reservaModalTitle.textContent = "Nueva Reserva";
            if (btnGuardarReserva) btnGuardarReserva.className = "btn btn-primary-custom";
            toggleRetorno();
            calcularTotal();
        });
    }

    // EDITAR RESERVA
    document.querySelectorAll(".btn-editar").forEach(function (btn) {
        btn.addEventListener("click", function () {
            if (actionReserva) actionReserva.value = "editar";
            if (idReserva) idReserva.value = this.dataset.id || "";
            if (usuarioReserva) usuarioReserva.value = this.dataset.usuario || "";

            const paqueteId = this.dataset.paquete;
            let categoriaId = 0;
            if (paqueteSelect) {
                for (let opt of paqueteSelect.options) {
                    if (opt.value == paqueteId) {
                        categoriaId = parseInt(opt.getAttribute("data-categoria")) || 0;
                        break;
                    }
                }
            }
            if (filtroCategoria) {
                filtroCategoria.value = categoriaId > 0 ? categoriaId : "0";
                filtroCategoria.dispatchEvent(new Event("change"));
            }
            if (paqueteSelect) paqueteSelect.value = paqueteId || "";

            const tipo = (this.dataset.tipoviaje === "roundtrip" || this.dataset.tipoviaje === "idavuelta") ? "idavuelta" : "ida";
            if (tipoViajeSelect) tipoViajeSelect.value = tipo;

            if (pasajerosInput) pasajerosInput.value = this.dataset.pasajeros || "1";
            if (salidaInput) salidaInput.value = this.dataset.salida || "";
            if (retornoInput) retornoInput.value = this.dataset.retorno || "";
            if (precioTotalInput) precioTotalInput.value = this.dataset.total || "";
            if (estadoReservaContainer) estadoReservaContainer.style.display = "block";
            if (estadoReserva) estadoReserva.value = this.dataset.estado || "pendiente";
            if (reservaModalTitle) reservaModalTitle.textContent = "Editar Reserva #" + (this.dataset.id || "");
            if (btnGuardarReserva) btnGuardarReserva.className = "btn btn-primary-custom";
            toggleRetorno();
            calcularTotal();
        });
    });

    // ELIMINAR CON SWEETALERT
    document.querySelectorAll(".btn-eliminar").forEach(function (btn) {
        btn.addEventListener("click", function () {
            const id = this.dataset.id;
            Swal.fire({
                title: "¿Eliminar reserva #" + id + "?",
                text: "Esta acción no se puede deshacer.",
                icon: "warning",
                showCancelButton: true,
                confirmButtonText: "Sí, eliminar",
                cancelButtonText: "Cancelar"
            }).then((result) => {
                if (result.isConfirmed) {
                    if (idEliminar && formEliminar) {
                        idEliminar.value = id;
                        formEliminar.submit();
                    }
                }
            });
        });
    });

    toggleRetorno();
});
