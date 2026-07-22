// ==================== MÓDULO DE REGIÓN ====================
// Archivo compartido por costa.html, sierra.html y selva.html.
// La región activa se lee desde el atributo data-region del <body>,
// por ejemplo: <body data-region="costa">
// Así evitamos tener código duplicado en cada página.

const currentRegion = document.body.dataset.region;
let tipoCambioActual = 3.75;
let paquetesActuales = [];

// ==================== INICIALIZACIÓN ====================
document.addEventListener('DOMContentLoaded', async () => {
    await obtenerTipoCambio();
    await cargaPaquetesDesdeServidor();
	cargarDestinosSelect();
    cargarDestinosRegion();
    initEventos();
    setFechasMinimas();
});


async function cargaPaquetesDesdeServidor(){
	try{
		const response = await fetch(`api/${currentRegion}`);
		if(!response.ok) throw new Error('Error HTTP: ' + response.status);
		
		paquetesActuales = await response.json();
		
	}
	catch(error){
		console.error('No se pudieron cargar los paquetes: ', error);
		paquetesActuales = [];
	}
}

// ==================== OBTENER TIPO DE CAMBIO ====================
// Consulta la API de tipo de cambio para convertir Soles a Dólares.
// En caso de fallo de red usa el valor de respaldo 0.27.
async function obtenerTipoCambio() {
    try {
        const response = await fetch('https://api.exchangerate-api.com/v4/latest/PEN');
        if (response.ok) {
            const data = await response.json();
            tipoCambioActual = data.rates.USD;
        }
    } catch (e) {
        tipoCambioActual = 0.27;
    }
}

// ==================== CARGAR DESTINOS EN SELECT ====================
// Filtra los destinos del data.js según la región del body y los
// carga como opciones en el <select id="destinoSelect">.
function cargarDestinosSelect() {
    const select = document.getElementById('destinoSelect');
    if (!select) return;

    // Limpiar opciones anteriores dejando la primera
    select.length = 1;

    paquetesActuales.forEach(p => {
        const option = document.createElement('option');
        option.value = p.idPaquete;
        option.textContent = `${p.nombre} - S/ ${Number(p.precioSoles).toFixed(2)}`;
        select.appendChild(option);
    });
}

// ==================== RENDERIZAR TARJETAS DE DESTINOS ====================
// Genera las tarjetas HTML de los destinos de la región actual
// e inserta el HTML en el contenedor #destinosContainer.
function cargarDestinosRegion() {
    const container = document.getElementById('destinosContainer');
    if (!container) return;

    container.innerHTML = '';

    if (paquetesActuales.length === 0) {
        container.innerHTML = `
            <div class="col-12 text-center text-muted">
                No hay paquetes disponibles para esta región.
            </div>
        `;
        return;
    }

    paquetesActuales.forEach(p => {

        const col = document.createElement('div');
        col.className = 'col-md-4';

        col.innerHTML = `
            <div class="card-tour">
                <div class="img-wrap">
                    <img src="${p.imagenUrl}" alt="${p.nombre}">
                    <span class="badge-region"><i class="bi bi-geo-alt"></i> ${p.destino}</span>
                </div>
                <div class="body">
                    <h3>${p.nombre}</h3>
                    <div class="meta mb-2">Destino destacado de la región</div>
                    <div class="d-flex justify-content-between align-items-end mt-3">
                        <div class="precio">S/ ${Number(p.precioSoles).toFixed(2)}<small> / persona</small></div>
                        <button class="btn btn-primary btn-sm" onclick="seleccionarDestino(${p.idPaquete})">Seleccionar</button>
                    </div>
                </div>
            </div>
        `;

        container.appendChild(col);
    });
}

// ==================== SELECCIONAR DESTINO DESDE TARJETA ====================
// Se ejecuta al hacer clic en "Reservar ahora" desde una tarjeta.
// Actualiza el select y hace scroll suave al formulario.
function seleccionarDestino(id) {
    const select = document.getElementById('destinoSelect');
    const paquete = getPaqueteById(id);
    if (select && paquete) {
        select.value = id;
        
        // Actualizar título en el modal
        const modalDestinoNombre = document.getElementById('modalDestinoNombre');
        if(modalDestinoNombre) modalDestinoNombre.textContent = paquete.nombre;
        
        // Disparar cálculo de precio
        select.dispatchEvent(new Event('change'));
        
        // Mostrar modal usando Bootstrap 5
        const modalEl = document.getElementById('modalReserva');
        if (modalEl) {
            const modal = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl);
            modal.show();
        }
    }
}

