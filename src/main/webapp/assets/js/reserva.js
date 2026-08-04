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
    btnPagar.innerHTML   = '<i class="bi bi-hourglass-split"></i> Procesando y guardando en BD...';
    btnPagar.disabled    = true;

    const reservaStr = localStorage.getItem('reservaActual');
    if (!reservaStr) {
        alert('❌ No hay datos de reserva activos.');
        btnPagar.innerHTML = textoOriginal;
        btnPagar.disabled = false;
        return;
    }

    const reserva = JSON.parse(reservaStr);
    const idPaquete = (reserva.destino && (reserva.destino.idPaquete || reserva.destino.id)) ? (reserva.destino.idPaquete || reserva.destino.id) : 1;
    
    let idMetodoInt = 1;
    if (metodoPago === 'yape') idMetodoInt = 2;
    else if (metodoPago === 'plin') idMetodoInt = 3;

    const tipoViajeParam = (reserva.tipoViaje === 'oneway' || reserva.tipoViaje === 'ida') ? 'ida' : 'idavuelta';

    const params = new URLSearchParams();
    params.append('id_paquete', idPaquete);
    params.append('tipo_viaje', tipoViajeParam);
    params.append('fecha_salida', reserva.fechaSalida);
    params.append('fecha_retorno', reserva.fechaRetorno || '');
    params.append('num_pasajeros', reserva.pasajeros || 1);
    params.append('precio_total', reserva.precioTotal);
    params.append('id_metodo', idMetodoInt);

    fetch('procesarPago', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        },
        body: params.toString()
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            let confirmadas = JSON.parse(localStorage.getItem('reservasConfirmadas')) || [];
            confirmadas.push({
                ...reserva,
                idReservaBD: data.idReserva,
                idPagoBD: data.idPago,
                estado: 'confirmada',
                fechaPago: new Date().toLocaleString()
            });

            localStorage.setItem('reservasConfirmadas', JSON.stringify(confirmadas));
            localStorage.removeItem('reservaActual');   // Limpiar reserva activa

            // Poblar datos del modal
            const elIdReserva = document.getElementById('confirmIdReserva');
            const elIdPago = document.getElementById('confirmIdPago');
            const elDestino = document.getElementById('confirmDestino');
            const elTotal = document.getElementById('confirmTotal');
            const btnAceptar = document.getElementById('btnAceptarExito');

            if (elIdReserva) elIdReserva.textContent = `#${data.idReserva}`;
            if (elIdPago) elIdPago.textContent = `#${data.idPago}`;
            if (elDestino) elDestino.textContent = reserva.destino ? reserva.destino.nombre : 'Paquete Turístico';
            if (elTotal) elTotal.textContent = `S/ ${reserva.precioTotal.toFixed(2)}`;

            const modalEl = document.getElementById('modalExitoPago');
            if (modalEl) {
                const modal = new bootstrap.Modal(modalEl);
                modal.show();

                if (btnAceptar) {
                    btnAceptar.onclick = function() {
                        modal.hide();
                        window.location.href = 'index.jsp';
                    };
                }
            } else {
                alert(`✅ ¡Pago y Reserva registrados con éxito!\n\nID Reserva en BD: #${data.idReserva}\nID Pago en BD: #${data.idPago}`);
                window.location.href = 'index.jsp';
            }
        } else {
            alert('❌ ' + data.mensaje);
            btnPagar.innerHTML = textoOriginal;
            btnPagar.disabled = false;
        }
    })
    .catch(error => {
        console.error('Error al procesar pago:', error);
        alert('❌ Ocurrió un error inesperado al conectar con el servidor.');
        btnPagar.innerHTML = textoOriginal;
        btnPagar.disabled = false;
    });
}