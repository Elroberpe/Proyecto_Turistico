package com.turismo.mantenimientos;

import com.turismo.conexion.ConexionDB;
import com.turismo.interfaces.PagoInterface;
import com.turismo.modelo.Pago;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PagoModel implements PagoInterface {

    // ============================================
    // LISTAR TODOS LOS PAGOS
    // ============================================
    @Override
    public List<Pago> listarTodos() {
        List<Pago> lista = new ArrayList<>();
        String sql = "SELECT p.id_pago, p.id_reserva, p.id_metodo, p.monto, p.estado, p.fecha_pago, " +
                     "r.fecha_salida, r.fecha_retorno, r.estado AS estado_reserva, " +
                     "u.nombre, u.apellidos, pq.nombre AS paquete_nombre, mp.nombre AS metodo_nombre " +
                     "FROM pagos p " +
                     "JOIN reservas r ON p.id_reserva = r.id_reserva " +
                     "JOIN usuario u ON r.id_usuario = u.id_usuario " +
                     "JOIN paquetes pq ON r.id_paquete = pq.id_paquete " +
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
                p.setMonto(rs.getBigDecimal("monto"));
                p.setEstado(rs.getString("estado"));
                p.setFechaPago(rs.getTimestamp("fecha_pago"));
                p.setNombreCliente(rs.getString("nombre") + " " + rs.getString("apellidos"));
                p.setNombrePaquete(rs.getString("paquete_nombre"));
                p.setNombreMetodo(rs.getString("metodo_nombre"));
                p.setFechaSalida(rs.getDate("fecha_salida"));
                p.setFechaRetorno(rs.getDate("fecha_retorno"));
                p.setEstadoReserva(rs.getString("estado_reserva"));
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
    @Override
    public Pago obtenerPorId(int id) {
        String sql = "SELECT p.id_pago, p.id_reserva, p.id_metodo, p.monto, p.estado, p.fecha_pago, " +
                     "r.fecha_salida, r.fecha_retorno, r.estado AS estado_reserva, " +
                     "u.nombre, u.apellidos, pq.nombre AS paquete_nombre, mp.nombre AS metodo_nombre " +
                     "FROM pagos p " +
                     "JOIN reservas r ON p.id_reserva = r.id_reserva " +
                     "JOIN usuario u ON r.id_usuario = u.id_usuario " +
                     "JOIN paquetes pq ON r.id_paquete = pq.id_paquete " +
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
                p.setMonto(rs.getBigDecimal("monto"));
                p.setEstado(rs.getString("estado"));
                p.setFechaPago(rs.getTimestamp("fecha_pago"));
                p.setNombreCliente(rs.getString("nombre") + " " + rs.getString("apellidos"));
                p.setNombrePaquete(rs.getString("paquete_nombre"));
                p.setNombreMetodo(rs.getString("metodo_nombre"));
                p.setFechaSalida(rs.getDate("fecha_salida"));
                p.setFechaRetorno(rs.getDate("fecha_retorno"));
                p.setEstadoReserva(rs.getString("estado_reserva"));
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
    @Override
    public boolean crear(Pago pago) {
        String sql = "INSERT INTO pagos (id_reserva, id_metodo, monto, estado, fecha_pago) VALUES (?, ?, ?, ?, ?)";

        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, pago.getIdReserva());
            ps.setInt(2, pago.getIdMetodo());
            ps.setBigDecimal(3, pago.getMonto());
            ps.setString(4, pago.getEstado());
            ps.setTimestamp(5, pago.getFechaPago() != null ? pago.getFechaPago() : new Timestamp(System.currentTimeMillis()));

            int affected = ps.executeUpdate();
            if (affected > 0) {
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
    @Override
    public boolean actualizar(Pago pago) {
        String sql = "UPDATE pagos SET id_reserva = ?, id_metodo = ?, monto = ?, estado = ?, fecha_pago = ? WHERE id_pago = ?";

        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, pago.getIdReserva());
            ps.setInt(2, pago.getIdMetodo());
            ps.setBigDecimal(3, pago.getMonto());
            ps.setString(4, pago.getEstado());
            ps.setTimestamp(5, pago.getFechaPago());
            ps.setInt(6, pago.getIdPago());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ============================================
    // ELIMINAR PAGO
    // ============================================
    @Override
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
    @Override
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

    // ============================================
    // SUMAR INGRESOS REALES DEL MES ACTUAL
    // ============================================
    @Override
    public BigDecimal sumarIngresosDelMes() {
        String sql = "SELECT SUM(monto) FROM pagos " +
                     "WHERE MONTH(fecha_pago) = MONTH(CURRENT_DATE()) " +
                     "  AND YEAR(fecha_pago) = YEAR(CURRENT_DATE()) " +
                     "  AND estado = 'pagado'";

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
}
