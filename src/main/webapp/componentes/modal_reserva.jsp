<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Modal de Reserva Modernizado -->
<div class="modal fade" id="modalReserva" tabindex="-1" aria-labelledby="modalReservaLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content border-0 shadow-lg modal-custom-content">
      <div class="modal-header border-bottom-0 pb-0 pt-4 px-4 px-md-5">
        <h5 class="modal-title modal-custom-title" id="modalReservaLabel">
          <i class="bi bi-geo-alt-fill me-2 modal-icon-primary"></i> Tu Aventura
        </h5>
        <button type="button" class="btn-close shadow-none" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body p-4 p-md-5 pt-2">
        <p class="text-muted mb-4 modal-subtitle">Reserva tu paquete a <strong id="modalDestinoNombre" class="text-dark">...</strong>.</p>
        
        <form id="bookingForm" class="row g-4">
          <!-- Destino Oculto para lógica JS -->
          <input type="hidden" id="destinoSelect" value="">

          <div class="col-md-6">
            <label class="form-label text-uppercase small text-muted fw-bold"><i class="bi bi-arrow-left-right me-2"></i>Tipo de viaje</label>
            <select id="tipoViaje" class="form-select bg-light border-0 shadow-none py-2 form-input-custom" required>
              <option value="roundtrip">Ida y Vuelta</option>
              <option value="oneway">Solo Ida</option>
            </select>
          </div>

          <div class="col-md-6">
            <label class="form-label text-uppercase small text-muted fw-bold"><i class="bi bi-people me-2"></i>Pasajeros</label>
            <select id="pasajerosSelect" class="form-select bg-light border-0 shadow-none py-2 form-input-custom">
              <option value="1">1 pasajero</option>
              <option value="2" selected>2 pasajeros</option>
              <option value="3">3 pasajeros</option>
              <option value="4">4 pasajeros</option>
              <option value="5">5 pasajeros</option>
              <option value="6">6 pasajeros</option>
            </select>
          </div>

          <div class="col-md-6">
            <label class="form-label text-uppercase small text-muted fw-bold"><i class="bi bi-calendar-check me-2"></i>Salida</label>
            <input type="date" id="fechaSalida" class="form-control bg-light border-0 shadow-none py-2 form-input-custom" required>
          </div>

          <div class="col-md-6" id="retornoGroup">
            <label class="form-label text-uppercase small text-muted fw-bold"><i class="bi bi-calendar-x me-2"></i>Retorno</label>
            <input type="date" id="fechaRetorno" class="form-control bg-light border-0 shadow-none py-2 form-input-custom">
          </div>

          <div class="col-12 mt-4 p-4 text-center precio-container-bg">
            <span class="text-muted small d-block mb-1 text-uppercase fw-bold">Precio total estimado</span>
            <div id="precioSoles" class="fw-bold precio-display">S/ 0.00</div>
          </div>

          <div id="validationMsg" class="text-danger small mt-2 col-12 text-center"></div>
          <input type="submit" id="btnSubmitOculto" class="d-none">
        </form>
      </div>
      <div class="modal-footer border-top-0 pt-0 pb-4 pb-md-5 px-4 px-md-5 d-flex justify-content-between">
        <button type="button" class="btn text-muted fw-semibold" data-bs-dismiss="modal">Cancelar</button>
        <button type="button" class="btn btn-primary-custom w-50" id="btnConfirmarReserva" onclick="document.getElementById('btnSubmitOculto').click();">Confirmar Reserva</button>
      </div>
    </div>
  </div>
</div>
