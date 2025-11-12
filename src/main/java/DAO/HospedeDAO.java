package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import org.mindrot.jbcrypt.BCrypt; 
import modelos.Hospedes;
import utils.Conexao; 

public class HospedeDAO {

   
    public Hospedes salvar (Hospedes hospede) {
        String sql = "INSERT INTO hospedes (nome, telefone, email, senha) VALUES (?, ?, ?, ?)";
        
        String hash = BCrypt.hashpw(hospede.getSenha(), BCrypt.gensalt());

        try (Connection con = Conexao.getConexao();
             PreparedStatement stm = con.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            stm.setString(1, hospede.getNome());
            stm.setString(2, hospede.getTelefone());
            stm.setString(3, hospede.getEmail());
            stm.setString(4, hash); 

            stm.executeUpdate();
            
            try (ResultSet rs = stm.getGeneratedKeys()) {
                if (rs.next()) {
                    hospede.setIdHospede(rs.getInt(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao salvar hóspede: " + e.getMessage());
        }
        return hospede;
    }

    
    public List<Hospedes> getAll() {
        List<Hospedes> hospedes = new ArrayList<>();
        String sql = "SELECT id_hospede, nome, telefone, email FROM hospedes"; 
        
        try (Connection con = Conexao.getConexao();
             PreparedStatement stm = con.prepareStatement(sql);
             ResultSet rs = stm.executeQuery()) {

            while (rs.next()) {
                Hospedes h = new Hospedes();
                h.setIdHospede(rs.getInt("id_hospede"));
                h.setNome(rs.getString("nome"));
                h.setTelefone(rs.getString("telefone"));
                h.setEmail(rs.getString("email"));
                hospedes.add(h);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao listar hóspedes: " + e.getMessage());
        }
        return hospedes;
    }
    
    
    public Hospedes buscarPorEmail(String email) {
        Hospedes hospede = null;
        String sql = "SELECT id_hospede, nome, telefone, email, senha FROM hospedes WHERE email = ?";

        try (Connection con = Conexao.getConexao();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setString(1, email);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    hospede = new Hospedes();
                    hospede.setIdHospede(rs.getInt("id_hospede"));
                    hospede.setNome(rs.getString("nome"));
                    hospede.setTelefone(rs.getString("telefone"));
                    hospede.setEmail(rs.getString("email"));
                    
                    hospede.setSenha(rs.getString("senha")); 
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao buscar hóspede por e-mail: " + e.getMessage());
        }
        return hospede;
    }
    
    
    public Hospedes buscarPorId(int id) {
        Hospedes hospede = null;
        String sql = "SELECT id_hospede, nome, telefone, email FROM hospedes WHERE id_hospede = ?";

        try (Connection con = Conexao.getConexao();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    hospede = new Hospedes();
                    hospede.setIdHospede(rs.getInt("id_hospede"));
                    hospede.setNome(rs.getString("nome"));
                    hospede.setTelefone(rs.getString("telefone"));
                    hospede.setEmail(rs.getString("email"));
                    // A senha não é carregada, pois não é necessária
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao buscar hóspede por ID: " + e.getMessage());
        }
        return hospede;
    }
    
    
    public void atualizar(Hospedes hospede) {
        String sql = "UPDATE hospedes SET nome = ?, telefone = ?, email = ? WHERE id_hospede = ?";

        try (Connection con = Conexao.getConexao();
             PreparedStatement stm = con.prepareStatement(sql)) {

            stm.setString(1, hospede.getNome());
            stm.setString(2, hospede.getTelefone());
            stm.setString(3, hospede.getEmail());
            stm.setInt(4, hospede.getIdHospede());

            stm.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao atualizar hóspede: " + e.getMessage());
        }
    }
    
    public void deletar(int id) {
        String sql = "DELETE FROM hospedes WHERE id_hospede = ?";

        try (Connection con = Conexao.getConexao();
             PreparedStatement stm = con.prepareStatement(sql)) {

            stm.setInt(1, id);
            stm.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao deletar hóspede (Pode haver dados relacionados): " + e.getMessage());
        }
    }
    
    public void atualizarSenha(int idHospede, String novaSenhaPura) {
        String hash = BCrypt.hashpw(novaSenhaPura, BCrypt.gensalt());
        String sql = "UPDATE hospedes SET senha = ? WHERE id_hospede = ?";

        try (Connection con = Conexao.getConexao();
             PreparedStatement stm = con.prepareStatement(sql)) {

            stm.setString(1, hash);
            stm.setInt(2, idHospede);

            stm.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao atualizar senha: " + e.getMessage());
        }
    }
}