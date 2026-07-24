package com.turismo.controlador;

import com.turismo.dao.CategoriaDao;
import com.turismo.modelo.CategoriaPaquete;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/categorias")
public class CategoriaPaqueteServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private CategoriaDao categoriaDAO;

    @Override
    public void init() {
        categoriaDAO = new CategoriaDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    	listar(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

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
        }
    }

    // ===========================
    // LISTAR
    // ===========================
    private void listar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<CategoriaPaquete> lista = categoriaDAO.listar();

        request.setAttribute("categorias", lista);
        request.getRequestDispatcher("categorias_paquetes.jsp")
                .forward(request, response);
    }

    // ===========================
    // GUARDAR
    // ===========================
    private void guardar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");

        CategoriaPaquete categoria = new CategoriaPaquete(nombre, descripcion);

        categoriaDAO.registrar(categoria);

        response.sendRedirect("categorias");
    }


    // ===========================
    // ACTUALIZAR
    // ===========================
    private void actualizar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");

        CategoriaPaquete categoria = new CategoriaPaquete(id, nombre, descripcion);

        categoriaDAO.actualizar(categoria);

        response.sendRedirect("categorias");
    }

    // ===========================
    // ELIMINAR
    // ===========================
    private void eliminar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        categoriaDAO.eliminar(id);
        
        response.sendRedirect("categorias");
    }
}