package utils;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexao {

    public static Connection getConexao() {

        try {
            // LÊ AS VARIÁVEIS DO RAILWAY (definidas no Render)
            String url = System.getenv("MYSQL_URL");
            String user = System.getenv("MYSQLUSER");
            String pass = System.getenv("MYSQLPASSWORD");

            System.out.println("🔎 URL carregada: " + url);
            System.out.println("🔎 USER carregado: " + user);

            if (url == null || user == null || pass == null) {
                throw new RuntimeException("❌ Variáveis de ambiente NÃO foram carregadas corretamente agora!");
            }

            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(url, user, pass);

        } catch (Exception e) {
            throw new RuntimeException("❌ Erro ao conectar com o banco: " + e.getMessage(), e);
        }
    }
}
