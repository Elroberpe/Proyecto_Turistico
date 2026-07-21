package com.turismo.conexion;


import java.sql.Connection;

public class probar {

    public static void main(String[] args) {

        System.out.println("Intentando conectar a MySQL...");

        Connection conexion = ConexionDB.obtenerConexion();

        if (conexion != null) {
            System.out.println("✅ Conexión exitosa a MySQL.");

            try {
                conexion.close();
                System.out.println("Conexión cerrada correctamente.");
            } catch (Exception e) {
                e.printStackTrace();
            }

        } else {
            System.out.println("❌ No se pudo establecer la conexión.");
        }
    }
}