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
});
