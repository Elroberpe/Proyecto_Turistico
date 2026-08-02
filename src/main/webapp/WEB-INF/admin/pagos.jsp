<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel Admin Turìstico - Pagos</title>
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
                <li><a href="${pageContext.request.contextPath}/admin/categorias"><i class="bi bi-tags me-2"></i> Categorìas</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/paquetes"><i class="bi bi-box-seam me-2"></i> Paquetes</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/clientes"><i class="bi bi-person-badge me-2"></i> Clientes</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/usuarios"><i class="bi bi-people me-2"></i> Usuarios</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/reservas"><i class="bi bi-calendar-check me-2"></i> Reservas</a></li>
                <li class="active"><a href="${pageContext.request.contextPath}/admin/pagos"><i class="bi bi-credit-card me-2"></i> Pagos</a></li>
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
                <h2>Gestiòn de Pagos</h2>
                <button class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#pagoModal">
                    <i class="bi bi-plus-circle"></i> Registrar Pago
                </button>
            </div>
            
            <div class="card p-4">
                <div class="table-responsive">
                    <table class="table table-hover table-custom align-middle">
                        <thead>
                            <tr>
                                <th>ID Pago</th>
                                <th>Reserva (ID)</th>
                                <th>Mètodo de Pago</th>
                                <th>Monto</th>
                                <th>Estado</th>
                                <th>Fecha de Pago</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>1</td>
                                <td>2</td>
                                <td>Tarjeta (1)</td>
                                <td>S/ 4800.00</td>
                                <td><span class="badge bg-success">Pagado</span></td>
                                <td>2026-07-22 14:30:00</td>
                                <td>
                                    <button class="btn btn-sm btn-secondary-custom" data-bs-toggle="modal" data-bs-target="#pagoModal"><i class="bi bi-pencil"></i></button>
                                    <button class="btn btn-sm btn-danger"><i class="bi bi-trash"></i></button>
                                </td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td>1</td>
                                <td>Yape (2)</td>
                                <td>S/ 700.00</td>
                                <td><span class="badge bg-warning text-dark">Reembolsado</span></td>
                                <td>2026-07-23 09:15:00</td>
                                <td>
                                    <button class="btn btn-sm btn-secondary-custom" data-bs-toggle="modal" data-bs-target="#pagoModal"><i class="bi bi-pencil"></i></button>
                                    <button class="btn btn-sm btn-danger"><i class="bi bi-trash"></i></button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Formulario Pago -->
    <div class="modal fade" id="pagoModal" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header bg-primary-custom text-white">
            <h5 class="modal-title">Detalle de Pago</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <form>
              <div class="mb-3">
                <label class="form-label">ID Reserva</label>
                <select class="form-select" name="id_reserva" required>
                    <option value="">Seleccione Reserva</option>
                    <option value="1">Reserva 1</option>
                    <option value="2">Reserva 2</option>
                </select>
              </div>
              <div class="row">
                  <div class="col-md-6 mb-3">
                    <label class="form-label">Monto</label>
                    <input type="number" step="0.01" class="form-control" name="monto" required>
                  </div>
                  <div class="col-md-6 mb-3">
                    <label class="form-label">MÃ©todo de Pago</label>
                    <select class="form-select" name="id_metodo" required>
                        <option value="1">Tarjeta</option>
                        <option value="2">Yape</option>
                        <option value="3">Plin</option>
                    </select>
                  </div>
              </div>
              <div class="mb-3">
                <label class="form-label">Estado del Pago</label>
                <select class="form-select" name="estado" required>
                    <option value="pagado">Pagado</option>
                    <option value="rechazado">Rechazado</option>
                    <option value="reembolsado">Reembolsado</option>
                </select>
              </div>
              <div class="text-end mt-3">
                  <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancelar</button>
                  <button type="submit" class="btn btn-primary-custom">Guardar Pago</button>
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
