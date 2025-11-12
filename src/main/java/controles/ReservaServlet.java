package controles;

import java.io.IOException;
import java.time.LocalDate;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.temporal.ChronoUnit;

import DAO.ReservaDAO;
import DAO.QuartoDAO;
import modelos.Hospedes;
import modelos.Reserva;
import modelos.Quartos;

@WebServlet("/ReservaServlet")
public class ReservaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ReservaDAO reservaDAO = new ReservaDAO();
    private QuartoDAO quartoDAO = new QuartoDAO();

    private Hospedes getAdminLogado(HttpSession session) {
        Hospedes usuario = (Hospedes) session.getAttribute("usuarioLogado");
        if (usuario != null && usuario.getIdHospede() == 1) {
            return usuario;
        }
        return null;
    }

    private Hospedes getHospedeLogado(HttpSession session) {
        Hospedes usuario = (Hospedes) session.getAttribute("usuarioLogado");
        if (usuario != null && usuario.getIdHospede() != 1) {
            return usuario;
        }
        return null;
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String acao = request.getParameter("acao");
        Hospedes admin = getAdminLogado(request.getSession());

        try {
            if ("listar".equals(acao)) {
                if (admin == null) {
                    response.sendRedirect(request.getContextPath() + "/entrar.jsp?erro=acesso_negado");
                    return;
                }
                listarReservas(request, response);
            } else if ("remarcar".equals(acao)) {
                prepararRemarcacao(request, response, admin != null);
            } else if ("minhas_reservas".equals(acao)) {
                listarMinhasReservas(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro interno no servidor.");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String acao = request.getParameter("acao");
        System.out.println("AÇÃO RECEBIDA: " + acao); // ✅ debug

        try {
            if ("reservar".equals(acao)) {
                criarReserva(request, response);
            } else if ("finalizarRemarcacao".equals(acao)) {
                finalizarRemarcacao(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro interno no servidor.");
        }
    }

    private void listarReservas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("reservas", reservaDAO.listar());
        RequestDispatcher rd = request.getRequestDispatcher("/lista_reserva.jsp");
        rd.forward(request, response);
    }
    
    private void listarMinhasReservas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Hospedes hospede = getHospedeLogado(request.getSession());
        if (hospede == null) {
            response.sendRedirect(request.getContextPath() + "/entrar.jsp?erro=login_necessario");
            return;
        }
        request.setAttribute("reservasHospede", reservaDAO.buscarPorIdHospede(hospede.getIdHospede()));
        RequestDispatcher rd = request.getRequestDispatcher("/minhas_reservas.jsp");
        rd.forward(request, response);
    }
    
    private void prepararRemarcacao(HttpServletRequest request, HttpServletResponse response, boolean isAdmin)
            throws ServletException, IOException {
        int idReserva = 0;
        String hospedeTarget = request.getContextPath() + "/minhas_reservas.jsp?erro=";
        String targetRedirect = isAdmin ? "ReservaServlet?acao=listar&erro=" : hospedeTarget;
        
        try {
            idReserva = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            response.sendRedirect(targetRedirect + "id_invalido");
            return;
        }
        Reserva reserva = reservaDAO.buscarPorId(idReserva);  
        if (reserva == null) {
            response.sendRedirect(targetRedirect + "/reserva_nao_encontrada");
            return;
        }
        if (!isAdmin) {
            Hospedes hospede = getHospedeLogado(request.getSession());
            if (hospede == null || hospede.getIdHospede() != reserva.getIdHospede()) {
                response.sendRedirect(request.getContextPath() + "/minhas_reservas.jsp?erro=acesso_negado");
                return;
            }
        }
        Quartos quarto = quartoDAO.buscarPorId(reserva.getIdQuarto());
        reserva.setQuarto(quarto);
        request.setAttribute("reserva", reserva);
        RequestDispatcher rd = request.getRequestDispatcher("/remarcar_reserva.jsp");
        rd.forward(request, response);
    }

    private void criarReserva(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Hospedes hospede = getHospedeLogado(request.getSession());
        String quartoBase = request.getContextPath() + "/quartos.jsp?erro=";
        
        if (hospede == null) {
            response.sendRedirect(request.getContextPath() + "/entrar.jsp?erro=login_necessario");
            return;
        }
        try {
            int idQuarto = Integer.parseInt(request.getParameter("idQuarto"));
            LocalDate dataCheckin = LocalDate.parse(request.getParameter("dataEntrada"));
            LocalDate dataCheckout = LocalDate.parse(request.getParameter("dataSaida"));
            int numAdultos = Integer.parseInt(request.getParameter("numAdultos"));
            int numCriancas = Integer.parseInt(request.getParameter("numCriancas"));
            
            if (dataCheckin.isAfter(dataCheckout) || dataCheckin.isEqual(dataCheckout) || dataCheckin.isBefore(LocalDate.now())) {
                response.sendRedirect(quartoBase + "dados_invalidos");
                return;
            }
            
            long diffDays = ChronoUnit.DAYS.between(dataCheckin, dataCheckout);
            
            if (diffDays > 7) {
                response.sendRedirect(quartoBase + "limite_dias");
                return;
            }
            
            Quartos quarto = quartoDAO.buscarPorId(idQuarto);
            
            if (quarto == null) {
                response.sendRedirect(quartoBase + "quarto_nao_encontrado");
                return;
            }
            
            if (numAdultos + numCriancas > quarto.getCapacidadeMaxima()) {
                response.sendRedirect(quartoBase + "capacidade_excedida");
                return;
            }
            
            if (!reservaDAO.verificarDisponibilidade(idQuarto, dataCheckin, dataCheckout)) {
                response.sendRedirect(quartoBase + "indisponivel");
                return;
            }
            
            double precoDiaria = quarto.getPrecoDiaria();
            double valorTotal = precoDiaria * diffDays;
            
            Reserva novaReserva = new Reserva();
            novaReserva.setIdHospede(hospede.getIdHospede()); 
            novaReserva.setIdQuarto(idQuarto);
            novaReserva.setDataCheckin(dataCheckin);
            novaReserva.setDataCheckout(dataCheckout);
            novaReserva.setNumAdultos(numAdultos);
            novaReserva.setNumCriancas(numCriancas);
            novaReserva.setValorTotal(valorTotal);
            novaReserva.setStatus("PENDENTE"); 
            
            Reserva reservaSalva = reservaDAO.salvar(novaReserva);
            
            if (reservaSalva != null && reservaSalva.getIdReserva() > 0) {
                reservaSalva.setQuarto(quarto); 
                request.setAttribute("reserva", reservaSalva);
                RequestDispatcher rd = request.getRequestDispatcher("/pagamento.jsp");
                rd.forward(request, response);
            } else {
                response.sendRedirect(quartoBase + "/reserva_falha_bd");
            }
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
            response.sendRedirect(quartoBase + "dados_invalidos");
        }
    }
    
    private void finalizarRemarcacao(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        Hospedes usuario = (Hospedes) request.getSession().getAttribute("usuarioLogado");
        boolean isAdmin = (usuario != null && usuario.getIdHospede() == 1);
        String targetRedirect = isAdmin ? "/ReservaServlet?acao=listar" : "/ReservaServlet?acao=minhas_reservas";
        
        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/entrar.jsp?erro=login_necessario");
            return;
        }
        
        Reserva reservaOriginal = null;
        try {
            int idReserva = Integer.parseInt(request.getParameter("idReserva"));
            LocalDate novaDataCheckin = LocalDate.parse(request.getParameter("dataEntrada"));
            LocalDate novaDataCheckout = LocalDate.parse(request.getParameter("dataSaida"));
            int novoNumAdultos = Integer.parseInt(request.getParameter("numAdultos"));
            int novoNumCriancas = Integer.parseInt(request.getParameter("numCriancas"));
            
            reservaOriginal = reservaDAO.buscarPorId(idReserva);
            
            if (reservaOriginal == null) {
                response.sendRedirect(targetRedirect + "&erro=reserva_nao_encontrada");
                return;
            }
            
            if (!isAdmin && reservaOriginal.getIdHospede() != usuario.getIdHospede()) {
                response.sendRedirect("ReservaServlet?acao=minhas_reservas&erro=acesso_negado");
                return;
            }
            
            if (novaDataCheckin.isAfter(novaDataCheckout) || novaDataCheckin.isEqual(novaDataCheckout) || novaDataCheckin.isBefore(LocalDate.now())) {
                request.setAttribute("erroRemarcacao", "Datas inválidas para a remarcação.");
                request.setAttribute("reserva", reservaOriginal);
                RequestDispatcher rd = request.getRequestDispatcher("/remarcar_reserva.jsp");
                rd.forward(request, response);
                return;
            }
            
            long diffDays = ChronoUnit.DAYS.between(novaDataCheckin, novaDataCheckout);
            
            if (diffDays > 7) {
                request.setAttribute("erroRemarcacao", "A reserva não pode ultrapassar 7 dias.");
                request.setAttribute("reserva", reservaOriginal);
                RequestDispatcher rd = request.getRequestDispatcher("/remarcar_reserva.jsp");
                rd.forward(request, response);
                return;
            }
            
            Quartos quarto = quartoDAO.buscarPorId(reservaOriginal.getIdQuarto());
            
            if (quarto == null) {
                response.sendRedirect(targetRedirect + "&erro=quarto_nao_encontrado");
                return;
            }
            
            if (novoNumAdultos + novoNumCriancas > quarto.getCapacidadeMaxima()) {
                request.setAttribute("erroRemarcacao", "O número de hóspedes excede a capacidade do quarto.");
                request.setAttribute("reserva", reservaOriginal);
                RequestDispatcher rd = request.getRequestDispatcher("/remarcar_reserva.jsp");
                rd.forward(request, response);
                return;
            }
            
            if (!reservaDAO.verificarDisponibilidadeExcluindoPropria(reservaOriginal.getIdQuarto(), novaDataCheckin, novaDataCheckout, idReserva)) {
                request.setAttribute("erroRemarcacao", "O quarto não está disponível para as novas datas selecionadas.");
                request.setAttribute("reserva", reservaOriginal);
                RequestDispatcher rd = request.getRequestDispatcher("/remarcar_reserva.jsp");
                rd.forward(request, response);
                return;
            }
            
            double precoDiaria = quarto.getPrecoDiaria();
            double novoValorTotal = precoDiaria * diffDays;
            
            reservaOriginal.setDataCheckin(novaDataCheckin);
            reservaOriginal.setDataCheckout(novaDataCheckout);
            reservaOriginal.setNumAdultos(novoNumAdultos);
            reservaOriginal.setNumCriancas(novoNumCriancas);
            reservaOriginal.setValorTotal(novoValorTotal);
            
            reservaDAO.atualizar(reservaOriginal);
            
            response.sendRedirect(targetRedirect + "&msg=remarcada");
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            if (reservaOriginal != null) {
                request.setAttribute("reserva", reservaOriginal);
            }
            request.setAttribute("erroRemarcacao", "Dados de entrada inválidos.");
            RequestDispatcher rd = request.getRequestDispatcher("/remarcar_reserva.jsp");
            rd.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(targetRedirect + "&erro=falha_ao_remarcar");
        }
    }
}