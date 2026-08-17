<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.turismo.modelo.Usuario"%>
<%
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
    if (usuarioSesion == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    String mensaje = (String) session.getAttribute("mensaje");
    String error = (String) session.getAttribute("error");
    session.removeAttribute("mensaje");
    session.removeAttribute("error");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chasqui PERÚ | Mi Perfil</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/style.css?v=2.0">
</head>
<body>

    <!-- NAVBAR -->
    <jsp:include page="componentes/navbar.jsp"></jsp:include>

    <!-- CONTENIDO PRINCIPAL -->
    <div class="container py-5" style="margin-top: 100px; min-height: 75vh;">
        
        <div class="row justify-content-center">
            <div class="col-lg-8">
                
                <!-- TITULO SECCIÓN -->
                <div class="d-flex align-items-center mb-4">
                    <div>
                        <h2 class="fw-bold text-dark mb-1">
                            <i class="bi bi-person-gear text-primary me-2"></i> Mi Perfil
                        </h2>
                        <p class="text-muted small mb-0">Consulta y actualiza tu información personal de cuenta</p>
                    </div>
                </div>

                <!-- ALERTAS DE SESIÓN -->
                <% if (mensaje != null) { %>
                    <div class="alert alert-success alert-dismissible fade show shadow-sm rounded-4 mb-4" role="alert">
                        <%= mensaje %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <% if (error != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show shadow-sm rounded-4 mb-4" role="alert">
                        <%= error %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <!-- TARJETA DE PERFIL Y FORMULARIO -->
                <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                    <div class="card-body p-4 p-md-5">
                        
                        <!-- ENCABEZADO AVATAR -->
                        <div class="text-center mb-4 pb-3 border-bottom">
                            <div class="d-inline-block bg-light p-3 rounded-circle mb-3 shadow-sm text-primary">
                                <i class="bi bi-person-circle display-4"></i>
                            </div>
                            <h4 class="fw-bold text-dark mb-0">
                                <%= usuarioSesion.getNombre() %> <%= usuarioSesion.getApellidos() != null ? usuarioSesion.getApellidos() : "" %>
                            </h4>
                            <span class="badge bg-primary rounded-pill px-3 py-2 mt-2">
                                Cliente Registrado
                            </span>
                        </div>

                        <!-- FORMULARIO DE EDICIÓN DE DATOS -->
                        <form action="<%= request.getContextPath() %>/perfil" method="post">
                            
                            <div class="row g-3 mb-3">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold text-muted small text-uppercase">Nombres</label>
                                    <input type="text" class="form-control bg-light border-0 py-2 rounded-3" 
                                           name="nombre" value="<%= usuarioSesion.getNombre() != null ? usuarioSesion.getNombre() : "" %>" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold text-muted small text-uppercase">Apellidos</label>
                                    <input type="text" class="form-control bg-light border-0 py-2 rounded-3" 
                                           name="apellidos" value="<%= usuarioSesion.getApellidos() != null ? usuarioSesion.getApellidos() : "" %>">
                                </div>
                            </div>

                            <div class="row g-3 mb-3">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold text-muted small text-uppercase">Correo Electrónico</label>
                                    <input type="email" class="form-control bg-light border-0 py-2 rounded-3" 
                                           name="email" value="<%= usuarioSesion.getEmail() != null ? usuarioSesion.getEmail() : "" %>" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold text-muted small text-uppercase">Teléfono / Celular</label>
                                    <input type="text" class="form-control bg-light border-0 py-2 rounded-3" 
                                           name="telefono" value="<%= usuarioSesion.getTelefono() != null ? usuarioSesion.getTelefono() : "" %>">
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-bold text-muted small text-uppercase">Nueva Contraseña (Opcional)</label>
                                <input type="password" class="form-control bg-light border-0 py-2 rounded-3" 
                                       name="password" placeholder="Dejar en blanco si no deseas cambiarla">
                            </div>

                            <div class="d-flex justify-content-end gap-2 pt-3 border-top">
                                <a href="index.jsp" class="btn btn-light rounded-pill px-4 fw-semibold">Cancelar</a>
                                <button type="submit" class="btn btn-primary-custom rounded-pill px-4 fw-bold">
                                    <i class="bi bi-check2-circle me-1"></i> Guardar Cambios
                                </button>
                            </div>

                        </form>

                    </div>
                </div>

            </div>
        </div>

    </div>

    <!-- FOOTER Y SCRIPTS -->
    <jsp:include page="componentes/footer.jsp"></jsp:include>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
