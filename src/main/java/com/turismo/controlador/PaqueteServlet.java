package com.turismo.controlador;

import com.turismo.dao.CategoriaPaqueteDao;
import com.turismo.dao.PaqueteDao;
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
    private PaqueteDao dao = new PaqueteDao();
    private CategoriaPaqueteDao categoriaDao = new CategoriaPaqueteDao();

    // ============================================
    // GET: Listar y Eliminar
    // ============================================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // ELIMINAR paquete
        if ("eliminar".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                if (dao.eliminar(id)) {
                    request.getSession().setAttribute("mensaje", "✅ Paquete eliminado correctamente.");
                } else {
                    request.getSession().setAttribute("error", "❌ Error al eliminar el paquete.");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("error", "❌ ID inválido.");
            }
            response.sendRedirect("PaqueteServlet");
            return;
        }

        // LISTAR paquetes
        List<Paquete> paquetes = dao.listarTodos();
        List<CategoriaPaquete> categorias = categoriaDao.listar();
        request.setAttribute("paquetes", paquetes);
        request.setAttribute("categorias", categorias);
        request.getRequestDispatcher("/WEB-INF/admin/paquetes.jsp").forward(request, response);
    }

    // ============================================
    // POST: Crear y Editar
    // ============================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("crear".equals(action)) {
            crear(request, response);
        } else if ("editar".equals(action)) {
            editar(request, response);
        } else {
            response.sendRedirect("PaqueteServlet");
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
                request.getSession().setAttribute("mensaje", "✅ Paquete creado correctamente.");
            } else {
                request.getSession().setAttribute("error", "❌ Error al crear el paquete.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "❌ Error inesperado.");
        }
        response.sendRedirect("PaqueteServlet");
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
                request.getSession().setAttribute("mensaje", "✅ Paquete actualizado correctamente.");
            } else {
                request.getSession().setAttribute("error", "❌ Error al actualizar el paquete.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "❌ Error inesperado.");
        }
        response.sendRedirect("PaqueteServlet");
    }
}