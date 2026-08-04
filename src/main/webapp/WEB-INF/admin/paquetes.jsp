<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.turismo.modelo.Paquete, com.turismo.modelo.CategoriaPaquete" %>
<%
    List<Paquete> paquetes = (List<Paquete>) request.getAttribute("paquetes");
    List<CategoriaPaquete> categorias = (List<CategoriaPaquete>) request.getAttribute("categorias");
    if (paquetes == null) {
        response.sendRedirect(request.getContextPath() + "/admin/paquetes");
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
    <title>Panel Admin Turístico - Paquetes</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/admin/css/style.css">
</head>
<body>

    <div class="d-flex">
        <!-- Sidebar -->
        <nav id="sidebar">
            <div class="sidebar-header">
                <h3 class="text-white m-0"><i class="bi bi-airplane-engines"></i> AdminTours</h3>
            </div>
            <ul class="list-unstyled components">
                <li><a href="<%=request.getContextPath()%>/admin/dashboard"><i class="bi bi-house-door me-2"></i> Dashboard</a></li>
                <li><a href="<%=request.getContextPath()%>/admin/categorias"><i class="bi bi-tags me-2"></i> Categorías</a></li>
                <li class="active"><a href="<%=request.getContextPath()%>/admin/paquetes"><i class="bi bi-box-seam me-2"></i> Paquetes</a></li>
                <li><a href="<%=request.getContextPath()%>/admin/clientes"><i class="bi bi-person-badge me-2"></i> Clientes</a></li>
                <li><a href="<%=request.getContextPath()%>/admin/usuarios"><i class="bi bi-people me-2"></i> Usuarios</a></li>
                <li><a href="<%=request.getContextPath()%>/admin/reservas"><i class="bi bi-calendar-check me-2"></i> Reservas</a></li>
                <li><a href="<%=request.getContextPath()%>/admin/pagos"><i class="bi bi-credit-card me-2"></i> Pagos</a></li>
            </ul>
        </nav>

        <!-- Page Content -->
        <div id="content">
            <nav class="navbar navbar-expand-lg navbar-light bg-white rounded shadow-sm mb-4 p-3">
                <div class="container-fluid">
                    <button type="button" id="sidebarCollapse" class="btn btn-primary-custom">
                        <i class="bi bi-list"></i>
                    </button>
                    <div class="ms-auto">
                        <span class="me-3 fw-bold">Bienvenido, Admin</span>
                    </div>
                </div>
            </nav>

            <% if (mensaje != null) { %>
                <div class="alert alert-success alert-dismissible fade show mb-4" role="alert">
                    <%= mensaje %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>
            <% if (error != null) { %>
                <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
                    <%= error %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>

            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Gestión de Paquetes</h2>
                <button id="btnNuevo" class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#paqueteModal">
                    <i class="bi bi-plus-circle"></i> Nuevo Paquete
                </button>
            </div>
            
            <div class="card p-4">
                <div class="table-responsive">
                    <table class="table table-hover table-custom align-middle">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Categoría</th>
                                <th>Nombre</th>
                                <th>Destino</th>
                                <th>Precio (S/)</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                        	<% if (paquetes.isEmpty()) { %>
                                <tr>
                                    <td colspan="7" class="text-center text-muted">No hay paquetes registrados.</td>
                                </tr>
                            <% } else { %>
                        
                        	<% for(Paquete paquete : paquetes){ %>
                            <tr>
                                <td><%=paquete.getIdPaquete() %></td>
                                <td><%= paquete.getCategoriaNombre() != null ? paquete.getCategoriaNombre() : "Sin categoría" %></td>
                                <td><%=paquete.getNombre() %></td>
                                <td><%=paquete.getDestino() %></td>
                                <td><%=paquete.getPrecioSoles() %></td>
                                <td><span class="badge <%= "activo".equals(paquete.getEstado()) ? "bg-success" : "bg-danger" %>">
                                            <%= paquete.getEstado() %>
                                        </span></td>
                                <td>
                                    <button class="btn btn-sm btn-secondary-custom btn-editar" 
                                            data-id="<%=paquete.getIdPaquete()%>"
                                            data-nombre="<%=paquete.getNombre()%>"
                                            data-categoria="<%=paquete.getIdCategoria()%>"
                                            data-destino="<%=paquete.getDestino()%>"
                                            data-precio="<%=paquete.getPrecioSoles()%>"
                                            data-descripcion="<%=paquete.getDescripcion() != null ? paquete.getDescripcion() : ""%>"
                                            data-imagen="<%=paquete.getImagenUrl() != null ? paquete.getImagenUrl() : ""%>"
                                            data-estado="<%=paquete.getEstado()%>"
                                            data-bs-toggle="modal" data-bs-target="#paqueteModal"><i class="bi bi-pencil"></i></button>
                                    <button class="btn btn-sm btn-danger btn-eliminar" data-id="<%=paquete.getIdPaquete()%>" data-nombre="<%=paquete.getNombre()%>">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </td>
                            </tr>
                          <% } } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Formulario Paquete -->
    <div class="modal fade" id="paqueteModal" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header bg-primary-custom text-white">
            <h5 class="modal-title" id="modalTitle">Detalle de Paquete</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <form action="<%=request.getContextPath()%>/admin/paquetes" method="post">
            	<input id="action" type="hidden" name="action" value="crear">
			    <input type="hidden" id="id" name="id">
			
			    <div class="row">
			        <div class="col-md-6 mb-3">
			            <label for="nombre" class="form-label">Nombre del Paquete</label>
			            <input id="nombre" type="text" class="form-control" name="nombre" required>
			        </div>
			
			        <div class="col-md-6 mb-3">
			            <label for="idCategoria" class="form-label">Categoría</label>
			            <select id="idCategoria" class="form-select" name="id_categoria" required>
			                <option value="">Seleccione Categoría</option>
			                <% if (categorias != null) { 
			                     for(CategoriaPaquete categoria : categorias){ %>
			                     <option value="<%=categoria.getIdCategoria()%>">
					               <%=categoria.getNombre()%>
					             </option>
			                  <% } 
			                } %>
			            </select>
			        </div>
			    </div>
			
			    <div class="row">
			        <div class="col-md-6 mb-3">
			            <label for="destino" class="form-label">Destino</label>
			            <input id="destino" type="text" class="form-control" name="destino" required>
			        </div>
			
			        <div class="col-md-6 mb-3">
			            <label for="precioSoles" class="form-label">Precio (Soles)</label>
			            <input id="precioSoles" type="number" step="0.01" class="form-control" name="precio_soles" required>
			        </div>
			    </div>
			
			    <div class="mb-3">
			        <label for="descripcion" class="form-label">Descripción</label>
			        <textarea id="descripcion" class="form-control" name="descripcion" rows="3" required></textarea>
			    </div>
			
			    <div class="row">
			        <div class="col-md-8 mb-3">
			            <label for="imagenUrl" class="form-label">URL de Imagen</label>
			            <input id="imagenUrl" type="text" class="form-control" name="imagenUrl" placeholder="https://ejemplo.com/imagen.jpg">
			        </div>
			
			        <div class="col-md-4 mb-3">
			            <label for="estado" class="form-label">Estado</label>
			            <select id="estado" class="form-select" name="estado" required>
			                <option value="activo">Activo</option>
			                <option value="inactivo">Inactivo</option>
			            </select>
			        </div>
			    </div>
			
			    <div class="text-end mt-3">
			        <button type="button" class="btn btn-light" data-bs-dismiss="modal">
			            Cancelar
			        </button>
			
			        <button type="submit" class="btn btn-primary-custom">
			            Guardar Paquete
			        </button>
			    </div>
			</form>
          </div>
        </div>
      </div>
    </div>
    
    <form id="formEliminar" action="<%=request.getContextPath()%>/admin/paquetes" method="post">
        <input type="hidden" name="action" value="eliminar">
        <input type="hidden" id="idEliminar" name="id">
    </form>

    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
    <script>
  		// Limpiar campos del modal para Nuevo Paquete
    	document.getElementById("btnNuevo").addEventListener("click", function () {
    		 document.getElementById("action").value = "crear";
    		 document.getElementById("id").value = "";
    		 document.getElementById("nombre").value = "";
    		 document.getElementById("idCategoria").selectedIndex = 0;
    		 document.getElementById("destino").value = "";
    		 document.getElementById("precioSoles").value = "";
    		 document.getElementById("descripcion").value = "";
    		 document.getElementById("imagenUrl").value = "";
    		 document.getElementById("estado").value = "activo";
    		 document.getElementById("modalTitle").textContent = "Nuevo Paquete";
    	});

    	// Cargar datos en el modal para Editar Paquete
    	document.querySelectorAll(".btn-editar").forEach(function (btn) {
    		btn.addEventListener("click", function () {
    			document.getElementById("action").value = "editar";
    			document.getElementById("id").value = this.dataset.id;
    			document.getElementById("nombre").value = this.dataset.nombre;
    			document.getElementById("idCategoria").value = this.dataset.categoria;
    			document.getElementById("destino").value = this.dataset.destino;
    			document.getElementById("precioSoles").value = this.dataset.precio;
    			document.getElementById("descripcion").value = this.dataset.descripcion;
    			document.getElementById("imagenUrl").value = this.dataset.imagen;
    			document.getElementById("estado").value = this.dataset.estado;
    			document.getElementById("modalTitle").textContent = "Editar Paquete";
    		});
    	});

    	// Confirmar eliminación con SweetAlert2
    	document.querySelectorAll(".btn-eliminar").forEach(function (btn) {
    		btn.addEventListener("click", function () {
    			let id = this.dataset.id;
    			let nombre = this.dataset.nombre || "el paquete";
    			Swal.fire({
    				title: "¿Eliminar paquete?",
    				text: "Esta acción eliminará " + nombre + ". ¿Deseas continuar?",
    				icon: "warning",
    				showCancelButton: true,
    				confirmButtonText: "Sí, eliminar",
    				cancelButtonText: "Cancelar"
    			}).then((result) => {
    				if (result.isConfirmed) {
    					document.getElementById("idEliminar").value = id;
    					document.getElementById("formEliminar").submit();
    				}
    			});
    		});
    	});
    </script>
    
</body>
</html>
