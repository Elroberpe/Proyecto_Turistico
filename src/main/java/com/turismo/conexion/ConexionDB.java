package com.turismo.conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionDB {

    // Configuración de MySQL
    private static final String URL = "jdbc:mysql://localhost:3306/chasquiPeru?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";      // Cambia si tu usuario es otro
    private static final String PASSWORD = "123456"; // Coloca tu contraseña de MySQL

    public static Connection obtenerConexion() {
        Connection conexion = null;

        try {
            // Cargar el driver de MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Abrir la conexión
            conexion = DriverManager.getConnection(URL, USER, PASSWORD);

        } catch (ClassNotFoundException e) {
            System.out.println("Error: No se encontró el driver de MySQL.");
            e.printStackTrace();

        } catch (SQLException e) {
            System.out.println("Error al conectar con MySQL.");
            e.printStackTrace();
        }

        return conexion;
    }

    // Método para probar la conexión
    public static void main(String[] args) {

        Connection prueba = ConexionDB.obtenerConexion();

        if (prueba != null) {
            System.out.println("¡ÉXITO! La conexión a MySQL funciona correctamente.");

            try {
                prueba.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }

        } else {
            System.out.println("No se pudo establecer la conexión.");
        }
    }
}