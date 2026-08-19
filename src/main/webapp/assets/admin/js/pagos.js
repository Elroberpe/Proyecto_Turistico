// ==========================================
// GESTIÓN DE PAGOS (ADMIN)
// ==========================================

document.addEventListener('DOMContentLoaded', function () {
    const selectReserva = document.getElementById('idReserva');
    const montoInput = document.getElementById('montoPago');
    const btnNuevo = document.getElementById("btnNuevo");
    const actionPago = document.getElementById("actionPago");
    const idPago = document.getElementById("idPago");
    const reservaPagoContainer = document.getElementById("reservaPagoContainer");
    const metodoPago = document.getElementById("metodoPago");
    const estadoPago = document.getElementById("estadoPago");
    const pagoModalTitle = document.getElementById("pagoModalTitle");
    const btnGuardarPago = document.getElementById("btnGuardarPago");
    const formEliminar = document.getElementById("formEliminar");
    const idEliminar = document.getElementById("idEliminar");

    // Auto-completar monto al seleccionar reserva
    if (selectReserva && montoInput) {
        selectReserva.addEventListener('change', function () {
            const selectedOption = this.options[this.selectedIndex];
            const monto = selectedOption ? selectedOption.getAttribute('data-monto') : null;
            if (monto) {
                montoInput.value = monto;
            } else {
                montoInput.value = '';
            }
        });
    }

    // Limpiar modal para Nuevo Pago
    if (btnNuevo) {
        btnNuevo.addEventListener("click", function () {
            if (actionPago) actionPago.value = "crear";
            if (idPago) idPago.value = "";
            if (reservaPagoContainer) reservaPagoContainer.style.display = "block";
            if (selectReserva) {
                selectReserva.required = true;
                selectReserva.selectedIndex = 0;
            }
            if (montoInput) {
                montoInput.value = "";
                montoInput.readOnly = true;
            }
            if (metodoPago) metodoPago.value = "1";
            if (estadoPago) estadoPago.value = "pagado";
            if (pagoModalTitle) pagoModalTitle.textContent = "Nuevo Pago";
            if (btnGuardarPago) btnGuardarPago.className = "btn btn-primary-custom";
        });
    }

    // Llenar modal para Editar Pago
    document.querySelectorAll(".btn-editar").forEach(function (btn) {
        btn.addEventListener("click", function () {
            if (actionPago) actionPago.value = "editar";
            if (idPago) idPago.value = this.dataset.id || "";
            if (reservaPagoContainer) reservaPagoContainer.style.display = "none";
            if (selectReserva) selectReserva.required = false;
            if (metodoPago) metodoPago.value = this.dataset.metodo || "1";
            if (montoInput) {
                montoInput.value = this.dataset.monto || "";
                montoInput.readOnly = false;
            }
            if (estadoPago) estadoPago.value = this.dataset.estado || "pagado";
            if (pagoModalTitle) pagoModalTitle.textContent = "Editar Pago #" + (this.dataset.id || "");
            if (btnGuardarPago) btnGuardarPago.className = "btn btn-primary-custom";
        });
    });

    // Eliminar con SweetAlert2
    document.querySelectorAll(".btn-eliminar").forEach(function (btn) {
        btn.addEventListener("click", function () {
            const id = this.dataset.id;
            Swal.fire({
                title: "¿Eliminar el pago #" + id + "?",
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
});
