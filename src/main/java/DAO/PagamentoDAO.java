package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import modelos.Pagamentos;
import utils.Conexao;

import java.sql.Date; 

public class PagamentoDAO {
    

    public Pagamentos salvar(Pagamentos pagamento) {
        String sql = "INSERT INTO pagamentos (id_reserva, valor_total, data_pagamento, metodo_pagamento, status, parcelas) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = Conexao.getConexao();
             PreparedStatement stm = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stm.setInt(1, pagamento.getIdReserva());
            stm.setDouble(2, pagamento.getValorTotal());
            
            stm.setDate(3, Date.valueOf(pagamento.getDataPagamento()));
            
            stm.setString(4, pagamento.getFormaPagamento());
            stm.setString(5, pagamento.getStatus()); 

            stm.executeUpdate();
            
            try (ResultSet rs = stm.getGeneratedKeys()) {
                if (rs.next()) {
                    pagamento.setIdPagamento(rs.getInt(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao salvar pagamento: " + e.getMessage());
        }
        return pagamento;
    }

    public Pagamentos buscarPorIdReserva(int idReserva) {
        Pagamentos pagamento = null;
        String sql = "SELECT * FROM pagamentos WHERE id_reserva = ?";

        try (Connection con = Conexao.getConexao();
             PreparedStatement stm = con.prepareStatement(sql)) {

            stm.setInt(1, idReserva);
            
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    pagamento = mapPagamento(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao buscar pagamento por ID da Reserva: " + e.getMessage());
        }
        return pagamento;
    }

    private Pagamentos mapPagamento(ResultSet rs) throws SQLException {
        Pagamentos pagamento = new Pagamentos();
        pagamento.setIdPagamento(rs.getInt("id_pagamento"));
        pagamento.setIdReserva(rs.getInt("id_reserva"));
        pagamento.setValorTotal(rs.getDouble("valor_total"));
        
        Date sqlDate = rs.getDate("data_pagamento");
        if (sqlDate != null) {
            pagamento.setDataPagamento(sqlDate.toLocalDate());
        }
        
        pagamento.setFormaPagamento(rs.getString("metodo_pagamento"));
        pagamento.setStatus(rs.getString("status"));
        
        
        return pagamento;
    }
}