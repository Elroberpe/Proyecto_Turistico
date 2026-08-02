package com.turismo.controlador;

import java.io.IOException;

import com.turismo.dao.UsuarioDao;
import com.turismo.modelo.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AuthServlet")
public class AuthServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
    private UsuarioDao dao = new UsuarioDao();

    @Override
    protected void doPost(HttpServletRequest request,HttpServletResponse response)
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
                response.sendRedirect("login.jsp");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        if ("logout".equals(accion)) {
            request.getSession().invalidate();
            response.sendRedirect("index.jsp");
        }
    }

    private void login(HttpServletRequest request,
            HttpServletResponse response) throws IOException {
        
    	String email = request.getParameter("email");
        String password = request.getParameter("password");

        Usuario usuario = dao.login(email, password);

        if (usuario != null) {

            HttpSession session = request.getSession();
            session.setAttribute("usuario", usuario);

            if (usuario.getIdRol() == 2) {
                response.sendRedirect("admin/dashboard");
            } else {
                String redirect = request.getParameter("redirect");
                if ("reserva".equals(redirect)) {
                    response.sendRedirect("reserva.jsp");
                } else {
                    response.sendRedirect("index.jsp");
                }
            }

        } else {
            String redirectParam = request.getParameter("redirect") != null ? "&redirect=" + request.getParameter("redirect") : "";
            response.sendRedirect("login.jsp?error=1" + redirectParam);
        }

    }
    
    private void registrar(HttpServletRequest request,
            HttpServletResponse response) throws IOException {
    	
    	Usuario usuario = new Usuario();

        usuario.setNombre(request.getParameter("nombre"));
        usuario.setApellidos(request.getParameter("apellidos"));
        usuario.setEmail(request.getParameter("email"));
        usuario.setPassword(request.getParameter("password"));
        usuario.setTelefono(request.getParameter("telefono"));

        String redirectParam = request.getParameter("redirect") != null ? "&redirect=" + request.getParameter("redirect") : "";
        if (dao.registrar(usuario)) {
            response.sendRedirect("login.jsp?registro=ok" + redirectParam);
        } else {
            response.sendRedirect("login.jsp?registro=error" + redirectParam);
        }

    }
}
