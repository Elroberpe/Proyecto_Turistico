package com.turismo.controlador;

import com.turismo.dao.CategoriaDao;
import com.turismo.dao.PaqueteDao;
import com.turismo.modelo.CategoriaPaquete;
import com.turismo.modelo.Paquete;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.util.List;

@WebServlet("/admin/paquetes")
@MultipartConfig
public class PaqueteServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private PaqueteDao paqueteDAO;
    private CategoriaDao categoriaDAO;

    @Override
    public void init() {
        paqueteDAO = new PaqueteDao();
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

        List<Paquete> lista = paqueteDAO.listar();
        List<CategoriaPaquete> listaCategorias = categoriaDAO.listar();

        request.setAttribute("paquetes", lista);
        request.setAttribute("categorias", listaCategorias);
        

        request.getRequestDispatcher("/WEB-INF/admin/paquetes.jsp")
                .forward(request, response);
    }

    // ===========================
    // GUARDAR
    // ===========================
    private void guardar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int idCategoria = Integer.parseInt(request.getParameter("id_categoria"));
        String nombre = request.getParameter("nombre");
        String destino = request.getParameter("destino");
        String descripcion = request.getParameter("descripcion");
        Part imagen = request.getPart("imagen");
        BigDecimal precio = new BigDecimal(request.getParameter("precioSoles"));
        String estado = request.getParameter("estado");
        
        CategoriaPaquete categoria = categoriaDAO.buscarPorId(idCategoria);
        
        String imagenUrl = null;
        
        if(imagen !=null && imagen.getSize() >0 ) {
        	
            String carpeta = categoria.getNombre().toLowerCase();
            
            String nombreArchivo =Paths.get(imagen.getSubmittedFileName())
                         .getFileName()
                         .toString();
            
            String ruta = getServletContext().getRealPath("/assets/img/" + carpeta);

            File directorio = new File(ruta);

            if (!directorio.exists()) {
                directorio.mkdirs();
            }
            System.out.println("Categoría: " + categoria.getNombre());
            System.out.println("Archivo: " + nombreArchivo);
            System.out.println("Ruta: " + ruta);
            System.out.println("Existe directorio: " + directorio.exists());
            System.out.println("Tamaño imagen: " + imagen.getSize());

            imagen.write(ruta + File.separator + nombreArchivo);
            
            imagenUrl = "assets/img/" + carpeta + "/" + nombreArchivo;
	
        }
                
        
        Paquete paquete = new Paquete(idCategoria, nombre, destino,descripcion, imagenUrl,precio, estado);

        paqueteDAO.registrar(paquete);

        response.sendRedirect("paquetes");
    }

    // ===========================
    // ACTUALIZAR
    // ===========================
    private void actualizar(HttpServletRequest request,HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        int idCategoria = Integer.parseInt(request.getParameter("idCategoria"));
        String nombre = request.getParameter("nombre");
        String destino = request.getParameter("destino");
        String descripcion = request.getParameter("descripcion");
        String imagenUrl = request.getParameter("imagenUrl");
        BigDecimal precio = new BigDecimal(request.getParameter("precioSoles"));
        String estado = request.getParameter("estado");
        Paquete paquete = new Paquete(id,idCategoria,nombre,destino,descripcion,imagenUrl,precio,estado);

        paqueteDAO.actualizar(paquete);

        response.sendRedirect("paquetes");
    }

    // ===========================
    // ELIMINAR
    // ===========================
    private void eliminar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        paqueteDAO.eliminar(id);

        response.sendRedirect("paquetes");
    }

}