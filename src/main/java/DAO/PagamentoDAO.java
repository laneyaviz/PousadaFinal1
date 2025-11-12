package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Date;
import java.time.LocalDate;
import modelos.Pagamentos;
import utils.Conexao;

public class PagamentoDAO {

    public Pagamentos salvar(Pagamentos pagamento) {
        String sql = "INSERT INTO pagamentos (id_reserva, valor_pago, metodo, data_pagamento) VALUES (?, ?, ?, ?)";

        try (Connection con = Conexao.getConexao();
             PreparedStatement stm = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stm.setInt(1, pagamento.getIdReserva());
            stm.setDouble(2, pagamento.getValorTotal());
            stm.setString(3, pagamento.getFormaPagamento());
            stm.setDate(4, Date.valueOf(pagamento.getDataPagamento()));

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
                    pagamento = new Pagamentos();
                    pagamento.setIdPagamento(rs.getInt("id_pagamento"));
                    pagamento.setIdReserva(rs.getInt("id_reserva"));
                    pagamento.setValorTotal(rs.getDouble("valor_pago"));
                    pagamento.setFormaPagamento(rs.getString("metodo"));

                    java.sql.Date sqlDate = rs.getDate("data_pagamento");
                    if (sqlDate != null) {
                        pagamento.setDataPagamento(sqlDate.toLocalDate());
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao buscar pagamento: " + e.getMessage());
        }

        return pagamento;
    }
}
