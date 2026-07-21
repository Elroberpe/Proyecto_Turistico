package com.turismo.modelo;

public class Paquete {

	private int idPaquete;
    private int idCategoria;
    private String nombre;
    private String destino;
    private String descripcion;
    private double precioDia;
    private double precioTransporteIda;
    private double precioTransporteIdaVuelta;
    private int diasMinimos;
    private int diasMaximos;
    private int cupoDisponible;
    private boolean activo;
 
    public int getIdPaquete() { return idPaquete; }
    public void setIdPaquete(int idPaquete) { this.idPaquete = idPaquete; }
 
    public int getIdCategoria() { return idCategoria; }
    public void setIdCategoria(int idCategoria) { this.idCategoria = idCategoria; }
 
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
 
    public String getDestino() { return destino; }
    public void setDestino(String destino) { this.destino = destino; }
 
    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
 
    public double getPrecioDia() { return precioDia; }
    public void setPrecioDia(double precioDia) { this.precioDia = precioDia; }
 
    public double getPrecioTransporteIda() { return precioTransporteIda; }
    public void setPrecioTransporteIda(double precioTransporteIda) { this.precioTransporteIda = precioTransporteIda; }
 
    public double getPrecioTransporteIdaVuelta() { return precioTransporteIdaVuelta; }
    public void setPrecioTransporteIdaVuelta(double precioTransporteIdaVuelta) { this.precioTransporteIdaVuelta = precioTransporteIdaVuelta; }
 
    public int getDiasMinimos() { return diasMinimos; }
    public void setDiasMinimos(int diasMinimos) { this.diasMinimos = diasMinimos; }
 
    public int getDiasMaximos() { return diasMaximos; }
    public void setDiasMaximos(int diasMaximos) { this.diasMaximos = diasMaximos; }
 
    public int getCupoDisponible() { return cupoDisponible; }
    public void setCupoDisponible(int cupoDisponible) { this.cupoDisponible = cupoDisponible; }
 
    public boolean isActivo() { return activo; }
    public void setActivo(boolean activo) { this.activo = activo; }
	
	
}
