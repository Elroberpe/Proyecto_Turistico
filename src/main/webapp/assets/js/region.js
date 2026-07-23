// ==================== MÓDULO DE REGIÓN ====================
// Archivo compartido por costa.html, sierra.html y selva.html.

const currentRegion = document.body.dataset.region;
let tipoCambioActual = 3.75;
let paquetesActuales = [];

document.addEventListener('DOMContentLoaded', async () => {
    await obtenerTipoCambio();
    await cargaPaquetesDesdeServidor();
    cargarDestinosRegion();
});

// Función puente para que booking-modal.js sepa dónde buscar la data
window.getPaqueteParaModal = function(id) {
    return paquetesActuales.find(p => p.idPaquete === parseInt(id));
};

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
                    <div class="meta mb-2">"${p.descripcion}"</div>
                    <div class="d-flex justify-content-between align-items-end mt-3">
                        <div class="precio">S/ ${Number(p.precioSoles).toFixed(2)}<small> / persona</small></div>
                        <button class="btn-card-action" onclick="seleccionarDestino(${p.idPaquete})">Seleccionar <i class="bi bi-arrow-right"></i></button>
                    </div>
                </div>
            </div>
        `;

        container.appendChild(col);
    });
}
