// ==================== VARIABLES GLOBALES ====================
let tipoCambioActual = 3.75;
let previewTimeout = null;

// ==================== INICIALIZACIÓN ====================
// Se ejecuta cuando el DOM está completamente cargado
// async/await permite esperar la respuesta de la API
document.addEventListener('DOMContentLoaded', async () => {
    await obtenerTipoCambio();
    cargarDestinosEnSelect();
    cargarPaquetesDestacados();
    cargarEquipoAsesores();
    initEventosBuscador();
    initHoverPreview();
    setFechasMinimas();
    
    // Verificar si hay destino precargado desde URL (para páginas costa, sierra, selva)
    cargarDestinoDesdeURL();
});

// ==================== CARGAR DESTINO DESDE URL ====================
// Lee el parámetro 'destino' de la URL (destino=1)
// Permite precargar un destino cuando se viene desde costa/sierra/selva
function cargarDestinoDesdeURL() {
    const urlParams = new URLSearchParams(window.location.search);
    const destinoId = urlParams.get('destino');
    
    if (destinoId) {
        const destinoSelect = document.getElementById('destinoSelect');
        if (destinoSelect) {
            destinoSelect.value = destinoId;
            // Disparar evento change para actualizar precio
            const event = new Event('change');
            destinoSelect.dispatchEvent(event);
        }
        // Scroll al formulario
        setTimeout(() => {
            document.getElementById('searchCard')?.scrollIntoView({ behavior: 'smooth' });
        }, 500);
    }
}

// ==================== OBTENER TIPO DE CAMBIO ====================
// Solicita a una API externa el tipo de cambio de Soles a Dólares
// try/catch maneja errores de red o API no disponible
async function obtenerTipoCambio() {
    try {
        const response = await fetch('https://api.exchangerate-api.com/v4/latest/PEN');
        if (response.ok) {
            const data = await response.json();
            tipoCambioActual = data.rates.USD;
        }
    } catch (error) {
        console.error('Error al obtener tipo de cambio:', error);
        tipoCambioActual = 0.27;
    }
}

// ==================== CARGAR DESTINOS EN SELECT ====================
// Llena dinámicamente el select de destinos con opciones
// Usa forEach() para recorrer el arreglo y createElement para crear cada option
function cargarDestinosEnSelect() {
    const destinoSelect = document.getElementById('destinoSelect');
    if (!destinoSelect) return;
    
    destinoSelect.innerHTML = '<option value="">Selecciona un destino</option>';
    
    destinosData.forEach(destino => {
        const option = document.createElement('option');
        option.value = destino.id;
        option.textContent = `${destino.nombre} (${destino.region.toUpperCase()})`;
        destinoSelect.appendChild(option);
    });
}

// ==================== CARGAR PAQUETES DESTACADOS ====================
function cargarPaquetesDestacados() {
    const container = document.getElementById('paquetesContainer');
    if (!container) return;
    
    container.innerHTML = '';
    const destacados = destinosData.slice(0, 3);
    
    destacados.forEach(destino => {
        const col = document.createElement('div');
        col.className = 'col-md-4';
        col.innerHTML = `
            <div class="destination-card">
                <img src="${destino.imagen}" alt="${destino.nombre}">
                <div class="card-body">
                    <h4>${destino.nombre}</h4>
                    <p>${destino.descripcion}</p>
                    <p class="price">S/ ${destino.precioBase} <small>/noche</small></p>
                    <small class="text-muted"><i class="bi bi-check-circle-fill text-success"></i> ${destino.incluye.slice(0,2).join(' • ')}</small>
                    <div class="mt-3">
                        <button class="btn btn-outline w-100" onclick="seleccionarDestino(${destino.id})">
                            <i class="bi bi-calendar-check"></i> Reservar ahora
                        </button>
                    </div>
                </div>
            </div>
        `;
        container.appendChild(col);
    });
}

// ==================== CARGAR EQUIPO ASESORES ====================
// Genera las tarjetas de los asesores de viaje dinámicamente
function cargarEquipoAsesores() {
    const container = document.getElementById('teamContainer');
    if (!container) return;
    
    container.innerHTML = '';
    
    teamData.forEach(miembro => {
        const col = document.createElement('div');
        col.className = 'col-md-3 col-sm-6';
        col.innerHTML = `
            <div class="team-card">
                <img src="${miembro.img}" alt="${miembro.nombre}">
                <h4>${miembro.nombre}</h4>
                <p>${miembro.cargo}</p>
                <div class="social-links">
                    <a href="#"><i class="bi bi-twitter"></i></a>
                    <a href="#"><i class="bi bi-instagram"></i></a>
                    <a href="#"><i class="bi bi-facebook"></i></a>
                </div>
            </div>
        `;
        container.appendChild(col);
    });
}

