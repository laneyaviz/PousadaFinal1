package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexao {

    public static Connection getConexao() {

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Variáveis oficiais do Railway
            String host = System.getenv("MYSQLHOST");
            String port = System.getenv("MYSQLPORT");
            String database = System.getenv("MYSQLDATABASE"); // <- ESTA é a correta
            String user = System.getenv("MYSQLUSER");
            String password = System.getenv("MYSQLPASSWORD");

            // Fallback local
            if (host == null || host.isEmpty()) {
                System.out.println("⚠️ Usando banco local.");
                String localUrl = "jdbc:mysql://localhost:3306/railway?useSSL=false&serverTimezone=UTC";
                return DriverManager.getConnection(localUrl, "root", "");
            }

            // URL JDBC correta para Railway
            String jdbcUrl = "jdbc:mysql://" + host + ":" + port + "/" + database +
                    "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";

            System.out.println("🔵 Conectando ao MySQL Railway:");
            System.out.println("URL: " + jdbcUrl);
            System.out.println("User: " + user);

            return DriverManager.getConnection(jdbcUrl, user, password);

        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Driver JDBC não encontrado!", e);

        } catch (SQLException e) {
            System.err.println("❌ Erro ao conectar no MySQL Railway");
            System.err.println("HOST=" + System.getenv("MYSQLHOST"));
            System.err.println("PORT=" + System.getenv("MYSQLPORT"));
            System.err.println("DB=" + System.getenv("MYSQLDATABASE"));
            throw new RuntimeException("Erro ao conectar: " + e.getMessage(), e);
        }
    }
}
