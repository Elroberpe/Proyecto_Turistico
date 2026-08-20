package com.turismo.service;

import java.util.List;
import com.turismo.dao.DAOFactory;
import com.turismo.interfaces.PaqueteInterface;
import com.turismo.modelo.Paquete;

public class PaqueteService {

    private PaqueteInterface paqueteDao = DAOFactory.getDaoFactory(DAOFactory.MYSQL).getPaquete();

    public List<Paquete> listarTodos() {
        return paqueteDao.listarTodos();
    }

    public List<Paquete> listarActivos() {
        return paqueteDao.listarActivos();
    }

    public List<Paquete> listarPorCategoria(String nombreCategoria) {
        if (nombreCategoria == null || nombreCategoria.trim().isEmpty()) {
            nombreCategoria = "Costa";
        }
        return paqueteDao.listarPorCategoria(nombreCategoria.trim());
    }

    public Paquete obtenerPorId(int id) {
        return paqueteDao.obtenerPorId(id);
    }

    public boolean crear(Paquete paquete) {
        if (paquete == null || paquete.getNombre() == null || paquete.getNombre().trim().isEmpty()) {
            return false;
        }
        return paqueteDao.crear(paquete);
    }

    public boolean actualizar(Paquete paquete) {
        if (paquete == null || paquete.getIdPaquete() <= 0) {
            return false;
        }
        return paqueteDao.actualizar(paquete);
    }

    public boolean eliminar(int id) {
        return paqueteDao.eliminar(id);
    }

    public int contarActivos() {
        return paqueteDao.contarActivos();
    }
}
