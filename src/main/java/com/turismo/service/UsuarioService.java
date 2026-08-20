package com.turismo.service;

import com.turismo.dao.DAOFactory;
import com.turismo.interfaces.UsuarioInterface;
import com.turismo.modelo.Usuario;

public class UsuarioService {

    private UsuarioInterface usuarioDao = DAOFactory.getDaoFactory(DAOFactory.MYSQL).getUsuario();

    public Usuario login(String email, String password) {
        return usuarioDao.login(email, password);
    }

    public boolean registrar(Usuario usuario) {
        return usuarioDao.registrar(usuario);
    }

    public boolean actualizar(Usuario usuario) {
        return usuarioDao.actualizar(usuario);
    }

    public boolean actualizarConPassword(Usuario usuario) {
        return usuarioDao.actualizarConPassword(usuario);
    }
}
