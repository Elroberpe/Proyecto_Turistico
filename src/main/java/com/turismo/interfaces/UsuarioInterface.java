package com.turismo.interfaces;

import java.util.List;
import com.turismo.modelo.Usuario;

public interface UsuarioInterface {
    Usuario login(String email, String password);
    boolean registrar(Usuario usuario);
    boolean actualizar(Usuario usuario);
    boolean actualizarConPassword(Usuario usuario);
    boolean eliminar(int id);
    Usuario obtenerPorId(int id);
    Usuario obtenerPorEmail(String email);
    List<Usuario> listarTodos();
    List<Usuario> listarClientes();
    List<Usuario> listarAdministradores();
    int contarClientes();
}
