package com.turismo.controlador;

import com.turismo.dao.DAOFactory;
import com.turismo.interfaces.PagoInterface;
import com.turismo.interfaces.ReservaInterface;
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
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

@WebServlet("/procesarPago")
public class ProcesarPagoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private ReservaInterface reservaDao = DAOFactory.getDaoFactory(DAOFactory.MYSQL).getReserva();
    private PagoInterface pagoDao = DAOFactory.getDaoFactory(DAOFactory.MYSQL).getPago();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/reserva.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (usuario == null) {
            request.getSession().setAttribute("error", "Debes iniciar sesión para completar la reserva.");
            response.sendRedirect(request.getContextPath() + "/login?redirect=reserva");
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
            } else if (metodoStr != null && !metodoStr.trim().isEmpty()) {
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
                request.getSession().setAttribute("error", "Error al crear la reserva en la base de datos.");
                response.sendRedirect(request.getContextPath() + "/reserva.jsp");
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
                // Sincronizar estado de la reserva a "pagada"
                reservaDao.actualizarEstado(r.getIdReserva(), "pagada");
                request.getSession().setAttribute("mensaje", "Tu reserva #" + r.getIdReserva() + " y pago han sido procesados exitosamente.");
            } else {
                request.getSession().setAttribute("error", "Reserva registrada (#" + r.getIdReserva() + "), pero ocurrió un problema al registrar el pago.");
            }

            response.sendRedirect(request.getContextPath() + "/mis-reservas");

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error al procesar la reserva: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/reserva.jsp");
        }
    }
}
