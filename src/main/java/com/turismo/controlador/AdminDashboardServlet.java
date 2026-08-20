package com.turismo.controlador;

import java.io.IOException;
import java.math.BigDecimal;

import com.turismo.dao.DAOFactory;
import com.turismo.interfaces.ReservaInterface;
import com.turismo.interfaces.UsuarioInterface;
import com.turismo.interfaces.PagoInterface;
import com.turismo.service.PaqueteService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    private PaqueteService paqueteService = new PaqueteService();
    private UsuarioInterface usuarioDao = DAOFactory.getDaoFactory(DAOFactory.MYSQL).getUsuario();
    private ReservaInterface reservaDao = DAOFactory.getDaoFactory(DAOFactory.MYSQL).getReserva();
    private PagoInterface pagoDao = DAOFactory.getDaoFactory(DAOFactory.MYSQL).getPago();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int totalPaquetes = paqueteService.contarActivos();
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