// ==================== SELECCIONAR DESTINO ====================
// Se ejecuta al hacer clic en "Reservar ahora" desde las tarjetas
// Actualiza el select y hace scroll al formulario
function seleccionarDestino(id) {
    const destinoSelect = document.getElementById('destinoSelect');
    if (destinoSelect) {
        destinoSelect.value = id;
        const event = new Event('change');
        destinoSelect.dispatchEvent(event);
    }
    document.getElementById('searchCard')?.scrollIntoView({ behavior: 'smooth' });
}

// ==================== INICIALIZAR EVENTOS ====================
// Asigna los event listeners a los elementos del formulario
// change: recalcula precio cuando cambia algún valor
// submit: procesa la reserva al enviar el formulario
function initEventosBuscador() {
    const tipoViaje = document.getElementById('tipoViaje');
    const destinoSelect = document.getElementById('destinoSelect');
    const fechaSalida = document.getElementById('fechaSalida');
    const fechaRetorno = document.getElementById('fechaRetorno');
    const pasajerosSelect = document.getElementById('pasajerosSelect');
    const bookingForm = document.getElementById('bookingForm');
    
    if (tipoViaje) tipoViaje.addEventListener('change', () => {
        toggleRetorno();
        calcularPrecio();
    });
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

// ==================== TOGGLE RETORNO ====================
// Muestra u oculta el campo de fecha de retorno según el tipo de viaje
// Modifica la propiedad CSS display del elemento
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

// ==================== CALCULAR PRECIO CON IMPUESTOS ====================
// Calcula el costo total del viaje basado en destino, noches y pasajeros
// Incluye validación de fechas y cálculo de IGV
function calcularPrecio() {
    const destinoSelect = document.getElementById('destinoSelect');
    const fechaSalida = document.getElementById('fechaSalida');
    const fechaRetorno = document.getElementById('fechaRetorno');
    const tipoViaje = document.getElementById('tipoViaje');
    const pasajerosSelect = document.getElementById('pasajerosSelect');
    const validationMsg = document.getElementById('validationMsg');
    
    if (!destinoSelect || !destinoSelect.value) return 0;
    
    const destinoId = parseInt(destinoSelect.value);
    const destino = getDestinoById(destinoId);
    
    if (!destino) return 0;
    
    const salidaStr = fechaSalida.value;
    if (!salidaStr) {
        if (validationMsg) validationMsg.textContent = '⚠️ Selecciona una fecha de salida';
        return 0;
    }
    
    const fechaSalidaObj = new Date(salidaStr);
    const hoy = new Date();
    hoy.setHours(0, 0, 0, 0);
    
    if (fechaSalidaObj <= hoy) {
        if (validationMsg) validationMsg.textContent = '❌ La fecha de salida debe ser posterior al día de hoy';
        return 0;
    }
    
    let noches = 1;
    const esSoloIda = tipoViaje.value === 'oneway';
    
    if (!esSoloIda) {
        const retornoStr = fechaRetorno.value;
        if (!retornoStr) {
            if (validationMsg) validationMsg.textContent = '⚠️ Selecciona una fecha de retorno';
            return 0;
        }
        
        const fechaRetornoObj = new Date(retornoStr);
        if (fechaRetornoObj <= fechaSalidaObj) {
            if (validationMsg) validationMsg.textContent = '❌ La fecha de retorno debe ser posterior a la salida';
            return 0;
        }
        
        const diffTime = Math.abs(fechaRetornoObj - fechaSalidaObj);
        noches = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    }
    
    const pasajeros = parseInt(pasajerosSelect.value);
    const subtotal = destino.precioBase * noches * pasajeros;
    const { igv, total } = calcularPrecioConImpuestos(subtotal);
    const totalUSD = total * tipoCambioActual;
    
    // Actualizar DOM
    const precioSolesSpan = document.getElementById('precioSoles');
    const precioUSDSpan = document.getElementById('precioUSD');
    
    if (precioSolesSpan) precioSolesSpan.textContent = `S/ ${total.toFixed(2)}`;
    if (precioUSDSpan) precioUSDSpan.textContent = `($${totalUSD.toFixed(2)} USD)`;
    
    if (validationMsg) validationMsg.textContent = '';
    
    // Guardar datos de precio para la reserva
    window.precioActual = { subtotal, igv, total, noches, pasajeros, destino };
    
    return total;
}

// ==================== PROCESAR RESERVA ====================
// Crea un objeto con los datos de la reserva y lo guarda en localStorage
// Redirige a la página de pago
function procesarReserva() {
    const destinoSelect = document.getElementById('destinoSelect');
    const fechaSalida = document.getElementById('fechaSalida');
    const fechaRetorno = document.getElementById('fechaRetorno');
    const tipoViaje = document.getElementById('tipoViaje');
    const pasajerosSelect = document.getElementById('pasajerosSelect');
    
    if (!destinoSelect || !destinoSelect.value) {
        alert('⚠️ Por favor, selecciona un destino');
        return;
    }
    
    const destinoId = parseInt(destinoSelect.value);
    const destino = getDestinoById(destinoId);
    
    // Recalcular para obtener valores actualizados
    calcularPrecio();
    
    const subtotal = window.precioActual?.subtotal || 0;
    const igv = window.precioActual?.igv || 0;
    const total = window.precioActual?.total || 0;
    const noches = window.precioActual?.noches || 1;
    const pasajeros = parseInt(pasajerosSelect.value);
    
    const reserva = {
        id: Date.now(),
        destino: destino,
        tipoViaje: tipoViaje.value,
        fechaSalida: fechaSalida.value,
        fechaRetorno: tipoViaje.value === 'roundtrip' ? fechaRetorno.value : null,
        pasajeros: pasajeros,
        noches: noches,
        subtotal: subtotal,
        igv: igv,
        precioTotal: total,
        fechaReserva: new Date().toLocaleString()
    };
    
    // Guardar en localStorage
    let reservas = JSON.parse(localStorage.getItem('reservasChasqui')) || [];
    reservas.push(reserva);
    localStorage.setItem('reservasChasqui', JSON.stringify(reservas));
    localStorage.setItem('reservaActual', JSON.stringify(reserva));
    
    window.location.href = 'reserva.html';
}

// ==================== SET FECHAS MÍNIMAS ====================
// Configura el atributo min de los input date para evitar fechas pasadas
// La fecha mínima es el día siguiente al actual
function setFechasMinimas() {
    const fechaSalida = document.getElementById('fechaSalida');
    const fechaRetorno = document.getElementById('fechaRetorno');
    
    const today = new Date();
    const tomorrow = new Date(today);
    tomorrow.setDate(today.getDate() + 1);
    const minDate = tomorrow.toISOString().split('T')[0];
    
    if (fechaSalida) fechaSalida.min = minDate;
    if (fechaRetorno) fechaRetorno.min = minDate;
}

// ==================== HOVER PREVIEW ====================
// Muestra una vista previa del destino al pasar el mouse sobre el select
// Usa setTimeout para delay, getBoundingClientRect para posicionamiento
function initHoverPreview() {
    const destinoSelect = document.getElementById('destinoSelect');
    if (!destinoSelect) return;
    
    let previewBox = null;
    
    destinoSelect.addEventListener('mouseenter', () => {
        if (!previewBox) {
            previewBox = document.createElement('div');
            previewBox.className = 'preview-box';
            document.body.appendChild(previewBox);
        }
    });
    
    destinoSelect.addEventListener('mouseover', (e) => {
        if (previewTimeout) clearTimeout(previewTimeout);
        
        previewTimeout = setTimeout(() => {
            const selectedId = parseInt(destinoSelect.value);
            if (selectedId && previewBox) {
                const destino = getDestinoById(selectedId);
                if (destino) {
                    previewBox.innerHTML = `
                        <img src="${destino.imagen}" alt="${destino.nombre}">
                        <p>${destino.nombre}</p>
                        <small>${destino.descripcion.substring(0, 50)}...</small>
                    `;
                    previewBox.style.display = 'block';
                    
                    const rect = destinoSelect.getBoundingClientRect();
                    let leftPos = rect.right + 10;
                    if (leftPos + 220 > window.innerWidth) {
                        leftPos = rect.left - 230;
                    }
                    previewBox.style.left = leftPos + 'px';
                    previewBox.style.top = (rect.top - 20) + 'px';
                }
            }
        }, 300);
    });
    
    destinoSelect.addEventListener('mouseout', () => {
        if (previewTimeout) clearTimeout(previewTimeout);
        if (previewBox) previewBox.style.display = 'none';
    });
}