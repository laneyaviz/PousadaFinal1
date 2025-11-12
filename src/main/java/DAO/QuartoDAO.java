package DAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import modelos.Quartos;
import utils.Conexao;


public class QuartoDAO {
    private Connection con = Conexao.getConexao();

   
    public Quartos salvar(Quartos quarto) {
        String sql = "INSERT INTO quartos (numero, tipo, preco_diaria, capacidade_maxima, descricao, disponivel) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = Conexao.getConexao();
             PreparedStatement stm = con.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            stm.setInt(1, quarto.getNumero());
            stm.setString(2, quarto.getTipo());
            stm.setDouble(3, quarto.getPrecoDiaria());
            stm.setInt(4, quarto.getCapacidadeMaxima());
            stm.setString(5, quarto.getDescricao());
            stm.setBoolean(6, quarto.isDisponivel()); // Booleans são salvos como 0/1 ou TRUE/FALSE dependendo do DB

            stm.executeUpdate();
            
            try (ResultSet rs = stm.getGeneratedKeys()) {
                if (rs.next()) {
                    quarto.setIdQuarto(rs.getInt(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Lança um erro claro (útil para o Servlet capturar, ex: número duplicado)
            throw new RuntimeException("Erro ao salvar quarto: " + e.getMessage());
        }
        return quarto;
    }
    
    public void atualizar(Quartos quarto) {
        String sql = "UPDATE quartos SET numero = ?, tipo = ?, preco_diaria = ?, capacidade_maxima = ?, descricao = ?, disponivel = ? WHERE id_quarto = ?";

        try (Connection con = Conexao.getConexao();
             PreparedStatement stm = con.prepareStatement(sql)) {

            stm.setInt(1, quarto.getNumero());
            stm.setString(2, quarto.getTipo());
            stm.setDouble(3, quarto.getPrecoDiaria());
            stm.setInt(4, quarto.getCapacidadeMaxima());
            stm.setString(5, quarto.getDescricao());
            stm.setBoolean(6, quarto.isDisponivel());
            stm.setInt(7, quarto.getIdQuarto()); // 🚨 CRÍTICO: WHERE ID

            stm.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao atualizar quarto: " + e.getMessage());
        }
    }

    public void deletar(int id) {
        String sql = "DELETE FROM quartos WHERE id_quarto=?";
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setInt(1, id);
            stm.executeUpdate();
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    public Quartos buscarPorId(int id) {
        Quartos quarto = null;
        String sql = "SELECT id_quarto, numero, tipo, preco_diaria, capacidade_maxima, descricao, disponivel FROM quartos WHERE id_quarto = ?";

        try (Connection con = Conexao.getConexao();
             PreparedStatement stm = con.prepareStatement(sql)) {

            stm.setInt(1, id);
            
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    quarto = new Quartos();
                    quarto.setIdQuarto(rs.getInt("id_quarto"));
                    quarto.setNumero(rs.getInt("numero"));
                    quarto.setTipo(rs.getString("tipo"));
                    quarto.setPrecoDiaria(rs.getDouble("preco_diaria"));
                    quarto.setCapacidadeMaxima(rs.getInt("capacidade_maxima"));
                    quarto.setDescricao(rs.getString("descricao"));
                    quarto.setDisponivel(rs.getBoolean("disponivel"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao buscar quarto por ID: " + e.getMessage());
        }
        return quarto;
    }

    public List<Quartos> getAll() {
        List<Quartos> quartos = new ArrayList<>();
        String sql = "SELECT id_quarto, numero, tipo, preco_diaria, capacidade_maxima, descricao, disponivel FROM quartos ORDER BY numero"; 

        try (Connection con = Conexao.getConexao();
             PreparedStatement stm = con.prepareStatement(sql);
             ResultSet rs = stm.executeQuery()) {

            while (rs.next()) {
                Quartos quarto = new Quartos();
                quarto.setIdQuarto(rs.getInt("id_quarto"));
                quarto.setNumero(rs.getInt("numero"));
                quarto.setTipo(rs.getString("tipo"));
                quarto.setPrecoDiaria(rs.getDouble("preco_diaria"));
                quarto.setCapacidadeMaxima(rs.getInt("capacidade_maxima"));
                quarto.setDescricao(rs.getString("descricao"));
                quarto.setDisponivel(rs.getBoolean("disponivel"));
                quartos.add(quarto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao listar quartos: " + e.getMessage());
        }
        return quartos;
    }
}
