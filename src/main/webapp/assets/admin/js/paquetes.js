// ==========================================
// GESTIÓN DE PAQUETES TURÍSTICOS (ADMIN)
// ==========================================

document.addEventListener('DOMContentLoaded', function () {
    const btnNuevo = document.getElementById("btnNuevo");
    const action = document.getElementById("action");
    const id = document.getElementById("id");
    const nombre = document.getElementById("nombre");
    const idCategoria = document.getElementById("idCategoria");
    const destino = document.getElementById("destino");
    const precioSoles = document.getElementById("precioSoles");
    const descripcion = document.getElementById("descripcion");
    const imagenUrl = document.getElementById("imagenUrl");
    const estado = document.getElementById("estado");
    const modalTitle = document.getElementById("modalTitle");
    const formEliminar = document.getElementById("formEliminar");
    const idEliminar = document.getElementById("idEliminar");

    // Limpiar campos del modal para Nuevo Paquete
    if (btnNuevo) {
        btnNuevo.addEventListener("click", function () {
            if (action) action.value = "crear";
            if (id) id.value = "";
            if (nombre) nombre.value = "";
            if (idCategoria) idCategoria.selectedIndex = 0;
            if (destino) destino.value = "";
            if (precioSoles) precioSoles.value = "";
            if (descripcion) descripcion.value = "";
            if (imagenUrl) imagenUrl.value = "";
            if (estado) estado.value = "activo";
            if (modalTitle) modalTitle.textContent = "Nuevo Paquete";
        });
    }

    // Cargar datos en el modal para Editar Paquete
    document.querySelectorAll(".btn-editar").forEach(function (btn) {
        btn.addEventListener("click", function () {
            if (action) action.value = "editar";
            if (id) id.value = this.dataset.id || "";
            if (nombre) nombre.value = this.dataset.nombre || "";
            if (idCategoria) idCategoria.value = this.dataset.categoria || "";
            if (destino) destino.value = this.dataset.destino || "";
            if (precioSoles) precioSoles.value = this.dataset.precio || "";
            if (descripcion) descripcion.value = this.dataset.descripcion || "";
            if (imagenUrl) imagenUrl.value = this.dataset.imagen || "";
            if (estado) estado.value = this.dataset.estado || "activo";
            if (modalTitle) modalTitle.textContent = "Editar Paquete";
        });
    });

    // Confirmar eliminación con SweetAlert2
    document.querySelectorAll(".btn-eliminar").forEach(function (btn) {
        btn.addEventListener("click", function () {
            const idPaquete = this.dataset.id;
            const nombrePaquete = this.dataset.nombre || "el paquete";
            Swal.fire({
                title: "¿Eliminar paquete?",
                text: "Esta acción eliminará " + nombrePaquete + ". ¿Deseas continuar?",
                icon: "warning",
                showCancelButton: true,
                confirmButtonText: "Sí, eliminar",
                cancelButtonText: "Cancelar"
            }).then((result) => {
                if (result.isConfirmed) {
                    if (idEliminar && formEliminar) {
                        idEliminar.value = idPaquete;
                        formEliminar.submit();
                    }
                }
            });
        });
    });

    // ==========================================
    // FILTROS DE REGIÓN Y DESTINO
    // ==========================================
    const filtroRegion = document.getElementById('filtroRegion');
    const filtroDestino = document.getElementById('filtroDestino');

    // Al cambiar región: recargar la página con la nueva región (sin destino)
    if (filtroRegion) {
        filtroRegion.addEventListener('change', function () {
            const region = this.value;
            if (region === '0' || region === '') {
                window.location.href = getContextPath() + '/admin/paquetes';
            } else {
                window.location.href = getContextPath() + '/admin/paquetes?region=' + encodeURIComponent(region);
            }
        });
    }

    // Al cambiar destino: aplicar ambos filtros
    if (filtroDestino) {
        filtroDestino.addEventListener('change', function () {
            aplicarFiltro();
        });
    }
});

function aplicarFiltro() {
    var region = document.getElementById('filtroRegion').value;
    var destino = document.getElementById('filtroDestino').value;
    var url = getContextPath() + '/admin/paquetes';

    if (region !== '0' && region !== '') {
        url += '?region=' + encodeURIComponent(region);
        if (destino !== '') {
            url += '&destino=' + encodeURIComponent(destino);
        }
    }
    window.location.href = url;
}

function limpiarFiltros() {
    window.location.href = getContextPath() + '/admin/paquetes';
}

function getContextPath() {
    var base = document.querySelector('base');
    if (base) return base.href.replace(/\/$/, '');
    return window.location.pathname.split('/').slice(0, 2).join('/');
}
