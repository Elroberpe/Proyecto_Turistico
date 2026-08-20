package com.turismo.interfaces;

import java.math.BigDecimal;
import java.util.List;
import com.turismo.modelo.Pago;

public interface PagoInterface {
    List<Pago> listarTodos();
    Pago obtenerPorId(int id);
    boolean crear(Pago pago);
    boolean actualizar(Pago pago);
    boolean eliminar(int id);
    Pago obtenerPorReserva(int idReserva);
    BigDecimal sumarIngresosDelMes();
}
