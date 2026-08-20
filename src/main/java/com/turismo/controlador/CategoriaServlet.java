package com.turismo.controlador;

import com.turismo.modelo.CategoriaPaquete;
import com.turismo.service.CategoriaService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/categorias")
public class CategoriaServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private CategoriaService categoriaService = new CategoriaService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("categorias", categoriaService.listar());
        request.getRequestDispatcher("/WEB-INF/admin/categorias_paquetes.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "";
        }

        switch (accion) {
            case "guardar":
                guardar(request, response);
                break;
            case "actualizar":
                actualizar(request, response);
                break;
            case "eliminar":
                eliminar(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/categorias");
                break;
        }
    }

    // ============================================
    // GUARDAR CATEGORÍA
    // ============================================
    private void guardar(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            CategoriaPaquete c = new CategoriaPaquete();
            c.setNombre(request.getParameter("nombre").trim());
            c.setDescripcion(request.getParameter("descripcion").trim());

            if (categoriaService.crear(c)) {
                request.getSession().setAttribute("mensaje", "Categoría creada correctamente.");
            } else {
                request.getSession().setAttribute("error", "Error al crear la categoría.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error inesperado al guardar.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/categorias");
    }

    // ============================================
    // ACTUALIZAR CATEGORÍA
    // ============================================
    private void actualizar(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            CategoriaPaquete c = new CategoriaPaquete();
            c.setIdCategoria(Integer.parseInt(request.getParameter("id")));
            c.setNombre(request.getParameter("nombre").trim());
            c.setDescripcion(request.getParameter("descripcion").trim());

            if (categoriaService.actualizar(c)) {
                request.getSession().setAttribute("mensaje", "Categoría actualizada correctamente.");
            } else {
                request.getSession().setAttribute("error", "Error al actualizar la categoría.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error inesperado al actualizar.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/categorias");
    }

    // ============================================
    // ELIMINAR CATEGORÍA
    // ============================================
    private void eliminar(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int count = categoriaService.contarPaquetesPorCategoria(id);

            if (count > 0) {
                request.getSession().setAttribute("error", "No se puede eliminar. La categoría tiene " + count + " paquetes asociados.");
            } else if (categoriaService.eliminar(id)) {
                request.getSession().setAttribute("mensaje", "Categoría eliminada correctamente.");
            } else {
                request.getSession().setAttribute("error", "Error al eliminar la categoría.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error inesperado al eliminar.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/categorias");
    }
}