package com.turismo.controlador;

import com.turismo.dao.DAOFactory;
import com.turismo.interfaces.CategoriaPaqueteInterface;
import com.turismo.interfaces.PaqueteInterface;
import com.turismo.interfaces.ReservaInterface;
import com.turismo.modelo.CategoriaPaquete;
import com.turismo.modelo.Paquete;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/admin/paquetes")
public class PaqueteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PaqueteInterface dao = DAOFactory.getDaoFactory(DAOFactory.MYSQL).getPaquete();
    private CategoriaPaqueteInterface categoriaDao = DAOFactory.getDaoFactory(DAOFactory.MYSQL).getCategoriaPaquete();
    private ReservaInterface reservaDao = DAOFactory.getDaoFactory(DAOFactory.MYSQL).getReserva();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String region = request.getParameter("region");
        String destino = request.getParameter("destino");

        // 1. Poblar el desplegable de regiones
        List<CategoriaPaquete> categorias = categoriaDao.listar();

        // 2. Filtrar paquetes y obtener destinos únicos según región seleccionada
        List<Paquete> paquetes;
        List<String> destinosUnicos = null;

        boolean tieneRegion = region != null && !region.trim().isEmpty() && !"0".equals(region);
        boolean tieneDestino = destino != null && !destino.trim().isEmpty();

        if (tieneRegion) {
            destinosUnicos = dao.listarDestinosPorCategoria(region);
            if (tieneDestino) {
                paquetes = dao.listarPorCategoriaYDestinoAdmin(region, destino);
            } else {
                paquetes = dao.listarPorCategoriaAdmin(region);
            }
        } else {
            paquetes = dao.listarTodos();
        }

        request.setAttribute("categorias", categorias);
        request.setAttribute("destinosUnicos", destinosUnicos);
        request.setAttribute("paquetes", paquetes);
        request.getRequestDispatcher("/WEB-INF/admin/paquetes.jsp").forward(request, response);
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
                response.sendRedirect(request.getContextPath() + "/admin/paquetes");
                break;
        }
    }

    private void crear(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            Paquete p = new Paquete();
            p.setIdCategoria(Integer.parseInt(request.getParameter("id_categoria")));
            p.setNombre(request.getParameter("nombre"));
            p.setDestino(request.getParameter("destino"));
            p.setDescripcion(request.getParameter("descripcion"));
            p.setImagenUrl(request.getParameter("imagenUrl"));
            p.setPrecioSoles(new BigDecimal(request.getParameter("precio_soles")));
            p.setEstado(request.getParameter("estado"));

            if (dao.crear(p)) {
                request.getSession().setAttribute("mensaje", "Paquete creado correctamente.");
            } else {
                request.getSession().setAttribute("error", "Error al crear el paquete.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error inesperado al crear paquete.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/paquetes");
    }

    private void editar(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Paquete p = new Paquete();
            p.setIdPaquete(id);
            p.setIdCategoria(Integer.parseInt(request.getParameter("id_categoria")));
            p.setNombre(request.getParameter("nombre"));
            p.setDestino(request.getParameter("destino"));
            p.setDescripcion(request.getParameter("descripcion"));
            p.setImagenUrl(request.getParameter("imagenUrl"));
            p.setPrecioSoles(new BigDecimal(request.getParameter("precio_soles")));
            p.setEstado(request.getParameter("estado"));

            if (dao.actualizar(p)) {
                request.getSession().setAttribute("mensaje", "Paquete actualizado correctamente.");
            } else {
                request.getSession().setAttribute("error", "Error al actualizar el paquete.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error inesperado al editar paquete.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/paquetes");
    }

    private void eliminar(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));

            int count = reservaDao.contarPorPaquete(id);
            if (count > 0) {
                request.getSession().setAttribute("error", "No se puede eliminar este paquete, tiene reservas asociadas.");
                response.sendRedirect(request.getContextPath() + "/admin/paquetes");
                return;
            }

            if (dao.eliminar(id)) {
                request.getSession().setAttribute("mensaje", "Paquete eliminado correctamente.");
            } else {
                request.getSession().setAttribute("error", "Error al eliminar el paquete.");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "ID inválido.");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error inesperado al eliminar paquete.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/paquetes");
    }
}