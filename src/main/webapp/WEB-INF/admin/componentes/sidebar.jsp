<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="uri" value="${pageContext.request.requestURI}" />
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<nav id="sidebar" class="d-flex flex-column justify-content-between">
    <div>
        <div class="sidebar-header">
            <h3 class="text-white m-0"><i class="bi bi-airplane-engines"></i> AdminTours</h3>
        </div>
        <ul class="list-unstyled components">
            <li class="${fn:contains(uri, '/admin/dashboard') or fn:endsWith(uri, 'index.jsp') ? 'active' : ''}">
                <a href="${ctx}/admin/dashboard"><i class="bi bi-house-door me-2"></i> Dashboard</a>
            </li>
            <li class="${fn:contains(uri, '/admin/categorias') or fn:contains(uri, 'categorias_paquetes.jsp') ? 'active' : ''}">
                <a href="${ctx}/admin/categorias"><i class="bi bi-tags me-2"></i> Categorías</a>
            </li>
            <li class="${fn:contains(uri, '/admin/paquetes') or fn:contains(uri, 'paquetes.jsp') ? 'active' : ''}">
                <a href="${ctx}/admin/paquetes"><i class="bi bi-box-seam me-2"></i> Paquetes</a>
            </li>
            <li class="${fn:contains(uri, '/admin/clientes') or fn:contains(uri, 'clientes.jsp') ? 'active' : ''}">
                <a href="${ctx}/admin/clientes"><i class="bi bi-person-badge me-2"></i> Clientes</a>
            </li>
            <li class="${fn:contains(uri, '/admin/usuarios') or fn:contains(uri, 'usuarios.jsp') ? 'active' : ''}">
                <a href="${ctx}/admin/usuarios"><i class="bi bi-people me-2"></i> Usuarios</a>
            </li>
            <li class="${fn:contains(uri, '/admin/reservas') or fn:contains(uri, 'reservas.jsp') ? 'active' : ''}">
                <a href="${ctx}/admin/reservas"><i class="bi bi-calendar-check me-2"></i> Reservas</a>
            </li>
            <li class="${fn:contains(uri, '/admin/pagos') or fn:contains(uri, 'pagos.jsp') ? 'active' : ''}">
                <a href="${ctx}/admin/pagos"><i class="bi bi-credit-card me-2"></i> Pagos</a>
            </li>
        </ul>
    </div>

    <!-- Botón de Cerrar Sesión en la parte inferior del Sidebar -->
    <div class="sidebar-footer p-3 border-top border-secondary">
        <a href="${ctx}/AuthServlet?accion=logout" class="btn btn-outline-light w-100 d-flex align-items-center justify-content-center gap-2 fw-semibold">
            <i class="bi bi-box-arrow-right"></i> Cerrar Sesión
        </a>
    </div>
</nav>
