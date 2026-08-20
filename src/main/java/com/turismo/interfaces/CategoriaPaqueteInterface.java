package com.turismo.interfaces;

import java.util.List;
import com.turismo.modelo.CategoriaPaquete;

public interface CategoriaPaqueteInterface {
    List<CategoriaPaquete> listar();
    CategoriaPaquete obtenerPorId(int id);
    boolean crear(CategoriaPaquete categoria);
    boolean actualizar(CategoriaPaquete categoria);
    boolean eliminar(int id);
}
