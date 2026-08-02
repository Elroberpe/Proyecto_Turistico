<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel Admin Turìstico - Reservas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/admin/css/style.css">
</head>
<body>
    <div class="d-flex">
        <!-- Sidebar -->
        <nav id="sidebar">
            <div class="sidebar-header">
                <h3 class="text-white m-0"><i class="bi bi-airplane-engines"></i> AdminTours</h3>
            </div>
            <ul class="list-unstyled components">
                <li><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-house-door me-2"></i> Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/categorias"><i class="bi bi-tags me-2"></i> CategorÃ­as</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/paquetes"><i class="bi bi-box-seam me-2"></i> Paquetes</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/clientes"><i class="bi bi-person-badge me-2"></i> Clientes</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/usuarios"><i class="bi bi-people me-2"></i> Usuarios</a></li>
                <li class="active"><a href="${pageContext.request.contextPath}/admin/reservas"><i class="bi bi-calendar-check me-2"></i> Reservas</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/pagos"><i class="bi bi-credit-card me-2"></i> Pagos</a></li>
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
                <h2>Gestiòn de Reservas</h2>
                <button class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#reservaModal">
                    <i class="bi bi-plus-circle"></i> Nueva Reserva
                </button>
            </div>
            
            <div class="card p-4">
                <div class="table-responsive">
                    <table class="table table-hover table-custom align-middle">
                        <thead>
                            <tr>
                                <th>ID Reserva</th>
                                <th>Cliente (ID)</th>
                                <th>Paquete (ID)</th>
                                <th>Tipo</th>
                                <th>F. Salida</th>
                                <th>F. Retorno</th>
                                <th>Pasajeros</th>
                                <th>Precio Total</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>1</td>
                                <td>Carlos RamÃ­rez (3)</td>
                                <td>Tour Paracas (1)</td>
                                <td>ida</td>
                                <td>2026-08-15</td>
                                <td>-</td>
                                <td>2</td>
                                <td>S/ 700.00</td>
                                <td><span class="badge bg-warning text-dark">Pendiente</span></td>
                                <td>
                                    <button class="btn btn-sm btn-secondary-custom" data-bs-toggle="modal" data-bs-target="#reservaModal"><i class="bi bi-pencil"></i></button>
                                    <button class="btn btn-sm btn-danger"><i class="bi bi-trash"></i></button>
                                </td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td>Ana Smith (4)</td>
                                <td>Aventura Andina (2)</td>
                                <td>idavuelta</td>
                                <td>2026-09-20</td>
                                <td>2026-09-27</td>
                                <td>4</td>
                                <td>S/ 4800.00</td>
                                <td><span class="badge bg-success">Pagada</span></td>
                                <td>
                                    <button class="btn btn-sm btn-secondary-custom" data-bs-toggle="modal" data-bs-target="#reservaModal"><i class="bi bi-pencil"></i></button>
                                    <button class="btn btn-sm btn-danger"><i class="bi bi-trash"></i></button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Formulario Reserva -->
    <div class="modal fade" id="reservaModal" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header bg-primary-custom text-white">
            <h5 class="modal-title">Detalle de Reserva</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <form>
              <div class="row">
                  <div class="col-md-6 mb-3">
                    <label class="form-label">Cliente (ID Usuario)</label>
                    <select class="form-select" name="id_usuario" required>
                        <option value="">Seleccionar Cliente</option>
                        <option value="3">Carlos Ramirez</option>
                        <option value="4">Ana Smith</option>
                    </select>
                  </div>
                  <div class="col-md-6 mb-3">
                    <label class="form-label">Paquete</label>
                    <select class="form-select" name="id_paquete" required>
                        <option value="">Seleccionar Paquete</option>
                        <option value="1">Tour Paracas (1)</option>
                        <option value="2">Aventura Andina (2)</option>
                    </select>
                  </div>
              </div>
              <div class="row">
                  <div class="col-md-4 mb-3">
                    <label class="form-label">Tipo de Viaje</label>
                    <select class="form-select" name="tipo_viaje" required>
                        <option value="ida">Ida</option>
                        <option value="idavuelta">Ida y Vuelta</option>
                    </select>
                  </div>
                  <div class="col-md-4 mb-3">
                    <label class="form-label">Fecha de Salida</label>
                    <input type="date" class="form-control" name="fecha_salida" required>
                  </div>
                  <div class="col-md-4 mb-3">
                    <label class="form-label">Fecha de Retorno</label>
                    <input type="date" class="form-control" name="fecha_retorno">
                  </div>
              </div>
              <div class="row">
                  <div class="col-md-4 mb-3">
                    <label class="form-label">NÂ° Pasajeros</label>
                    <input type="number" class="form-control" name="num_pasajeros" min="1" value="1" required>
                  </div>
                  <div class="col-md-4 mb-3">
                    <label class="form-label">Precio Total (Soles)</label>
                    <input type="number" step="0.01" class="form-control" name="precio_total" required>
                  </div>
                  <div class="col-md-4 mb-3">
                    <label class="form-label">Estado</label>
                    <select class="form-select" name="estado" required>
                        <option value="pendiente">Pendiente</option>
                        <option value="pagada">Pagada</option>
                        <option value="cancelada">Cancelada</option>
                    </select>
                  </div>
              </div>
              <div class="text-end mt-3">
                  <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancelar</button>
                  <button type="submit" class="btn btn-primary-custom">Guardar Reserva</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/admin/js/script.js"></script>
</body>
</html>
