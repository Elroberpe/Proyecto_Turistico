package com.turismo.interfaces;

import java.util.List;
import com.turismo.modelo.Usuario;

public interface UsuarioInterface {
    Usuario login(String email, String password);
    boolean registrar(Usuario usuario);
    List<Usuario> listar();
    Usuario obtenerPorId(int id);
    Usuario obtenerPorEmail(String email);
    boolean actualizar(Usuario usuario);
    boolean actualizarConPassword(Usuario usuario);
    boolean eliminar(int id);
    int contarClientes();
    List<Usuario> listarClientes();
}
