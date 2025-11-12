package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import modelos.Reserva;
import modelos.Quartos;
import utils.Conexao;
import java.sql.Date; 

public class ReservaDAO {


    public Reserva salvar(Reserva reserva) {
        String sql = "INSERT INTO reservas (id_hospede, id_quarto, data_checkin, data_checkout, status, num_adultos, num_criancas, valor_total) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        System.out.println("💾 Salvando reserva no banco...");
        System.out.println("Hospede: " + reserva.getIdHospede());
        System.out.println("Quarto: " + reserva.getIdQuarto());
        System.out.println("Check-in: " + reserva.getDataCheckin());
        System.out.println("Check-out: " + reserva.getDataCheckout());
        System.out.println("Valor: " + reserva.getValorTotal());

        try (Connection con = Conexao.getConexao();
             PreparedStatement stm = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stm.setInt(1, reserva.getIdHospede());
            stm.setInt(2, reserva.getIdQuarto());
            
            stm.setDate(3, Date.valueOf(reserva.getDataCheckin()));
            stm.setDate(4, Date.valueOf(reserva.getDataCheckout()));
            
            stm.setString(5, reserva.getStatus());
            stm.setInt(6, reserva.getNumAdultos());
            stm.setInt(7, reserva.getNumCriancas());
            stm.setDouble(8, reserva.getValorTotal());

            stm.executeUpdate();

            try (ResultSet rs = stm.getGeneratedKeys()) {
                if (rs.next()) {
                    reserva.setIdReserva(rs.getInt(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao salvar reserva: " + e.getMessage());
        }
        return reserva;
    }
    

    public void atualizar(Reserva reserva) {
        String sql = "UPDATE reservas SET id_quarto = ?, data_checkin = ?, data_checkout = ?, status = ?, num_adultos = ?, num_criancas = ?, valor_total = ? WHERE id_reserva = ?";

        try (Connection con = Conexao.getConexao();
             PreparedStatement stm = con.prepareStatement(sql)) {

            stm.setInt(1, reserva.getIdQuarto());
            
            stm.setDate(2, Date.valueOf(reserva.getDataCheckin()));
            stm.setDate(3, Date.valueOf(reserva.getDataCheckout()));
            
            stm.setString(4, reserva.getStatus());
            stm.setInt(5, reserva.getNumAdultos());
            stm.setInt(6, reserva.getNumCriancas());
            stm.setDouble(7, reserva.getValorTotal());
            stm.setInt(8, reserva.getIdReserva());

            stm.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao atualizar reserva: " + e.getMessage());
        }
    }



    public boolean verificarDisponibilidade(int idQuarto, LocalDate dataCheckin, LocalDate dataCheckout) {

        String sql = "SELECT COUNT(*) FROM reservas " +
                     "WHERE id_quarto = ? AND status IN ('PENDENTE', 'CONFIRMADA') AND " +
                     "(data_checkin < ? AND data_checkout > ?)";

        try (Connection con = Conexao.getConexao();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setInt(1, idQuarto);
            stmt.setDate(2, Date.valueOf(dataCheckout)); 
            stmt.setDate(3, Date.valueOf(dataCheckin));

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int conflitos = rs.getInt(1);
                    return conflitos == 0; 
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false; 
        }
        return false; 
    }


    public boolean verificarDisponibilidadeExcluindoPropria(int idQuarto, LocalDate dataCheckin, LocalDate dataCheckout, int idReservaAtual) {
        String sql = "SELECT COUNT(*) FROM reservas " +
                     "WHERE id_quarto = ? AND id_reserva != ? AND status IN ('PENDENTE', 'CONFIRMADA') AND " +
                     "(data_checkin < ? AND data_checkout > ?)";

        try (Connection con = Conexao.getConexao();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setInt(1, idQuarto);
            stmt.setInt(2, idReservaAtual);
            stmt.setDate(3, Date.valueOf(dataCheckout)); 
            stmt.setDate(4, Date.valueOf(dataCheckin));

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int conflitos = rs.getInt(1);
                    return conflitos == 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
        return false;
    }

    private Reserva mapReserva(ResultSet rs) throws SQLException {
        Reserva reserva = new Reserva();
        reserva.setIdReserva(rs.getInt("id_reserva"));
        reserva.setIdHospede(rs.getInt("id_hospede"));
        reserva.setIdQuarto(rs.getInt("id_quarto"));
        
        Date sqlCheckin = rs.getDate("data_checkin");
        Date sqlCheckout = rs.getDate("data_checkout");

        if (sqlCheckin != null) {
            reserva.setDataCheckin(sqlCheckin.toLocalDate());
        }
        if (sqlCheckout != null) {
            reserva.setDataCheckout(sqlCheckout.toLocalDate());
        }
        
        reserva.setStatus(rs.getString("status"));
        reserva.setNumAdultos(rs.getInt("num_adultos"));
        reserva.setNumCriancas(rs.getInt("num_criancas"));
        reserva.setValorTotal(rs.getDouble("valor_total"));

        return reserva;
    }
    
    

    public Reserva buscarPorId(int idReserva) {
        Reserva reserva = null;
        String sql = "SELECT * FROM reservas WHERE id_reserva = ?";

        try (Connection con = Conexao.getConexao();
             PreparedStatement stm = con.prepareStatement(sql)) {

            stm.setInt(1, idReserva);

            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    reserva = mapReserva(rs);
                    reserva.setQuarto(new Quartos()); 
                    reserva.getQuarto().setIdQuarto(reserva.getIdQuarto());
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao buscar reserva por ID: " + e.getMessage());
        }
        return reserva;
    }


    public List<Reserva> buscarPorIdHospede(int idHospede) {
        List<Reserva> reservas = new ArrayList<>();
        String sql = "SELECT r.*, q.numero, q.tipo, q.preco_diaria, q.capacidade_maxima " +
                     "FROM reservas r JOIN quartos q ON r.id_quarto = q.id_quarto " +
                     "WHERE r.id_hospede = ? ORDER BY r.data_checkin DESC";

        try (Connection con = Conexao.getConexao();
             PreparedStatement stm = con.prepareStatement(sql)) {

            stm.setInt(1, idHospede);

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Reserva reserva = mapReserva(rs);
                    Quartos quarto = new Quartos();
                    quarto.setNumero(rs.getInt("numero"));
                    quarto.setTipo(rs.getString("tipo"));
                    reserva.setQuarto(quarto);
                    reservas.add(reserva);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao buscar reservas do hóspede: " + e.getMessage());
        }
        return reservas;
    }
    

     
     public List<Reserva> listar() {
        List<Reserva> reservas = new ArrayList<>();
        String sql = "SELECT r.*, q.numero, q.tipo, q.preco_diaria " +
                     "FROM reservas r " +
                     "JOIN quartos q ON r.id_quarto = q.id_quarto " +
                     "ORDER BY r.data_checkin DESC";

        try (Connection con = Conexao.getConexao();
             PreparedStatement stm = con.prepareStatement(sql);
             ResultSet rs = stm.executeQuery()) {

            while (rs.next()) {
                Reserva reserva = new Reserva();
                reserva.setIdReserva(rs.getInt("id_reserva"));
                reserva.setIdHospede(rs.getInt("id_hospede"));
                reserva.setIdQuarto(rs.getInt("id_quarto"));
                reserva.setDataCheckin(rs.getDate("data_checkin").toLocalDate());
                reserva.setDataCheckout(rs.getDate("data_checkout").toLocalDate());
                reserva.setNumAdultos(rs.getInt("num_adultos"));
                reserva.setNumCriancas(rs.getInt("num_criancas"));
                reserva.setValorTotal(rs.getDouble("valor_total"));
                reserva.setStatus(rs.getString("status"));

                Quartos quarto = new Quartos();
                quarto.setNumero(rs.getInt("numero"));
                quarto.setTipo(rs.getString("tipo"));
                quarto.setPrecoDiaria(rs.getDouble("preco_diaria"));

                reserva.setQuarto(quarto);

                reservas.add(reserva);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao listar reservas: " + e.getMessage());
        }
        return reservas;
    }
}