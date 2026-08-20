package com.turismo.mantenimientos;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.turismo.conexion.ConexionDB;
import com.turismo.interfaces.PaqueteInterface;
import com.turismo.modelo.Paquete;

public class PaqueteModel implements PaqueteInterface {

    public PaqueteModel() {
    }

    // ============================================
    // LISTAR POR CATEGORÍA (para web pública)
    // ============================================
    @Override
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
    // LISTAR TODOS (para admin)
    // ============================================
    @Override
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
                p.setNombre(rs.getString("nombre"));
                p.setDestino(rs.getString("destino"));
                p.setDescripcion(rs.getString("descripcion"));
                p.setImagenUrl(rs.getString("imagenUrl"));
                p.setPrecioSoles(rs.getBigDecimal("precio_soles"));
                p.setEstado(rs.getString("estado"));
                p.setCategoriaNombre(rs.getString("categoria_nombre"));
                lista.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    // ============================================
    // OBTENER POR ID
    // ============================================
    @Override
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
                p.setNombre(rs.getString("nombre"));
                p.setDestino(rs.getString("destino"));
                p.setDescripcion(rs.getString("descripcion"));
                p.setImagenUrl(rs.getString("imagenUrl"));
                p.setPrecioSoles(rs.getBigDecimal("precio_soles"));
                p.setEstado(rs.getString("estado"));
                p.setCategoriaNombre(rs.getString("categoria_nombre"));
                return p;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ============================================
    // CREAR PAQUETE
    // ============================================
    @Override
    public boolean crear(Paquete paquete) {
        String sql = "INSERT INTO paquetes (id_categoria, nombre, destino, descripcion, imagenUrl, precio_soles, estado) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, paquete.getIdCategoria());
            ps.setString(2, paquete.getNombre());
            ps.setString(3, paquete.getDestino());
            ps.setString(4, paquete.getDescripcion());
            ps.setString(5, paquete.getImagenUrl());
            ps.setBigDecimal(6, paquete.getPrecioSoles());
            ps.setString(7, paquete.getEstado());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ============================================
    // ACTUALIZAR PAQUETE
    // ============================================
    @Override
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
    // ELIMINAR PAQUETE
    // ============================================
    @Override
    public boolean eliminar(int id) {
        String sql = "DELETE FROM paquetes WHERE id_paquete = ?";

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
    @Override
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

    // ============================================
    // LISTAR ACTIVOS
    // ============================================
    @Override
    public List<Paquete> listarActivos() {
        List<Paquete> lista = new ArrayList<>();
        String sql = "SELECT p.*, c.nombre as categoria_nombre FROM paquetes p " +
                     "JOIN categorias_paquetes c ON p.id_categoria = c.id_categoria " +
                     "WHERE p.estado = 'activo' ORDER BY p.nombre";

        try (Connection con = ConexionDB.obtenerConexion();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

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
                p.setCategoriaNombre(rs.getString("categoria_nombre"));
                lista.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    // ============================================
    // LISTAR POR CATEGORÍA - ADMIN (activos + inactivos)
    // ============================================
    @Override
    public List<Paquete> listarPorCategoriaAdmin(String nombreCategoria) {
        List<Paquete> lista = new ArrayList<>();
        String sql = "SELECT p.*, c.nombre as categoria_nombre FROM paquetes p " +
                     "JOIN categorias_paquetes c ON p.id_categoria = c.id_categoria " +
                     "WHERE c.nombre = ? " +
                     "ORDER BY p.id_paquete DESC";

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
                p.setCategoriaNombre(rs.getString("categoria_nombre"));
                lista.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    // ============================================
    // LISTAR POR CATEGORÍA Y DESTINO - ADMIN
    // ============================================
    @Override
    public List<Paquete> listarPorCategoriaYDestinoAdmin(String nombreCategoria, String destino) {
        List<Paquete> lista = new ArrayList<>();
        String sql = "SELECT p.*, c.nombre as categoria_nombre FROM paquetes p " +
                     "JOIN categorias_paquetes c ON p.id_categoria = c.id_categoria " +
                     "WHERE c.nombre = ? AND p.destino = ? " +
                     "ORDER BY p.id_paquete DESC";

        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, nombreCategoria);
            ps.setString(2, destino);
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
                p.setCategoriaNombre(rs.getString("categoria_nombre"));
                lista.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    // ============================================
    // LISTAR DESTINOS ÚNICOS POR CATEGORÍA - ADMIN
    // ============================================
    @Override
    public List<String> listarDestinosPorCategoria(String nombreCategoria) {
        List<String> lista = new ArrayList<>();
        String sql = "SELECT DISTINCT p.destino FROM paquetes p " +
                     "JOIN categorias_paquetes c ON p.id_categoria = c.id_categoria " +
                     "WHERE c.nombre = ? " +
                     "ORDER BY p.destino";

        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, nombreCategoria);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                String dest = rs.getString("destino");
                if (dest != null && !dest.trim().isEmpty()) {
                    lista.add(dest);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }
}
