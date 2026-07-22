package com.turismo.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.turismo.conexion.ConexionDB;
import com.turismo.modelo.Paquete;

public class PaqueteDao {

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

        } catch (Exception e) {
            e.printStackTrace();
        }

        return lista;
    }

}