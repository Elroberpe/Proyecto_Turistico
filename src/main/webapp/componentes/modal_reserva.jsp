<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Modal de Reserva -->
<div class="modal fade" id="modalReserva" tabindex="-1" aria-labelledby="modalReservaLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content border-0 shadow-lg rounded-4">
      <div class="modal-header border-bottom-0 pb-0">
        <h5 class="modal-title fw-bold" id="modalReservaLabel">
          <i class="bi bi-calendar-heart text-terracota me-2"></i> Reservar Paquete
        </h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body p-4 p-md-5 pt-3">
        <p class="text-muted mb-4">Completa los detalles para tu viaje a <strong id="modalDestinoNombre" class="text-dark">...</strong>.</p>
        
        <form id="bookingForm" class="row g-3">
          <!-- Destino Oculto para lógica JS -->
          <input type="hidden" id="destinoSelect" value="">

          <div class="col-md-6">
            <label class="form-label text-uppercase small text-muted fw-medium"><i class="bi bi-arrow-left-right me-1"></i> Tipo de viaje</label>
            <select id="tipoViaje" class="form-select rounded-3" required>
              <option value="roundtrip">Ida y Vuelta</option>
              <option value="oneway">Solo Ida</option>
            </select>
          </div>

          <div class="col-md-6">
            <label class="form-label text-uppercase small text-muted fw-medium"><i class="bi bi-people me-1"></i> Pasajeros</label>
            <select id="pasajerosSelect" class="form-select rounded-3">
              <option value="1">1 pasajero</option>
              <option value="2" selected>2 pasajeros</option>
              <option value="3">3 pasajeros</option>
              <option value="4">4 pasajeros</option>
              <option value="5">5 pasajeros</option>
              <option value="6">6 pasajeros</option>
            </select>
          </div>

          <div class="col-md-6">
            <label class="form-label text-uppercase small text-muted fw-medium"><i class="bi bi-calendar-check me-1"></i> Salida</label>
            <input type="date" id="fechaSalida" class="form-control rounded-3" required>
          </div>

          <div class="col-md-6" id="retornoGroup">
            <label class="form-label text-uppercase small text-muted fw-medium"><i class="bi bi-calendar-x me-1"></i> Retorno</label>
            <input type="date" id="fechaRetorno" class="form-control rounded-3">
          </div>

          <div class="col-12 mt-4 bg-light p-3 rounded-3 border">
            <div class="d-flex justify-content-between align-items-center">
              <span class="text-muted small">Precio total estimado</span>
              <div class="text-end">
                <div id="precioSoles" class="fw-bold fs-4" style="color: var(--accent);">S/ 0.00</div>
              </div>
            </div>
          </div>

          <div id="validationMsg" class="text-danger small mt-2 col-12"></div>
          
          <!-- Submit real oculto para validaciones nativas de HTML5 -->
          <input type="submit" id="btnSubmitOculto" style="display:none;">
        </form>
      </div>
      <div class="modal-footer border-top-0 pt-0 pb-4 px-4 px-md-5">
        <button type="button" class="btn btn-outline-secondary rounded-pill px-4" data-bs-dismiss="modal">Cancelar</button>
        <button type="button" class="btn btn-primary rounded-pill px-5" id="btnConfirmarReserva" onclick="document.getElementById('btnSubmitOculto').click();">Confirmar Reserva</button>
      </div>
    </div>
  </div>
</div>
