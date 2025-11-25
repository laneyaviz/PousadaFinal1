package utils;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexao {

    public static Connection getConexao() {

        try {
            // Lê as variáveis de ambiente
            String url = System.getenv("MYSQL_URL");
            String user = System.getenv("MYSQLUSER");
            String pass = System.getenv("MYSQLPASSWORD");

            System.out.println("🔎 MYSQL_URL: " + url);
            System.out.println("🔎 MYSQLUSER: " + user);

            if (url == null || user == null || pass == null) {
                throw new RuntimeException("❌ Variáveis de ambiente não foram carregadas corretamente!");
            }

            // Converte a URL padrão do Railway para JDBC
            // Exemplo:
            // mysql://user:pass@host:port/database
            // ↓ vira ↓
            // jdbc:mysql://host:port/database?useSSL=false&allowPublicKeyRetrieval=true

            if (url.startsWith("mysql://")) {
                url = url.replace("mysql://", "jdbc:mysql://");
                url += "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
            }

            Class.forName("com.mysql.cj.jdbc.Driver");

            return DriverManager.getConnection(url, user, pass);

        } catch (Exception e) {
            throw new RuntimeException("❌ Erro ao conectar com o banco: " + e.getMessage(), e);
        }
    }
}
