package com.turismo.controlador;

import java.io.IOException;
import java.util.List;

import com.turismo.dao.DAOFactory;
import com.turismo.interfaces.UsuarioInterface;
import com.turismo.modelo.Usuario;
import com.turismo.service.UsuarioService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/usuarios")
public class UsuarioServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UsuarioInterface dao = DAOFactory.getDaoFactory(DAOFactory.MYSQL).getUsuario();
    private UsuarioService usuarioService = new UsuarioService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Usuario> usuarios = dao.listar();
        request.setAttribute("usuarios", usuarios);
        request.getRequestDispatcher("/WEB-INF/admin/usuarios.jsp").forward(request, response);
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
            case "registrarAdmin":
                crear(request, response);
                break;
            case "editar":
                editar(request, response);
                break;
            case "eliminar":
                eliminar(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/usuarios");
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

            String rolParam = request.getParameter("id_rol");
            int rol = (rolParam != null && !rolParam.trim().isEmpty()) ? Integer.parseInt(rolParam) : 2;
            u.setIdRol(rol);

            if (usuarioService.registrar(u)) {
                request.getSession().setAttribute("mensaje", "Usuario registrado correctamente.");
            } else {
                request.getSession().setAttribute("error", "Error al registrar el usuario.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error inesperado.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/usuarios");
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

            String rolParam = request.getParameter("id_rol");
            if (rolParam != null && !rolParam.trim().isEmpty()) {
                u.setIdRol(Integer.parseInt(rolParam));
            }

            if (dao.actualizar(u)) {
                request.getSession().setAttribute("mensaje", "Usuario actualizado correctamente.");
            } else {
                request.getSession().setAttribute("error", "Error al actualizar el usuario.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error inesperado.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/usuarios");
    }

    private void eliminar(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            if (dao.eliminar(id)) {
                request.getSession().setAttribute("mensaje", "Usuario eliminado correctamente.");
            } else {
                request.getSession().setAttribute("error", "Error al eliminar el usuario.");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "ID inválido.");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error inesperado al eliminar.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/usuarios");
    }
}