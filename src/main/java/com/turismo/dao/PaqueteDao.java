package com.turismo.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.turismo.conexion.ConexionDB;
import com.turismo.modelo.Paquete;

public class PaqueteDao {

    public PaqueteDao() {
        // Constructor vacío
    }

    // ============================================
    // LISTAR POR CATEGORÍA (para web pública)
    // ============================================
    public List<Paquete> listarPorCategoria(String nombreCategoria) {
        List<Paquete> lista = new ArrayList<>();
        String sql = "SELECT p.* FROM paquetes p " +
                     "JOIN categorias_paquetes c ON p.id_categoria = c.id_categoria " +
                     "WHERE c.nombre = ? AND p.estado = 'activo'";

        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, nombreCategoria);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Paquete p = new Paquete();
                p.setIdPaquete(rs.getInt("id_paquete"));
                p.setIdCategoria(rs.getInt("id_categoria"));
                p.setNombre(rs.getString("nombre"));
                p.setDestino(rs.getString("destino"));
                p.setDescripcion(rs.getString("descripcion"));
                p.setImagenUrl(rs.getString("imagenUrl"));
                p.setPrecioSoles(rs.getBigDecimal("precio_soles"));
                p.setEstado(rs.getString("estado"));
                lista.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    // ============================================
    // ✅ NUEVO: LISTAR TODOS (para admin)
    // ============================================
    public List<Paquete> listarTodos() {
        List<Paquete> lista = new ArrayList<>();
        String sql = "SELECT p.*, c.nombre as categoria_nombre FROM paquetes p " +
                     "JOIN categorias_paquetes c ON p.id_categoria = c.id_categoria " +
                     "ORDER BY p.id_paquete DESC";

        try (Connection con = ConexionDB.obtenerConexion();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                Paquete p = new Paquete();
                p.setIdPaquete(rs.getInt("id_paquete"));
                p.setIdCategoria(rs.getInt("id_categoria"));
                p.setCategoriaNombre(rs.getString("categoria_nombre"));
                p.setNombre(rs.getString("nombre"));
                p.setDestino(rs.getString("destino"));
                p.setDescripcion(rs.getString("descripcion"));
                p.setImagenUrl(rs.getString("imagenUrl"));
                p.setPrecioSoles(rs.getBigDecimal("precio_soles"));
                p.setEstado(rs.getString("estado"));
                lista.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    // ============================================
    // ✅ NUEVO: OBTENER POR ID
    // ============================================
    public Paquete obtenerPorId(int id) {
        String sql = "SELECT p.*, c.nombre as categoria_nombre FROM paquetes p " +
                     "JOIN categorias_paquetes c ON p.id_categoria = c.id_categoria " +
                     "WHERE p.id_paquete = ?";

        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Paquete p = new Paquete();
                p.setIdPaquete(rs.getInt("id_paquete"));
                p.setIdCategoria(rs.getInt("id_categoria"));
                p.setCategoriaNombre(rs.getString("categoria_nombre"));
                p.setNombre(rs.getString("nombre"));
                p.setDestino(rs.getString("destino"));
                p.setDescripcion(rs.getString("descripcion"));
                p.setImagenUrl(rs.getString("imagenUrl"));
                p.setPrecioSoles(rs.getBigDecimal("precio_soles"));
                p.setEstado(rs.getString("estado"));
                return p;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ============================================
    // ✅ NUEVO: CREAR PAQUETE
    // ============================================
    public boolean crear(Paquete paquete) {
        String sql = "INSERT INTO paquetes (id_categoria, nombre, destino, descripcion, imagenUrl, precio_soles, estado) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, paquete.getIdCategoria());
            ps.setString(2, paquete.getNombre());
            ps.setString(3, paquete.getDestino());
            ps.setString(4, paquete.getDescripcion());
            ps.setString(5, paquete.getImagenUrl());
            ps.setBigDecimal(6, paquete.getPrecioSoles());
            ps.setString(7, paquete.getEstado());

            int filas = ps.executeUpdate();
            if (filas > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    paquete.setIdPaquete(rs.getInt(1));
                }
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ============================================
    // ✅ NUEVO: ACTUALIZAR PAQUETE
    // ============================================
    public boolean actualizar(Paquete paquete) {
        String sql = "UPDATE paquetes SET id_categoria = ?, nombre = ?, destino = ?, " +
                     "descripcion = ?, imagenUrl = ?, precio_soles = ?, estado = ? " +
                     "WHERE id_paquete = ?";

        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, paquete.getIdCategoria());
            ps.setString(2, paquete.getNombre());
            ps.setString(3, paquete.getDestino());
            ps.setString(4, paquete.getDescripcion());
            ps.setString(5, paquete.getImagenUrl());
            ps.setBigDecimal(6, paquete.getPrecioSoles());
            ps.setString(7, paquete.getEstado());
            ps.setInt(8, paquete.getIdPaquete());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ============================================
    // ✅ NUEVO: ELIMINAR (cambia estado a inactivo)
    // ============================================
    public boolean eliminar(int id) {
        String sql = "UPDATE paquetes SET estado = 'inactivo' WHERE id_paquete = ?";

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
	// CONTAR PAQUETES ACTIVOS
	// ============================================
    public int contarActivos() {
        String sql = "SELECT COUNT(*) FROM paquetes WHERE estado = 'activo'";
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
 
}