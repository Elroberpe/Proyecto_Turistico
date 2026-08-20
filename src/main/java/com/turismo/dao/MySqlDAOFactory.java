package com.turismo.dao;

import com.turismo.interfaces.CategoriaPaqueteInterface;
import com.turismo.interfaces.PagoInterface;
import com.turismo.interfaces.PaqueteInterface;
import com.turismo.interfaces.ReservaInterface;
import com.turismo.interfaces.UsuarioInterface;
import com.turismo.mantenimientos.CategoriaPaqueteModel;
import com.turismo.mantenimientos.PagoModel;
import com.turismo.mantenimientos.PaqueteModel;
import com.turismo.mantenimientos.ReservaModel;
import com.turismo.mantenimientos.UsuarioModel;

public class MySqlDAOFactory extends DAOFactory {

    @Override
    public UsuarioInterface getUsuario() {
        return new UsuarioModel();
    }

    @Override
    public PaqueteInterface getPaquete() {
        return new PaqueteModel();
    }

    @Override
    public ReservaInterface getReserva() {
        return new ReservaModel();
    }

    @Override
    public PagoInterface getPago() {
        return new PagoModel();
    }

    @Override
    public CategoriaPaqueteInterface getCategoriaPaquete() {
        return new CategoriaPaqueteModel();
    }
}
