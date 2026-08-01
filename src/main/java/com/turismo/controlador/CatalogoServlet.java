package com.turismo.controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import com.turismo.dao.PaqueteDao;
import com.turismo.modelo.Paquete;

@WebServlet("/catalogo")
public class CatalogoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String region = request.getParameter("region");
        if (region == null || region.trim().isEmpty()) {
            region = "Costa"; // Por defecto
        }

        PaqueteDao dao = new PaqueteDao();
        List<Paquete> paquetes = dao.listarPorCategoria(region);
        request.setAttribute("paquetes", paquetes);

        if ("Selva".equalsIgnoreCase(region)) {
            request.getRequestDispatcher("selva.jsp").forward(request, response);
        } else if ("Sierra".equalsIgnoreCase(region)) {
            request.getRequestDispatcher("sierra.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("costa.jsp").forward(request, response);
        }
    }
}
