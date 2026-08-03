package com.turismo.controlador;

import com.turismo.dao.PagoDao;
import com.turismo.dao.ReservaDao;
import com.turismo.modelo.Pago;
import com.turismo.modelo.Reserva;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

@WebServlet("/admin/pagos")
public class PagoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PagoDao pagoDao = new PagoDao();
    private ReservaDao reservaDao = new ReservaDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // ============================================
        // ✅ ELIMINAR PAGO (con actualización de reserva)
        // ============================================
        if ("eliminar".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                
                // 🔥 Obtener el pago antes de eliminarlo
                Pago pago = pagoDao.obtenerPorId(id);
                if (pago != null) {
                    int idReserva = pago.getIdReserva();
                    
                    // Eliminar el pago
                    if (pagoDao.eliminar(id)) {
                        // ✅ Actualizar reserva a "pendiente"
                        reservaDao.actualizarEstado(idReserva, "pendiente");
                        request.getSession().setAttribute("mensaje", 
                            "✅ Pago eliminado. Reserva #" + idReserva + " vuelta a estado Pendiente.");
                    } else {
                        request.getSession().setAttribute("error", "❌ Error al eliminar el pago.");
                    }
                } else {
                    request.getSession().setAttribute("error", "❌ Pago no encontrado.");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("error", "❌ ID inválido.");
            }
            response.sendRedirect(request.getContextPath() + "/admin/pagos");
            return;
        }

        // Listar pagos
        List<Pago> pagos = pagoDao.listarTodos();
        request.setAttribute("pagos", pagos);

        // Obtener reservas pendientes para el combo
        List<Reserva> reservasPendientes = reservaDao.listarPendientes();
        request.setAttribute("reservasPendientes", reservasPendientes);

        request.getRequestDispatcher("/WEB-INF/admin/pagos.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("crear".equals(action)) {
            crear(request, response);
        } else if ("editar".equals(action)) {
            editar(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/pagos");
        }
    }

    // ============================================
    // CREAR PAGO
    // ============================================
    private void crear(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int idReserva = Integer.parseInt(request.getParameter("id_reserva"));
            
            // Verificar que la reserva esté pendiente
            Reserva reserva = reservaDao.obtenerPorId(idReserva);
            if (reserva == null || !"pendiente".equals(reserva.getEstado())) {
                request.getSession().setAttribute("error", 
                    "❌ Solo se pueden pagar reservas en estado 'pendiente'.");
                response.sendRedirect(request.getContextPath() + "/admin/pagos");
                return;
            }

            Pago p = new Pago();
            p.setIdReserva(idReserva);
            p.setIdMetodo(Integer.parseInt(request.getParameter("id_metodo")));
            p.setMonto(reserva.getPrecioTotal());
            p.setEstado(request.getParameter("estado"));
            p.setFechaPago(new Timestamp(System.currentTimeMillis()));

            if (pagoDao.crear(p)) {
                // Sincronizar estado de reserva según el pago
                if ("pagado".equals(p.getEstado())) {
                    reservaDao.actualizarEstado(idReserva, "pagada");
                    request.getSession().setAttribute("mensaje", "✅ Pago registrado. Reserva marcada como Pagada.");
                } else if ("rechazado".equals(p.getEstado())) {
                    reservaDao.actualizarEstado(idReserva, "cancelada");
                    request.getSession().setAttribute("mensaje", "✅ Pago rechazado. Reserva cancelada.");
                } else if ("reembolsado".equals(p.getEstado())) {
                    reservaDao.actualizarEstado(idReserva, "cancelada");
                    request.getSession().setAttribute("mensaje", "✅ Pago reembolsado. Reserva cancelada.");
                }
            } else {
                request.getSession().setAttribute("error", "❌ Error al crear el pago.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "❌ Error inesperado.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/pagos");
    }

    // ============================================
    // EDITAR PAGO
    // ============================================
    private void editar(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int idMetodo = Integer.parseInt(request.getParameter("id_metodo"));
            String estado = request.getParameter("estado");

            // Obtener pago actual para saber el estado anterior
            Pago pagoActual = pagoDao.obtenerPorId(id);
            if (pagoActual == null) {
                request.getSession().setAttribute("error", "❌ Pago no encontrado.");
                response.sendRedirect(request.getContextPath() + "/admin/pagos");
                return;
            }

            String estadoAnterior = pagoActual.getEstado();
            int idReserva = pagoActual.getIdReserva();

            // Actualizar pago
            Pago p = new Pago();
            p.setIdPago(id);
            p.setIdMetodo(idMetodo);
            p.setMonto(pagoActual.getMonto());
            p.setEstado(estado);

            if (pagoDao.actualizar(p)) {
                // Sincronizar reserva según nuevo estado del pago
                if ("pagado".equals(estado) && !"pagado".equals(estadoAnterior)) {
                    reservaDao.actualizarEstado(idReserva, "pagada");
                } else if (("rechazado".equals(estado) || "reembolsado".equals(estado)) 
                           && !"rechazado".equals(estadoAnterior) && !"reembolsado".equals(estadoAnterior)) {
                    reservaDao.actualizarEstado(idReserva, "cancelada");
                }
                request.getSession().setAttribute("mensaje", "✅ Pago actualizado.");
            } else {
                request.getSession().setAttribute("error", "❌ Error al actualizar.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "❌ Error inesperado.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/pagos");
    }
}