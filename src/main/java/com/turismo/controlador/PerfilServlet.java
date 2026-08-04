package com.turismo.controlador;

import com.turismo.dao.UsuarioDao;
import com.turismo.modelo.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/perfil")
public class PerfilServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UsuarioDao usuarioDao = new UsuarioDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Usuario uActual = usuarioDao.obtenerPorId(usuario.getIdUsuario());
        if (uActual != null) {
            session.setAttribute("usuario", uActual);
        }

        request.getRequestDispatcher("/perfil.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            String nombre = request.getParameter("nombre");
            String apellidos = request.getParameter("apellidos");
            String email = request.getParameter("email");
            String telefono = request.getParameter("telefono");
            String password = request.getParameter("password");

            Usuario u = usuarioDao.obtenerPorId(usuario.getIdUsuario());
            if (u != null) {
                u.setNombre(nombre);
                u.setApellidos(apellidos);
                u.setEmail(email);
                u.setTelefono(telefono);

                boolean exito;
                if (password != null && !password.trim().isEmpty()) {
                    u.setPassword(password);
                    exito = usuarioDao.actualizarConPassword(u);
                } else {
                    exito = usuarioDao.actualizar(u);
                }

                if (exito) {
                    session.setAttribute("usuario", u);
                    session.setAttribute("mensaje", "✅ Tu perfil ha sido actualizado correctamente.");
                } else {
                    session.setAttribute("error", "❌ Error al actualizar los datos en la base de datos.");
                }
            } else {
                session.setAttribute("error", "❌ Usuario no encontrado.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "❌ Error inesperado al procesar la actualización.");
        }

        response.sendRedirect(request.getContextPath() + "/perfil");
    }
}
