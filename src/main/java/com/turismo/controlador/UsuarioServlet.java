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
        // Reservado para futuras consultas GET
    }

    private void editar(HttpServletRequest request,
            HttpServletResponse response) {
    }

    private void eliminar(HttpServletRequest request,
            HttpServletResponse response) {
    }

}