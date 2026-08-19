// ==================== PÁGINA DE CONTACTO ====================

document.addEventListener('DOMContentLoaded', () => {
    initFormularioContacto();
});

// ==================== INICIALIZAR FORMULARIO DE CONTACTO ====================
// Asigna el listener de submit al formulario #contactForm.
function initFormularioContacto() {
    const contactForm = document.getElementById('contactForm');
    if (!contactForm) return;

    contactForm.addEventListener('submit', e => {
        e.preventDefault();
        validarYEnviarContacto(e.target);
    });
}

// ==================== VALIDAR Y ENVIAR FORMULARIO ====================
// Valida cada campo con expresiones regulares antes de "enviar".
// Si todo es válido, muestra confirmación y resetea el formulario.
function validarYEnviarContacto(form) {
    const nombre   = document.getElementById('nombre').value.trim();
    const email    = document.getElementById('email').value.trim();
    const telefono = document.getElementById('telefono').value.trim();
    const mensaje  = document.getElementById('mensaje').value.trim();

    // Expresiones regulares para validación de cada campo
    const regexNombre   = /^[a-zA-ZáéíóúñÑÁÉÍÓÚ\s]{3,50}$/; // Solo letras y espacios, 3-50 caracteres
    const regexEmail    = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;       // Formato básico de email
    const regexTelefono = /^\d{9}$/;                           // 9 dígitos exactos (formato Perú)

    if (!regexNombre.test(nombre)) {
        alert('❌ Nombre inválido (mínimo 3 caracteres, solo letras)');
        return;
    }
    if (!regexEmail.test(email)) {
        alert('❌ Correo electrónico inválido');
        return;
    }
    if (telefono && !regexTelefono.test(telefono)) {
        // El teléfono es opcional; solo se valida si fue completado
        alert('❌ Teléfono inválido (9 dígitos)');
        return;
    }
    if (mensaje.length < 10) {
        alert('❌ El mensaje debe tener al menos 10 caracteres');
        return;
    }

    // Todo válido: confirmar y limpiar el formulario
    alert('✅ Mensaje enviado correctamente. Te contactaremos pronto.');
    form.reset();
}
