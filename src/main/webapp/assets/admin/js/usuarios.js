// ==========================================
// GESTIÓN DE USUARIOS (ADMIN)
// ==========================================

document.addEventListener('DOMContentLoaded', function () {
    const btnNuevo = document.getElementById("btnNuevo");
    const actionUsuario = document.getElementById("actionUsuario");
    const idUsuario = document.getElementById("idUsuario");
    const nombreUsuario = document.getElementById("nombreUsuario");
    const apellidosUsuario = document.getElementById("apellidosUsuario");
    const emailUsuario = document.getElementById("emailUsuario");
    const telefonoUsuario = document.getElementById("telefonoUsuario");
    const passwordUsuario = document.getElementById("passwordUsuario");
    const passwordContainer = document.getElementById("passwordContainer");
    const rolUsuario = document.getElementById("rolUsuario");
    const usuarioModalTitle = document.getElementById("usuarioModalTitle");
    const btnGuardarModal = document.getElementById("btnGuardarModal");
    const formEliminar = document.getElementById("formEliminar");
    const idEliminar = document.getElementById("idEliminar");

    // Limpiar formulario para nuevo usuario
    if (btnNuevo) {
        btnNuevo.addEventListener("click", function () {
            if (actionUsuario) actionUsuario.value = "crear";
            if (idUsuario) idUsuario.value = "";
            if (nombreUsuario) nombreUsuario.value = "";
            if (apellidosUsuario) apellidosUsuario.value = "";
            if (emailUsuario) emailUsuario.value = "";
            if (telefonoUsuario) telefonoUsuario.value = "";
            if (passwordUsuario) {
                passwordUsuario.value = "";
                passwordUsuario.required = true;
            }
            if (passwordContainer) passwordContainer.style.display = "block";
            if (rolUsuario) rolUsuario.value = "2";
            if (usuarioModalTitle) usuarioModalTitle.textContent = "Nuevo Usuario";
        });
    }

    // Llenar formulario para editar usuario
    document.querySelectorAll(".btn-editar").forEach(boton => {
        boton.addEventListener("click", function () {
            if (actionUsuario) actionUsuario.value = "editar";
            if (idUsuario) idUsuario.value = this.dataset.id || "";
            if (nombreUsuario) nombreUsuario.value = this.dataset.nombre || "";
            if (apellidosUsuario) apellidosUsuario.value = this.dataset.apellidos || "";
            if (emailUsuario) emailUsuario.value = this.dataset.email || "";
            if (telefonoUsuario) telefonoUsuario.value = this.dataset.telefono || "";
            if (passwordUsuario) {
                passwordUsuario.value = "";
                passwordUsuario.required = false;
            }
            if (passwordContainer) passwordContainer.style.display = "none";
            if (rolUsuario) rolUsuario.value = this.dataset.rol || "1";
            if (usuarioModalTitle) usuarioModalTitle.textContent = "Editar Usuario: " + (this.dataset.nombre || "");
            if (btnGuardarModal) btnGuardarModal.className = "btn btn-primary-custom";
        });
    });

    // Eliminar con SweetAlert2
    document.querySelectorAll(".btn-eliminar").forEach(boton => {
        boton.addEventListener("click", function () {
            const id = this.dataset.id;
            const nombre = this.dataset.nombre || "el usuario";
            Swal.fire({
                title: "¿Eliminar usuario?",
                text: "Esta acción eliminará a " + nombre + ". ¿Deseas continuar?",
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
