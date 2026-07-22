<%@ page import="com.turismo.modelo.Usuario"%>

<%
Usuario usuario = (Usuario) session.getAttribute("usuario");
%>

<nav class="navbar navbar-expand-lg fixed-top navbar-chasqui">
  <div class="container">
    <a class="navbar-brand fw-bold" href="index.jsp"><span class="text-primary">Chasqui</span> PERÚ</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav ms-auto">
        <li class="nav-item"><a class="nav-link active" href="index.jsp">Inicio</a></li>
        <li class="nav-item"><a class="nav-link" href="costa.jsp">Costa</a></li>
        <li class="nav-item"><a class="nav-link" href="sierra.jsp">Sierra</a></li>
        <li class="nav-item"><a class="nav-link" href="selva.jsp">Selva</a></li>
        <li class="nav-item"><a class="nav-link" href="contacto.jsp">Contacto</a></li>
        <%
		if (usuario == null) {
		%>
        <li class="nav-item ms-lg-2"><a class="btn btn-primary" href="login.jsp">Iniciar sesión</a></li>
        <%
		} else {
		%>
        <li class="nav-item dropdown ms-lg-2">
          <a class="btn btn-primary dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown"><%=usuario.getNombre()%></a>
          <ul class="dropdown-menu dropdown-menu-end">
            <li><a class="dropdown-item" href="perfil.jsp">Mi perfil</a></li>
            <li><a class="dropdown-item" href="misReservas.jsp">Mis reservas</a></li>
            <li><hr class="dropdown-divider"></li>
            <li><a class="dropdown-item text-danger" href="UsuarioServlet?accion=logout">Cerrar sesión</a></li>
          </ul>
        </li>
		<%
			}
		%>
      </ul>
    </div>
  </div>
</nav>