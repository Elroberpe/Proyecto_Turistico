<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chasqui PERÚ | Finalizar Reserva</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/style.css?v=2.0">
</head>
<body style="background-color: var(--light-gray);">
    <jsp:include page="componentes/navbar.jsp"></jsp:include>

    <div class="container py-5" style="margin-top: 100px;">
        <div class="row g-4">
            <div class="col-md-6">
                <div class="payment-card" id="resumenReserva"></div>
            </div>
            <div class="col-md-6">
                <div class="payment-card bg-white p-4" style="border-radius: var(--radius-md); box-shadow: var(--shadow-soft);">
                    <h3 class="text-center mb-4"><i class="bi bi-credit-card text-primary me-2"></i> Método de Pago</h3>
                    <form id="paymentForm">
                        <div class="mb-3">
                            <label class="form-label fw-bold text-muted small text-uppercase">Selecciona método de pago</label>
                            <select id="metodoPago" class="form-select bg-light border-0 py-2 form-input-custom" required>
                                <option value="tarjeta">💳 Tarjeta de Crédito/Débito</option>
                                <option value="yape">📱 Yape</option>
                                <option value="plin">📱 Plin</option>
                            </select>
                        </div>

                        <div id="tarjetaFields">
                            <div class="mb-3">
                                <label class="form-label fw-bold text-muted small text-uppercase">Número de tarjeta</label>
                                <input type="text" id="numeroTarjeta" class="form-control bg-light border-0 form-input-custom" placeholder="**** **** **** ****">
                            </div>
                            <div class="row g-3 mb-3">
                                <div class="col-6">
                                    <label class="form-label fw-bold text-muted small text-uppercase">Fecha exp.</label>
                                    <input type="text" id="fechaExp" class="form-control bg-light border-0 form-input-custom" placeholder="MM/AA">
                                </div>
                                <div class="col-6">
                                    <label class="form-label fw-bold text-muted small text-uppercase">CVV</label>
                                    <input type="password" id="cvv" class="form-control bg-light border-0 form-input-custom" placeholder="***">
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-bold text-muted small text-uppercase">Nombre del titular</label>
                                <input type="text" id="titular" class="form-control bg-light border-0 form-input-custom" placeholder="Como aparece en la tarjeta">
                            </div>
                        </div>

                        <div id="qrFields" style="display: none;">
                            <div class="qr-code text-center p-4 mb-3" style="background: rgba(13, 148, 136, 0.05); border-radius: var(--radius-md);">
                                <i class="bi bi-qr-code" style="font-size: 100px; color: var(--primary);"></i>
                                <p class="mt-3 mb-1 fw-bold">Escanea el código QR desde tu app</p>
                                <p class="text-muted small mb-0">Código de referencia: <strong class="text-dark">CH-2026-001</strong></p>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary-custom w-100 mt-3 btn-lg rounded-pill fw-bold">
                            <i class="bi bi-lock me-2"></i> Pagar ahora
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- COMPONENTES COMPARTIDOS -->
    <jsp:include page="componentes/modal_reserva.jsp"></jsp:include>
    <jsp:include page="componentes/footer.jsp"></jsp:include>

    <!-- SCRIPTS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="assets/js/reserva.js?v=<%= System.currentTimeMillis() %>"></script>
    <script src="assets/js/booking-modal.js?v=<%= System.currentTimeMillis() %>"></script>
</body>
</html>
