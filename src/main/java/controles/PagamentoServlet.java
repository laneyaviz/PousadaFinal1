package controles;

import java.io.IOException;
import java.time.LocalDate;
import DAO.PagamentoDAO;
import DAO.ReservaDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modelos.Hospedes;
import modelos.Pagamentos;
import modelos.Reserva;

@WebServlet("/PagamentoServlet")
public class PagamentoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private PagamentoDAO pagamentoDAO = new PagamentoDAO();
    private ReservaDAO reservaDAO = new ReservaDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        Hospedes usuarioLogado = (Hospedes) session.getAttribute("usuarioLogado");

        if (usuarioLogado == null) {
            response.sendRedirect("entrar.jsp?erro=login_necessario");
            return;
        }

        try {
            int idReserva = Integer.parseInt(request.getParameter("idReserva"));
            double valorTotal = Double.parseDouble(request.getParameter("valorTotal"));
            String metodoPagamento = request.getParameter("metodo");

            if (metodoPagamento == null || metodoPagamento.isEmpty()) {
                response.sendRedirect("pagamento.jsp?erro=metodo_invalido");
                return;
            }

            System.out.println("💰 Processando pagamento da reserva " + idReserva + " via " + metodoPagamento);

            Pagamentos novoPagamento = new Pagamentos();
            novoPagamento.setIdReserva(idReserva);
            novoPagamento.setValorTotal(valorTotal);
            novoPagamento.setDataPagamento(LocalDate.now());
            novoPagamento.setFormaPagamento(metodoPagamento);

            pagamentoDAO.salvar(novoPagamento);

            Reserva reserva = reservaDAO.buscarPorId(idReserva);
            if (reserva != null) {
                reserva.setStatus("CONFIRMADA");
                reservaDAO.atualizar(reserva);
            }

            response.sendRedirect("ReservaServlet?acao=minhas_reservas&msg=pagamento_ok");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("pagamento.jsp?erro=falha_processamento");
        }
    }
}
