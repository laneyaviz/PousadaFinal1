package utils;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexao {
    private static Connection conexao;

    public static Connection getConexao() {
        if (conexao == null) {
            try {
                String host = System.getenv("DB_HOST");
                String port = System.getenv("DB_PORT");
                String db   = System.getenv("DB_NAME");
                String user = System.getenv("DB_USER");
                String pass = System.getenv("DB_PASS");

                if (host == null) {
                    // fallback local (para teste no Eclipse)
                    host = "localhost";
                    port = "3306";
                    db = "pousada_db";
                    user = "root";
                    pass = "root";
                }

                String url = "jdbc:mysql://" + host + ":" + port + "/" + db
                           + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";

                Class.forName("com.mysql.cj.jdbc.Driver");
                conexao = DriverManager.getConnection(url, user, pass);
                System.out.println("✅ Conectado ao banco MySQL: " + url);

            } catch (Exception e) {
                e.printStackTrace();
                throw new RuntimeException("❌ Erro ao conectar ao banco: " + e.getMessage());
            }
        }
        return conexao;
    }
}
