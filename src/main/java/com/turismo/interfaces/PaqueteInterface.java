package com.turismo.interfaces;

import java.util.List;
import com.turismo.modelo.Paquete;

public interface PaqueteInterface {
    List<Paquete> listarTodos();
    List<Paquete> listarActivos();
    List<Paquete> listarPorCategoria(String nombreCategoria);
    Paquete obtenerPorId(int id);
    boolean crear(Paquete paquete);
    boolean actualizar(Paquete paquete);
    boolean eliminar(int id);
    int contarActivos();
}
