package com.turismo.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.turismo.conexion.ConexionDB;
import com.turismo.modelo.Usuario;

public class UsuarioDao {

    public UsuarioDao() {
        // Constructor vacío
    }

    // ============================================
    // LOGIN
    // ============================================
    public Usuario login(String email, String password) {
        Usuario usuario = null;
        String sql = "SELECT * FROM usuario WHERE email = ? AND password = ?";

        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

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

        } catch (Exception e) {
            e.printStackTrace();
        }
        return usuario;
    }

    // ============================================
    // REGISTRAR (CREAR)
    // ============================================
    public boolean registrar(Usuario usuario) {
        String sql = "INSERT INTO usuario (id_rol, nombre, apellidos, email, password, telefono) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, usuario.getIdRol());
            ps.setString(2, usuario.getNombre());
            ps.setString(3, usuario.getApellidos());
            ps.setString(4, usuario.getEmail());
            ps.setString(5, usuario.getPassword());
            ps.setString(6, usuario.getTelefono());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ============================================
    // LISTAR TODOS LOS USUARIOS
    // ============================================
    public List<Usuario> listar() {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM usuario ORDER BY id_usuario";

        try (Connection con = ConexionDB.obtenerConexion();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                Usuario u = new Usuario();
                u.setIdUsuario(rs.getInt("id_usuario"));
                u.setIdRol(rs.getInt("id_rol"));
                u.setNombre(rs.getString("nombre"));
                u.setApellidos(rs.getString("apellidos"));
                u.setEmail(rs.getString("email"));
                u.setTelefono(rs.getString("telefono"));
                lista.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    // ============================================
    // OBTENER USUARIO POR ID
    // ============================================
    public Usuario obtenerPorId(int id) {
        String sql = "SELECT * FROM usuario WHERE id_usuario = ?";

        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Usuario u = new Usuario();
                u.setIdUsuario(rs.getInt("id_usuario"));
                u.setIdRol(rs.getInt("id_rol"));
                u.setNombre(rs.getString("nombre"));
                u.setApellidos(rs.getString("apellidos"));
                u.setEmail(rs.getString("email"));
                u.setTelefono(rs.getString("telefono"));
                return u;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ============================================
    // ACTUALIZAR USUARIO
    // ============================================
    public boolean actualizar(Usuario usuario) {
        String sql = "UPDATE usuario SET nombre = ?, apellidos = ?, email = ?, telefono = ? WHERE id_usuario = ?";

        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, usuario.getNombre());
            ps.setString(2, usuario.getApellidos());
            ps.setString(3, usuario.getEmail());
            ps.setString(4, usuario.getTelefono());
            ps.setInt(5, usuario.getIdUsuario());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ============================================
    // ACTUALIZAR USUARIO CON CONTRASEÑA
    // ============================================
    public boolean actualizarConPassword(Usuario usuario) {
        String sql = "UPDATE usuario SET nombre = ?, apellidos = ?, email = ?, telefono = ?, password = ? WHERE id_usuario = ?";

        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, usuario.getNombre());
            ps.setString(2, usuario.getApellidos());
            ps.setString(3, usuario.getEmail());
            ps.setString(4, usuario.getTelefono());
            ps.setString(5, usuario.getPassword());
            ps.setInt(6, usuario.getIdUsuario());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ============================================
    // ELIMINAR USUARIO
    // ============================================
    public boolean eliminar(int id) {
        String sql = "DELETE FROM usuario WHERE id_usuario = ?";

        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
	// ============================================
	// CONTAR CLIENTES (id_rol = 1)
	// ============================================
    public int contarClientes() {
        String sql = "SELECT COUNT(*) FROM usuario WHERE id_rol = 1";
        try (Connection con = ConexionDB.obtenerConexion();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
   
    
	// ============================================
	// LISTAR SOLO CLIENTES (id_rol = 1)
	// ============================================
	public List<Usuario> listarClientes() {
	    List<Usuario> lista = new ArrayList<>();
	    String sql = "SELECT * FROM usuario WHERE id_rol = 1 ORDER BY nombre";
	
	    try (Connection con = ConexionDB.obtenerConexion();
	         Statement st = con.createStatement();
	         ResultSet rs = st.executeQuery(sql)) {
	
	        while (rs.next()) {
	            Usuario u = new Usuario();
	            u.setIdUsuario(rs.getInt("id_usuario"));
	            u.setIdRol(rs.getInt("id_rol"));
	            u.setNombre(rs.getString("nombre"));
	            u.setApellidos(rs.getString("apellidos"));
	            u.setEmail(rs.getString("email"));
	            u.setTelefono(rs.getString("telefono"));
	            lista.add(u);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return lista;
	}
}