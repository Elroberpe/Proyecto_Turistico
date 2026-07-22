<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
                    <a class="nav-link <%= request.getRequestURI().contains("costa.jsp") ? "active" : "" %>" href="costa.jsp">Costa</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= request.getRequestURI().contains("sierra.jsp") ? "active" : "" %>" href="sierra.jsp">Sierra</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= request.getRequestURI().contains("selva.jsp") ? "active" : "" %>" href="selva.jsp">Selva</a>
                </li>
                <li class="nav-item ms-lg-3 mt-3 mt-lg-0">
                    <a class="btn btn-primary-custom" href="login.jsp">Iniciar Sesión</a>
                </li>
            </ul>
        </div>
    </div>
</nav>
