package com.turismo.controlador;

import com.turismo.dao.ReservaDao;
import com.turismo.modelo.Reserva;
import com.turismo.modelo.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/mis-reservas")
public class MisReservasServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ReservaDao reservaDao = new ReservaDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Reserva> reservas = reservaDao.listarPorUsuario(usuario.getIdUsuario());
        request.setAttribute("reservas", reservas);
        request.setAttribute("fechaHoy", Date.valueOf(LocalDate.now()));
        request.getRequestDispatcher("/mis-reservas.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if ("cancelar".equals(action)) {
            try {
                int idReserva = Integer.parseInt(request.getParameter("id"));
                Reserva r = reservaDao.obtenerPorId(idReserva);
                if (r != null && r.getIdUsuario() == usuario.getIdUsuario()) {
                    if ("cancelada".equalsIgnoreCase(r.getEstado())) {
                        request.getSession().setAttribute("error", "La reserva ya se encuentra cancelada.");
                        response.sendRedirect(request.getContextPath() + "/mis-reservas");
                        return;
                    }

                    if (r.getFechaSalida() != null) {
                        LocalDate hoy = LocalDate.now();
                        LocalDate fechaSalida = r.getFechaSalida().toLocalDate();
                        if (!fechaSalida.isAfter(hoy)) {
                            request.getSession().setAttribute("error", "No se puede cancelar una reserva cuya fecha de viaje ya inició o ha concluido.");
                            response.sendRedirect(request.getContextPath() + "/mis-reservas");
                            return;
                        }
                    }

                    boolean ok = reservaDao.actualizarEstado(idReserva, "cancelada");
                    if (ok) {
                        request.getSession().setAttribute("mensaje", "La reserva #" + idReserva + " ha sido cancelada exitosamente.");
                    } else {
                        request.getSession().setAttribute("error", "No se pudo cancelar la reserva.");
                    }
                } else {
                    request.getSession().setAttribute("error", "No tienes permisos para modificar esta reserva.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("error", "Error al procesar la cancelación.");
            }
        }

        response.sendRedirect(request.getContextPath() + "/mis-reservas");
    }
}
