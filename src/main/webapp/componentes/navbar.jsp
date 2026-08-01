<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.turismo.modelo.Usuario"%>

<%
Usuario usuario = (Usuario) session.getAttribute("usuario");
%>

<!-- ================== NAVBAR GLASSMORPHISM ================== -->
<nav class="navbar navbar-expand-lg fixed-top navbar-glass">
    <div class="container">
        <a class="navbar-brand" href="index.jsp">Perú<span>Chasqui</span></a>
        <button class="navbar-toggler border-0 shadow-none" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto align-items-center">
                <li class="nav-item">
                    <a class="nav-link <%= request.getRequestURI().contains("index.jsp") ? "active" : "" %>" href="index.jsp">Inicio</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= "Costa".equalsIgnoreCase(request.getParameter("region")) ? "active" : "" %>" href="${pageContext.request.contextPath}/catalogo?region=Costa">Costa</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= "Sierra".equalsIgnoreCase(request.getParameter("region")) ? "active" : "" %>" href="${pageContext.request.contextPath}/catalogo?region=Sierra">Sierra</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= "Selva".equalsIgnoreCase(request.getParameter("region")) ? "active" : "" %>" href="${pageContext.request.contextPath}/catalogo?region=Selva">Selva</a>
                </li>
                
                <%
				if (usuario == null) {
				%>
					
				<li class="nav-item ms-lg-3 mt-3 mt-lg-0"><a class="btn btn-primary-custom" href="login.jsp">Iniciar sesión </a></li>

				<%
				} else {
				%>

				<li class="nav-item dropdown ms-2">
					<a class="btn btn-primary-custom dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown"><%=usuario.getNombre()%></a>

					<ul class="dropdown-menu dropdown-menu-end">
						<li><a class="dropdown-item" href="perfil.jsp"> Mi perfil </a></li>
						<li><a class="dropdown-item" href="misReservas.jsp"> Mis reservas </a></li>
						<li><hr class="dropdown-divider"></li>
						<li><a class="dropdown-item text-danger" href="UsuarioServlet?accion=logout"> Cerrar sesión </a></li>
					</ul>
				</li>
				<%
				}
				%>
                        
            </ul>
        </div>
    </div>
</nav>

