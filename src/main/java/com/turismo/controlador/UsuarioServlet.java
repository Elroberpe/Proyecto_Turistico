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

@WebServlet("/UsuarioServlet")
public class UsuarioServlet extends HttpServlet {
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

            case "editar":
                editar(request, response);
                break;

            case "eliminar":
                eliminar(request, response);
                break;

            default:
                response.sendRedirect("login.jsp");
        }

    }
    
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        if ("logout".equals(accion)) {
            request.getSession().invalidate();
            response.sendRedirect("login.jsp");
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
                response.sendRedirect("admin/dashboard.jsp");
            } else {
                response.sendRedirect("index.jsp");
            }

        } else {
            response.sendRedirect("login.jsp?error=1");
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


        if (dao.registrar(usuario)) {
            response.sendRedirect("login.jsp?registro=ok");
        } else {
            response.sendRedirect("login.jsp?registro=error");
        }

    }
  

    private void editar(HttpServletRequest request,
            HttpServletResponse response) {
    }

    private void eliminar(HttpServletRequest request,
            HttpServletResponse response) {
    }

}