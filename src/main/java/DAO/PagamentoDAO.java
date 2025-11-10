package DAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import modelos.Pagamentos;
import utils.Conexao;

public class PagamentoDAO {

    public void inserir(Pagamentos p) {
        String sql = "INSERT INTO pagamentos (id_reserva, valor_total, data_pagamento, forma_pagamento, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, p.getIdReserva());
            stmt.setDouble(2, p.getValorTotal());
            stmt.setDate(3, Date.valueOf(p.getDataPagamento()));
            stmt.setString(4, p.getFormaPagamento());
            stmt.setString(5, p.getStatus());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Pagamentos> listar() {
        List<Pagamentos> lista = new ArrayList<>();
        String sql = "SELECT * FROM pagamentos";
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Pagamentos p = new Pagamentos();
                p.setIdPagamento(rs.getInt("id_pagamento"));
                p.setIdReserva(rs.getInt("id_reserva"));
                p.setValorTotal(rs.getDouble("valor_total"));
                p.setDataPagamento(rs.getDate("data_pagamento").toLocalDate());
                p.setFormaPagamento(rs.getString("forma_pagamento"));
                p.setStatus(rs.getString("status"));
                lista.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public Pagamentos buscarPorId(int id) {
    	Pagamentos pagamento = null;
        String sql = "SELECT * FROM pagamentos WHERE id_pagamento = ?";
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Pagamentos p = new Pagamentos();
                p.setIdPagamento(rs.getInt("id_pagamento"));
                p.setIdReserva(rs.getInt("id_reserva"));
                p.setValorTotal(rs.getDouble("valor_total"));
                p.setDataPagamento(rs.getDate("data_pagamento").toLocalDate());
                p.setFormaPagamento(rs.getString("forma_pagamento"));
                p.setStatus(rs.getString("status"));
                return p;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return pagamento;
    }

    public void atualizar(Pagamentos p) {
        String sql = "UPDATE pagamentos SET id_reserva = ?, valor_total = ?, data_pagamento = ?, forma_pagamento = ?, status = ? WHERE id_pagamento = ?";
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, p.getIdReserva());
            stmt.setDouble(2, p.getValorTotal());
            stmt.setDate(3, Date.valueOf(p.getDataPagamento()));
            stmt.setString(4, p.getFormaPagamento());
            stmt.setString(5, p.getStatus());
            stmt.setInt(6, p.getIdPagamento());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deletar(int id) {
        String sql = "DELETE FROM pagamentos WHERE id_pagamento = ?";
        try (Connection conn = Conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

