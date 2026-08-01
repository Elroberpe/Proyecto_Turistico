package com.turismo.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.turismo.conexion.ConexionDB;
import com.turismo.modelo.Paquete;

public class PaqueteDao {
	
	// ===========================
    // LISTAR
    // ===========================
    public List<Paquete> listar() {

        List<Paquete> lista = new ArrayList<>();

        String sql = "SELECT * FROM paquetes ORDER BY id_paquete DESC";

        try (
                Connection con = ConexionDB.obtenerConexion();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {

                Paquete paquete = new Paquete();

                paquete.setIdPaquete(rs.getInt("id_paquete"));
                paquete.setIdCategoria(rs.getInt("id_categoria"));
                paquete.setNombre(rs.getString("nombre"));
                paquete.setDestino(rs.getString("destino"));
                paquete.setDescripcion(rs.getString("descripcion"));
                paquete.setImagenUrl(rs.getString("imagenUrl"));
                paquete.setPrecioSoles(rs.getBigDecimal("precio_soles"));
                paquete.setEstado(rs.getString("estado"));

                lista.add(paquete);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }

	

    public List<Paquete> listarPorCategoria(String nombreCategoria) {

        List<Paquete> lista = new ArrayList<>();

        String sql =
                "SELECT p.id_paquete, p.id_categoria, p.nombre, p.destino, p.descripcion," +
                "p.imagenUrl, p.precio_soles, p.estado " +
                "FROM paquetes p " +
                "INNER JOIN categorias_paquetes c ON p.id_categoria = c.id_categoria " +
                "WHERE c.nombre = ? AND p.estado = 'activo'";

        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, nombreCategoria);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Paquete paquete = new Paquete();

                paquete.setIdPaquete(rs.getInt("id_paquete"));
                paquete.setIdCategoria(rs.getInt("id_categoria"));
                paquete.setNombre(rs.getString("nombre"));
                paquete.setDestino(rs.getString("destino"));
                paquete.setDescripcion(rs.getString("descripcion"));
                paquete.setImagenUrl(rs.getString("imagenUrl"));
                paquete.setPrecioSoles(rs.getBigDecimal("precio_soles"));
                paquete.setEstado(rs.getString("estado"));

                lista.add(paquete);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }
 // ===========================
    // BUSCAR POR ID
    // ===========================
    public Paquete buscarPorId(int id) {

        String sql = "SELECT * FROM paquetes WHERE id_paquete=?";

        try (
                Connection con = ConexionDB.obtenerConexion();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Paquete paquete = new Paquete();

                paquete.setIdPaquete(rs.getInt("id_paquete"));
                paquete.setIdCategoria(rs.getInt("id_categoria"));
                paquete.setNombre(rs.getString("nombre"));
                paquete.setDestino(rs.getString("destino"));
                paquete.setDescripcion(rs.getString("descripcion"));
                paquete.setImagenUrl(rs.getString("imagenUrl"));
                paquete.setPrecioSoles(rs.getBigDecimal("precio_soles"));
                paquete.setEstado(rs.getString("estado"));

                return paquete;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
 // ===========================
    // REGISTRAR
    // ===========================
    public boolean registrar(Paquete paquete) {

        String sql = """
                INSERT INTO paquetes
                (id_categoria,nombre,destino,descripcion,imagenUrl,precio_soles,estado)
                VALUES (?,?,?,?,?,?,?)
                """;

        try (
                Connection con = ConexionDB.obtenerConexion();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setInt(1, paquete.getIdCategoria());
            ps.setString(2, paquete.getNombre());
            ps.setString(3, paquete.getDestino());
            ps.setString(4, paquete.getDescripcion());
            ps.setString(5, paquete.getImagenUrl());
            ps.setBigDecimal(6, paquete.getPrecioSoles());
            ps.setString(7, paquete.getEstado());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
    
    // ===========================
    // ACTUALIZAR
    // ===========================
    public boolean actualizar(Paquete paquete) {

        String sql = """
                UPDATE paquetes
                SET id_categoria=?,
                    nombre=?,
                    destino=?,
                    descripcion=?,
                    imagenUrl=?,
                    precio_soles=?,
                    estado=?
                WHERE id_paquete=?
                """;

        try (
                Connection con = ConexionDB.obtenerConexion();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setInt(1, paquete.getIdCategoria());
            ps.setString(2, paquete.getNombre());
            ps.setString(3, paquete.getDestino());
            ps.setString(4, paquete.getDescripcion());
            ps.setString(5, paquete.getImagenUrl());
            ps.setBigDecimal(6, paquete.getPrecioSoles());
            ps.setString(7, paquete.getEstado());
            ps.setInt(8, paquete.getIdPaquete());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
    
 // ===========================
    // ELIMINAR
    // ===========================
    public boolean eliminar(int id) {

        String sql = "DELETE FROM paquetes WHERE id_paquete=?";

        try (
                Connection con = ConexionDB.obtenerConexion();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setInt(1, id);
            
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }




    

}