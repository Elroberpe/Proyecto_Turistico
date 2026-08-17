<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- ================== NAVBAR GLASSMORPHISM ================== -->
<nav class="navbar navbar-expand-lg fixed-top navbar-glass">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">Perú<span>Chasqui</span></a>
        <button class="navbar-toggler border-0 shadow-none" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto align-items-center">
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.requestURI.contains('index.jsp') || empty param.region && empty requestScope.paquetes && empty sessionScope.mensaje && pageContext.request.requestURI.endsWith('/') ? 'active' : ''}" href="${pageContext.request.contextPath}/index.jsp">Inicio</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.region == 'Costa' ? 'active' : ''}" href="${pageContext.request.contextPath}/catalogo?region=Costa">Costa</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.region == 'Sierra' ? 'active' : ''}" href="${pageContext.request.contextPath}/catalogo?region=Sierra">Sierra</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.region == 'Selva' ? 'active' : ''}" href="${pageContext.request.contextPath}/catalogo?region=Selva">Selva</a>
                </li>
                
                <c:choose>
                    <c:when test="${empty sessionScope.usuario}">
                        <li class="nav-item ms-lg-3 mt-3 mt-lg-0">
                            <a class="btn btn-primary-custom" href="${pageContext.request.contextPath}/login">Iniciar sesión</a>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item dropdown ms-2">
                            <a class="btn btn-primary-custom dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">${sessionScope.usuario.nombre}</a>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/perfil">Mi perfil</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/mis-reservas">Mis reservas</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/AuthServlet?accion=logout">Cerrar sesión</a></li>
                            </ul>
                        </li>
                    </c:otherwise>
                </c:choose>
                        
            </ul>
        </div>
    </div>
</nav>

