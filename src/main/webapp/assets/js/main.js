const regionLabel = { costa: "Costa", sierra: "Sierra", selva: "Selva" };
let tipoCambioActual = 3.75;
let previewTimeout = null;
let destinosGlobales = []; // Cache para buscador

document.addEventListener('DOMContentLoaded', async () => {
  await obtenerTipoCambio();
  await inicializarDatos();
  cargarEquipoAsesores();
  initHoverPreview();
  cargarDestinoDesdeURL();
});

// Función puente para que booking-modal.js sepa dónde buscar la data
window.getPaqueteParaModal = function(id) {
    return destinosGlobales.find(d => (d.idPaquete == id || d.id == id));
};

async function inicializarDatos() {
  try {
    const response = await fetch('api/paquetes');
    if(response.ok) {
        destinosGlobales = await response.json();
    } else {
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
      destinoSelect.dispatchEvent(new Event('change')); // dispara calcularPrecio de booking-modal
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

function initHoverPreview() {}
