<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.turismo.modelo.CategoriaPaquete" %>
<%
    List<CategoriaPaquete> categorias = (List<CategoriaPaquete>) request.getAttribute("categorias");
    if (categorias == null) {
        response.sendRedirect(request.getContextPath() + "/admin/categorias");
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
    <title>Admin Turìstico - CategorÃ­as de Paquetes</title>
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
                <li class="active"><a href="<%=request.getContextPath()%>/admin/categorias"><i class="bi bi-tags me-2"></i> Categorìas</a></li>
                <li><a href="<%=request.getContextPath()%>/admin/paquetes"><i class="bi bi-box-seam me-2"></i> Paquetes</a></li>
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

            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Categorias de Paquetes</h2>
                <button id="btnNuevo" class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#categoriaModal">
                    <i class="bi bi-plus-circle"></i> Nueva CategorÃ­a
                </button>
            </div>
            
            <div class="card p-4">
                <div class="table-responsive">
                    <table class="table table-hover table-custom align-middle">
                        <thead>
                            <tr>
                                <th>ID Categorìa</th>
                                <th>Nombre</th>
                                <th>Descripciòn</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>                        	
                        	<% if (categorias.isEmpty()) { %>
                                <tr>
                                    <td colspan="4" class="text-center text-muted">No hay categorías registradas.</td>
                                </tr>
                            <% } else { %>
                        	
                        	<%
                        	for(CategoriaPaquete categoria : categorias){
                        	%>                       
                            <tr>
                                <td><%=categoria.getIdCategoria() %></td>
                                <td><%= categoria.getNombre() %></td>
                                <td><%= categoria.getDescripcion() %></td>
                                <td>
                                    <button
									    class="btn btn-sm btn-secondary-custom btn-editar"
									
									    data-id="<%= categoria.getIdCategoria() %>"
									    data-nombre="<%= categoria.getNombre() %>"
									    data-descripcion="<%= categoria.getDescripcion() %>"
									
									    data-bs-toggle="modal"
									    data-bs-target="#categoriaModal">
									
									    <i class="bi bi-pencil"></i>
									
									</button>
                                    <button data-id="<%=categoria.getIdCategoria() %>" class="btn btn-sm btn-danger btn-eliminar"><i class="bi bi-trash"></i></button>
                                </td>
                            </tr>
                            <%
                        	}
                            }
                            %>
                            
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Formulario CategorÃ­a -->
    <div class="modal fade" id="categoriaModal" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header bg-primary-custom text-white">
            <h5 class="modal-title">Detalle de Categorìa</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <form action="categorias" method="post">      
              <input id="accion" type ="hidden" name="accion" value="guardar">
              <input id="idCategoria" type="hidden" name="id">
              <div class="mb-3">
                <label class="form-label">Nombre de Categorìa</label>
                <input id="nombre" type="text" class="form-control" name="nombre" placeholder="Ej. Selva" required>
              </div>
              <div class="mb-3">
                <label class="form-label">Descripciòn</label>
                <textarea id="descripcion"class="form-control" name="descripcion" rows="3" required></textarea>
              </div>
              <div class="text-end mt-3">
                  <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancelar</button>
                  <button type="submit" class="btn btn-primary-custom">Guardar Cambios</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
    
    <form id="formEliminar" action="categorias" method="post">
    	<input type="hidden" name="accion" value="eliminar">
    	<input type="hidden" id="idEliminar" name="id">
    </form>

    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
   
    <script>
    
    	//limpiar campos del modal
	    document.getElementById("btnNuevo").addEventListener("click", function () {
	
	        document.getElementById("idCategoria").value = "";
	        document.getElementById("nombre").value = "";
	        document.getElementById("descripcion").value = "";
	
	        document.getElementById("accion").value = "guardar";
	
	    });
    
    	//llenar campos del modal al editar
	    document.querySelectorAll(".btn-editar").forEach(boton => {

	        boton.addEventListener("click", function () {
	
	            document.getElementById("idCategoria").value = this.dataset.id;
	            document.getElementById("nombre").value = this.dataset.nombre;	
	            document.getElementById("descripcion").value = this.dataset.descripcion;	
	            document.getElementById("accion").value ="actualizar";
	
	        });
	
	    });
	    
    	//crear un modal al presionar btn eliminar
	    document.querySelectorAll(".btn-eliminar").forEach(boton=>{

	        boton.addEventListener("click",function(){

	            let id=this.dataset.id;
	            Swal.fire({

	                title:"¿Eliminar categoría?",
	                text:"Esta acción no se puede deshacer.",
	                icon:"warning",
	                showCancelButton:true,
	                confirmButtonText:"Sí, eliminar",
	                cancelButtonText:"Cancelar"
	            }).then((result)=>{
	            	//envia un post para eliminar
	                if(result.isConfirmed){
	                	document.getElementById("idEliminar").value = id;
	                	document.getElementById("formEliminar").submit();
	                }
	            });
	        });
	    });
    </script>
   
    
</body>
</html>
