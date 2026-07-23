<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel Admin Turístico - Clientes</title>
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
                <li><a href="paquetes.jsp"><i class="bi bi-box-seam me-2"></i> Paquetes</a></li>
                <li class="active"><a href="clientes.jsp"><i class="bi bi-person-badge me-2"></i> Clientes</a></li>
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
                <h2>Directorio de Clientes</h2>
                <button class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#clienteModal">
                    <i class="bi bi-plus-circle"></i> Nuevo Cliente
                </button>
            </div>
            
            <div class="card p-4">
                <div class="table-responsive">
                    <table class="table table-hover table-custom align-middle">
                        <thead>
                            <tr>
                                <th>ID Usuario</th>
                                <th>Nombres</th>
                                <th>Apellidos</th>
                                <th>Email</th>
                                <th>Teléfono</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>3</td>
                                <td>Carlos</td>
                                <td>Ramírez</td>
                                <td>carlos.ramirez@mail.com</td>
                                <td>987654321</td>
                                <td>
                                    <button class="btn btn-sm btn-secondary-custom" data-bs-toggle="modal" data-bs-target="#clienteModal"><i class="bi bi-pencil"></i></button>
                                    <button class="btn btn-sm btn-danger"><i class="bi bi-trash"></i></button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Formulario Cliente -->
    <div class="modal fade" id="clienteModal" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header bg-primary-custom text-white">
            <h5 class="modal-title">Detalle de Cliente</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <form>
              <!-- Por defecto id_rol = 3 (Cliente) oculto -->
              <input type="hidden" name="id_rol" value="3">
              <div class="row">
                  <div class="col-md-6 mb-3">
                    <label class="form-label">Nombres</label>
                    <input type="text" class="form-control" name="nombre" required>
                  </div>
                  <div class="col-md-6 mb-3">
                    <label class="form-label">Apellidos</label>
                    <input type="text" class="form-control" name="apellidos" required>
                  </div>
              </div>
              <div class="row">
                  <div class="col-md-6 mb-3">
                    <label class="form-label">Correo Electrónico</label>
                    <input type="email" class="form-control" name="email" required>
                  </div>
                  <div class="col-md-6 mb-3">
                    <label class="form-label">Teléfono</label>
                    <input type="text" class="form-control" name="telefono">
                  </div>
              </div>
              <div class="mb-3">
                <label class="form-label">Contraseña</label>
                <input type="password" class="form-control" name="password" required>
              </div>
              <div class="text-end mt-3">
                  <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancelar</button>
                  <button type="submit" class="btn btn-primary-custom">Guardar Cliente</button>
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
