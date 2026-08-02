package com.turismo.controlador;

import com.turismo.dao.CategoriaPaqueteDao;
import com.turismo.modelo.CategoriaPaquete;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/categorias")
public class CategoriaServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private CategoriaPaqueteDao dao = new CategoriaPaqueteDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("eliminar".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                
                // 🔥 VERIFICAR si tiene paquetes
                int count = dao.contarPaquetesPorCategoria(id);
                
                if (count > 0) {
                    // Tiene paquetes → No se puede eliminar
                    request.getSession().setAttribute("error", 
                        "❌ No se puede eliminar. La categoría tiene " + count + " paquetes asociados. Elimina los paquetes primero.");
                } else {
                    // No tiene paquetes → Se puede eliminar
                    boolean eliminado = dao.eliminar(id);
                    if (eliminado) {
                        request.getSession().setAttribute("mensaje", "✅ Categoría eliminada correctamente.");
                    } else {
                        request.getSession().setAttribute("error", "❌ Error al eliminar la categoría.");
                    }
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("error", "❌ ID inválido.");
            }
            response.sendRedirect("CategoriaServlet");
            return;
        }

        // Listar categorías
        List<CategoriaPaquete> categorias = dao.listar();
        request.setAttribute("categorias", categorias);
        request.getRequestDispatcher("/WEB-INF/admin/categorias_paquetes.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");

        // Validar campos obligatorios
        if (nombre == null || nombre.trim().isEmpty()) {
            request.getSession().setAttribute("error", "❌ El nombre es obligatorio.");
            response.sendRedirect("CategoriaServlet");
            return;
        }

        try {
            if ("crear".equals(action)) {
                CategoriaPaquete categoria = new CategoriaPaquete();
                categoria.setNombre(nombre.trim());
                categoria.setDescripcion(descripcion != null ? descripcion.trim() : "");
                
                boolean creado = dao.crear(categoria);
                if (creado) {
                    request.getSession().setAttribute("mensaje", "✅ Categoría creada correctamente.");
                } else {
                    request.getSession().setAttribute("error", "❌ Error al crear la categoría.");
                }

            } else if ("editar".equals(action)) {
                String idParam = request.getParameter("id");
                if (idParam == null || idParam.isEmpty()) {
                    request.getSession().setAttribute("error", "❌ ID no proporcionado.");
                    response.sendRedirect("CategoriaServlet");
                    return;
                }

                int id = Integer.parseInt(idParam);
                CategoriaPaquete categoria = new CategoriaPaquete();
                categoria.setIdCategoria(id);
                categoria.setNombre(nombre.trim());
                categoria.setDescripcion(descripcion != null ? descripcion.trim() : "");
                
                boolean editado = dao.editar(categoria);
                if (editado) {
                    request.getSession().setAttribute("mensaje", "✅ Categoría actualizada correctamente.");
                } else {
                    request.getSession().setAttribute("error", "❌ Error al actualizar la categoría.");
                }
            }

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "❌ ID inválido.");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "❌ Error inesperado.");
        }

        response.sendRedirect("CategoriaServlet");
    }
}