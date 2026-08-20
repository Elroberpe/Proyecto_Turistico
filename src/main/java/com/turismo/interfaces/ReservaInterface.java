package com.turismo.interfaces;

import java.math.BigDecimal;
import java.util.List;
import com.turismo.modelo.Reserva;

public interface ReservaInterface {
    List<Reserva> listarTodos();
    Reserva obtenerPorId(int id);
    boolean crear(Reserva reserva);
    boolean actualizar(Reserva reserva);
    boolean eliminar(int id);
    boolean actualizarEstado(int idReserva, String estado);
    List<Reserva> listarPendientes();
    int contarReservasDelMes();
    BigDecimal sumarIngresosDelMes();
    List<Reserva> listarPorUsuario(int idUsuario);
    int contarPorPaquete(int idPaquete);
    void actualizarReservasCompletadas();
}
