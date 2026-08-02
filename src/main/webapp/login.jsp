<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login / Registro</title>
<link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.3/css/bootstrap.min.css" rel="stylesheet">
<style>
  /* 1. Reemplazamos las variables nativas de Bootstrap para mantener tu diseño original */
  :root {
    --bs-body-bg: #f2efe9;
    --bs-body-color: #4a4540;
    --bs-primary: #4a5a6a;
    --bs-primary-rgb: 74, 90, 106;
    --bs-link-color: #4a5a6a;
    --bs-link-hover-color: #6b7b8d;
  }

  /* 2. Solo dejamos CSS personalizado para lo que Bootstrap no cubre por defecto (el ancho máximo del form) */
  .card-auth {
    max-width: 400px;
    background-color: #fefcf8;
  }

  /* 3. Personalizamos el contorno (focus) de los inputs para que haga juego con tu tema */
  .form-control:focus {
    border-color: #6b7b8d;
    box-shadow: 0 0 0 0.25rem rgba(107, 123, 141, 0.25);
  }
</style>
</head>
<!-- Utilizamos flexbox de Bootstrap (d-flex, align-items-center, justify-content-center) 
     y le damos altura total a la ventana (vh-100) para centrar la tarjeta. -->
<body class="d-flex align-items-center justify-content-center vh-100">

<!-- Clases de Bootstrap: 
     card (tarjeta), shadow (sombra), border-0 (sin bordes), rounded-4 (bordes curvos), 
     p-4 (padding general), mx-3 (margen horizontal en móviles), w-100 (ocupa el ancho disponible). -->
<div class="card card-auth shadow border-0 rounded-4 p-4 p-sm-5 mx-3 w-100">

  <!-- LOGIN -->
  <div id="loginView">
    <h3 class="text-center mb-4 fw-semibold">Iniciar sesión</h3>
    <form action="UsuarioServlet" method="post">
      <input type="hidden" name="accion" value="login">
      <% if (request.getParameter("redirect") != null) { %>
      <input type="hidden" name="redirect" value="<%= request.getParameter("redirect") %>">
      <% } %>
      <div class="mb-3">
        <label class="form-label fw-medium small">Correo electrónico</label>
        <input type="email" class="form-control bg-light" name="email" placeholder="tucorreo@ejemplo.com" required>
      </div>
      <div class="mb-3">
        <label class="form-label fw-medium small">Contraseña</label>
        <input type="password" class="form-control bg-light" name="password" placeholder="••••••••" required>
      </div>
      <button type="submit" class="btn btn-primary w-100 fw-semibold mt-2 py-2">Ingresar</button>
    </form>
    <div class="text-center mt-4 small text-secondary">
      ¿No tienes cuenta? 
      <!-- Usamos btn-link para que parezca un texto normal, pero siga siendo un botón accesible -->
      <button class="btn btn-link p-0 m-0 align-baseline text-decoration-none fw-bold" onclick="switchView('register')">Regístrate</button>
    </div>
  </div>

  <!-- REGISTRO -->
  <div id="registerView" class="d-none">
    <h3 class="text-center mb-4 fw-semibold">Crear cuenta</h3>

    <form action="UsuarioServlet" method="post">
      <input type="hidden" name="accion" value="registrar">
      <% if (request.getParameter("redirect") != null) { %>
      <input type="hidden" name="redirect" value="<%= request.getParameter("redirect") %>">
      <% } %>
      <div class="mb-3">
        <label class="form-label fw-medium small">Nombres</label>
        <input type="text" class="form-control bg-light" name ="nombre" placeholder="Tus nombres" required>
      </div>
      <div class="mb-3">
        <label class="form-label fw-medium small">Apellidos</label>
        <input type="text" class="form-control bg-light" name= "apellidos" placeholder="Tus apellidos" required>
      </div>
      <div class="mb-3">
        <label class="form-label fw-medium small">Correo electrónico</label>
        <input type="email" class="form-control bg-light" name="email" placeholder="tucorreo@ejemplo.com" required>
      </div>
      <div class="mb-3">
        <label class="form-label fw-medium small">Teléfono</label>
        <input type="text" class="form-control bg-light" name="telefono" placeholder="987654321">
      </div>
      <div class="mb-3">
        <label class="form-label fw-medium small">Contraseña</label>
        <input type="password" class="form-control bg-light" name="password" placeholder="••••••••" required>
      </div>
      <button type="submit" class="btn btn-primary w-100 fw-semibold mt-2 py-2">Registrarme</button>
    </form>
    <div class="text-center mt-4 small text-secondary">
      ¿Ya tienes cuenta? 
      <button class="btn btn-link p-0 m-0 align-baseline text-decoration-none fw-bold" onclick="switchView('login')">Inicia sesión</button>
    </div>
  </div>

</div>

<script>
  function switchView(view) {
    // La clase d-none (display: none) es nativa de Bootstrap.
    document.getElementById('loginView').classList.toggle('d-none', view === 'register');
    document.getElementById('registerView').classList.toggle('d-none', view === 'login');
  }
</script>

</body>
</html>