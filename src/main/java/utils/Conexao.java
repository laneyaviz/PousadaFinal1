package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexao {

    // Retorna uma nova conexão a cada chamada
    public static Connection getConexao() {
        try {
            String url = "jdbc:mysql://localhost:3306/db_pousada?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
            String user = "root";
            String pass = "root";

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conexao = DriverManager.getConnection(url, user, pass);

            System.out.println("✅ Nova conexão aberta com sucesso.");
            return conexao;

        } catch (ClassNotFoundException e) {
            System.err.println("❌ Driver MySQL não encontrado!");
            throw new RuntimeException("Driver MySQL não encontrado!", e);

        } catch (SQLException e) {
            System.err.println("❌ Erro ao conectar com o banco: " + e.getMessage());
            throw new RuntimeException("Erro ao conectar com o banco: " + e.getMessage(), e);
        }
    }
}
