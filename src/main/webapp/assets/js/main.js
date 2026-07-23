const regionLabel = { costa: "Costa", sierra: "Sierra", selva: "Selva" };
let tipoCambioActual = 3.75;
let previewTimeout = null;
let destinosGlobales = []; // Cache para buscador

document.addEventListener('DOMContentLoaded', async () => {
  await obtenerTipoCambio();
  await inicializarDatos();
  cargarEquipoAsesores();
  initEventosBuscador();
  initHoverPreview();
  setFechasMinimas();
  cargarDestinoDesdeURL();
});

async function inicializarDatos() {
  try {
    // Simulamos endpoint global de paquetes (cuando esté listo en tu BD)
    const response = await fetch('api/paquetes');
    if(response.ok) {
        destinosGlobales = await response.json();
    } else {
        // Fallback: si falla 'api/paquetes', intentamos cargar 'api/sierra' temporalmente
        const resSierra = await fetch('api/sierra');
        if(resSierra.ok) destinosGlobales = await resSierra.json();
    }
  } catch(e) {
    console.warn("API global no disponible aún. ", e);
  }
  
  cargarDestinosEnSelect();
  cargarPaquetesDestacados();
}

function cargarDestinosEnSelect() {
  const destinoSelect = document.getElementById('destinoSelect');
  if (!destinoSelect) return;
  destinoSelect.innerHTML = '<option value="">Selecciona un destino</option>';
  destinosGlobales.forEach(destino => {
    const option = document.createElement('option');
    option.value = destino.idPaquete || destino.id;
    option.textContent = `${destino.nombre} (${destino.region ? destino.region.toUpperCase() : ''})`;
    destinoSelect.appendChild(option);
  });
}

function cargarPaquetesDestacados() {
  const container = document.getElementById('paquetesContainer');
  if (!container) return;
  container.innerHTML = '';
  
  if(destinosGlobales.length === 0) {
      container.innerHTML = '<div class="col-12 text-center py-5 text-muted"><h4>Próximamente nuevos paquetes...</h4></div>';
      return;
  }
  
  const destacados = destinosGlobales.slice(0, 3);
  destacados.forEach(destino => {
    const id = destino.idPaquete || destino.id;
    const regionText = regionLabel[destino.region] || destino.region || '';
    
    const col = document.createElement('div');
    col.className = 'col-md-4';
    col.innerHTML = `
      <div class="card-tour">
        <div class="img-wrap">
          <img src="${destino.imagenUrl || destino.imagen}" alt="${destino.nombre}">
          <span class="badge-region">${regionText}</span>
        </div>
        <div class="body">
          <h3>${destino.nombre}</h3>
          <div class="meta mb-2">"${destino.descripcion}"</div>
          <div class="d-flex justify-content-between align-items-end mt-3">
            <div class="precio">S/ ${Number(destino.precioSoles || destino.precioBase).toFixed(2)}<small> / persona</small></div>
            <button class="btn-card-action" onclick="seleccionarDestino(${id})">Seleccionar <i class="bi bi-arrow-right"></i></button>
          </div>
        </div>
      </div>
    `;
    container.appendChild(col);
  });
}

function cargarEquipoAsesores() {
  const teamData = [
    { nombre:"María Fernández", cargo:"Especialista en Sierra", img:"https://i.pravatar.cc/300?img=47" },
    { nombre:"Jorge Ramírez", cargo:"Especialista en Costa", img:"https://i.pravatar.cc/300?img=12" },
    { nombre:"Lucía Torres", cargo:"Especialista en Selva", img:"https://i.pravatar.cc/300?img=32" },
    { nombre:"Diego Salazar", cargo:"Asesor de viajes grupales", img:"https://i.pravatar.cc/300?img=51" }
  ];
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

async function obtenerTipoCambio() {
  try {
    const response = await fetch('https://api.exchangerate-api.com/v4/latest/PEN');
    if (response.ok) {
      const data = await response.json();
      tipoCambioActual = data.rates.USD;
    }
  } catch (error) {
    tipoCambioActual = 0.27;
  }
}

function seleccionarDestino(id) {
  const destinoSelect = document.getElementById('destinoSelect');
  if (destinoSelect) {
    destinoSelect.value = id;
    destinoSelect.dispatchEvent(new Event('change'));
  }
  document.getElementById('searchCard')?.scrollIntoView({ behavior:'smooth' });
  
  // Show Modal Reserva si existe
  const modalEl = document.getElementById('modalReserva');
  if (modalEl) {
      const paquete = getDestinoById(id);
      const modalDestinoNombre = document.getElementById('modalDestinoNombre');
      if(modalDestinoNombre && paquete) modalDestinoNombre.textContent = paquete.nombre;
      
      const modal = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl);
      modal.show();
  }
}

function getDestinoById(id) {
  return destinosGlobales.find(d => (d.idPaquete == id || d.id == id));
}

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
  const validationMsg = document.getElementById('validationMsg');

  if (!destinoSelect || !destinoSelect.value) return 0;

  const destinoId = parseInt(destinoSelect.value);
  const destino = getDestinoById(destinoId);
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
  window.location.href = 'reserva.html';
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

function initHoverPreview() {}
