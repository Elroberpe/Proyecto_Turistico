// ==================== DATOS DE MUESTRA (equivalente a data.js) ====================
const destinosData = [
  { id:1, nombre:"Máncora", region:"costa", descripcion:"Playas cálidas y vida nocturna frente al mar.", precioBase:180, imagen:"https://picsum.photos/seed/mancora/700/500", incluye:["Hospedaje","Traslados","Tour de playa"] },
  { id:2, nombre:"Paracas", region:"costa", descripcion:"Reserva marina, Islas Ballestas y desierto costero.", precioBase:150, imagen:"https://picsum.photos/seed/paracas/700/500", incluye:["Tour en lancha","Hospedaje","Desayuno"] },
  { id:3, nombre:"Cusco Imperial", region:"sierra", descripcion:"Ciudad imperial, historia inca y arquitectura colonial.", precioBase:350, imagen:"https://picsum.photos/seed/cuscoimperial/700/500", incluye:["City tour","Hospedaje","Guía local"] },
  { id:4, nombre:"Camino Inca a Machu Picchu", region:"sierra", descripcion:"La ruta más icónica hacia la ciudadela inca.", precioBase:1200, imagen:"https://picsum.photos/seed/caminoinca/700/500", incluye:["Porteadores","Campamento","Entrada a Machu Picchu"] },
  { id:5, nombre:"Iquitos y Amazonía", region:"selva", descripcion:"Navegación por el río y comunidades nativas.", precioBase:420, imagen:"https://picsum.photos/seed/iquitos/700/500", incluye:["Paseo en bote","Lodge","Alimentación"] },
  { id:6, nombre:"Tarapoto", region:"selva", descripcion:"Cataratas, lagunas y aventura en la selva alta.", precioBase:260, imagen:"https://picsum.photos/seed/tarapoto/700/500", incluye:["Tour cataratas","Hospedaje","Traslados"] }
];

const teamData = [
  { nombre:"María Fernández", cargo:"Especialista en Sierra", img:"https://i.pravatar.cc/300?img=47" },
  { nombre:"Jorge Ramírez", cargo:"Especialista en Costa", img:"https://i.pravatar.cc/300?img=12" },
  { nombre:"Lucía Torres", cargo:"Especialista en Selva", img:"https://i.pravatar.cc/300?img=32" },
  { nombre:"Diego Salazar", cargo:"Asesor de viajes grupales", img:"https://i.pravatar.cc/300?img=51" }
];

const regionLabel = { costa:"Costa", sierra:"Sierra", selva:"Selva" };

// ==================== VARIABLES GLOBALES ====================
let tipoCambioActual = 3.75;
let previewTimeout = null;

// ==================== INICIALIZACIÓN ====================
document.addEventListener('DOMContentLoaded', async () => {
  await obtenerTipoCambio();
  cargarDestinosEnSelect();
  cargarPaquetesDestacados();
  cargarEquipoAsesores();
  initEventosBuscador();
  initHoverPreview();
  setFechasMinimas();
  cargarDestinoDesdeURL();
});

// ==================== CARGAR DESTINO DESDE URL ====================
function cargarDestinoDesdeURL() {
  const urlParams = new URLSearchParams(window.location.search);
  const destinoId = urlParams.get('destino');
  if (destinoId) {
    const destinoSelect = document.getElementById('destinoSelect');
    if (destinoSelect) {
      destinoSelect.value = destinoId;
      destinoSelect.dispatchEvent(new Event('change'));
    }
    setTimeout(() => {
      document.getElementById('searchCard')?.scrollIntoView({ behavior:'smooth' });
    }, 500);
  }
}

// ==================== TIPO DE CAMBIO ====================
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

// ==================== SELECT DE DESTINOS ====================
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

