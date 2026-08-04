package com.turismo.controlador;

import com.turismo.dao.ReservaDao;
import com.turismo.dao.UsuarioDao;
import com.turismo.dao.PaqueteDao;
import com.turismo.modelo.Reserva;
import com.turismo.modelo.Usuario;
import com.turismo.modelo.Paquete;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;

@WebServlet("/admin/reservas")
public class ReservaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ReservaDao reservaDao = new ReservaDao();
    private UsuarioDao usuarioDao = new UsuarioDao();
    private PaqueteDao paqueteDao = new PaqueteDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Reserva> reservas = reservaDao.listarTodos();
        request.setAttribute("reservas", reservas);

        List<Usuario> usuarios = usuarioDao.listarClientes();
        List<Paquete> paquetes = paqueteDao.listarActivos();
        request.setAttribute("usuarios", usuarios);
        request.setAttribute("paquetes", paquetes);

        request.getRequestDispatcher("/WEB-INF/admin/reservas.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        switch (action) {
            case "crear":
                crear(request, response);
                break;
            case "editar":
                editar(request, response);
                break;
            case "eliminar":
                eliminar(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/reservas");
                break;
        }
    }

    // ============================================
    // CREAR RESERVA (FORZADO A PENDIENTE)
    // ============================================
    private void crear(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            Reserva r = new Reserva();
            r.setIdUsuario(Integer.parseInt(request.getParameter("id_usuario")));
            r.setIdPaquete(Integer.parseInt(request.getParameter("id_paquete")));
            String tipoViajeRaw = request.getParameter("tipo_viaje");
            String tipoViaje = ("oneway".equalsIgnoreCase(tipoViajeRaw) || "ida".equalsIgnoreCase(tipoViajeRaw) || "Solo Ida".equalsIgnoreCase(tipoViajeRaw)) ? "ida" : "idavuelta";
            r.setTipoViaje(tipoViaje);
            r.setFechaSalida(Date.valueOf(request.getParameter("fecha_salida")));

            String fechaRetorno = request.getParameter("fecha_retorno");
            if (fechaRetorno != null && !fechaRetorno.isEmpty()) {
                r.setFechaRetorno(Date.valueOf(fechaRetorno));
            }

            r.setNumPasajeros(Integer.parseInt(request.getParameter("num_pasajeros")));
            r.setPrecioTotal(new BigDecimal(request.getParameter("precio_total")));
            r.setEstado("pendiente"); // FORZADO a pendiente

            if (reservaDao.crear(r)) {
                request.getSession().setAttribute("mensaje", "✅ Reserva creada (Pendiente de pago).");
            } else {
                request.getSession().setAttribute("error", "❌ Error al crear la reserva.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "❌ Error inesperado al crear reserva.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/reservas");
    }

    // ============================================
    // EDITAR RESERVA
    // ============================================
    private void editar(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            
            // Obtener estado anterior
            Reserva reservaAnterior = reservaDao.obtenerPorId(id);
            if (reservaAnterior == null) {
                request.getSession().setAttribute("error", "❌ Reserva no encontrada.");
                response.sendRedirect(request.getContextPath() + "/admin/reservas");
                return;
            }
            String estadoAnterior = reservaAnterior.getEstado();

            // Si la reserva está pagada, no se puede editar (solo desde pagos)
            if ("pagada".equals(estadoAnterior)) {
                request.getSession().setAttribute("error", 
                    "❌ No se puede editar una reserva pagada. Use el módulo de Pagos.");
                response.sendRedirect(request.getContextPath() + "/admin/reservas");
                return;
            }

            // Actualizar datos
            Reserva r = new Reserva();
            r.setIdReserva(id);
            r.setIdUsuario(Integer.parseInt(request.getParameter("id_usuario")));
            r.setIdPaquete(Integer.parseInt(request.getParameter("id_paquete")));
            String tipoViajeRaw = request.getParameter("tipo_viaje");
            String tipoViaje = ("oneway".equalsIgnoreCase(tipoViajeRaw) || "ida".equalsIgnoreCase(tipoViajeRaw) || "Solo Ida".equalsIgnoreCase(tipoViajeRaw)) ? "ida" : "idavuelta";
            r.setTipoViaje(tipoViaje);
            r.setFechaSalida(Date.valueOf(request.getParameter("fecha_salida")));

            String fechaRetorno = request.getParameter("fecha_retorno");
            if (fechaRetorno != null && !fechaRetorno.isEmpty()) {
                r.setFechaRetorno(Date.valueOf(fechaRetorno));
            }

            r.setNumPasajeros(Integer.parseInt(request.getParameter("num_pasajeros")));
            r.setPrecioTotal(new BigDecimal(request.getParameter("precio_total")));
            r.setEstado(request.getParameter("estado"));

            if (reservaDao.actualizar(r)) {
                request.getSession().setAttribute("mensaje", "✅ Reserva actualizada.");
            } else {
                request.getSession().setAttribute("error", "❌ Error al actualizar la reserva.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "❌ Error inesperado al editar reserva.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/reservas");
    }

    // ============================================
    // ELIMINAR RESERVA
    // ============================================
    private void eliminar(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            
            // Solo se puede eliminar si está pendiente o cancelada
            Reserva reserva = reservaDao.obtenerPorId(id);
            if (reserva != null && "pagada".equals(reserva.getEstado())) {
                request.getSession().setAttribute("error", 
                    "❌ No se puede eliminar una reserva pagada.");
                response.sendRedirect(request.getContextPath() + "/admin/reservas");
                return;
            }
            
            if (reservaDao.eliminar(id)) {
                request.getSession().setAttribute("mensaje", "✅ Reserva eliminada.");
            } else {
                request.getSession().setAttribute("error", "❌ Error al eliminar la reserva.");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "❌ ID inválido.");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "❌ Error inesperado al eliminar reserva.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/reservas");
    }
}