// ==================== INICIALIZAR EVENTOS DEL FORMULARIO ====================
// Asigna los listeners de cambio a todos los campos del formulario
// para recalcular el precio en tiempo real.
function initEventos() {
    const tipoViaje      = document.getElementById('tipoViaje');
    const destinoSelect  = document.getElementById('destinoSelect');
    const fechaSalida    = document.getElementById('fechaSalida');
    const fechaRetorno   = document.getElementById('fechaRetorno');
    const pasajerosSelect = document.getElementById('pasajerosSelect');
    const bookingForm    = document.getElementById('bookingForm');

    if (tipoViaje) {
        tipoViaje.addEventListener('change', () => {
            // Muestra u oculta la fecha de retorno según el tipo de viaje
            const retornoGroup = document.getElementById('retornoGroup');
            if (retornoGroup) {
                retornoGroup.style.display =
                    tipoViaje.value === 'oneway' ? 'none' : 'block';
            }
            calcularPrecio();
        });
    }

    if (destinoSelect)  destinoSelect.addEventListener('change', calcularPrecio);
    if (fechaSalida)    fechaSalida.addEventListener('change', calcularPrecio);
    if (fechaRetorno)   fechaRetorno.addEventListener('change', calcularPrecio);
    if (pasajerosSelect) pasajerosSelect.addEventListener('change', calcularPrecio);

    if (bookingForm) {
        bookingForm.addEventListener('submit', e => {
            e.preventDefault();
            procesarReserva();
        });
    }
}

function getPaqueteById(id) {
    return paquetesActuales.find(p => p.idPaquete === parseInt(id));
}

// ==================== CALCULAR PRECIO ====================
// Calcula el costo total del viaje (con IGV) según el destino,
// las fechas y la cantidad de pasajeros seleccionados.
function calcularPrecio() {
    const destinoId = document.getElementById('destinoSelect')?.value;
    if (!destinoId) return;

    const destino = getPaqueteById(destinoId);
    if (!destino) return;

    const fechaSalidaVal = document.getElementById('fechaSalida')?.value;
    if (!fechaSalidaVal) return;

    let noches = 1;
    const tipoViaje = document.getElementById('tipoViaje')?.value;

    if (tipoViaje === 'roundtrip') {
        const retornoVal = document.getElementById('fechaRetorno')?.value;
        if (retornoVal) {
            noches = Math.ceil(
                (new Date(retornoVal) - new Date(fechaSalidaVal)) / 86400000
            );
            if (noches < 1) noches = 1;
        }
    }

    const pasajeros = parseInt(document.getElementById('pasajerosSelect')?.value || 1);
    const subtotal  = destino.precioBase * noches * pasajeros;
    const { igv, total } = calcularPrecioConImpuestos(subtotal);

    // Actualizar precio mostrado en pantalla
    const precioSolesEl = document.getElementById('precioSoles');
    if (precioSolesEl) precioSolesEl.textContent = `S/ ${total.toFixed(2)}`;

    // Guardar datos de precio para usarlos al procesar la reserva
    window.precioActual = { subtotal, igv, total, noches, pasajeros, destino };
}

// ==================== PROCESAR RESERVA ====================
// Construye el objeto de reserva, lo guarda en localStorage
// y redirige a la página de pago (reserva.html).
function procesarReserva() {
    if (!window.precioActual) {
        alert('⚠️ Completa los datos de tu viaje antes de reservar');
        return;
    }

    const reserva = {
        id           : Date.now(),
        destino      : window.precioActual.destino,
        tipoViaje    : document.getElementById('tipoViaje')?.value,
        fechaSalida  : document.getElementById('fechaSalida')?.value,
        fechaRetorno : document.getElementById('fechaRetorno')?.value || null,
        pasajeros    : window.precioActual.pasajeros,
        noches       : window.precioActual.noches,
        subtotal     : window.precioActual.subtotal,
        igv          : window.precioActual.igv,
        precioTotal  : window.precioActual.total,
        fechaReserva : new Date().toLocaleString()
    };

    // Guardar en historial y como reserva activa
    let reservas = JSON.parse(localStorage.getItem('reservasChasqui')) || [];
    reservas.push(reserva);
    localStorage.setItem('reservasChasqui', JSON.stringify(reservas));
    localStorage.setItem('reservaActual', JSON.stringify(reserva));

    window.location.href = 'reserva.html';
}

// ==================== FECHAS MÍNIMAS ====================
// Configura el atributo min de los inputs de fecha para
// que el usuario no pueda seleccionar fechas pasadas.
function setFechasMinimas() {
    const tomorrow = new Date();
    tomorrow.setDate(tomorrow.getDate() + 1);
    const minDate = tomorrow.toISOString().split('T')[0];

    const fechaSalida  = document.getElementById('fechaSalida');
    const fechaRetorno = document.getElementById('fechaRetorno');
    if (fechaSalida)  fechaSalida.min  = minDate;
    if (fechaRetorno) fechaRetorno.min = minDate;
}
