<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chasqui PERÚ | Iniciar Sesión / Registro</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/style.css?v=2.0">
</head>
<body class="d-flex align-items-center justify-content-center vh-100">

<div class="card card-auth border-0 p-4 p-sm-5 mx-3 w-100">

  <div class="text-center mb-4">
    <a href="index.jsp" class="auth-brand">Perú<span>Chasqui</span></a>
  </div>

  <!-- LOGIN -->
  <div id="loginView">
    <h3 class="text-center mb-4 fw-semibold">Iniciar sesión</h3>
    <form action="AuthServlet" method="post">
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
      <button type="submit" class="btn btn-primary-custom w-100 fw-semibold mt-2 py-2">Ingresar</button>
    </form>
    <div class="text-center mt-4 small text-secondary">
      ¿No tienes cuenta? 
      <button class="btn btn-link p-0 m-0 align-baseline text-decoration-none fw-bold" onclick="switchView('register')">Regístrate</button>
    </div>
  </div>

  <!-- REGISTRO -->
  <div id="registerView" class="d-none">
    <h3 class="text-center mb-4 fw-semibold">Crear cuenta</h3>

    <form action="AuthServlet" method="post">
      <input type="hidden" name="accion" value="registrar">
      <% if (request.getParameter("redirect") != null) { %>
      <input type="hidden" name="redirect" value="<%= request.getParameter("redirect") %>">
      <% } %>
      <div class="mb-3">
        <label class="form-label fw-medium small">Nombres</label>
        <input type="text" class="form-control bg-light" name="nombre" placeholder="Tus nombres" required>
      </div>
      <div class="mb-3">
        <label class="form-label fw-medium small">Apellidos</label>
        <input type="text" class="form-control bg-light" name="apellidos" placeholder="Tus apellidos" required>
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
      <button type="submit" class="btn btn-primary-custom w-100 fw-semibold mt-2 py-2">Registrarme</button>
    </form>
    <div class="text-center mt-4 small text-secondary">
      ¿Ya tienes cuenta? 
      <button class="btn btn-link p-0 m-0 align-baseline text-decoration-none fw-bold" onclick="switchView('login')">Inicia sesión</button>
    </div>
  </div>

</div>

<script>
  function switchView(view) {
    document.getElementById('loginView').classList.toggle('d-none', view === 'register');
    document.getElementById('registerView').classList.toggle('d-none', view === 'login');
  }
</script>

</body>
</html>