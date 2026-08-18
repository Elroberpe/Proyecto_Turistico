package com.turismo.controlador;

import java.io.IOException;
import java.util.List;

import com.turismo.dao.UsuarioDao;
import com.turismo.modelo.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/clientes")
public class ClienteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UsuarioDao dao = new UsuarioDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Usuario> clientes = dao.listarClientes();
        request.setAttribute("clientes", clientes);
        request.getRequestDispatcher("/WEB-INF/admin/clientes.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = request.getParameter("accion");
        }
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
                response.sendRedirect(request.getContextPath() + "/admin/clientes");
                break;
        }
    }

    private void crear(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            Usuario u = new Usuario();
            u.setNombre(request.getParameter("nombre"));
            u.setApellidos(request.getParameter("apellidos"));
            u.setEmail(request.getParameter("email"));
            u.setPassword(request.getParameter("password"));
            u.setTelefono(request.getParameter("telefono"));
            u.setIdRol(1); // Rol Cliente

            if (dao.registrar(u)) {
                request.getSession().setAttribute("mensaje", "Cliente registrado correctamente.");
            } else {
                request.getSession().setAttribute("error", "Error al registrar el cliente.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error inesperado.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/clientes");
    }

    private void editar(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Usuario u = new Usuario();
            u.setIdUsuario(id);
            u.setNombre(request.getParameter("nombre"));
            u.setApellidos(request.getParameter("apellidos"));
            u.setEmail(request.getParameter("email"));
            u.setTelefono(request.getParameter("telefono"));
            u.setIdRol(1);

            if (dao.actualizar(u)) {
                request.getSession().setAttribute("mensaje", "Cliente actualizado correctamente.");
            } else {
                request.getSession().setAttribute("error", "Error al actualizar el cliente.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error inesperado.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/clientes");
    }

    private void eliminar(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            if (dao.eliminar(id)) {
                request.getSession().setAttribute("mensaje", "Cliente eliminado correctamente.");
            } else {
                request.getSession().setAttribute("error", "Error al eliminar el cliente.");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "ID inválido.");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error inesperado al eliminar.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/clientes");
    }
}
