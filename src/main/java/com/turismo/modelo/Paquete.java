package com.turismo.modelo;

import java.math.BigDecimal;

public class Paquete {

    private int idPaquete;
    private int idCategoria;
    private String nombre;
    private String destino;
    private String descripcion;
    private String imagenUrl;
    private BigDecimal precioSoles;
    private String estado;

    // Constructor vacío
    public Paquete() {
    }

    // Constructor sin id (para registrar)
    public Paquete(int idCategoria, String nombre, String destino, String imagenUrl,
                   BigDecimal precioSoles, String estado) {
        this.idCategoria = idCategoria;
        this.nombre = nombre;
        this.destino = destino;
        this.imagenUrl = imagenUrl;
        this.precioSoles = precioSoles;
        this.estado = estado;
    }

    // Constructor completo
    public Paquete(int idPaquete, int idCategoria, String nombre, String destino,
                   String imagenUrl, BigDecimal precioSoles, String estado) {
        this.idPaquete = idPaquete;
        this.idCategoria = idCategoria;
        this.nombre = nombre;
        this.destino = destino;
        this.imagenUrl = imagenUrl;
        this.precioSoles = precioSoles;
        this.estado = estado;
    }

    // Getters y Setters

    public int getIdPaquete() {
        return idPaquete;
    }

    public void setIdPaquete(int idPaquete) {
        this.idPaquete = idPaquete;
    }

    public int getIdCategoria() {
        return idCategoria;
    }

    public void setIdCategoria(int idCategoria) {
        this.idCategoria = idCategoria;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDestino() {
        return destino;
    }

    public void setDestino(String destino) {
        this.destino = destino;
    }

    public String getImagenUrl() {
        return imagenUrl;
    }

    public void setImagenUrl(String imagenUrl) {
        this.imagenUrl = imagenUrl;
    }

    public BigDecimal getPrecioSoles() {
        return precioSoles;
    }

    public void setPrecioSoles(BigDecimal precioSoles) {
        this.precioSoles = precioSoles;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    @Override
    public String toString() {
        return "Paquete{" +
                "idPaquete=" + idPaquete +
                ", idCategoria=" + idCategoria +
                ", nombre='" + nombre + '\'' +
                ", destino='" + destino + '\'' +
                ", imagenUrl='" + imagenUrl + '\'' +
                ", precioSoles=" + precioSoles +
                ", estado='" + estado + '\'' +
                '}';
    }

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
}