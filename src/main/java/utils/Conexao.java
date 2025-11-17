package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexao {

    public static Connection getConexao() {
        // 1. Lendo as variáveis de ambiente do Railway
        String host = System.getenv("DB_HOST");
        String port = System.getenv("DB_PORT");
        String database = System.getenv("DB_DATABASE");
        String user = System.getenv("DB_USER");
        String pass = System.getenv("DB_PASSWORD");

        // 2. Validação básica para garantir que as variáveis estão presentes
        if (host == null || host.isEmpty() || database == null || user == null || pass == null) {
            String msg = "❌ Erro: Variáveis de ambiente do Railway (DB_HOST, DB_PORT, DB_DATABASE, DB_USER, DB_PASSWORD) não encontradas ou incompletas.";
            System.err.println(msg);
            // Lança uma exceção se não conseguir as informações necessárias
            throw new IllegalStateException(msg); 
        }

        try {
            // 3. Constrói a URL JDBC usando os valores do ambiente
            String url = String.format(
                "jdbc:mysql://%s:%s/%s?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC",
                host, 
                port != null && !port.isEmpty() ? port : "3306", // Usa a porta se estiver definida, senão 3306
                database
            );

            // 4. Carrega o Driver (opcional em JDBC 4.0+, mas mantido por segurança)
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // 5. Abre a conexão
            Connection conexao = DriverManager.getConnection(url, user, pass);

            System.out.println("✅ Conexão Railway aberta com sucesso.");
            return conexao;

        } catch (ClassNotFoundException e) {
            System.err.println("❌ Driver MySQL não encontrado!");
            throw new RuntimeException("Driver MySQL não encontrado!", e);

        } catch (SQLException e) {
            System.err.println("❌ Erro ao conectar com o banco Railway: " + e.getMessage());
            System.err.println("   Tentativa de URL: " + String.format("jdbc:mysql://%s:%s/%s", host, port, database));
            throw new RuntimeException("Erro ao conectar com o banco Railway: " + e.getMessage(), e);
        }
    }
}