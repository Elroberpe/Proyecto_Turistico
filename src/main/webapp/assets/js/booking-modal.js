// =============================================================================
// MODAL DE RESERVA - CONTROLADOR JS
// =============================================================================
// Administra el comportamiento del modal de reserva flotante:
// - Selección de paquetes turísticos (vía JavaScript o atributos data-bs-* de HTML)
// - Validación y restricciones dinámicas de fechas (ida y vuelta / solo ida)
// - Cálculo en tiempo real del precio total (Subtotal + 18% IGV)
// - Guardado de cotización en localStorage y redirección a checkout / login
// =============================================================================

let paqueteSeleccionado = null;

// Referencias a los elementos del DOM (inicializadas al cargar la página)
let el = {};

document.addEventListener('DOMContentLoaded', () => {
    cachearElementosDOM();
    if (!el.modal) return;

    registrarEventos();
    configurarFechasIniciales();
});

// =============================================================================
// 1. INICIALIZACIÓN Y CACHÉ DE ELEMENTOS DEL DOM
// =============================================================================
function cachearElementosDOM() {
    el = {
        modal: document.getElementById('modalReserva'),
        form: document.getElementById('bookingForm'),
        destinoSelect: document.getElementById('destinoSelect'),
        destinoNombre: document.getElementById('modalDestinoNombre'),
        tipoViaje: document.getElementById('tipoViaje'),
        pasajeros: document.getElementById('pasajerosSelect'),
        fechaSalida: document.getElementById('fechaSalida'),
        fechaRetorno: document.getElementById('fechaRetorno'),
        retornoGroup: document.getElementById('retornoGroup'),
        precioDisplay: document.getElementById('precioSoles'),
        validationMsg: document.getElementById('validationMsg'),
        isLoggedIn: document.getElementById('isUserLoggedIn')
    };
}

function registrarEventos() {
    // Cambio en tipo de viaje (Solo Ida / Ida y Vuelta)
    el.tipoViaje?.addEventListener('change', () => {
        const esSoloIda = el.tipoViaje.value === 'oneway';
        if (el.retornoGroup) el.retornoGroup.style.display = esSoloIda ? 'none' : 'block';
        if (el.fechaRetorno) {
            el.fechaRetorno.required = !esSoloIda;
            if (esSoloIda) el.fechaRetorno.value = '';
        }
        actualizarRestriccionRetorno();
        calcularPrecio();
    });

    // Recálculo reactivo ante cambios en el formulario
    el.destinoSelect?.addEventListener('change', calcularPrecio);
    el.pasajeros?.addEventListener('change', calcularPrecio);
    el.fechaSalida?.addEventListener('change', () => {
        actualizarRestriccionRetorno();
        calcularPrecio();
    });
    el.fechaRetorno?.addEventListener('change', calcularPrecio);

    // Apertura nativa de Bootstrap (Tarjetas renderizadas en JSPs con data-bs-*)
    el.modal?.addEventListener('show.bs.modal', (event) => {
        mostrarError('');
        configurarFechasIniciales();

        const triggerBtn = event.relatedTarget;
        if (triggerBtn && triggerBtn.hasAttribute('data-id')) {
            const id = triggerBtn.getAttribute('data-id');
            const nombre = triggerBtn.getAttribute('data-nombre');
            const precio = parseFloat(triggerBtn.getAttribute('data-precio')) || 0;

            cargarPaqueteEnModal({
                idPaquete: id,
                nombre: nombre,
                precioSoles: precio,
                precioBase: precio
            });
        }
    });

    // Envío del formulario
    el.form?.addEventListener('submit', (e) => {
        e.preventDefault();
        procesarReserva();
    });
}

// =============================================================================
// 2. GESTIÓN DEL PAQUETE SELECCIONADO
// =============================================================================

/**
 * Carga un paquete en el modal y actualiza el título y selector.
 */
function cargarPaqueteEnModal(paquete) {
    if (!paquete) return;
    paqueteSeleccionado = paquete;

    if (el.destinoSelect) el.destinoSelect.value = paquete.idPaquete || paquete.id || '';
    if (el.destinoNombre) el.destinoNombre.textContent = paquete.nombre || 'Destino seleccionado';

    calcularPrecio();
}

/**
 * API Global: Abre el modal y selecciona un destino por su ID (usado en main.js y region.js)
 */
window.seleccionarDestino = function(id) {
    if (!el.modal) cachearElementosDOM();

    let paquete = null;
    if (typeof window.getPaqueteParaModal === 'function') {
        paquete = window.getPaqueteParaModal(id);
    }

    if (!paquete) {
        paquete = { idPaquete: id, nombre: 'Destino #' + id, precioSoles: 0, precioBase: 0 };
    }

    cargarPaqueteEnModal(paquete);

    const modalInstance = bootstrap.Modal.getInstance(el.modal) || new bootstrap.Modal(el.modal);
    modalInstance.show();
};

// =============================================================================
// 3. CONTROL Y VALIDACIÓN DE FECHAS
// =============================================================================

/**
 * Configura la fecha mínima de salida (a partir de mañana) y sincroniza retorno.
 */
