package com.turismo.controlador;

import com.turismo.dao.DAOFactory;
import com.turismo.interfaces.ReservaInterface;
import com.turismo.interfaces.UsuarioInterface;
import com.turismo.interfaces.PaqueteInterface;
import com.turismo.interfaces.PagoInterface;
import com.turismo.modelo.Reserva;
import com.turismo.modelo.Usuario;
import com.turismo.modelo.Paquete;
import com.turismo.modelo.CategoriaPaquete;
import com.turismo.modelo.Pago;
import com.turismo.service.CategoriaService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/admin/reservas")
public class ReservaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ReservaInterface reservaDao = DAOFactory.getDaoFactory(DAOFactory.MYSQL).getReserva();
    private UsuarioInterface usuarioDao = DAOFactory.getDaoFactory(DAOFactory.MYSQL).getUsuario();
    private PaqueteInterface paqueteDao = DAOFactory.getDaoFactory(DAOFactory.MYSQL).getPaquete();
    private CategoriaService categoriaService = new CategoriaService();
    private PagoInterface pagoDao = DAOFactory.getDaoFactory(DAOFactory.MYSQL).getPago();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Reserva> reservas = reservaDao.listarTodos();
        List<Usuario> usuarios = usuarioDao.listarClientes();
        List<Paquete> paquetes = paqueteDao.listarActivos();
        List<CategoriaPaquete> categorias = categoriaService.listar();

        request.setAttribute("reservas", reservas);
        request.setAttribute("usuarios", usuarios);
        request.setAttribute("paquetes", paquetes);
        request.setAttribute("categorias", categorias);
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
    // CREAR RESERVA
    // ============================================
    private void crear(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int idUsuario = Integer.parseInt(request.getParameter("id_usuario"));
            int idPaquete = Integer.parseInt(request.getParameter("id_paquete"));
            String tipoViajeRaw = request.getParameter("tipo_viaje");
            String tipoViaje = ("oneway".equalsIgnoreCase(tipoViajeRaw) || "ida".equalsIgnoreCase(tipoViajeRaw)
                    || "Solo Ida".equalsIgnoreCase(tipoViajeRaw)) ? "ida" : "idavuelta";
            int numPasajeros = Integer.parseInt(request.getParameter("num_pasajeros"));
            BigDecimal precioTotal = new BigDecimal(request.getParameter("precio_total"));

            String fechaSalidaStr = request.getParameter("fecha_salida");
            String fechaRetornoStr = request.getParameter("fecha_retorno");

            LocalDate hoy = LocalDate.now();
            LocalDate fechaSalida = LocalDate.parse(fechaSalidaStr);

            if (fechaSalida.isBefore(hoy)) {
                request.getSession().setAttribute("error", "La fecha de salida no puede ser anterior a hoy.");
                response.sendRedirect(request.getContextPath() + "/admin/reservas");
                return;
            }

            if ("idavuelta".equalsIgnoreCase(tipoViaje)) {
                if (fechaRetornoStr == null || fechaRetornoStr.trim().isEmpty()) {
                    request.getSession().setAttribute("error",
                            "Para viaje de ida y vuelta, la fecha de retorno es obligatoria.");
                    response.sendRedirect(request.getContextPath() + "/admin/reservas");
                    return;
                }
                LocalDate fechaRetorno = LocalDate.parse(fechaRetornoStr);
                if (fechaRetorno.isBefore(fechaSalida)) {
                    request.getSession().setAttribute("error",
                            "La fecha de retorno no puede ser anterior a la fecha de salida.");
                    response.sendRedirect(request.getContextPath() + "/admin/reservas");
                    return;
                }
            }

            Reserva r = new Reserva();
            r.setIdUsuario(idUsuario);
            r.setIdPaquete(idPaquete);
            r.setTipoViaje(tipoViaje);
            r.setFechaSalida(Date.valueOf(fechaSalida));
            if (fechaRetornoStr != null && !fechaRetornoStr.trim().isEmpty()) {
                r.setFechaRetorno(Date.valueOf(LocalDate.parse(fechaRetornoStr)));
            }
            r.setNumPasajeros(numPasajeros);
            r.setPrecioTotal(precioTotal);
            r.setEstado("pendiente");

            if (reservaDao.crear(r)) {
                request.getSession().setAttribute("mensaje", "Reserva creada (Pendiente de pago).");
            } else {
                request.getSession().setAttribute("error", "Error al crear la reserva.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error inesperado al crear reserva.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/reservas");
    }

    // ============================================
    // EDITAR RESERVA
    // ============================================
    private void editar(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));

            Reserva reservaAnterior = reservaDao.obtenerPorId(id);
            if (reservaAnterior == null) {
                request.getSession().setAttribute("error", "Reserva no encontrada.");
                response.sendRedirect(request.getContextPath() + "/admin/reservas");
                return;
            }

            if ("pagada".equals(reservaAnterior.getEstado())) {
                request.getSession().setAttribute("error",
                        "No se puede editar una reserva pagada. Use el módulo de Pagos.");
                response.sendRedirect(request.getContextPath() + "/admin/reservas");
                return;
            }

            int idUsuario = Integer.parseInt(request.getParameter("id_usuario"));
            int idPaquete = Integer.parseInt(request.getParameter("id_paquete"));
            String tipoViajeRaw = request.getParameter("tipo_viaje");
            String tipoViaje = ("oneway".equalsIgnoreCase(tipoViajeRaw) || "ida".equalsIgnoreCase(tipoViajeRaw)
                    || "Solo Ida".equalsIgnoreCase(tipoViajeRaw)) ? "ida" : "idavuelta";
            int numPasajeros = Integer.parseInt(request.getParameter("num_pasajeros"));
            BigDecimal precioTotal = new BigDecimal(request.getParameter("precio_total"));
            String estado = request.getParameter("estado");

            String fechaSalidaStr = request.getParameter("fecha_salida");
            String fechaRetornoStr = request.getParameter("fecha_retorno");

            LocalDate hoy = LocalDate.now();
            LocalDate fechaSalida = LocalDate.parse(fechaSalidaStr);

            if (fechaSalida.isBefore(hoy)) {
                request.getSession().setAttribute("error", "La fecha de salida no puede ser anterior a hoy.");
                response.sendRedirect(request.getContextPath() + "/admin/reservas");
                return;
            }

            if ("idavuelta".equalsIgnoreCase(tipoViaje)) {
                if (fechaRetornoStr == null || fechaRetornoStr.trim().isEmpty()) {
                    request.getSession().setAttribute("error",
                            "Para viaje de ida y vuelta, la fecha de retorno es obligatoria.");
                    response.sendRedirect(request.getContextPath() + "/admin/reservas");
                    return;
                }
                LocalDate fechaRetorno = LocalDate.parse(fechaRetornoStr);
                if (fechaRetorno.isBefore(fechaSalida)) {
                    request.getSession().setAttribute("error",
                            "La fecha de retorno no puede ser anterior a la fecha de salida.");
                    response.sendRedirect(request.getContextPath() + "/admin/reservas");
                    return;
                }
            }

            Reserva r = new Reserva();
            r.setIdReserva(id);
            r.setIdUsuario(idUsuario);
            r.setIdPaquete(idPaquete);
            r.setTipoViaje(tipoViaje);
            r.setFechaSalida(Date.valueOf(fechaSalida));
            if (fechaRetornoStr != null && !fechaRetornoStr.trim().isEmpty()) {
                r.setFechaRetorno(Date.valueOf(LocalDate.parse(fechaRetornoStr)));
            }
            r.setNumPasajeros(numPasajeros);
            r.setPrecioTotal(precioTotal);
            r.setEstado(estado);

            if (reservaDao.actualizar(r)) {
                request.getSession().setAttribute("mensaje", "Reserva actualizada.");
            } else {
                request.getSession().setAttribute("error", "Error al actualizar la reserva.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error inesperado al editar reserva.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/reservas");
    }

    // ============================================
    // ELIMINAR RESERVA
    // ============================================
    private void eliminar(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));

            Reserva reserva = reservaDao.obtenerPorId(id);
            if (reserva == null) {
                request.getSession().setAttribute("error", "Reserva no encontrada.");
                response.sendRedirect(request.getContextPath() + "/admin/reservas");
                return;
            }

            if (!"pendiente".equalsIgnoreCase(reserva.getEstado())) {
                request.getSession().setAttribute("error", 
                    "Solo se pueden eliminar reservas en estado 'pendiente'. Las reservas pagadas o canceladas no pueden eliminarse.");
                response.sendRedirect(request.getContextPath() + "/admin/reservas");
                return;
            }

            // Validar si tiene algún pago o transacción asociada en el historial
            Pago pago = pagoDao.obtenerPorReserva(id);
            if (pago != null) {
                request.getSession().setAttribute("error", "No se puede eliminar la reserva, tiene un pago asociado.");
                response.sendRedirect(request.getContextPath() + "/admin/reservas");
                return;
            }

            if (reservaDao.eliminar(id)) {
                request.getSession().setAttribute("mensaje", "Reserva eliminada exitosamente.");
            } else {
                request.getSession().setAttribute("error", "Error al eliminar la reserva.");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "ID inválido.");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error inesperado al eliminar reserva.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/reservas");
    }
}
