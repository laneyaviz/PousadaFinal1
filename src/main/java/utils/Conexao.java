package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexao {

    // Prefixo necessário para o formato JDBC
    private static final String RAILWAY_URL_PREFIX = "jdbc:";
    
    // Fallback local (para desenvolvimento, se necessário)
    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/railway?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";

    public static Connection getConexao() {
        
        // Tenta ler a variável injetada pelo Railway (MYSQL_URL)
        String rawUrl = System.getenv("MYSQL_URL");
        boolean usingRailway = false;

        String jdbcUrl;
        String user = "root"; // Mantemos root para o fallback
        String pass = null;   // A senha deve estar embutida na URL do Railway

        // 1. Processamento da URL do Railway
        if (rawUrl != null && !rawUrl.isEmpty()) {
            // A MYSQL_URL do Railway começa com "mysql://", precisamos de "jdbc:mysql://"
            if (rawUrl.startsWith("mysql://")) {
                jdbcUrl = RAILWAY_URL_PREFIX + rawUrl;
                usingRailway = true;
            } else {
                jdbcUrl = rawUrl; // Se já estiver no formato JDBC
                usingRailway = true;
            }
        } else {
            // 2. Uso do Fallback Local
            jdbcUrl = DEFAULT_URL;
            // No fallback, precisamos do user/pass separados (se não estiverem na URL)
            // Se estiver usando o DEFAULT_URL acima, user/pass serão ignorados por segurança.
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            Connection conexao;
            
            if (usingRailway) {
                // A MYSQL_URL já contém usuário e senha: mysql://user:pass@host:port/db
                conexao = DriverManager.getConnection(jdbcUrl);
                System.out.println("✅ Conexão Railway (MYSQL_URL) aberta com sucesso.");
            } else {
                // Para o fallback, precisamos do user/pass se a URL não os tiver
                conexao = DriverManager.getConnection(jdbcUrl, user, DEFAULT_PASS);
                System.out.println("⚠️ Conexão local aberta com sucesso.");
            }
            
            return conexao;

        } catch (ClassNotFoundException e) {
            System.err.println("❌ Driver MySQL não encontrado!");
            throw new RuntimeException("Driver MySQL não encontrado!", e);

        } catch (SQLException e) {
            System.err.println("❌ Erro ao conectar com o banco. Host interno: " + System.getenv("MYSQLHOST"));
            System.err.println("   URL usada na falha: " + jdbcUrl);
            throw new RuntimeException("Erro ao conectar com o banco: " + e.getMessage(), e);
        }
    }
}