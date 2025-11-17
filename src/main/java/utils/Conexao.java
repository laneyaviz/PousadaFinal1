package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexao {

    private static final String RAILWAY_URL_PREFIX = "jdbc:";
    
    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/railway?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";

    public static Connection getConexao() {
        
        String rawUrl = System.getenv("DATABASE_URL");
        boolean usingRailway = false;

        String jdbcUrl;

        // Verifica e ajusta o formato da URL
        if (rawUrl != null && !rawUrl.isEmpty()) {
            if (rawUrl.startsWith("mysql://")) {
                // Converte de 'mysql://' para 'jdbc:mysql://'
                jdbcUrl = RAILWAY_URL_PREFIX + rawUrl;
                usingRailway = true;
            } else {
                jdbcUrl = rawUrl;
                usingRailway = true;
            }
        } else {
            jdbcUrl = DEFAULT_URL;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            Connection conexao = DriverManager.getConnection(jdbcUrl);

            if (usingRailway) {
                 System.out.println("✅ Conexão Railway (Banco 'railway') aberta com sucesso.");
            } else {
                 System.out.println("⚠️ Conexão local (Banco 'railway') aberta com sucesso.");
            }
            
            return conexao;

        } catch (ClassNotFoundException e) {
            System.err.println("❌ Driver MySQL não encontrado!");
            throw new RuntimeException("Driver MySQL não encontrado!", e);

        } catch (SQLException e) {
            System.err.println("❌ Erro ao conectar com o banco. Verifique as credenciais e o nome 'railway'.");
            System.err.println("   URL usada na falha: " + jdbcUrl);
            throw new RuntimeException("Erro ao conectar com o banco: " + e.getMessage(), e);
        }
    }
}