function configurarFechasIniciales() {
    const manana = new Date();
    manana.setDate(manana.getDate() + 1);
    const minSalidaStr = manana.toISOString().split('T')[0];

    if (el.fechaSalida) {
        el.fechaSalida.min = minSalidaStr;
        if (!el.fechaSalida.value) el.fechaSalida.value = minSalidaStr;
    }
    actualizarRestriccionRetorno();
}

/**
 * Asegura que la fecha mínima de retorno sea al menos 1 día después de la salida.
 */
function actualizarRestriccionRetorno() {
    if (!el.fechaSalida?.value || !el.fechaRetorno) return;

    const fechaSalida = new Date(el.fechaSalida.value + 'T00:00:00');
    const minRetorno = new Date(fechaSalida);
    minRetorno.setDate(minRetorno.getDate() + 1);
    
    el.fechaRetorno.min = minRetorno.toISOString().split('T')[0];

    if (el.fechaRetorno.value && el.fechaRetorno.value <= el.fechaSalida.value) {
        el.fechaRetorno.value = '';
        mostrarError('⚠️ La fecha de retorno debe ser posterior a la fecha de salida.');
    }
}

function mostrarError(mensaje) {
    if (el.validationMsg) el.validationMsg.textContent = mensaje || '';
}

// =============================================================================
// 4. MOTOR DE COTIZACIÓN Y CÁLCULO DE PRECIOS
// =============================================================================

function calcularPrecio() {
    mostrarError('');

    // Resolver datos del paquete actual
    let destino = paqueteSeleccionado;
    const destinoId = el.destinoSelect?.value;
    if (!destino && destinoId && typeof window.getPaqueteParaModal === 'function') {
        destino = window.getPaqueteParaModal(destinoId);
        paqueteSeleccionado = destino;
    }

    if (!destino || !el.fechaSalida?.value) {
        if (el.precioDisplay) el.precioDisplay.textContent = 'S/ 0.00';
        window.precioActual = null;
        return 0;
    }

    // Cálculo financiero unificado mediante la función compartida
    const cotizacion = calcularCotizacionReserva({
        precioBase: destino.precioSoles || destino.precioBase || 0,
        tipoViaje: el.tipoViaje?.value,
        fechaSalida: el.fechaSalida?.value,
        fechaRetorno: el.fechaRetorno?.value,
        pasajeros: el.pasajeros?.value
    });

    if (el.precioDisplay) {
        el.precioDisplay.textContent = `S/ ${cotizacion.total.toFixed(2)}`;
    }

    window.precioActual = {
        subtotal: cotizacion.subtotal,
        igv: cotizacion.igv,
        total: cotizacion.total,
        noches: cotizacion.noches,
        pasajeros: cotizacion.numPasajeros,
        destino: destino
    };
    return cotizacion.total;
}

// =============================================================================
// 5. PROCESAMIENTO Y CONFIRMACIÓN DE LA RESERVA
// =============================================================================

function procesarReserva() {
    const tipoViaje = el.tipoViaje?.value;
    const fechaSalidaVal = el.fechaSalida?.value;
    const fechaRetornoVal = el.fechaRetorno?.value;

    if (!fechaSalidaVal) {
        mostrarError('⚠️ Por favor, selecciona una fecha de salida.');
        el.fechaSalida?.focus();
        return;
    }

    if (tipoViaje === 'roundtrip') {
        if (!fechaRetornoVal) {
            mostrarError('⚠️ Por favor, selecciona una fecha de retorno.');
            el.fechaRetorno?.focus();
            return;
        }
        if (fechaRetornoVal <= fechaSalidaVal) {
            mostrarError('⚠️ La fecha de retorno debe ser posterior a la fecha de salida.');
            el.fechaRetorno?.focus();
            return;
        }
    }

    if (!window.precioActual) {
        calcularPrecio();
        if (!window.precioActual) {
            mostrarError('⚠️ Completa todos los datos requeridos para cotizar.');
            return;
        }
    }

    // Construcción del objeto reserva
    const reserva = {
        id: Date.now(),
        destino: window.precioActual.destino,
        tipoViaje: tipoViaje,
        fechaSalida: fechaSalidaVal,
        fechaRetorno: tipoViaje === 'roundtrip' ? fechaRetornoVal : null,
        pasajeros: window.precioActual.pasajeros,
        noches: window.precioActual.noches,
        subtotal: window.precioActual.subtotal,
        igv: window.precioActual.igv,
        precioTotal: window.precioActual.total,
        fechaReserva: new Date().toLocaleString()
    };

    // Almacenamiento en el cliente
    const historialReservas = JSON.parse(localStorage.getItem('reservasChasqui')) || [];
    historialReservas.push(reserva);
    localStorage.setItem('reservasChasqui', JSON.stringify(historialReservas));
    localStorage.setItem('reservaActual', JSON.stringify(reserva));

    // Redirección según autenticación
    const usuarioAutenticado = el.isLoggedIn?.value === 'true';
    if (!usuarioAutenticado) {
        window.location.href = 'login?redirect=reserva';
    } else {
        window.location.href = 'reserva.jsp';
    }
}
