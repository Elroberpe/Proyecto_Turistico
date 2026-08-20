package com.turismo.service;

import java.util.List;
import com.turismo.dao.DAOFactory;
import com.turismo.interfaces.CategoriaPaqueteInterface;
import com.turismo.modelo.CategoriaPaquete;

public class CategoriaService {

    private CategoriaPaqueteInterface categoriaDao = DAOFactory.getDaoFactory(DAOFactory.MYSQL).getCategoriaPaquete();

    public List<CategoriaPaquete> listar() {
        return categoriaDao.listar();
    }

    public CategoriaPaquete obtenerPorId(int id) {
        return categoriaDao.obtenerPorId(id);
    }

    public boolean crear(CategoriaPaquete categoria) {
        if (categoria == null || categoria.getNombre() == null || categoria.getNombre().trim().isEmpty()) {
            return false;
        }
        return categoriaDao.crear(categoria);
    }

    public boolean actualizar(CategoriaPaquete categoria) {
        if (categoria == null || categoria.getIdCategoria() <= 0) {
            return false;
        }
        return categoriaDao.actualizar(categoria);
    }

    public int contarPaquetesPorCategoria(int idCategoria) {
        return categoriaDao.contarPaquetesPorCategoria(idCategoria);
    }

    public boolean eliminar(int id) {
        if (contarPaquetesPorCategoria(id) > 0) {
            return false;
        }
        return categoriaDao.eliminar(id);
    }
}
