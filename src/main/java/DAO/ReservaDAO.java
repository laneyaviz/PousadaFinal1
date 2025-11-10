package DAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import modelos.Reserva;
import modelos.Quartos; 

import utils.Conexao;

public class ReservaDAO {
    
    private QuartoDAO quartoDAO = new QuartoDAO(); 

    private Reserva popularReserva(ResultSet rs) throws SQLException {
        Reserva r = new Reserva();
        r.setIdReserva(rs.getInt("id_reserva"));
        r.setIdHospede(rs.getInt("id_hospede"));
        int idQuarto = rs.getInt("id_quarto");
        r.setIdQuarto(idQuarto);
        r.setDataCheckin(rs.getDate("data_checkin"));
        r.setDataCheckout(rs.getDate("data_checkout"));
        r.setStatus(rs.getString("status"));
        r.setNumAdultos(rs.getInt("num_adultos")); 
        r.setNumCriancas(rs.getInt("num_criancas")); 
        r.setValorTotal(rs.getDouble("valor_total")); 
        
        Quartos quarto = quartoDAO.buscarporId(idQuarto);
        r.setQuarto(quarto); 
        
        return r;
    }

    public int inserir(Reserva r) {
        String sql = "INSERT INTO reservas (id_hospede, id_quarto, data_checkin, data_checkout, status, num_adultos, num_criancas, valor_total) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        int idGerado = -1;

        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, r.getIdHospede());
            stmt.setInt(2, r.getIdQuarto());
            stmt.setDate(3, r.getDataCheckin());
            stmt.setDate(4, r.getDataCheckout());
            stmt.setString(5, r.getStatus());
            stmt.setInt(6, r.getNumAdultos());
            stmt.setInt(7, r.getNumCriancas());
            stmt.setDouble(8, r.getValorTotal());
            stmt.executeUpdate();

            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    idGerado = rs.getInt(1);
                    r.setIdReserva(idGerado); 
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao inserir reserva: " + e.getMessage());
        }
        return idGerado;
    }

    public void atualizar(Reserva r) {
        String sql = "UPDATE reservas SET id_quarto=?, data_checkin=?, data_checkout=?, status=?, num_adultos=?, num_criancas=?, valor_total=? WHERE id_reserva=?";
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, r.getIdQuarto());
            stmt.setDate(2, r.getDataCheckin());
            stmt.setDate(3, r.getDataCheckout());
            stmt.setString(4, r.getStatus()); 
            stmt.setInt(5, r.getNumAdultos()); 
            stmt.setInt(6, r.getNumCriancas());
            stmt.setDouble(7, r.getValorTotal());
            stmt.setInt(8, r.getIdReserva()); 
            
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao atualizar reserva: " + e.getMessage());
        }
    }
    
    public Reserva buscarPorId(int id) {
        Reserva r = null;
        String sql = "SELECT * FROM reservas WHERE id_reserva = ?";
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    r = popularReserva(rs); // Usa o método corrigido
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return r;
    }

    public List<Reserva> listar() {
        List<Reserva> lista = new ArrayList<>();
        String sql = "SELECT * FROM reservas ORDER BY data_checkin DESC";
        try (Connection conn = Conexao.getConexao();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                lista.add(popularReserva(rs)); // Usa o método corrigido
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public List<Reserva> listarPorHospede(int idHospede) {
        List<Reserva> lista = new ArrayList<>();
        String sql = "SELECT * FROM reservas WHERE id_hospede = ? ORDER BY data_checkin DESC";
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idHospede);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    lista.add(popularReserva(rs)); // Usa o método corrigido
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
    
    public boolean verificarDisponibilidade(int idQuarto, Date dataCheckin, Date dataCheckout) {
        
       
        String sql = "SELECT COUNT(*) FROM reservas " +
                     "WHERE id_quarto = ? AND status IN ('PENDENTE', 'CONFIRMADA') " +
                     "AND data_checkin < ? AND data_checkout > ?";
        
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idQuarto);
            stmt.setDate(2, dataCheckout); 
            stmt.setDate(3, dataCheckin);  
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int conflitos = rs.getInt(1);
                    return conflitos == 0; // Disponível se NENHUM conflito for encontrado
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false; 
        }
        return false;
    }
    
    public boolean verificarDisponibilidadeExcluindoPropria(int idQuarto, Date dataCheckin, Date dataCheckout, int idReservaAtual) {
        
        String sql = "SELECT COUNT(*) FROM reservas " +
                     "WHERE id_quarto = ? AND id_reserva != ? AND status IN ('PENDENTE', 'CONFIRMADA') " +
                     "AND data_checkin < ? AND data_checkout > ?";
        
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idQuarto);
            stmt.setInt(2, idReservaAtual); // Exclui a própria reserva
            stmt.setDate(3, dataCheckout);
            stmt.setDate(4, dataCheckin);  
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) == 0; 
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false; 
        }
        return false;
    }
}