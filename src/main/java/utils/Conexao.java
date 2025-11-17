package utils;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexao {

    public static Connection getConexao() {

        // 1. Tenta ler a variável de ambiente MYSQL_URL
        String jdbcUrl = System.getenv("MYSQL_URL");

        // 2. Se estiver nula, usa diretamente sua URL (para facilitar o grupo)
        if (jdbcUrl == null || jdbcUrl.isEmpty()) {
            System.out.println("⚠️ MYSQL_URL não encontrada. Usando URL padrão do Railway.");
            jdbcUrl = "mysql://root:XegHhUBnYKoGEfBQkUTFVKbhvIfggeJd@switchyard.proxy.rlwy.net:41269/railway";
        }

        // 3. Ajusta para formato JDBC
        if (jdbcUrl.startsWith("mysql://")) {
            jdbcUrl = "jdbc:" + jdbcUrl;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(jdbcUrl);
            System.out.println("✅ Conectado ao Railway com sucesso!");
            return conn;

        } catch (Exception e) {
            System.err.println("❌ Erro ao conectar no Railway.");
            System.err.println("URL usada: " + jdbcUrl);
            throw new RuntimeException("Erro na conexão: " + e.getMessage(), e);
        }
    }
}
