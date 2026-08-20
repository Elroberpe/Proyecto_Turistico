package com.turismo.dao;

import com.turismo.interfaces.CategoriaPaqueteInterface;
import com.turismo.interfaces.PagoInterface;
import com.turismo.interfaces.PaqueteInterface;
import com.turismo.interfaces.ReservaInterface;
import com.turismo.interfaces.UsuarioInterface;

public abstract class DAOFactory {

    public static final int MYSQL = 1;
    public static final int SQLSERVER = 2;

    public abstract UsuarioInterface getUsuario();
    public abstract PaqueteInterface getPaquete();
    public abstract ReservaInterface getReserva();
    public abstract PagoInterface getPago();
    public abstract CategoriaPaqueteInterface getCategoriaPaquete();

    public static DAOFactory getDaoFactory(int tipo) {
        if (tipo == MYSQL) {
            return new MySqlDAOFactory();
        }
        return null;
    }
}
