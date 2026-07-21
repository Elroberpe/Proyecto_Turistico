package com.turismo.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.turismo.conexion.ConexionDB;
import com.turismo.modelo.Usuario;

public class UsuarioDao {

    private Connection con;

    public UsuarioDao() {
        con = ConexionDB.obtenerConexion();
    }

    public Usuario login(String email, String password) {
        
    	Usuario usuario = null;
    			
        String sql = """
                SELECT * FROM usuario
                WHERE email = ? AND password = ?
                """;

        try {

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                usuario = new Usuario();
                usuario.setIdUsuario(rs.getInt("id_usuario"));
                usuario.setIdRol(rs.getInt("id_rol"));
                usuario.setNombre(rs.getString("nombre"));
                usuario.setApellidos(rs.getString("apellidos"));
                usuario.setEmail(rs.getString("email"));
                usuario.setTelefono(rs.getString("telefono"));
            }

            rs.close();
            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return usuario;
    }
    
    public boolean registrar(Usuario usuario) {

        String sql = """
                INSERT INTO usuario (id_rol, nombre, apellidos, email, password, telefono)
                VALUES (?, ?, ?, ?, ?, ?)
                """;

        try {

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, 1); // Siempre Cliente

            ps.setString(2, usuario.getNombre());
            ps.setString(3, usuario.getApellidos());
            ps.setString(4, usuario.getEmail());
            ps.setString(5, usuario.getPassword());
            ps.setString(6, usuario.getTelefono());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}