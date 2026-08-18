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

    let reserva = null;
    try {
        reserva = JSON.parse(reservaStr);
        // Validacion de seguridad para evitar TypeError si el JSON esta corrupto o incompleto
        if (!reserva || !reserva.destino || typeof reserva.subtotal !== 'number') {
            throw new Error("Datos de reserva incompletos o corruptos");
        }
    } catch (e) {
        console.error("Error parsing reservaActual:", e);
        localStorage.removeItem('reservaActual');
        window.location.href = 'index.jsp';
        return;
    }

    const container = document.getElementById('resumenReserva');

    if (container) {
        container.innerHTML = `
            <div class="bg-white p-4" style="border-radius: var(--radius-md); box-shadow: var(--shadow-soft);">
                <div class="text-center mb-4 pb-3 border-bottom">
                    <div class="d-inline-block bg-primary text-white p-3 rounded-circle mb-3 shadow-sm">
                        <i class="bi bi-receipt fs-3"></i>
                    </div>
                    <h3 class="text-dark fw-bold mb-0">Resumen de Viaje</h3>
                    <p class="text-muted small">ID Reserva: #${reserva.id}</p>
                </div>
                
                <div class="invoice-detail px-2">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="text-muted"><i class="bi bi-geo-alt me-2 text-primary"></i>Destino:</span>
                        <span class="fw-bold text-end">${reserva.destino.nombre}</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="text-muted"><i class="bi bi-arrow-left-right me-2 text-primary"></i>Tipo:</span>
                        <span class="fw-bold">${reserva.tipoViaje === 'roundtrip' ? 'Ida y Vuelta' : 'Solo Ida'}</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="text-muted"><i class="bi bi-calendar-check me-2 text-primary"></i>Salida:</span>
                        <span class="fw-bold">${reserva.fechaSalida}</span>
                    </div>
                    ${reserva.fechaRetorno
                        ? `<div class="d-flex justify-content-between align-items-center mb-3">
                             <span class="text-muted"><i class="bi bi-calendar-x me-2 text-primary"></i>Retorno:</span>
                             <span class="fw-bold">${reserva.fechaRetorno}</span>
                           </div>`
                        : ''}
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="text-muted"><i class="bi bi-moon me-2 text-primary"></i>Noches:</span>
                        <span class="fw-bold">${reserva.noches}</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <span class="text-muted"><i class="bi bi-people me-2 text-primary"></i>Pasajeros:</span>
                        <span class="fw-bold">${reserva.pasajeros}</span>
                    </div>
                    
                    <div class="p-3 bg-light rounded-4 mb-4">
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted small">Subtotal:</span>
                            <span class="fw-semibold text-dark">S/ ${reserva.subtotal.toFixed(2)}</span>
                        </div>
                        <div class="d-flex justify-content-between mb-3 border-bottom pb-2">
                            <span class="text-muted small">IGV (18%):</span>
                            <span class="fw-semibold text-dark">S/ ${reserva.igv.toFixed(2)}</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center mt-2">
                            <span class="fw-bold text-dark fs-5">TOTAL</span>
                            <span class="fw-bold fs-4 text-primary">S/ ${reserva.precioTotal.toFixed(2)}</span>
                        </div>
                    </div>
                </div>
                
                <div class="alert alert-success d-flex align-items-center border-0 small shadow-sm mt-3" role="alert">
                    <i class="bi bi-shield-check fs-4 me-2"></i>
                    <div>
                        Pago 100% seguro. Transacción encriptada de extremo a extremo.
                    </div>
                </div>
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

// ==================== FUNCIONES DE NOTIFICACIÓN EN INTERFAZ ====================
function mostrarError(mensaje) {
    const errorEl = document.getElementById('paymentErrorMsg');
    if (errorEl) {
        errorEl.textContent = mensaje;
        errorEl.classList.remove('d-none');
    } else {
        console.error("Error de Pago:", mensaje);
    }
}

function ocultarError() {
    const errorEl = document.getElementById('paymentErrorMsg');
    if (errorEl) {
        errorEl.classList.add('d-none');
        errorEl.textContent = '';
    }
}

// ==================== PROCESAR PAGO ====================
// Valida los datos del método de pago, asigna los campos ocultos y envía el formulario al servlet.
function procesarPago() {
    ocultarError();
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
            mostrarError('Número de tarjeta inválido (debe tener 16 dígitos)');
            return;
        }
        if (!regexCVV.test(cvv)) {
            mostrarError('CVV inválido (3 dígitos)');
            return;
        }
        if (!regexFecha.test(fechaExp)) {
            mostrarError('Fecha de expiración inválida (MM/AA)');
            return;
        }
    }

    const reservaStr = localStorage.getItem('reservaActual');
    if (!reservaStr) {
        mostrarError('No hay datos de reserva activos.');
        return;
    }

    let reserva;
    try {
        reserva = JSON.parse(reservaStr);
    } catch (e) {
        mostrarError('Datos de reserva corruptos o incompletos.');
        return;
    }

    const idPaquete = (reserva.destino && (reserva.destino.idPaquete || reserva.destino.id)) 
        ? (reserva.destino.idPaquete || reserva.destino.id) : 1;
    
    let idMetodoInt = 1;
    if (metodoPago === 'yape') idMetodoInt = 2;
    else if (metodoPago === 'plin') idMetodoInt = 3;

    const tipoViajeParam = (reserva.tipoViaje === 'oneway' || reserva.tipoViaje === 'ida') ? 'ida' : 'idavuelta';

    // Poblar campos ocultos del formulario POST
    const inputIdPaquete = document.getElementById('input_id_paquete');
    const inputTipoViaje = document.getElementById('input_tipo_viaje');
    const inputFechaSalida = document.getElementById('input_fecha_salida');
    const inputFechaRetorno = document.getElementById('input_fecha_retorno');
    const inputNumPasajeros = document.getElementById('input_num_pasajeros');
    const inputPrecioTotal = document.getElementById('input_precio_total');
    const inputIdMetodo = document.getElementById('input_id_metodo');

    if (inputIdPaquete) inputIdPaquete.value = idPaquete;
    if (inputTipoViaje) inputTipoViaje.value = tipoViajeParam;
    if (inputFechaSalida) inputFechaSalida.value = reserva.fechaSalida || '';
    if (inputFechaRetorno) inputFechaRetorno.value = reserva.fechaRetorno || '';
    if (inputNumPasajeros) inputNumPasajeros.value = reserva.pasajeros || 1;
    if (inputPrecioTotal) inputPrecioTotal.value = reserva.precioTotal || 0;
    if (inputIdMetodo) inputIdMetodo.value = idMetodoInt;

    // Deshabilitar botón y mostrar estado "procesando"
    const btnPagar = document.querySelector('#paymentForm button[type="submit"]');
    if (btnPagar) {
        btnPagar.innerHTML = '<i class="bi bi-hourglass-split me-2"></i> Procesando reserva y pago...';
        btnPagar.disabled = true;
    }

    // Limpiar reserva activa de localStorage
    localStorage.removeItem('reservaActual');

    // Enviar formulario al servlet ProcesarPagoServlet
    const paymentForm = document.getElementById('paymentForm');
    if (paymentForm) {
        paymentForm.submit();
    }
}