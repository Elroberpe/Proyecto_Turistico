<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:if test="${empty totalPaquetes}">
    <c:redirect url="/admin/dashboard"/>
</c:if>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel Admin - Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/admin/css/style.css">
</head>
<body>
    <div class="d-flex">
        <!-- Sidebar Reutilizable -->
        <jsp:include page="componentes/sidebar.jsp" />

        <div id="content">
            <jsp:include page="componentes/topbar.jsp" />


            <h2 class="mb-4">Resumen General</h2>

            <div class="row">
                <div class="col-md-3 mb-4">
                    <div class="card text-center p-4 border-0 shadow-sm">
                        <h1 class="text-primary-custom"><i class="bi bi-box-seam"></i></h1>
                        <h3 class="mt-2">${totalPaquetes}</h3>
                        <p class="text-muted">Paquetes Activos</p>
                    </div>
                </div>
                <div class="col-md-3 mb-4">
                    <div class="card text-center p-4 border-0 shadow-sm">
                        <h1 class="text-secondary-custom"><i class="bi bi-person-badge"></i></h1>
                        <h3 class="mt-2">${totalClientes}</h3>
                        <p class="text-muted">Clientes Registrados</p>
                    </div>
                </div>
                <div class="col-md-3 mb-4">
                    <div class="card text-center p-4 border-0 shadow-sm">
                        <h1 class="text-primary-custom"><i class="bi bi-calendar-check"></i></h1>
                        <h3 class="mt-2">${reservasMes}</h3>
                        <p class="text-muted">Reservas del Mes</p>
                    </div>
                </div>
                <div class="col-md-3 mb-4">
                    <div class="card text-center p-4 border-0 shadow-sm">
                        <h1 class="text-success"><i class="bi bi-cash-coin"></i></h1>
                        <h3 class="mt-2">S/ <fmt:formatNumber value="${ingresosMes != null ? ingresosMes : 0}" minFractionDigits="2" maxFractionDigits="2"/></h3>
                        <p class="text-muted">Ingresos del Mes</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/admin/js/script.js"></script>
</body>
</html>