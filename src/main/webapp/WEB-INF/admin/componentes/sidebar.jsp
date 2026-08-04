<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String currentUri = request.getRequestURI();
%>
<nav id="sidebar" class="d-flex flex-column justify-content-between">
    <div>
        <div class="sidebar-header">
            <h3 class="text-white m-0"><i class="bi bi-airplane-engines"></i> AdminTours</h3>
        </div>
        <ul class="list-unstyled components">
            <li class="<%= currentUri.contains("/admin/dashboard") || currentUri.endsWith("index.jsp") ? "active" : "" %>">
                <a href="<%=request.getContextPath()%>/admin/dashboard"><i class="bi bi-house-door me-2"></i> Dashboard</a>
            </li>
            <li class="<%= currentUri.contains("/admin/categorias") || currentUri.contains("categorias_paquetes.jsp") ? "active" : "" %>">
                <a href="<%=request.getContextPath()%>/admin/categorias"><i class="bi bi-tags me-2"></i> Categorías</a>
            </li>
            <li class="<%= currentUri.contains("/admin/paquetes") || currentUri.contains("paquetes.jsp") ? "active" : "" %>">
                <a href="<%=request.getContextPath()%>/admin/paquetes"><i class="bi bi-box-seam me-2"></i> Paquetes</a>
            </li>
            <li class="<%= currentUri.contains("/admin/clientes") || currentUri.contains("clientes.jsp") ? "active" : "" %>">
                <a href="<%=request.getContextPath()%>/admin/clientes"><i class="bi bi-person-badge me-2"></i> Clientes</a>
            </li>
            <li class="<%= currentUri.contains("/admin/usuarios") || currentUri.contains("usuarios.jsp") ? "active" : "" %>">
                <a href="<%=request.getContextPath()%>/admin/usuarios"><i class="bi bi-people me-2"></i> Usuarios</a>
            </li>
            <li class="<%= currentUri.contains("/admin/reservas") || currentUri.contains("reservas.jsp") ? "active" : "" %>">
                <a href="<%=request.getContextPath()%>/admin/reservas"><i class="bi bi-calendar-check me-2"></i> Reservas</a>
            </li>
            <li class="<%= currentUri.contains("/admin/pagos") || currentUri.contains("pagos.jsp") ? "active" : "" %>">
                <a href="<%=request.getContextPath()%>/admin/pagos"><i class="bi bi-credit-card me-2"></i> Pagos</a>
            </li>
        </ul>
    </div>

    <!-- Botón de Cerrar Sesión en la parte inferior del Sidebar -->
    <div class="sidebar-footer p-3 border-top border-secondary">
        <a href="<%=request.getContextPath()%>/AuthServlet?accion=logout" class="btn btn-outline-light w-100 d-flex align-items-center justify-content-center gap-2 fw-semibold">
            <i class="bi bi-box-arrow-right"></i> Cerrar Sesión
        </a>
    </div>
</nav>
