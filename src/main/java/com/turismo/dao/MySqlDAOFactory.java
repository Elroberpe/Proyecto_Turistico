package com.turismo.dao;

import com.turismo.interfaces.CategoriaPaqueteInterface;
import com.turismo.interfaces.PagoInterface;
import com.turismo.interfaces.PaqueteInterface;
import com.turismo.interfaces.ReservaInterface;
import com.turismo.interfaces.UsuarioInterface;

public class MySqlDAOFactory extends DAOFactory {

    @Override
    public UsuarioInterface getUsuario() {
        return new UsuarioDao();
    }

    @Override
    public PaqueteInterface getPaquete() {
        return new PaqueteDao();
    }

    @Override
    public ReservaInterface getReserva() {
        return new ReservaDao();
    }

    @Override
    public PagoInterface getPago() {
        return new PagoDao();
    }

    @Override
    public CategoriaPaqueteInterface getCategoriaPaquete() {
        return new CategoriaPaqueteDao();
    }
}
