package com.turismo.dao;

import com.turismo.conexion.ConexionDB;
import com.turismo.interfaces.CategoriaPaqueteInterface;
import com.turismo.modelo.CategoriaPaquete;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoriaPaqueteDao implements CategoriaPaqueteInterface {

    public List<CategoriaPaquete> listar() {
        List<CategoriaPaquete> lista = new ArrayList<>();
        String sql = "SELECT * FROM categorias_paquetes ORDER BY nombre";

        try (Connection con = ConexionDB.obtenerConexion();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                CategoriaPaquete c = new CategoriaPaquete();
                c.setIdCategoria(rs.getInt("id_categoria"));
                c.setNombre(rs.getString("nombre"));
                c.setDescripcion(rs.getString("descripcion"));
                lista.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public CategoriaPaquete obtenerPorId(int id) {
        String sql = "SELECT * FROM categorias_paquetes WHERE id_categoria = ?";

        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                CategoriaPaquete c = new CategoriaPaquete();
                c.setIdCategoria(rs.getInt("id_categoria"));
                c.setNombre(rs.getString("nombre"));
                c.setDescripcion(rs.getString("descripcion"));
                return c;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean crear(CategoriaPaquete categoria) {
        String sql = "INSERT INTO categorias_paquetes (nombre, descripcion) VALUES (?, ?)";

        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, categoria.getNombre());
            ps.setString(2, categoria.getDescripcion());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean editar(CategoriaPaquete categoria) {
        String sql = "UPDATE categorias_paquetes SET nombre = ?, descripcion = ? WHERE id_categoria = ?";

        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, categoria.getNombre());
            ps.setString(2, categoria.getDescripcion());
            ps.setInt(3, categoria.getIdCategoria());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM categorias_paquetes WHERE id_categoria = ?";

        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Contar paquetes por categoría
    public int contarPaquetesPorCategoria(int idCategoria) {
        String sql = "SELECT COUNT(*) FROM paquetes WHERE id_categoria = ?";
        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idCategoria);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}