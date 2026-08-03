package com.turismo.dao;

import com.turismo.conexion.ConexionDB;
import com.turismo.modelo.Pago;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PagoDao {

    // ============================================
    // LISTAR TODOS LOS PAGOS
    // ============================================
    public List<Pago> listarTodos() {
        List<Pago> lista = new ArrayList<>();
        String sql = "SELECT p.id_pago, p.id_reserva, p.id_metodo, p.monto, p.estado, p.fecha_pago, " +
                     "u.nombre AS nombre_cliente, pa.nombre AS nombre_paquete, mp.nombre AS nombre_metodo " +
                     "FROM pagos p " +
                     "JOIN reservas r ON p.id_reserva = r.id_reserva " +
                     "JOIN usuario u ON r.id_usuario = u.id_usuario " +
                     "JOIN paquetes pa ON r.id_paquete = pa.id_paquete " +
                     "JOIN metodo_pago mp ON p.id_metodo = mp.id_metodo " +
                     "ORDER BY p.id_pago DESC";

        try (Connection con = ConexionDB.obtenerConexion();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                Pago p = new Pago();
                p.setIdPago(rs.getInt("id_pago"));
                p.setIdReserva(rs.getInt("id_reserva"));
                p.setIdMetodo(rs.getInt("id_metodo"));
                p.setNombreCliente(rs.getString("nombre_cliente"));
                p.setNombrePaquete(rs.getString("nombre_paquete"));
                p.setNombreMetodo(rs.getString("nombre_metodo"));
                p.setMonto(rs.getBigDecimal("monto"));
                p.setEstado(rs.getString("estado"));
                p.setFechaPago(rs.getTimestamp("fecha_pago"));
                lista.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // ============================================
    // OBTENER PAGO POR ID
    // ============================================
    public Pago obtenerPorId(int id) {
        String sql = "SELECT p.id_pago, p.id_reserva, p.id_metodo, p.monto, p.estado, p.fecha_pago, " +
                     "u.nombre AS nombre_cliente, pa.nombre AS nombre_paquete, mp.nombre AS nombre_metodo " +
                     "FROM pagos p " +
                     "JOIN reservas r ON p.id_reserva = r.id_reserva " +
                     "JOIN usuario u ON r.id_usuario = u.id_usuario " +
                     "JOIN paquetes pa ON r.id_paquete = pa.id_paquete " +
                     "JOIN metodo_pago mp ON p.id_metodo = mp.id_metodo " +
                     "WHERE p.id_pago = ?";

        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Pago p = new Pago();
                p.setIdPago(rs.getInt("id_pago"));
                p.setIdReserva(rs.getInt("id_reserva"));
                p.setIdMetodo(rs.getInt("id_metodo"));
                p.setNombreCliente(rs.getString("nombre_cliente"));
                p.setNombrePaquete(rs.getString("nombre_paquete"));
                p.setNombreMetodo(rs.getString("nombre_metodo"));
                p.setMonto(rs.getBigDecimal("monto"));
                p.setEstado(rs.getString("estado"));
                p.setFechaPago(rs.getTimestamp("fecha_pago"));
                return p;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ============================================
    // CREAR PAGO
    // ============================================
    public boolean crear(Pago pago) {
        String sql = "INSERT INTO pagos (id_reserva, id_metodo, monto, estado, fecha_pago) " +
                     "VALUES (?, ?, ?, ?, ?)";

        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, pago.getIdReserva());
            ps.setInt(2, pago.getIdMetodo());
            ps.setBigDecimal(3, pago.getMonto());
            ps.setString(4, pago.getEstado());
            ps.setTimestamp(5, pago.getFechaPago() != null ? pago.getFechaPago() : new Timestamp(System.currentTimeMillis()));

            int filas = ps.executeUpdate();
            if (filas > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    pago.setIdPago(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ============================================
    // ACTUALIZAR PAGO
    // ============================================
    public boolean actualizar(Pago pago) {
        String sql = "UPDATE pagos SET id_metodo = ?, monto = ?, estado = ? WHERE id_pago = ?";

        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, pago.getIdMetodo());
            ps.setBigDecimal(2, pago.getMonto());
            ps.setString(3, pago.getEstado());
            ps.setInt(4, pago.getIdPago());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ============================================
    // ELIMINAR PAGO
    // ============================================
    public boolean eliminar(int id) {
        String sql = "DELETE FROM pagos WHERE id_pago = ?";

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
    // OBTENER PAGO POR RESERVA
    // ============================================
    public Pago obtenerPorReserva(int idReserva) {
        String sql = "SELECT * FROM pagos WHERE id_reserva = ?";

        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idReserva);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Pago p = new Pago();
                p.setIdPago(rs.getInt("id_pago"));
                p.setIdReserva(rs.getInt("id_reserva"));
                p.setIdMetodo(rs.getInt("id_metodo"));
                p.setMonto(rs.getBigDecimal("monto"));
                p.setEstado(rs.getString("estado"));
                p.setFechaPago(rs.getTimestamp("fecha_pago"));
                return p;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}