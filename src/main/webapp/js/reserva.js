// ==================== PÁGINA DE PAGO ====================
// Se ejecuta cuando el DOM está cargado
// Carga el resumen de la reserva y los eventos de pago
document.addEventListener('DOMContentLoaded', () => {
    cargarResumenReserva();
    initEventosPago();
});

// ==================== CARGAR RESUMEN DE RESERVA ====================
// Recupera la reserva desde localStorage y la muestra en pantalla
// Si no hay reserva activa, redirige al inicio
function cargarResumenReserva() {
    const reservaStr = localStorage.getItem('reservaActual');
    if (!reservaStr) {
        window.location.href = 'index.html';
        return;
    }
    
    const reserva = JSON.parse(reservaStr);
    const container = document.getElementById('resumenReserva');
    
    if (container) {
        container.innerHTML = `
            <div class="card shadow-sm">
                <div class="card-body">
                    <h4 class="text-primary"><i class="bi bi-suitcase-lg"></i> Resumen de tu reserva</h4>
                    <hr>
                    <p><strong>Destino:</strong> ${reserva.destino.nombre}</p>
                    <p><strong>Tipo:</strong> ${reserva.tipoViaje === 'roundtrip' ? 'Ida y Vuelta' : 'Solo Ida'}</p>
                    <p><strong>Salida:</strong> ${reserva.fechaSalida}</p>
                    ${reserva.fechaRetorno ? `<p><strong>Retorno:</strong> ${reserva.fechaRetorno}</p>` : ''}
                    <p><strong>Pasajeros:</strong> ${reserva.pasajeros}</p>
                    <hr>
                    <h3 class="text-success">Total: S/ ${reserva.precioTotal.toFixed(2)}</h3>
                </div>
            </div>
        `;
    }
}

// ==================== INICIALIZAR EVENTOS DE PAGO ====================
// Asigna event listeners para cambio de método de pago y envío del formulario
function initEventosPago() {
    const metodoPago = document.getElementById('metodoPago');
    const tarjetaFields = document.getElementById('tarjetaFields');
    const qrFields = document.getElementById('qrFields');
    const paymentForm = document.getElementById('paymentForm');
    
    if (metodoPago) {
        metodoPago.addEventListener('change', (e) => {
            // Muestra campos de tarjeta o código QR según selección
            if (e.target.value === 'tarjeta') {
                tarjetaFields.style.display = 'block';
                qrFields.style.display = 'none';
            } else {
                tarjetaFields.style.display = 'none';
                qrFields.style.display = 'block';
            }
        });
    }
    
    if (paymentForm) {
        paymentForm.addEventListener('submit', (e) => {
            e.preventDefault();
            procesarPago();
        });
    }
}

// ==================== PROCESAR PAGO ====================
// Valida los datos de la tarjeta con expresiones regulares
// Simula el procesamiento del pago con setTimeout
// Guarda la reserva confirmada y redirige al inicio
function procesarPago() {
    // Validar datos de tarjeta (expresiones regulares)
    const metodoPago = document.getElementById('metodoPago').value;
    
    if (metodoPago === 'tarjeta') {
        const numeroTarjeta = document.getElementById('numeroTarjeta').value;
        const cvv = document.getElementById('cvv').value;
        const fechaExp = document.getElementById('fechaExp').value;
        
        // Expresiones regulares para validación
        const regexTarjeta = /^\d{16}$/;
        const regexCVV = /^\d{3}$/;
        const regexFecha = /^(0[1-9]|1[0-2])\/\d{2}$/;
        
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
    
    // Simular procesamiento
    const btnPagar = document.querySelector('#paymentForm button[type="submit"]');  // Selecciona el botón de pagar dentro del formulario
    const textoOriginal = btnPagar.innerHTML;   // Guarda el texto original del botón para poder restaurarlo después
    btnPagar.innerHTML = '<i class="bi bi-hourglass-split"></i> Procesando...'; // Cambia el contenido del botón: muestra un ícono de reloj de arena y el texto "Procesando..."
    btnPagar.disabled = true;   // Deshabilita el botón para que el usuario no pueda hacer clic múltiples veces
    
    setTimeout(() => {  // Todo esto se ejecuta DESPUÉS de 2 segundos
        // Obtener reserva
        const reserva = JSON.parse(localStorage.getItem('reservaActual'));
        
        // Guardar como reserva confirmada
        let confirmadas = JSON.parse(localStorage.getItem('reservasConfirmadas')) || [];
        confirmadas.push({ ...reserva, estado: 'confirmada', fechaPago: new Date().toLocaleString() });
        localStorage.setItem('reservasConfirmadas', JSON.stringify(confirmadas));
        
        // Limpiar reserva actual
        localStorage.removeItem('reservaActual');
        
        // Mostrar éxito y redirigir
        alert('✅ ¡Pago exitoso! Tu reserva ha sido confirmada. Revisa tu correo.');
        window.location.href = 'index.html';
    }, 2000);       // 2000 milisegundos = 2 segundos
}