// ==================== PÁGINA DE PAGO ====================
// Se ejecuta cuando el DOM está completamente cargado.
// Carga el resumen de la reserva y registra los eventos del formulario de pago.
document.addEventListener('DOMContentLoaded', () => {
    cargarResumenReserva();
    initEventosPago();
});

// ==================== CARGAR RESUMEN DE RESERVA ====================
// Recupera la reserva guardada en localStorage y la muestra como
// una factura electrónica con desglose de IGV.
// Si no hay reserva activa, redirige al inicio.
function cargarResumenReserva() {
    const reservaStr = localStorage.getItem('reservaActual');
    if (!reservaStr) {
        window.location.href = 'index.jsp';
        return;
    }

    const reserva   = JSON.parse(reservaStr);
    const container = document.getElementById('resumenReserva');

    if (container) {
        container.innerHTML = `
            <h3 class="mb-4 text-primary"><i class="bi bi-receipt"></i> Factura Electrónica</h3>
            <div class="invoice-detail">
                <div class="row"><div class="col-6 text-muted">Destino:</div>
                    <div class="col-6 fw-bold">${reserva.destino.nombre}</div></div>
                <div class="row"><div class="col-6 text-muted">Tipo de viaje:</div>
                    <div class="col-6 fw-bold">${reserva.tipoViaje === 'roundtrip' ? 'Ida y Vuelta' : 'Solo Ida'}</div></div>
                <div class="row"><div class="col-6 text-muted">Salida:</div>
                    <div class="col-6 fw-bold">${reserva.fechaSalida}</div></div>
                ${reserva.fechaRetorno
                    ? `<div class="row"><div class="col-6 text-muted">Retorno:</div>
                       <div class="col-6 fw-bold">${reserva.fechaRetorno}</div></div>`
                    : ''}
                <div class="row"><div class="col-6 text-muted">Noches:</div>
                    <div class="col-6 fw-bold">${reserva.noches}</div></div>
                <div class="row"><div class="col-6 text-muted">Pasajeros:</div>
                    <div class="col-6 fw-bold">${reserva.pasajeros}</div></div>
                <hr>
                <div class="row"><div class="col-6 text-muted">Subtotal:</div>
                    <div class="col-6">S/ ${reserva.subtotal.toFixed(2)}</div></div>
                <div class="row"><div class="col-6 text-muted">IGV (18%):</div>
                    <div class="col-6">S/ ${reserva.igv.toFixed(2)}</div></div>
                <div class="row"><div class="col-6 fw-bold">TOTAL:</div>
                    <div class="col-6 fw-bold total-grande">S/ ${reserva.precioTotal.toFixed(2)}</div></div>
            </div>
            <div class="alert alert-info mt-3 small">
                <i class="bi bi-info-circle"></i> Pago 100% seguro. Datos encriptados.
            </div>
        `;
    }
}

// ==================== INICIALIZAR EVENTOS DE PAGO ====================
// Asigna event listeners para:
//   - Cambio de método de pago: muestra campos de tarjeta o QR según selección.
//   - Envío del formulario: llama a procesarPago().
function initEventosPago() {
    const metodoPago   = document.getElementById('metodoPago');
    const tarjetaFields = document.getElementById('tarjetaFields');
    const qrFields     = document.getElementById('qrFields');
    const paymentForm  = document.getElementById('paymentForm');

    if (metodoPago) {
        metodoPago.addEventListener('change', e => {
            // Muestra campos de tarjeta o código QR según selección
            if (e.target.value === 'tarjeta') {
                tarjetaFields.style.display = 'block';
                qrFields.style.display      = 'none';
            } else {
                tarjetaFields.style.display = 'none';
                qrFields.style.display      = 'block';
            }
        });
    }

    if (paymentForm) {
        paymentForm.addEventListener('submit', e => {
            e.preventDefault();
            procesarPago();
        });
    }
}

// ==================== PROCESAR PAGO ====================
// Valida los datos del método de pago con expresiones regulares.
// Simula el procesamiento con setTimeout (2 segundos).
// Guarda la reserva como confirmada en localStorage y redirige al inicio.
function procesarPago() {
    const metodoPago = document.getElementById('metodoPago').value;

    // Validación de datos de tarjeta mediante expresiones regulares
    if (metodoPago === 'tarjeta') {
        const numeroTarjeta = document.getElementById('numeroTarjeta').value;
        const cvv           = document.getElementById('cvv').value;
        const fechaExp      = document.getElementById('fechaExp').value;

        const regexTarjeta = /^\d{16}$/;           // 16 dígitos exactos
        const regexCVV     = /^\d{3}$/;            // 3 dígitos exactos
        const regexFecha   = /^(0[1-9]|1[0-2])\/\d{2}$/; // formato MM/AA

        if (!regexTarjeta.test(numeroTarjeta.replace(/\s/g, ''))) {
            alert('❌ Número de tarjeta inválido (debe tener 16 dígitos)');
            return;
        }
        if (!regexCVV.test(cvv)) {
            alert('❌ CVV inválido (3 dígitos)');
            return;
        }
        if (!regexFecha.test(fechaExp)) {
            alert('❌ Fecha de expiración inválida (MM/AA)');
            return;
        }
    }

    // Deshabilitar botón y mostrar estado "procesando" para evitar doble envío
    const btnPagar       = document.querySelector('#paymentForm button[type="submit"]');
    const textoOriginal  = btnPagar.innerHTML;
    btnPagar.innerHTML   = '<i class="bi bi-hourglass-split"></i> Procesando...';
    btnPagar.disabled    = true;

    // Simular procesamiento de 2 segundos y luego confirmar la reserva
    setTimeout(() => {
        const reserva      = JSON.parse(localStorage.getItem('reservaActual'));
        let confirmadas    = JSON.parse(localStorage.getItem('reservasConfirmadas')) || [];

        // Agregar estado y fecha de pago al objeto de reserva
        confirmadas.push({
            ...reserva,
            estado    : 'confirmada',
            fechaPago : new Date().toLocaleString()
        });

        localStorage.setItem('reservasConfirmadas', JSON.stringify(confirmadas));
        localStorage.removeItem('reservaActual');   // Limpiar reserva activa

        alert('✅ ¡Pago exitoso! Tu reserva ha sido confirmada. Revisa tu correo.');
        window.location.href = 'index.jsp';
    }, 2000); // 2000 ms = 2 segundos
}