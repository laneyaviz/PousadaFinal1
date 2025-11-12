package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexao {
    private static Connection conexao = null;

    public static Connection getConexao() {
        if (conexao == null) {
            try {
                // Lê variáveis de ambiente (Render/Railway)
                String url = System.getenv("DB_URL");
                String user = System.getenv("DB_USER");
                String pass = System.getenv("DB_PASS");

                // ⚙️ Fallback para ambiente local (Eclipse)
                if (url == null || user == null || pass == null) {
                    url = "jdbc:mysql://localhost:3306/pousada_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
                    user = "root";
                    pass = "root";
                }

                // Carrega o driver MySQL
                Class.forName("com.mysql.cj.jdbc.Driver");

                // Conecta
                conexao = DriverManager.getConnection(url, user, pass);
                System.out.println("✅ Conectado com sucesso ao banco: " + url);

            } catch (ClassNotFoundException e) {
                System.err.println("❌ Driver MySQL não encontrado!");
                e.printStackTrace();
            } catch (SQLException e) {
                System.err.println("❌ Erro de conexão SQL: " + e.getMessage());
                e.printStackTrace();
            } catch (Exception e) {
                System.err.println("❌ Erro inesperado ao conectar: " + e.getMessage());
                e.printStackTrace();
            }
        }
        return conexao;
    }
}
