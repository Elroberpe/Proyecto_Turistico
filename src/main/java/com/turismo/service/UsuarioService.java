package com.turismo.service;

import com.turismo.dao.DAOFactory;
import com.turismo.interfaces.UsuarioInterface;
import com.turismo.modelo.Usuario;
import com.turismo.utils.BCrypt;

public class UsuarioService {

    private UsuarioInterface usuarioDao = DAOFactory.getDaoFactory(DAOFactory.MYSQL).getUsuario();

    // ============================================
    // LOGIN CON BCRYPT Y SOPORTE DE COMPATIBILIDAD
    // ============================================
    public Usuario login(String email, String password) {
        if (email == null || password == null) {
            return null;
        }

        Usuario usuario = usuarioDao.obtenerPorEmail(email.trim());

        if (usuario != null && usuario.getPassword() != null) {
            String dbPass = usuario.getPassword();
            boolean match = false;

            // 1. Si es hash BCrypt ($2a$, $2b$, $2y$)
            if (dbPass.startsWith("$2a$") || dbPass.startsWith("$2b$") || dbPass.startsWith("$2y$")) {
                match = BCrypt.checkpw(password, dbPass);
            } else {
                // 2. Soporte para contrasenas antiguas en texto plano
                if (dbPass.equals(password)) {
                    match = true;
                    // Auto-actualizar la contrasena a BCrypt de forma transparente
                    usuario.setPassword(password);
                    actualizarConPassword(usuario);
                }
            }

            if (match) {
                usuario.setPassword(null); // Limpiar hash antes de guardarlo en sesion HTTP
                return usuario;
            }
        }
        return null;
    }

    // ============================================
    // REGISTRAR NUEVO USUARIO CON HASH BCRYPT
    // ============================================
    public boolean registrar(Usuario usuario) {
        if (usuario == null || usuario.getPassword() == null || usuario.getPassword().trim().isEmpty()) {
            return false;
        }
        String salt = BCrypt.gensalt(12);
        String hash = BCrypt.hashpw(usuario.getPassword(), salt);
        usuario.setPassword(hash);
        return usuarioDao.registrar(usuario);
    }

    // ============================================
    // ACTUALIZAR PERFIL / DATOS BASICOS
    // ============================================
    public boolean actualizar(Usuario usuario) {
        return usuarioDao.actualizar(usuario);
    }

    // ============================================
    // ACTUALIZAR DATOS + NUEVA CONTRASEÑA HASHEADA
    // ============================================
    public boolean actualizarConPassword(Usuario usuario) {
        if (usuario == null) {
            return false;
        }
        if (usuario.getPassword() != null && !usuario.getPassword().trim().isEmpty()) {
            String salt = BCrypt.gensalt(12);
            String hash = BCrypt.hashpw(usuario.getPassword(), salt);
            usuario.setPassword(hash);
        }
        return usuarioDao.actualizarConPassword(usuario);
    }

    public Usuario obtenerPorId(int id) {
        return usuarioDao.obtenerPorId(id);
    }
}
