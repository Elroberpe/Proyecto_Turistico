// =============================================================================
// CONTROLADOR PORTADA (index.jsp)
// =============================================================================
// Administra interacciones específicas de la página principal:
// - Apertura automática del modal de reserva si viene el parámetro ?destino=ID en la URL

document.addEventListener('DOMContentLoaded', () => {
    cargarDestinoDesdeURL();
});

/**
 * Abre el modal automáticamente si la URL contiene el parámetro ?destino=ID
 */
function cargarDestinoDesdeURL() {
    const urlParams = new URLSearchParams(window.location.search);
    const destinoId = urlParams.get('destino');
    if (destinoId && typeof window.seleccionarDestino === 'function') {
        // Pequeño retraso para asegurar que los elementos del DOM y modal estén listos
        setTimeout(() => {
            window.seleccionarDestino(destinoId);
        }, 300);
    }
}
