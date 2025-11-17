package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexao {

    // Fallback local caso as variáveis do Railway não sejam encontradas
    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/railway?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASS = "XegHhUBnYKoGEfBQKUTFVKbhvIfggeJd"; 

    public static Connection getConexao() {
        
        // Lendo as variáveis customizadas configuradas no Railway
        String url = System.getenv("DB_URL");
        String user = System.getenv("DB_USER");
        String pass = System.getenv("DB_PASS");
        
        boolean usingRailway = true;

        if (url == null || url.isEmpty()) {
            url = DEFAULT_URL;
            user = DEFAULT_USER;
            pass = DEFAULT_PASS;
            usingRailway = false;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Tenta a conexão usando os valores lidos
            Connection conexao = DriverManager.getConnection(url, user, pass);

            if (usingRailway) {
                 System.out.println("✅ Conexão Railway aberta com sucesso.");
            } else {
                 System.out.println("⚠️ Conexão local aberta com sucesso.");
            }
            
            return conexao;

        } catch (ClassNotFoundException e) {
            System.err.println("❌ Driver MySQL não encontrado!");
            throw new RuntimeException("Driver MySQL não encontrado!", e);

        } catch (SQLException e) {
            System.err.println("❌ Erro ao conectar com o banco. O problema é quase sempre o Host/Porta.");
            System.err.println("   URL usada na falha: " + url);
            throw new RuntimeException("Erro ao conectar com o banco: Communications link failure", e);
        }
    }
}