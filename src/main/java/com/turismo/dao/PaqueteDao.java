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

    public List<Paquete> listarPorCategoria(String nombreCategoria) {
        List<Paquete> lista = new ArrayList<>();

        String sql = "SELECT p.id_paquete, p.id_categoria, p.nombre, p.destino, p.descripcion, "
                   + "p.precio_dia, p.precio_transporte_ida, p.precio_transporte_ida_vuelta, "
                   + "p.dias_minimos, p.dias_maximos, p.cupo_disponible, p.activo "
                   + "FROM paquetes p "
                   + "INNER JOIN categorias_paquete c ON p.id_categoria = c.id_categoria "
                   + "WHERE c.nombre = ? AND p.activo = 1";

        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, nombreCategoria);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Paquete p = new Paquete();
                    p.setIdPaquete(rs.getInt("id_paquete"));
                    p.setIdCategoria(rs.getInt("id_categoria"));
                    p.setNombre(rs.getString("nombre"));
                    p.setDestino(rs.getString("destino"));
                    p.setDescripcion(rs.getString("descripcion"));
                    p.setPrecioDia(rs.getDouble("precio_dia"));
                    p.setPrecioTransporteIda(rs.getDouble("precio_transporte_ida"));
                    p.setPrecioTransporteIdaVuelta(rs.getDouble("precio_transporte_ida_vuelta"));
                    p.setDiasMinimos(rs.getInt("dias_minimos"));
                    p.setDiasMaximos(rs.getInt("dias_maximos"));
                    p.setCupoDisponible(rs.getInt("cupo_disponible"));
                    p.setActivo(rs.getBoolean("activo"));
                    lista.add(p);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }
}