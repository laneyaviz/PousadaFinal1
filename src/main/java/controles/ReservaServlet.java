package controles;

import java.io.IOException;
import java.sql.Date; 
import java.util.concurrent.TimeUnit;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

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

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String acao = request.getParameter("acao");
        
        try {
            if ("listar".equals(acao)) {
                request.setAttribute("reservas", reservaDAO.listar());
                RequestDispatcher rd = request.getRequestDispatcher("lista_reserva.jsp");
                rd.forward(request, response);
            
            } else if ("remarcar".equals(acao)) {
                // Prepara formulário de remarcação
                int idReserva = Integer.parseInt(request.getParameter("id"));
                Reserva reserva = reservaDAO.buscarPorId(idReserva);
                
                // Buscar dados do Quarto para capacidade e preço
                Quartos quarto = quartoDAO.buscarporId(reserva.getIdQuarto());
                // CORREÇÃO: Usar setQuarto(Quartos)
                reserva.setQuarto(quarto); 
                
                request.setAttribute("reserva", reserva);
                RequestDispatcher rd = request.getRequestDispatcher("remarcar_reserva.jsp");
                rd.forward(request, response);
                
            } else if ("reembolsar".equals(acao)) {
                // Altera o status da reserva para CANCELADA
                int idReserva = Integer.parseInt(request.getParameter("id"));
                Reserva reserva = reservaDAO.buscarPorId(idReserva);
                if (reserva != null && !"CANCELADA".equals(reserva.getStatus())) {
                    reserva.setStatus("CANCELADA"); 
                    reservaDAO.atualizar(reserva);
                    response.sendRedirect("ReservaServlet?acao=listar&msg=cancelada_sucesso");
                } else {
                     response.sendRedirect("ReservaServlet?acao=listar&erro=cancelamento_falhou");
                }
            } else if ("minhas_reservas".equals(acao)) {
                // Lista reservas do Hóspede logado
                HttpSession session = request.getSession(false);
                Hospedes usuarioLogado = (session != null) ? (Hospedes) session.getAttribute("usuarioLogado") : null;

                if (usuarioLogado == null) {
                    response.sendRedirect("entrar.jsp?erro=login_necessario");
                    return;
                }
                
                request.setAttribute("reservasHospede", reservaDAO.listarPorHospede(usuarioLogado.getIdHospede()));
                RequestDispatcher rd = request.getRequestDispatcher("minhas_reservas.jsp");
                rd.forward(request, response);

            } else {
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/erro.jsp?msg=ID_Invalido");
        } catch (Exception e) {
             response.sendRedirect(request.getContextPath() + "/erro.jsp?msg=" + e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String acao = request.getParameter("acao");

        // --- 1. LÓGICA DE REMARCAÇÃO (ADMIN) ---
        if ("remarcar".equals(acao)) {
            try {
                int idReserva = Integer.parseInt(request.getParameter("idReserva"));
                Reserva reserva = reservaDAO.buscarPorId(idReserva);

                if (reserva != null) {
                    Date novaDataCheckin = Date.valueOf(request.getParameter("dataEntrada"));
                    Date novaDataCheckout = Date.valueOf(request.getParameter("dataSaida"));
                    int novosAdultos = Integer.parseInt(request.getParameter("numAdultos")); 
                    int novasCriancas = Integer.parseInt(request.getParameter("numCriancas"));
                    
                    long diffMillis = novaDataCheckout.getTime() - novaDataCheckin.getTime();
                    long dias = TimeUnit.DAYS.convert(diffMillis, TimeUnit.MILLISECONDS);
                    Quartos quarto = quartoDAO.buscarporId(reserva.getIdQuarto());

                    // VALIDAÇÃO 1: LIMITE DE 7 DIAS
                    if (dias > 7 || dias <= 0) {
                        throw new RuntimeException("Datas inválidas para remarcação (Limite máximo: 7 dias)."); 
                    }
                    
                    // VALIDAÇÃO 2: CAPACIDADE
                    if ((novosAdultos + novasCriancas) > quarto.getCapacidadeMaxima()) {
                         throw new RuntimeException("Capacidade excedida para o quarto.");
                    }
                    
                    // VALIDAÇÃO 3: DISPONIBILIDADE (Excluindo a própria reserva da checagem)
                    if (!reservaDAO.verificarDisponibilidadeExcluindoPropria(reserva.getIdQuarto(), novaDataCheckin, novaDataCheckout, idReserva)) {
                        throw new RuntimeException("Quarto indisponível nas novas datas.");
                    }
                    
                    // ATUALIZAÇÃO E RECÁLCULO
                    reserva.setDataCheckin(novaDataCheckin);
                    reserva.setDataCheckout(novaDataCheckout);
                    reserva.setNumAdultos(novosAdultos);
                    reserva.setNumCriancas(novasCriancas);
                    
                    double precoDiaria = quarto.getPrecoDiaria();
                    double valorTotal = dias * precoDiaria;
                    reserva.setValorTotal(valorTotal);
                    
                    reservaDAO.atualizar(reserva); 
                    response.sendRedirect("ReservaServlet?acao=listar&msg=remarcada");
                }
            } catch (Exception e) {
                request.setAttribute("erroRemarcacao", "Erro ao remarcar: " + e.getMessage());
                // Recarrega os dados para o formulário
                try {
                    int idReserva = Integer.parseInt(request.getParameter("idReserva"));
                    Reserva reservaOriginal = reservaDAO.buscarPorId(idReserva);
                    // CORREÇÃO AQUI TAMBÉM: Usar setQuarto(Quartos)
                    reservaOriginal.setQuarto(quartoDAO.buscarporId(reservaOriginal.getIdQuarto()));
                    request.setAttribute("reserva", reservaOriginal);
                } catch(Exception ignored) {} 
                request.getRequestDispatcher("remarcar_reserva.jsp").forward(request, response);
            }
            return;
        }

        // --- 2. LÓGICA DE INSERÇÃO DE NOVA RESERVA (USUÁRIO) ---
        
        HttpSession session = request.getSession(false);
        Hospedes usuarioLogado = (session != null) ? (Hospedes) session.getAttribute("usuarioLogado") : null;

        if (usuarioLogado == null) {
            response.sendRedirect("entrar.jsp?erro=login_necessario");
            return;
        }
        
        try {
            int idHospede = usuarioLogado.getIdHospede();
            int idQuarto = Integer.parseInt(request.getParameter("idQuarto"));
            Date dataCheckin = Date.valueOf(request.getParameter("dataEntrada")); 
            Date dataCheckout = Date.valueOf(request.getParameter("dataSaida")); 
            int numAdultos = Integer.parseInt(request.getParameter("numAdultos")); 
            int numCriancas = Integer.parseInt(request.getParameter("numCriancas")); 

            // REGRA 1: VALIDAÇÃO DO LIMITE DE DIAS (7 DIAS)
            long diffMillis = dataCheckout.getTime() - dataCheckin.getTime();
            long dias = TimeUnit.DAYS.convert(diffMillis, TimeUnit.MILLISECONDS);

            if (dias > 7 || dias <= 0) {
                response.sendRedirect("quartos.jsp?erro=limite_dias");
                return;
            }
            
            // REGRA 2: BUSCA E VALIDAÇÃO DE CAPACIDADE
            Quartos quarto = quartoDAO.buscarporId(idQuarto); 
            
            if (quarto == null || (numAdultos + numCriancas) > quarto.getCapacidadeMaxima()) {
                 response.sendRedirect("quartos.jsp?erro=capacidade_excedida");
                 return;
            }
            
            // REGRA 3: VERIFICAÇÃO DE DISPONIBILIDADE (Onde o erro de 'sempre ocupado' ocorre)
            if (!reservaDAO.verificarDisponibilidade(idQuarto, dataCheckin, dataCheckout)) {
                response.sendRedirect("quartos.jsp?erro=indisponivel");
                return;
            }
            
            // REGRA 4: CÁLCULO DO VALOR
            double precoDiaria = quarto.getPrecoDiaria();
            double valorTotal = dias * precoDiaria;
            
            // 5. INSERÇÃO DA RESERVA
            Reserva novaReserva = new Reserva();
            novaReserva.setIdHospede(idHospede);
            novaReserva.setIdQuarto(idQuarto);
            novaReserva.setDataCheckin(dataCheckin);
            novaReserva.setDataCheckout(dataCheckout);
            novaReserva.setStatus("PENDENTE"); 
            novaReserva.setNumAdultos(numAdultos);
            novaReserva.setNumCriancas(numCriancas);
            novaReserva.setValorTotal(valorTotal);
            
            int idReservaGerada = reservaDAO.inserir(novaReserva); 

            // 6.FLUXO DE PAGAMENTO: Redireciona
            response.sendRedirect("pagamento.jsp?id_reserva=" + idReservaGerada); 
            
        } catch (NumberFormatException e) {
            response.sendRedirect("quartos.jsp?erro=dados_invalidos");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("quartos.jsp?erro=erro_interno"); 
        }
    }
}