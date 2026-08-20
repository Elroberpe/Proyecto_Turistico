package com.turismo.controlador;

import java.io.IOException;
import java.math.BigDecimal;

import com.turismo.dao.PaqueteDao;
import com.turismo.dao.ReservaDao;
import com.turismo.dao.UsuarioDao;
import com.turismo.dao.PagoDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	
        PaqueteDao paqueteDao = new PaqueteDao();
        UsuarioDao usuarioDao = new UsuarioDao();
        ReservaDao reservaDao = new ReservaDao();
        PagoDao pagoDao = new PagoDao();

        int totalPaquetes = paqueteDao.contarActivos();
        int totalClientes = usuarioDao.contarClientes();
        int reservasMes = reservaDao.contarReservasDelMes();
        BigDecimal ingresosMes = pagoDao.sumarIngresosDelMes();

        request.setAttribute("totalPaquetes", totalPaquetes);
        request.setAttribute("totalClientes", totalClientes);
        request.setAttribute("reservasMes", reservasMes);
        request.setAttribute("ingresosMes", ingresosMes);
    	
        request.getRequestDispatcher("/WEB-INF/admin/index.jsp").forward(request, response);
    }
}
