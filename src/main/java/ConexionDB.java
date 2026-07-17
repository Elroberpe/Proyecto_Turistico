// Cambia esto si le pusiste otro nombre a tu paquete
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionDB {
    // Ajusta el nombre de tu base de datos y tu contraseña
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=BDTuristico;encrypt=true;trustServerCertificate=true;";
    private static final String USER = "sa"; 
    private static final String PASSWORD = "123456";

    public static Connection obtenerConexion() {
        Connection conexion = null;
        try {
            // Le decimos a Java qué driver usar
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            // Abrimos la puerta a la base de datos
            conexion = DriverManager.getConnection(URL, USER, PASSWORD);
            
        } catch (ClassNotFoundException e) {
            System.out.println("Error: No se encontró el driver. ¿Pusiste el .jar en WEB-INF/lib?");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("Error de base de datos: Revisa tu usuario, contraseña o si SQL Server está encendido.");
            e.printStackTrace();
        }
        return conexion;
    }

    // --- MÉTODO PARA PROBAR LA CONEXIÓN RÁPIDAMENTE ---
    public static void main(String[] args) {
        Connection prueba = ConexionDB.obtenerConexion();
        if (prueba != null) {
            System.out.println("¡ÉXITO! La conexión a SQL Server funciona perfectamente.");
        } else {
            System.out.println("ALGO FALLÓ. Revisa los mensajes de error arriba.");
        }
    }
}