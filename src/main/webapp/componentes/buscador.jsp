<section class="search-section">
		<div class="container">
			<div class="search-card">
				<h3 class="text-center mb-4">
					<i class="bi bi-calendar-heart me-2"></i> Planifica tu viaje desde
					Lima
				</h3>
				<form id="bookingForm" class="row g-3">
					<div class="col-md-3">
						<label class="form-label"><i
							class="bi bi-arrow-left-right me-1"></i> Tipo de viaje</label> <select
							id="tipoViaje" class="form-select" required>
							<option value="roundtrip">Ida y Vuelta</option>
							<option value="oneway">Solo Ida</option>
						</select>
					</div>
					<div class="col-md-3">
						<label class="form-label"><i class="bi bi-geo-alt me-1"></i>
							Destino</label> <select id="destinoSelect" class="form-select" required>
							<option value="">Selecciona un destino</option>
						</select>
						<div id="destinoPreview" class="preview-box"></div>
					</div>
					<div class="col-md-2">
						<label class="form-label"><i
							class="bi bi-calendar-check me-1"></i> Salida</label> <input type="date"
							id="fechaSalida" class="form-control" required>
					</div>
					<div class="col-md-2" id="retornoGroup">
						<label class="form-label"><i class="bi bi-calendar-x me-1"></i>
							Retorno</label> <input type="date" id="fechaRetorno" class="form-control">
					</div>
					<div class="col-md-2">
						<label class="form-label"><i class="bi bi-people me-1"></i>
							Pasajeros</label> <select id="pasajerosSelect" class="form-select">
							<option value="1">1 pasajero</option>
							<option value="2">2 pasajeros</option>
							<option value="3">3 pasajeros</option>
							<option value="4">4 pasajeros</option>
							<option value="5">5 pasajeros</option>
							<option value="6">6 pasajeros</option>
						</select>
					</div>
					<div
						class="col-12 mt-3 d-flex justify-content-between align-items-center flex-wrap">
						<div class="price-display">
							<span class="fw-bold">Precio estimado: </span> <span
								id="precioSoles" class="price-soles">S/ 0.00</span> <span
								id="precioUSD" class="price-usd">($0.00 USD)</span>
						</div>
						<button type="submit" class="btn btn-primary btn-lg px-5">
							<i class="bi bi-search"></i> Reservar Ahora
						</button>
					</div>
					<div id="validationMsg" class="text-danger small mt-2"></div>
				</form>
			</div>
		</div>
	</section>
