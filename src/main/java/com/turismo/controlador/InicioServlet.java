package com.turismo.controlador;

import java.io.IOException;
import java.util.List;

import com.turismo.dao.DAOFactory;
import com.turismo.interfaces.PaqueteInterface;
import com.turismo.modelo.Paquete;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet({"/inicio", "/home", "/index"})
public class InicioServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PaqueteInterface paqueteDao = DAOFactory.getDaoFactory(DAOFactory.MYSQL).getPaquete();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Paquete> paquetesDestacados = paqueteDao.listarDestacados(3);
        request.setAttribute("paquetesDestacados", paquetesDestacados);
        request.setAttribute("inicioCargado", true);

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
