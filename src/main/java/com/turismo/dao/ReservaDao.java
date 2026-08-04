package com.turismo.dao;

import com.turismo.conexion.ConexionDB;
import com.turismo.modelo.Reserva;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class ReservaDao {

    public List<Reserva> listarTodos() {
        List<Reserva> lista = new ArrayList<>();
        String sql = "SELECT r.*, u.nombre as nombre_usuario, p.nombre as nombre_paquete " +
                     "FROM reservas r " +
                     "JOIN usuario u ON r.id_usuario = u.id_usuario " +
                     "JOIN paquetes p ON r.id_paquete = p.id_paquete " +
                     "ORDER BY r.id_reserva DESC";

        try (Connection con = ConexionDB.obtenerConexion();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                Reserva r = new Reserva();
                r.setIdReserva(rs.getInt("id_reserva"));
                r.setIdUsuario(rs.getInt("id_usuario"));
                r.setNombreUsuario(rs.getString("nombre_usuario"));
                r.setIdPaquete(rs.getInt("id_paquete"));
                r.setNombrePaquete(rs.getString("nombre_paquete"));
                r.setTipoViaje(rs.getString("tipo_viaje"));
                r.setFechaSalida(rs.getDate("fecha_salida"));
                r.setFechaRetorno(rs.getDate("fecha_retorno"));
                r.setNumPasajeros(rs.getInt("num_pasajeros"));
                r.setPrecioTotal(rs.getBigDecimal("precio_total"));
                r.setEstado(rs.getString("estado"));
                lista.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public Reserva obtenerPorId(int id) {
        String sql = "SELECT r.*, u.nombre as nombre_usuario, p.nombre as nombre_paquete " +
                     "FROM reservas r " +
                     "JOIN usuario u ON r.id_usuario = u.id_usuario " +
                     "JOIN paquetes p ON r.id_paquete = p.id_paquete " +
                     "WHERE r.id_reserva = ?";

        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Reserva r = new Reserva();
                r.setIdReserva(rs.getInt("id_reserva"));
                r.setIdUsuario(rs.getInt("id_usuario"));
                r.setNombreUsuario(rs.getString("nombre_usuario"));
                r.setIdPaquete(rs.getInt("id_paquete"));
                r.setNombrePaquete(rs.getString("nombre_paquete"));
                r.setTipoViaje(rs.getString("tipo_viaje"));
                r.setFechaSalida(rs.getDate("fecha_salida"));
                r.setFechaRetorno(rs.getDate("fecha_retorno"));
                r.setNumPasajeros(rs.getInt("num_pasajeros"));
                r.setPrecioTotal(rs.getBigDecimal("precio_total"));
                r.setEstado(rs.getString("estado"));
                return r;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean crear(Reserva reserva) {
        String sql = "INSERT INTO reservas (id_usuario, id_paquete, tipo_viaje, fecha_salida, fecha_retorno, num_pasajeros, precio_total, estado) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, reserva.getIdUsuario());
            ps.setInt(2, reserva.getIdPaquete());
            ps.setString(3, reserva.getTipoViaje());
            ps.setDate(4, reserva.getFechaSalida());
            ps.setDate(5, reserva.getFechaRetorno());
            ps.setInt(6, reserva.getNumPasajeros());
            ps.setBigDecimal(7, reserva.getPrecioTotal());
            ps.setString(8, reserva.getEstado());

            int filas = ps.executeUpdate();
            if (filas > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    reserva.setIdReserva(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean actualizar(Reserva reserva) {
        String sql = "UPDATE reservas SET id_usuario = ?, id_paquete = ?, tipo_viaje = ?, fecha_salida = ?, fecha_retorno = ?, num_pasajeros = ?, precio_total = ?, estado = ? WHERE id_reserva = ?";

        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, reserva.getIdUsuario());
            ps.setInt(2, reserva.getIdPaquete());
            ps.setString(3, reserva.getTipoViaje());
            ps.setDate(4, reserva.getFechaSalida());
            ps.setDate(5, reserva.getFechaRetorno());
            ps.setInt(6, reserva.getNumPasajeros());
            ps.setBigDecimal(7, reserva.getPrecioTotal());
            ps.setString(8, reserva.getEstado());
            ps.setInt(9, reserva.getIdReserva());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM reservas WHERE id_reserva = ?";

        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
	 // ============================================
	 // ACTUALIZAR ESTADO DE RESERVA
	 // ============================================
	 public boolean actualizarEstado(int idReserva, String estado) {
	     String sql = "UPDATE reservas SET estado = ? WHERE id_reserva = ?";
	
	     try (Connection con = ConexionDB.obtenerConexion();
	          PreparedStatement ps = con.prepareStatement(sql)) {
	
	         ps.setString(1, estado);
	         ps.setInt(2, idReserva);
	
	         return ps.executeUpdate() > 0;
	     } catch (SQLException e) {
	         e.printStackTrace();
	         return false;
	     }
	 }
	 
	// ============================================
	// LISTAR SOLO RESERVAS PENDIENTES
	// ============================================
	public List<Reserva> listarPendientes() {
	    List<Reserva> lista = new ArrayList<>();
	    String sql = "SELECT r.*, u.nombre as nombre_usuario, p.nombre as nombre_paquete " +
	                 "FROM reservas r " +
	                 "JOIN usuario u ON r.id_usuario = u.id_usuario " +
	                 "JOIN paquetes p ON r.id_paquete = p.id_paquete " +
	                 "WHERE r.estado = 'pendiente' " +
	                 "ORDER BY r.id_reserva DESC";

	    try (Connection con = ConexionDB.obtenerConexion();
	         Statement st = con.createStatement();
	         ResultSet rs = st.executeQuery(sql)) {

	        while (rs.next()) {
	            Reserva r = new Reserva();
	            r.setIdReserva(rs.getInt("id_reserva"));
	            r.setIdUsuario(rs.getInt("id_usuario"));
	            r.setNombreUsuario(rs.getString("nombre_usuario"));
	            r.setIdPaquete(rs.getInt("id_paquete"));
	            r.setNombrePaquete(rs.getString("nombre_paquete"));
	            r.setTipoViaje(rs.getString("tipo_viaje"));
	            r.setFechaSalida(rs.getDate("fecha_salida"));
	            r.setFechaRetorno(rs.getDate("fecha_retorno"));
	            r.setNumPasajeros(rs.getInt("num_pasajeros"));
	            r.setPrecioTotal(rs.getBigDecimal("precio_total"));
	            r.setEstado(rs.getString("estado"));
	            lista.add(r);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return lista;
	}
	
	// ============================================
	// CONTAR RESERVAS DEL MES ACTUAL
	// ============================================
	public int contarReservasDelMes() {
	    String sql = "SELECT COUNT(*) FROM reservas WHERE MONTH(fecha_reserva) = MONTH(CURRENT_DATE()) AND YEAR(fecha_reserva) = YEAR(CURRENT_DATE())";
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
	// SUMAR INGRESOS DEL MES ACTUAL
	// ============================================
	public BigDecimal sumarIngresosDelMes() {
	    String sql = "SELECT SUM(precio_total) FROM reservas WHERE MONTH(fecha_reserva) = MONTH(CURRENT_DATE()) AND YEAR(fecha_reserva) = YEAR(CURRENT_DATE()) AND estado = 'pagada'";
	    try (Connection con = ConexionDB.obtenerConexion();
	         Statement st = con.createStatement();
	         ResultSet rs = st.executeQuery(sql)) {
	        if (rs.next()) {
	            return rs.getBigDecimal(1) != null ? rs.getBigDecimal(1) : BigDecimal.ZERO;
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return BigDecimal.ZERO;
	}
	
	// ============================================
	// LISTAR RESERVAS POR USUARIO
	// ============================================
	public List<Reserva> listarPorUsuario(int idUsuario) {
	    List<Reserva> lista = new ArrayList<>();
	    String sql = "SELECT r.*, u.nombre as nombre_usuario, p.nombre as nombre_paquete " +
	                 "FROM reservas r " +
	                 "JOIN usuario u ON r.id_usuario = u.id_usuario " +
	                 "JOIN paquetes p ON r.id_paquete = p.id_paquete " +
	                 "WHERE r.id_usuario = ? " +
	                 "ORDER BY r.id_reserva DESC";

	    try (Connection con = ConexionDB.obtenerConexion();
	         PreparedStatement ps = con.prepareStatement(sql)) {

	        ps.setInt(1, idUsuario);
	        ResultSet rs = ps.executeQuery();

	        while (rs.next()) {
	            Reserva r = new Reserva();
	            r.setIdReserva(rs.getInt("id_reserva"));
	            r.setIdUsuario(rs.getInt("id_usuario"));
	            r.setNombreUsuario(rs.getString("nombre_usuario"));
	            r.setIdPaquete(rs.getInt("id_paquete"));
	            r.setNombrePaquete(rs.getString("nombre_paquete"));
	            r.setTipoViaje(rs.getString("tipo_viaje"));
	            r.setFechaSalida(rs.getDate("fecha_salida"));
	            r.setFechaRetorno(rs.getDate("fecha_retorno"));
	            r.setNumPasajeros(rs.getInt("num_pasajeros"));
	            r.setPrecioTotal(rs.getBigDecimal("precio_total"));
	            r.setEstado(rs.getString("estado"));
	            lista.add(r);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return lista;
	}
}