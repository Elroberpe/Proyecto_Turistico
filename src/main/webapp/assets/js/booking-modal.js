// ==================== LÓGICA CENTRALIZADA DEL MODAL DE RESERVA ====================
// Este archivo maneja todo el comportamiento del formulario flotante (modal),
// el recálculo de precios, y el almacenamiento de la reserva.
// Se usa tanto en la portada (index) como en las regiones.

// Nota: Depende de que main.js o region.js expongan la función 'window.getPaqueteParaModal(id)'
// y opcionalmente definan 'tipoCambioActual'. Si no, usa valores por defecto.

document.addEventListener('DOMContentLoaded', () => {
    initEventosBuscador();
    setFechasMinimas();
});

// Abre el modal y prepara el formulario para un paquete específico
window.seleccionarDestino = function(id) {
    const destinoSelect = document.getElementById('destinoSelect');
    if (destinoSelect) {
        destinoSelect.value = id;
        destinoSelect.dispatchEvent(new Event('change'));
    }
    
    const modalEl = document.getElementById('modalReserva');
    if (modalEl) {
        // Llama a la función definida en main.js o region.js
        let paquete = null;
        if (typeof window.getPaqueteParaModal === 'function') {
            paquete = window.getPaqueteParaModal(id);
        }

        const modalDestinoNombre = document.getElementById('modalDestinoNombre');
        if(modalDestinoNombre && paquete) {
            modalDestinoNombre.textContent = paquete.nombre;
        }
        
        const modal = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl);
        modal.show();
    }
};

function initEventosBuscador() {
    const tipoViaje = document.getElementById('tipoViaje');
    const destinoSelect = document.getElementById('destinoSelect');
    const fechaSalida = document.getElementById('fechaSalida');
    const fechaRetorno = document.getElementById('fechaRetorno');
    const pasajerosSelect = document.getElementById('pasajerosSelect');
    const bookingForm = document.getElementById('bookingForm');
  
    if (tipoViaje) tipoViaje.addEventListener('change', () => { toggleRetorno(); calcularPrecio(); });
    if (destinoSelect) destinoSelect.addEventListener('change', calcularPrecio);
    if (fechaSalida) fechaSalida.addEventListener('change', calcularPrecio);
    if (fechaRetorno) fechaRetorno.addEventListener('change', calcularPrecio);
    if (pasajerosSelect) pasajerosSelect.addEventListener('change', calcularPrecio);
  
    if (bookingForm) {
      bookingForm.addEventListener('submit', (e) => {
        e.preventDefault();
        procesarReserva();
      });
    }
}
  
function toggleRetorno() {
    const tipoViaje = document.getElementById('tipoViaje');
    const retornoGroup = document.getElementById('retornoGroup');
    if (tipoViaje && retornoGroup) {
        if (tipoViaje.value === 'oneway') {
            retornoGroup.style.display = 'none';
            document.getElementById('fechaRetorno').value = '';
        } else {
            retornoGroup.style.display = 'block';
        }
    }
}
  
function calcularPrecioConImpuestos(subtotal) {
    const igv = subtotal * 0.18;
    const total = subtotal + igv;
    return { igv, total };
}
  
function calcularPrecio() {
    const destinoSelect = document.getElementById('destinoSelect');
    const fechaSalida = document.getElementById('fechaSalida');
    const fechaRetorno = document.getElementById('fechaRetorno');
    const tipoViaje = document.getElementById('tipoViaje');
    const pasajerosSelect = document.getElementById('pasajerosSelect');
  
    if (!destinoSelect || !destinoSelect.value) return 0;
  
    const destinoId = parseInt(destinoSelect.value);
    
    let destino = null;
    if (typeof window.getPaqueteParaModal === 'function') {
        destino = window.getPaqueteParaModal(destinoId);
    }
    
    if (!destino) return 0;
  
    const salidaStr = fechaSalida?.value;
    if (!salidaStr) return 0;
  
    let noches = 1;
    const esSoloIda = tipoViaje?.value === 'oneway';
    if (!esSoloIda && fechaRetorno?.value) {
        const diffTime = Math.abs(new Date(fechaRetorno.value) - new Date(salidaStr));
        noches = Math.ceil(diffTime / (1000*60*60*24)) || 1;
    }
  
    const pasajeros = parseInt(pasajerosSelect?.value || 1);
    const precioS = destino.precioSoles || destino.precioBase || 0;
    const subtotal = precioS * noches * pasajeros;
    const { igv, total } = calcularPrecioConImpuestos(subtotal);
  
    const precioSolesSpan = document.getElementById('precioSoles');
    if (precioSolesSpan) precioSolesSpan.textContent = `S/ ${total.toFixed(2)}`;
  
    window.precioActual = { subtotal, igv, total, noches, pasajeros, destino };
    return total;
}
  
function procesarReserva() {
    if (!window.precioActual) {
        alert('⚠️ Completa los datos');
        return;
    }
    const tipoViaje = document.getElementById('tipoViaje')?.value;
    const reserva = {
        id: Date.now(),
        destino: window.precioActual.destino,
        tipoViaje: tipoViaje,
        fechaSalida: document.getElementById('fechaSalida')?.value,
        fechaRetorno: tipoViaje === 'roundtrip' ? document.getElementById('fechaRetorno')?.value : null,
        pasajeros: window.precioActual.pasajeros,
        noches: window.precioActual.noches,
        subtotal: window.precioActual.subtotal,
        igv: window.precioActual.igv,
        precioTotal: window.precioActual.total,
        fechaReserva: new Date().toLocaleString()
    };
    let reservas = JSON.parse(localStorage.getItem('reservasChasqui')) || [];
    reservas.push(reserva);
    localStorage.setItem('reservasChasqui', JSON.stringify(reservas));
    localStorage.setItem('reservaActual', JSON.stringify(reserva));
    window.location.href = 'reserva.jsp';
}
  
function setFechasMinimas() {
    const tomorrow = new Date();
    tomorrow.setDate(tomorrow.getDate() + 1);
    const minDate = tomorrow.toISOString().split('T')[0];
    const fechaSalida = document.getElementById('fechaSalida');
    const fechaRetorno = document.getElementById('fechaRetorno');
    if (fechaSalida) fechaSalida.min = minDate;
    if (fechaRetorno) fechaRetorno.min = minDate;
}
