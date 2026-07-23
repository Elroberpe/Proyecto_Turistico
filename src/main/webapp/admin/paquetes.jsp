<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel Admin Turístico - Paquetes</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="d-flex">
        <!-- Sidebar -->
        <nav id="sidebar">
            <div class="sidebar-header">
                <h3 class="text-white m-0"><i class="bi bi-airplane-engines"></i> AdminTours</h3>
            </div>
            <ul class="list-unstyled components">
                <li><a href="index.jsp"><i class="bi bi-house-door me-2"></i> Dashboard</a></li>
                <li><a href="categorias_paquetes.jsp"><i class="bi bi-tags me-2"></i> Categorías</a></li>
                <li class="active"><a href="paquetes.jsp"><i class="bi bi-box-seam me-2"></i> Paquetes</a></li>
                <li><a href="clientes.jsp"><i class="bi bi-person-badge me-2"></i> Clientes</a></li>
                <li><a href="usuarios.jsp"><i class="bi bi-people me-2"></i> Usuarios</a></li>
                <li><a href="reservas.jsp"><i class="bi bi-calendar-check me-2"></i> Reservas</a></li>
                <li><a href="pagos.jsp"><i class="bi bi-credit-card me-2"></i> Pagos</a></li>
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
                <h2>Gestión de Paquetes</h2>
                <button class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#paqueteModal">
                    <i class="bi bi-plus-circle"></i> Nuevo Paquete
                </button>
            </div>
            
            <div class="card p-4">
                <div class="table-responsive">
                    <table class="table table-hover table-custom align-middle">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Categoría (ID)</th>
                                <th>Nombre</th>
                                <th>Destino</th>
                                <th>Precio (S/)</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>1</td>
                                <td>Costa (1)</td>
                                <td>Tour Paracas</td>
                                <td>Ica, Perú</td>
                                <td>S/ 350.00</td>
                                <td><span class="badge bg-success">Activo</span></td>
                                <td>
                                    <button class="btn btn-sm btn-secondary-custom" data-bs-toggle="modal" data-bs-target="#paqueteModal"><i class="bi bi-pencil"></i></button>
                                    <button class="btn btn-sm btn-danger"><i class="bi bi-trash"></i></button>
                                </td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td>Sierra (2)</td>
                                <td>Aventura Andina</td>
                                <td>Cusco, Perú</td>
                                <td>S/ 1200.00</td>
                                <td><span class="badge bg-danger">Inactivo</span></td>
                                <td>
                                    <button class="btn btn-sm btn-secondary-custom" data-bs-toggle="modal" data-bs-target="#paqueteModal"><i class="bi bi-pencil"></i></button>
                                    <button class="btn btn-sm btn-danger"><i class="bi bi-trash"></i></button>
                                </td>
                            </tr>
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
            <h5 class="modal-title">Detalle de Paquete</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <form>
              <div class="row">
                  <div class="col-md-6 mb-3">
                    <label class="form-label">Nombre del Paquete</label>
                    <input type="text" class="form-control" name="nombre" required>
                  </div>
                  <div class="col-md-6 mb-3">
                    <label class="form-label">Categoría</label>
                    <select class="form-select" name="id_categoria" required>
                        <option value="">Seleccione Categoría</option>
                        <option value="1">Costa</option>
                        <option value="2">Sierra</option>
                        <option value="3">Selva</option>
                    </select>
                  </div>
              </div>
              <div class="row">
                  <div class="col-md-6 mb-3">
                    <label class="form-label">Destino</label>
                    <input type="text" class="form-control" name="destino" required>
                  </div>
                  <div class="col-md-6 mb-3">
                    <label class="form-label">Precio (Soles)</label>
                    <input type="number" step="0.01" class="form-control" name="precio_soles" required>
                  </div>
              </div>
              <div class="mb-3">
                <label class="form-label">Descripción</label>
                <textarea class="form-control" name="descripcion" rows="3" required></textarea>
              </div>
              <div class="row">
                  <div class="col-md-8 mb-3">
                      <label class="form-label">URL de Imagen (Opcional)</label>
                      <input type="text" class="form-control" name="imagenUrl">
                  </div>
                  <div class="col-md-4 mb-3">
                    <label class="form-label">Estado</label>
                    <select class="form-select" name="estado" required>
                        <option value="activo">Activo</option>
                        <option value="inactivo">Inactivo</option>
                    </select>
                  </div>
              </div>
              <div class="text-end mt-3">
                  <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancelar</button>
                  <button type="submit" class="btn btn-primary-custom">Guardar Paquete</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"></script>
    <script src="js/script.js"></script>
</body>
</html>
