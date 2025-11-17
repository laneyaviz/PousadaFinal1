package utils;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexao {

    private static final String LOCAL_URL = "jdbc:mysql://localhost:3306/db_pousada?useSSL=false";
    private static final String LOCAL_USER = "root";
    private static final String LOCAL_PASS = "root";

    public static Connection getConnection() {

        // Tenta pegar variáveis do Railway
        String host = System.getenv("MYSQLHOST");
        String port = System.getenv("MYSQLPORT");
        String database = System.getenv("MYSQLDATABASE");
        String user = System.getenv("MYSQLUSER");
        String password = System.getenv("MYSQLPASSWORD");

        try {

            if (host != null && port != null && database != null) {
                System.out.println("🔗 Conectando ao Railway...");

                String url = "jdbc:mysql://mysql.railway.internal:3306/railway?useSSL=false&allowPublicKeyRetrieval=true";

                return DriverManager.getConnection(url, user, password);
            }

            // Caso contrário, usa LOCAL
            System.out.println("⚠️ Usando banco LOCAL.");
            return DriverManager.getConnection(LOCAL_URL, LOCAL_USER, LOCAL_PASS);

        } catch (Exception e) {
            throw new RuntimeException("Erro ao conectar: " + e.getMessage(), e);
        }
    }
}
