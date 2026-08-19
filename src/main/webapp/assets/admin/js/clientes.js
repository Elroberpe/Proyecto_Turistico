// ==========================================
// GESTIÓN DE CLIENTES (ADMIN)
// ==========================================

document.addEventListener('DOMContentLoaded', function () {
    const btnNuevo = document.getElementById("btnNuevo");
    const actionCliente = document.getElementById("actionCliente");
    const idCliente = document.getElementById("idCliente");
    const nombreCliente = document.getElementById("nombreCliente");
    const apellidosCliente = document.getElementById("apellidosCliente");
    const emailCliente = document.getElementById("emailCliente");
    const telefonoCliente = document.getElementById("telefonoCliente");
    const passwordCliente = document.getElementById("passwordCliente");
    const passwordContainerCliente = document.getElementById("passwordContainerCliente");
    const clienteModalTitle = document.getElementById("clienteModalTitle");
    const btnGuardarCliente = document.getElementById("btnGuardarCliente");
    const formEliminar = document.getElementById("formEliminar");
    const idEliminar = document.getElementById("idEliminar");

    // Limpiar campos para Nuevo Cliente
    if (btnNuevo) {
        btnNuevo.addEventListener("click", function () {
            if (actionCliente) actionCliente.value = "crear";
            if (idCliente) idCliente.value = "";
            if (nombreCliente) nombreCliente.value = "";
            if (apellidosCliente) apellidosCliente.value = "";
            if (emailCliente) emailCliente.value = "";
            if (telefonoCliente) telefonoCliente.value = "";
            if (passwordCliente) {
                passwordCliente.value = "";
                passwordCliente.required = true;
            }
            if (passwordContainerCliente) passwordContainerCliente.style.display = "block";
            if (clienteModalTitle) clienteModalTitle.textContent = "Nuevo Cliente";
            if (btnGuardarCliente) btnGuardarCliente.className = "btn btn-primary-custom";
        });
    }

    // Llenar campos para Editar Cliente
    document.querySelectorAll(".btn-editar").forEach(boton => {
        boton.addEventListener("click", function () {
            if (actionCliente) actionCliente.value = "editar";
            if (idCliente) idCliente.value = this.dataset.id || "";
            if (nombreCliente) nombreCliente.value = this.dataset.nombre || "";
            if (apellidosCliente) apellidosCliente.value = this.dataset.apellidos || "";
            if (emailCliente) emailCliente.value = this.dataset.email || "";
            if (telefonoCliente) telefonoCliente.value = this.dataset.telefono || "";
            if (passwordCliente) {
                passwordCliente.value = "";
                passwordCliente.required = false;
            }
            if (passwordContainerCliente) passwordContainerCliente.style.display = "none";
            if (clienteModalTitle) clienteModalTitle.textContent = "Editar Cliente: " + (this.dataset.nombre || "");
            if (btnGuardarCliente) btnGuardarCliente.className = "btn btn-warning";
        });
    });

    // Eliminar con SweetAlert2
    document.querySelectorAll(".btn-eliminar").forEach(boton => {
        boton.addEventListener("click", function () {
            const id = this.dataset.id;
            const nombre = this.dataset.nombre || "el cliente";
            Swal.fire({
                title: "¿Eliminar cliente?",
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
