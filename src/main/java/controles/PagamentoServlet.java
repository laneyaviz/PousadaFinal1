package controles;

import java.io.IOException;
import java.time.LocalDate;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import DAO.PagamentoDAO;
import DAO.ReservaDAO;
import modelos.Pagamentos;
import modelos.Reserva;

@WebServlet("/PagamentoServlet")
public class PagamentoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private ReservaDAO reservaDAO = new ReservaDAO();
	private PagamentoDAO pagamentoDAO = new PagamentoDAO();

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		try {
			// 1. Obtém a ID da reserva e o método de pagamento
			int idReserva = Integer.parseInt(request.getParameter("id_reserva"));
			String formaPagamento = request.getParameter("formaPagamento");
			
			// 2. Busca a reserva no banco de dados
			Reserva reserva = reservaDAO.buscarPorId(idReserva);

			if (reserva == null || !"PENDENTE".equals(reserva.getStatus())) {
				response.sendRedirect("minhas_reservas.jsp?erro=reserva_invalida");
				return;
			}
			
			// 3. Simula a transação e registra o pagamento
			Pagamentos pagamento = new Pagamentos();
			pagamento.setIdReserva(idReserva);
			pagamento.setValorTotal(reserva.getValorTotal()); // Usa o valor já calculado
			pagamento.setDataPagamento(LocalDate.now());
			pagamento.setFormaPagamento(formaPagamento);
			pagamento.setStatus("APROVADO"); // Simulação de aprovação

			pagamentoDAO.inserir(pagamento);

			// 4. Atualiza o status da reserva para CONFIRMADA
			reserva.setStatus("CONFIRMADA");
			reservaDAO.atualizar(reserva);

			// 5. Redireciona para a página de sucesso
			response.sendRedirect("sucesso_reserva.jsp?id=" + idReserva);

		} catch (NumberFormatException e) {
			response.sendRedirect("minhas_reservas.jsp?erro=id_invalido");
		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("minhas_reservas.jsp?erro=pagamento_falhou");
		}
	}
}
