package com.turismo.controlador;

import com.turismo.dao.CategoriaPaqueteDao;
import com.turismo.modelo.CategoriaPaquete;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/categorias")
public class CategoriaServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private CategoriaPaqueteDao dao = new CategoriaPaqueteDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("categorias", dao.listar());
        request.getRequestDispatcher("/WEB-INF/admin/categorias_paquetes.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        try {
            if ("guardar".equals(accion)) {
                CategoriaPaquete c = new CategoriaPaquete();
                c.setNombre(request.getParameter("nombre").trim());
                c.setDescripcion(request.getParameter("descripcion").trim());

                if (dao.crear(c)) {
                    request.getSession().setAttribute("mensaje", "✅ Categoría creada correctamente.");
                } else {
                    request.getSession().setAttribute("error", "❌ Error al crear la categoría.");
                }

            } else if ("actualizar".equals(accion)) {
                CategoriaPaquete c = new CategoriaPaquete();
                c.setIdCategoria(Integer.parseInt(request.getParameter("id")));
                c.setNombre(request.getParameter("nombre").trim());
                c.setDescripcion(request.getParameter("descripcion").trim());

                if (dao.editar(c)) {
                    request.getSession().setAttribute("mensaje", "✅ Categoría actualizada correctamente.");
                } else {
                    request.getSession().setAttribute("error", "❌ Error al actualizar la categoría.");
                }

            } else if ("eliminar".equals(accion)) {
                int id = Integer.parseInt(request.getParameter("id"));
                int count = dao.contarPaquetesPorCategoria(id);

                if (count > 0) {
                    request.getSession().setAttribute("error", "❌ No se puede eliminar. La categoría tiene " + count + " paquetes asociados.");
                } else if (dao.eliminar(id)) {
                    request.getSession().setAttribute("mensaje", "✅ Categoría eliminada correctamente.");
                } else {
                    request.getSession().setAttribute("error", "❌ Error al eliminar la categoría.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "❌ Error al procesar la solicitud.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/categorias");
    }
}