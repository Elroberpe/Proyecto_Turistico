/**
 * =============================================================================
 * UTILIDAD COMPARTIDA: CÁLCULO DE COTIZACIONES Y RESERVAS (CHASQUI PERÚ)
 * =============================================================================
 * Función pura e independiente del DOM, utilizada tanto por el modal del cliente
 * (booking-modal.js) como por el panel de administración (reservas.js) para
 * garantizar total consistencia en el cálculo de noches, subtotal, IGV y total.
 * =============================================================================
 */

function calcularCotizacionReserva(params) {
    const { precioBase, tipoViaje, fechaSalida, fechaRetorno, pasajeros } = params || {};

    let noches = 1;
    const esSoloIda = (tipoViaje === 'oneway' || tipoViaje === 'ida' || tipoViaje === 'Solo Ida');

    if (!esSoloIda && fechaSalida && fechaRetorno) {
        const dSalida = new Date(fechaSalida + 'T00:00:00');
        const dRetorno = new Date(fechaRetorno + 'T00:00:00');
        const diffTiempo = dRetorno.getTime() - dSalida.getTime();
        const diffDias = Math.ceil(diffTiempo / (1000 * 60 * 60 * 24));
        if (diffDias > 0) {
            noches = diffDias;
        }
    }

    const numPasajeros = Math.max(1, parseInt(pasajeros, 10) || 1);
    const unitario = Math.max(0, parseFloat(precioBase) || 0);
    const subtotal = unitario * noches * numPasajeros;
    const igv = subtotal * 0.18;
    const total = subtotal + igv;

    return {
        noches: noches,
        numPasajeros: numPasajeros,
        precioBase: unitario,
        subtotal: parseFloat(subtotal.toFixed(2)),
        igv: parseFloat(igv.toFixed(2)),
        total: parseFloat(total.toFixed(2))
    };
}

// Exponer en el contexto global (navegador)
if (typeof window !== 'undefined') {
    window.calcularCotizacionReserva = calcularCotizacionReserva;
}
