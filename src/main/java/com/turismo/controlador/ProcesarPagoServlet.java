package com.turismo.controlador;

import com.turismo.dao.PagoDao;
import com.turismo.dao.ReservaDao;
import com.turismo.modelo.Pago;
import com.turismo.modelo.Reserva;
import com.turismo.modelo.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

@WebServlet("/procesarPago")
public class ProcesarPagoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private ReservaDao reservaDao = new ReservaDao();
    private PagoDao pagoDao = new PagoDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (usuario == null) {
            out.print("{\"success\": false, \"mensaje\": \"Sesión no iniciada. Por favor inicie sesión.\"}");
            out.flush();
            return;
        }

        try {
            int idPaquete = Integer.parseInt(request.getParameter("id_paquete"));
            String tipoViajeRaw = request.getParameter("tipo_viaje");
            String tipoViaje = ("oneway".equalsIgnoreCase(tipoViajeRaw) || "ida".equalsIgnoreCase(tipoViajeRaw) || "Solo Ida".equalsIgnoreCase(tipoViajeRaw)) ? "ida" : "idavuelta";
            
            String fechaSalidaStr = request.getParameter("fecha_salida");
            String fechaRetornoStr = request.getParameter("fecha_retorno");
            int numPasajeros = Integer.parseInt(request.getParameter("num_pasajeros"));
            BigDecimal precioTotal = new BigDecimal(request.getParameter("precio_total"));
            
            String metodoStr = request.getParameter("id_metodo");
            int idMetodo = 1; // Default: Tarjeta (1)
            if ("2".equals(metodoStr) || "yape".equalsIgnoreCase(metodoStr)) {
                idMetodo = 2; // Yape
            } else if ("3".equals(metodoStr) || "plin".equalsIgnoreCase(metodoStr)) {
                idMetodo = 3; // Plin
            } else if (metodoStr != null && !metodoStr.isEmpty()) {
                try {
                    idMetodo = Integer.parseInt(metodoStr);
                } catch (NumberFormatException e) {
                    idMetodo = 1;
                }
            }

            // 1. Crear Reserva en BD
            Reserva r = new Reserva();
            r.setIdUsuario(usuario.getIdUsuario());
            r.setIdPaquete(idPaquete);
            r.setTipoViaje(tipoViaje);
            r.setFechaSalida(Date.valueOf(fechaSalidaStr));
            if (fechaRetornoStr != null && !fechaRetornoStr.trim().isEmpty()) {
                r.setFechaRetorno(Date.valueOf(fechaRetornoStr));
            }
            r.setNumPasajeros(numPasajeros);
            r.setPrecioTotal(precioTotal);
            r.setEstado("pendiente");

            boolean reservaCreada = reservaDao.crear(r);

            if (!reservaCreada) {
                out.print("{\"success\": false, \"mensaje\": \"Error al crear la reserva en la base de datos.\"}");
                out.flush();
                return;
            }

            // 2. Crear Pago en BD asociado a la Reserva
            Pago p = new Pago();
            p.setIdReserva(r.getIdReserva());
            p.setIdMetodo(idMetodo);
            p.setMonto(precioTotal);
            p.setEstado("pagado");
            p.setFechaPago(new Timestamp(System.currentTimeMillis()));

            boolean pagoCreado = pagoDao.crear(p);

            if (pagoCreado) {
                // Ahora que el pago fue exitoso, actualizamos la reserva de "pendiente" a "pagada"
                reservaDao.actualizarEstado(r.getIdReserva(), "pagada");
                out.print("{\"success\": true, \"idReserva\": " + r.getIdReserva() + 
                          ", \"idPago\": " + p.getIdPago() + 
                          ", \"mensaje\": \"¡Pago y reserva procesados correctamente!\"}" );
            } else {
                // El pago falló: la reserva queda en "pendiente" (estado consistente)
                out.print("{\"success\": false, \"mensaje\": \"Reserva registrada, pero ocurrió un error al registrar el pago.\"}" );
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"mensaje\": \"Error al procesar la solicitud: " + e.getMessage() + "\"}");
        }
        out.flush();
    }
}