// ==================== PAQUETES DESTACADOS ====================
function cargarPaquetesDestacados() {
  const container = document.getElementById('paquetesContainer');
  if (!container) return;
  container.innerHTML = '';
  const destacados = destinosData.slice(0, 3);

  destacados.forEach(destino => {
    const col = document.createElement('div');
    col.className = 'col-md-4';
    col.innerHTML = `
      <div class="card-tour">
        <div class="img-wrap">
          <img src="${destino.imagen}" alt="${destino.nombre}">
          <span class="badge-region">${regionLabel[destino.region]}</span>
        </div>
        <div class="body">
          <h3>${destino.nombre}</h3>
          <p class="desc">${destino.descripcion}</p>
          <p class="incluye"><i class="bi bi-check-circle-fill"></i> ${destino.incluye.slice(0,2).join(' · ')}</p>
          <div class="d-flex justify-content-between align-items-end mt-3">
            <div class="precio">S/ ${destino.precioBase}<small> / persona</small></div>
            <button class="btn btn-terracota btn-sm" onclick="seleccionarDestino(${destino.id})">
              <i class="bi bi-calendar-check"></i> Reservar
            </button>
          </div>
        </div>
      </div>
    `;
    container.appendChild(col);
  });
}

// ==================== EQUIPO ASESORES ====================
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
function seleccionarDestino(id) {
  const destinoSelect = document.getElementById('destinoSelect');
  if (destinoSelect) {
    destinoSelect.value = id;
    destinoSelect.dispatchEvent(new Event('change'));
  }
  document.getElementById('searchCard')?.scrollIntoView({ behavior:'smooth' });
}

function getDestinoById(id) {
  return destinosData.find(d => d.id === parseInt(id));
}

// ==================== EVENTOS DEL BUSCADOR ====================
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

// ==================== IGV (18% Perú) ====================
function calcularPrecioConImpuestos(subtotal) {
  const igv = subtotal * 0.18;
  const total = subtotal + igv;
  return { igv, total };
}

// ==================== CALCULAR PRECIO ====================
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
  hoy.setHours(0,0,0,0);
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
    noches = Math.ceil(diffTime / (1000*60*60*24));
  }

  const pasajeros = parseInt(pasajerosSelect.value);
  const subtotal = destino.precioBase * noches * pasajeros;
  const { igv, total } = calcularPrecioConImpuestos(subtotal);
  const totalUSD = total * tipoCambioActual;

  const precioSolesSpan = document.getElementById('precioSoles');
  const precioUSDSpan = document.getElementById('precioUSD');
  if (precioSolesSpan) precioSolesSpan.textContent = `S/ ${total.toFixed(2)}`;
  if (precioUSDSpan) precioUSDSpan.textContent = `($${totalUSD.toFixed(2)} USD)`;
  if (validationMsg) validationMsg.textContent = '';

  window.precioActual = { subtotal, igv, total, noches, pasajeros, destino };
  return total;
}

// ==================== PROCESAR RESERVA ====================
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

  let reservas = JSON.parse(localStorage.getItem('reservasChasqui')) || [];
  reservas.push(reserva);
  localStorage.setItem('reservasChasqui', JSON.stringify(reservas));
  localStorage.setItem('reservaActual', JSON.stringify(reserva));

  window.location.href = 'reserva.html';
}

// ==================== FECHAS MÍNIMAS ====================
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

  destinoSelect.addEventListener('mouseover', () => {
    if (previewTimeout) clearTimeout(previewTimeout);
    previewTimeout = setTimeout(() => {
      const selectedId = parseInt(destinoSelect.value);
      if (selectedId && previewBox) {
        const destino = getDestinoById(selectedId);
        if (destino) {
          previewBox.innerHTML = `
            <img src="${destino.imagen}" alt="${destino.nombre}">
            <p>${destino.nombre}</p>
            <small>${destino.descripcion.substring(0,50)}...</small>
          `;
          previewBox.style.display = 'block';
          const rect = destinoSelect.getBoundingClientRect();
          let leftPos = rect.right + 10;
          if (leftPos + 220 > window.innerWidth) leftPos = rect.left - 230;
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