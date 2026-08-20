package com.turismo.mantenimientos;

import com.turismo.conexion.ConexionDB;
import com.turismo.interfaces.ReservaInterface;
import com.turismo.modelo.Reserva;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class ReservaModel implements ReservaInterface {

    // ============================================
    // ACTUALIZAR AUTOMÁTICAMENTE RESERVAS A COMPLETADAS
    // ============================================
    @Override
    public void actualizarReservasCompletadas() {
        String sql = "UPDATE reservas SET estado = 'completada' " +
                     "WHERE estado = 'pagada' AND ( " +
                     "  (fecha_retorno IS NOT NULL AND fecha_retorno < CURDATE()) OR " +
                     "  (fecha_retorno IS NULL AND fecha_salida < CURDATE()) " +
                     ")";
        try (Connection con = ConexionDB.obtenerConexion();
             Statement st = con.createStatement()) {
            st.executeUpdate(sql);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ============================================
    // LISTAR TODAS LAS RESERVAS
    // ============================================
    @Override
    public List<Reserva> listarTodos() {
        actualizarReservasCompletadas();
        List<Reserva> lista = new ArrayList<>();
        String sql = "SELECT r.*, " +
                     "u.nombre as usuario_nombre, u.apellidos as usuario_apellidos, u.email as usuario_email, " +
                     "p.nombre as paquete_nombre, p.destino as paquete_destino " +
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
                r.setIdPaquete(rs.getInt("id_paquete"));
                r.setFechaReserva(rs.getTimestamp("fecha_reserva"));
                r.setNumeroPasajeros(rs.getInt("numero_pasajeros"));
                r.setPrecioTotal(rs.getBigDecimal("precio_total"));
                r.setEstado(rs.getString("estado"));
                r.setTipoViaje(rs.getString("tipo_viaje"));
                r.setFechaSalida(rs.getDate("fecha_salida"));
                r.setFechaRetorno(rs.getDate("fecha_retorno"));
                r.setUsuarioNombre(rs.getString("usuario_nombre") + " " + rs.getString("usuario_apellidos"));
                r.setPaqueteNombre(rs.getString("paquete_nombre") + " (" + rs.getString("paquete_destino") + ")");
                lista.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // ============================================
    // OBTENER RESERVA POR ID
    // ============================================
    @Override
    public Reserva obtenerPorId(int id) {
        actualizarReservasCompletadas();
        String sql = "SELECT r.*, " +
                     "u.nombre as usuario_nombre, u.apellidos as usuario_apellidos, u.email as usuario_email, " +
                     "p.nombre as paquete_nombre, p.destino as paquete_destino, p.precio_soles as paquete_precio, " +
                     "p.id_categoria as paquete_id_categoria " +
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
                r.setIdPaquete(rs.getInt("id_paquete"));
                r.setFechaReserva(rs.getTimestamp("fecha_reserva"));
                r.setNumeroPasajeros(rs.getInt("numero_pasajeros"));
                r.setPrecioTotal(rs.getBigDecimal("precio_total"));
                r.setEstado(rs.getString("estado"));
                r.setTipoViaje(rs.getString("tipo_viaje"));
                r.setFechaSalida(rs.getDate("fecha_salida"));
                r.setFechaRetorno(rs.getDate("fecha_retorno"));
                r.setUsuarioNombre(rs.getString("usuario_nombre") + " " + rs.getString("usuario_apellidos"));
                r.setPaqueteNombre(rs.getString("paquete_nombre"));
                r.setPaquetePrecio(rs.getBigDecimal("paquete_precio"));
                r.setIdCategoria(rs.getInt("paquete_id_categoria"));
                return r;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ============================================
    // CREAR RESERVA
    // ============================================
    @Override
    public boolean crear(Reserva reserva) {
        String sql = "INSERT INTO reservas (id_usuario, id_paquete, numero_pasajeros, precio_total, estado, tipo_viaje, fecha_salida, fecha_retorno) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, reserva.getIdUsuario());
            ps.setInt(2, reserva.getIdPaquete());
            ps.setInt(3, reserva.getNumeroPasajeros());
            ps.setBigDecimal(4, reserva.getPrecioTotal());
            ps.setString(5, reserva.getEstado());
            ps.setString(6, reserva.getTipoViaje());
            ps.setDate(7, reserva.getFechaSalida());
            ps.setDate(8, reserva.getFechaRetorno());

            int affected = ps.executeUpdate();
            if (affected > 0) {
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

    // ============================================
    // ACTUALIZAR RESERVA
    // ============================================
    @Override
    public boolean actualizar(Reserva reserva) {
        String sql = "UPDATE reservas SET id_usuario = ?, id_paquete = ?, numero_pasajeros = ?, " +
                     "precio_total = ?, estado = ?, tipo_viaje = ?, fecha_salida = ?, fecha_retorno = ? " +
                     "WHERE id_reserva = ?";

        try (Connection con = ConexionDB.obtenerConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, reserva.getIdUsuario());
            ps.setInt(2, reserva.getIdPaquete());
            ps.setInt(3, reserva.getNumeroPasajeros());
            ps.setBigDecimal(4, reserva.getPrecioTotal());
            ps.setString(5, reserva.getEstado());
            ps.setString(6, reserva.getTipoViaje());
            ps.setDate(7, reserva.getFechaSalida());
            ps.setDate(8, reserva.getFechaRetorno());
            ps.setInt(9, reserva.getIdReserva());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ============================================
    // ELIMINAR RESERVA
    // ============================================
    @Override
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
    @Override
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
    // LISTAR RESERVAS PENDIENTES
    // ============================================
    @Override
    public List<Reserva> listarPendientes() {
        actualizarReservasCompletadas();
        List<Reserva> lista = new ArrayList<>();
        String sql = "SELECT r.*, " +
                     "u.nombre as usuario_nombre, u.apellidos as usuario_apellidos, " +
                     "p.nombre as paquete_nombre " +
                     "FROM reservas r " +
                     "JOIN usuario u ON r.id_usuario = u.id_usuario " +
                     "JOIN paquetes p ON r.id_paquete = p.id_paquete " +
                     "WHERE r.estado = 'pendiente' " +
                     "ORDER BY r.fecha_reserva DESC";

        try (Connection con = ConexionDB.obtenerConexion();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                Reserva r = new Reserva();
                r.setIdReserva(rs.getInt("id_reserva"));
                r.setIdUsuario(rs.getInt("id_usuario"));
                r.setIdPaquete(rs.getInt("id_paquete"));
                r.setFechaReserva(rs.getTimestamp("fecha_reserva"));
                r.setNumeroPasajeros(rs.getInt("numero_pasajeros"));
                r.setPrecioTotal(rs.getBigDecimal("precio_total"));
                r.setEstado(rs.getString("estado"));
                r.setUsuarioNombre(rs.getString("usuario_nombre") + " " + rs.getString("usuario_apellidos"));
                r.setPaqueteNombre(rs.getString("paquete_nombre"));
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
    @Override
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
    @Override
    public BigDecimal sumarIngresosDelMes() {
        actualizarReservasCompletadas();
        String sql = "SELECT SUM(precio_total) FROM reservas WHERE MONTH(fecha_reserva) = MONTH(CURRENT_DATE()) AND YEAR(fecha_reserva) = YEAR(CURRENT_DATE()) AND (estado = 'pagada' OR estado = 'completada')";
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
    @Override
    public List<Reserva> listarPorUsuario(int idUsuario) {
        actualizarReservasCompletadas();
        List<Reserva> lista = new ArrayList<>();
        String sql = "SELECT r.*, p.nombre as paquete_nombre, p.destino as paquete_destino, p.imagenUrl as paquete_imagen " +
                     "FROM reservas r " +
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
                r.setIdPaquete(rs.getInt("id_paquete"));
                r.setFechaReserva(rs.getTimestamp("fecha_reserva"));
                r.setNumeroPasajeros(rs.getInt("numero_pasajeros"));
                r.setPrecioTotal(rs.getBigDecimal("precio_total"));
                r.setEstado(rs.getString("estado"));
                r.setTipoViaje(rs.getString("tipo_viaje"));
                r.setFechaSalida(rs.getDate("fecha_salida"));
                r.setFechaRetorno(rs.getDate("fecha_retorno"));
                r.setPaqueteNombre(rs.getString("paquete_nombre"));
                r.setPaqueteDestino(rs.getString("paquete_destino"));
                r.setPaqueteImagen(rs.getString("paquete_imagen"));
                lista.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
}
