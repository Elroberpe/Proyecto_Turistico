// ==========================================
// GESTIÓN DE CATEGORÍAS DE PAQUETES (ADMIN)
// ==========================================

document.addEventListener('DOMContentLoaded', function () {
    const btnNuevo = document.getElementById("btnNuevo");
    const idCategoria = document.getElementById("idCategoria");
    const nombre = document.getElementById("nombre");
    const descripcion = document.getElementById("descripcion");
    const accion = document.getElementById("accion");
    const formEliminar = document.getElementById("formEliminar");
    const idEliminar = document.getElementById("idEliminar");

    // Limpiar campos del modal para nueva categoría
    if (btnNuevo) {
        btnNuevo.addEventListener("click", function () {
            if (idCategoria) idCategoria.value = "";
            if (nombre) nombre.value = "";
            if (descripcion) descripcion.value = "";
            if (accion) accion.value = "guardar";
        });
    }

    // Llenar campos del modal al editar
    document.querySelectorAll(".btn-editar").forEach(boton => {
        boton.addEventListener("click", function () {
            if (idCategoria) idCategoria.value = this.dataset.id || "";
            if (nombre) nombre.value = this.dataset.nombre || "";
            if (descripcion) descripcion.value = this.dataset.descripcion || "";
            if (accion) accion.value = "actualizar";
        });
    });

    // Confirmar eliminación con SweetAlert2
    document.querySelectorAll(".btn-eliminar").forEach(boton => {
        boton.addEventListener("click", function () {
            const id = this.dataset.id;
            Swal.fire({
                title: "¿Eliminar categoría?",
                text: "Esta acción no se puede deshacer.",
                icon: "warning",
                showCancelButton: true,
                confirmButtonText: "Sí, eliminar",
                cancelButtonText: "Cancelar"
            }).then((result) => {
                if (result.isConfirmed) {
                    if (idEliminar && formEliminar) {
                        idEliminar.value = id;
                        formEliminar.submit();
                    }
                }
            });
        });
    });
});
