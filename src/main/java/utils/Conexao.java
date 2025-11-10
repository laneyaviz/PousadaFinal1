package utils;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexao {
	 public static Connection getConexao(){
	    	String user = "root";
	    	String password = "root";
	    	String url = "jdbc:mysql://localhost:3306/db_pousada";
	    	try {
	    		Class.forName("com.mysql.cj.jdbc.Driver");
	    		return DriverManager.getConnection(url, user, password);
	    	} catch (SQLException | ClassNotFoundException e) {
	    		System.out.println(e.getMessage());
	    		return null;
	    	}
	    }

	
}
