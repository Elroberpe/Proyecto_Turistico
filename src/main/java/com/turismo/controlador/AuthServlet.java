package com.turismo.controlador;

import java.io.IOException;

import org.mindrot.jbcrypt.BCrypt;

import com.turismo.dao.DAOFactory;
import com.turismo.interfaces.UsuarioInterface;
import com.turismo.modelo.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet({"/login", "/AuthServlet"})
public class AuthServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
    private UsuarioInterface dao = DAOFactory.getDaoFactory(DAOFactory.MYSQL).getUsuario();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        switch (accion) {
            case "login":
                login(request, response);
                break;

            case "registrar":
                registrar(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/login");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        if ("logout".equals(accion)) {
            request.getSession().invalidate();
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        } else {
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    private void login(HttpServletRequest request,
            HttpServletResponse response) throws IOException {
        
    	String email = request.getParameter("email");
        String password = request.getParameter("password");

        Usuario usuario = null;
        if (email != null && password != null) {
            Usuario uBD = dao.obtenerPorEmail(email.trim());
            if (uBD != null && uBD.getPassword() != null) {
                String dbPass = uBD.getPassword();
                boolean match = false;

                if (dbPass.startsWith("$2a$") || dbPass.startsWith("$2b$") || dbPass.startsWith("$2y$")) {
                    match = BCrypt.checkpw(password, dbPass);
                } else if (dbPass.equals(password)) {
                    match = true;
                    // Auto-actualizar contrasena antigua a BCrypt
                    String hash = BCrypt.hashpw(password, BCrypt.gensalt(12));
                    uBD.setPassword(hash);
                    dao.actualizarConPassword(uBD);
                }

                if (match) {
                    uBD.setPassword(null);
                    usuario = uBD;
                }
            }
        }

        if (usuario != null) {

            HttpSession session = request.getSession();
            session.setAttribute("usuario", usuario);

            if (usuario.getIdRol() == 2) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                String redirect = request.getParameter("redirect");
                if ("reserva".equals(redirect)) {
                    response.sendRedirect(request.getContextPath() + "/reserva.jsp");
                } else {
                    response.sendRedirect(request.getContextPath() + "/index.jsp");
                }
            }

        } else {
            request.getSession().setAttribute("error", "Correo o contraseña incorrectos.");
            String redirect = request.getParameter("redirect");
            String redirectParam = (redirect != null && !redirect.trim().isEmpty()) ? "?redirect=" + redirect : "";
            response.sendRedirect(request.getContextPath() + "/login" + redirectParam);
        }

    }
    
    private void registrar(HttpServletRequest request,
            HttpServletResponse response) throws IOException {
    	
    	Usuario usuario = new Usuario();
    	
    	usuario.setIdRol(1);
        usuario.setNombre(request.getParameter("nombre"));
        usuario.setApellidos(request.getParameter("apellidos"));
        usuario.setEmail(request.getParameter("email"));
        usuario.setTelefono(request.getParameter("telefono"));

        String rawPassword = request.getParameter("password");
        if (rawPassword != null && !rawPassword.trim().isEmpty()) {
            String hash = BCrypt.hashpw(rawPassword, BCrypt.gensalt(12));
            usuario.setPassword(hash);
        }

        String redirect = request.getParameter("redirect");
        String redirectParam = (redirect != null && !redirect.trim().isEmpty()) ? "?redirect=" + redirect : "";

        if (dao.registrar(usuario)) {
            request.getSession().setAttribute("mensaje", "Cuenta creada con éxito. Ya puedes iniciar sesión.");
            response.sendRedirect(request.getContextPath() + "/login" + redirectParam);
        } else {
            request.getSession().setAttribute("error", "No se pudo registrar la cuenta. El correo ya podría estar en uso.");
            response.sendRedirect(request.getContextPath() + "/login" + redirectParam);
        }

    }
}
