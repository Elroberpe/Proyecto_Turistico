package com.turismo.controlador;



import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import com.google.gson.Gson;
import com.turismo.dao.PaqueteDao;
import com.turismo.modelo.Paquete;

/**
 * Servlet implementation class SierraServlet
 */
@WebServlet("/api/sierra")
public class SierraServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	   @Override
	    protected void doGet(HttpServletRequest request, HttpServletResponse response)
	            throws ServletException, IOException {
	 
	        PaqueteDao dao = new PaqueteDao();
	        List<Paquete> paquetes = dao.listarPorCategoria("Sierra");
	        
	        
	        response.setContentType("application/json;charset=UTF-8");
        	response.setCharacterEncoding("UTF-8");
        	
        	Gson gson = new Gson();
        	String json =gson.toJson(paquetes);
        	
        	response.getWriter().write(json);
	    }
	
}
