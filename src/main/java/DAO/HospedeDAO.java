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

    private Connection con = Conexao.getConexao();

   
    public Hospedes salvar(Hospedes hospede) {
        String sql = "INSERT INTO hospedes (nome, telefone, email, senha) VALUES (?, ?, ?, ?)";

        // Criptografa a senha antes de salvar
        String hash = BCrypt.hashpw(hospede.getSenha(), BCrypt.gensalt());

        try {
            PreparedStatement stm = con.prepareStatement(sql);
            stm.setString(1, hospede.getNome());
            stm.setString(2, hospede.getTelefone());
            stm.setString(3, hospede.getEmail());
            stm.setString(4, hash);
            stm.execute();

        } catch (SQLException e) {
            throw new RuntimeException("Erro ao salvar hóspede: " + e.getMessage());
        }

        return hospede;
    }

    /**
     * Retorna todos os hóspedes cadastrados.
     */
    public List<Hospedes> getAll() {
        List<Hospedes> hospedes = new ArrayList<>();

        try {
            PreparedStatement stm = con.prepareStatement("SELECT * FROM hospedes");
            ResultSet rs = stm.executeQuery();

            while (rs.next()) {
                Hospedes h = new Hospedes();
                h.setIdHospede(rs.getInt("id_hospede"));
                h.setNome(rs.getString("nome"));
                h.setTelefone(rs.getString("telefone"));
                h.setEmail(rs.getString("email"));
                h.setSenha(rs.getString("senha")); // senha criptografada
                hospedes.add(h);
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erro ao listar hóspedes: " + e.getMessage());
        }

        return hospedes;
    }

  
    public Hospedes Login(String email, String senha) {
        Hospedes hospede = null;

        try {
            // Busca o hóspede pelo e-mail
            PreparedStatement stm = con.prepareStatement("SELECT * FROM hospedes WHERE email = ?");
            stm.setString(1, email);
            ResultSet rs = stm.executeQuery();

            if (rs.next()) {
                String senhaHash = rs.getString("senha");

                // Verifica se a senha digitada corresponde ao hash armazenado
                if (BCrypt.checkpw(senha, senhaHash)) {
                    hospede = new Hospedes();
                    hospede.setIdHospede(rs.getInt("id_hospede"));
                    hospede.setNome(rs.getString("nome"));
                    hospede.setTelefone(rs.getString("telefone"));
                    hospede.setEmail(rs.getString("email"));
                    hospede.setSenha(senhaHash); // senha armazenada (hash)
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Erro ao fazer login: " + e.getMessage());
        }

        return hospede;
    }
}
