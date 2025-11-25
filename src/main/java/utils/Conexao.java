package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Properties;

public class Conexao {

    private static Properties props = new Properties();

    static {
        try {
            InputStream is = Conexao.class.getClassLoader().getResourceAsStream("app.config");

            if (is == null) {
                throw new RuntimeException("❌ Arquivo app.config não encontrado!");
            }

            props.load(is);

        } catch (Exception e) {
            throw new RuntimeException("❌ Erro ao carregar app.config: " + e.getMessage(), e);
        }
    }

    public static Connection getConexao() {

        try {
            String url = props.getProperty("MYSQL_URL");
            String user = props.getProperty("MYSQLUSER");
            String pass = props.getProperty("MYSQLPASSWORD");

            System.out.println("🔎 URL carregada: " + url);
            System.out.println("🔎 USER carregado: " + user);

            if (url == null || user == null || pass == null)
                throw new RuntimeException("❌ Variáveis não carregadas no app.config!");

            if (url.startsWith("mysql://")) {
                url = url.replace("mysql://", "jdbc:mysql://") +
                      "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
            }

            Class.forName("com.mysql.cj.jdbc.Driver");

            return DriverManager.getConnection(url, user, pass);

        } catch (Exception e) {
            throw new RuntimeException("❌ Erro ao conectar com o banco: " + e.getMessage(), e);
        }
    }
}
