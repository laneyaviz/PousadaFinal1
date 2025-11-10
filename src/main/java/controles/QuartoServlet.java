package controles; 

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import DAO.QuartoDAO;
import modelos.Quartos;


@WebServlet("/QuartoServlet")
public class QuartoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private QuartoDAO quartoDAO;

    @Override
    public void init() throws ServletException {
        quartoDAO = new QuartoDAO();
        
        // ** INÍCIO DA LÓGICA DE INICIALIZAÇÃO DE DADOS **
        try {
            // Verifica se a tabela está vazia (0 quartos)
            if (quartoDAO.contarQuartos() == 0) {
                
                System.out.println("Tabela de quartos vazia. Inserindo dados iniciais...");
                
                // Quarto 1: Standard
                Quartos q1 = new Quartos();
                q1.setNumero(101);
                q1.setTipo("Quarto Standard");
                q1.setDescricao("Quarto Standard, ideal para uma viagem rápida.");
                q1.setPrecoDiaria(150.00);
                q1.setCapacidadeMaxima(2);
                q1.setDisponivel(true); // DISPONÍVEL!
                quartoDAO.inserir(q1); 

                // Quarto 2: Luxo
                Quartos q2 = new Quartos();
                q2.setNumero(202);
                q2.setTipo("Suíte Família");
                q2.setDescricao("Suíte espaçosa com vista para o mar, perfeita para famílias.");
                q2.setPrecoDiaria(350.00);
                q2.setCapacidadeMaxima(4);
                q2.setDisponivel(true); // DISPONÍVEL!
                quartoDAO.inserir(q2);

                System.out.println("✅ Dois quartos iniciais inseridos com sucesso.");
            } else {
                System.out.println("Tabela de quartos já contém dados. Inicialização automática ignorada.");
            }
        } catch (Exception e) {
            System.err.println("❌ Erro ao tentar inicializar quartos no banco de dados. Verifique a conexão e o QuartoDAO.");
            e.printStackTrace();
        }
        // ** FIM DA LÓGICA DE INICIALIZAÇÃO DE DADOS **
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String acao = request.getParameter("acao");
        
        if (acao == null) {
            acao = "listar"; 
        }

        try {
            switch (acao) {
                case "listar":
                    listarQuartos(request, response);
                    break;
                case "editar":
                    exibirFormularioEdicao(request, response);
                    break;
                case "deletar":
                    deletarQuarto(request, response);
                    break;
                default:
                    listarQuartos(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String acao = request.getParameter("acao");

        if (acao != null && acao.equals("salvar")) {
            salvarQuarto(request, response);
        } else if (acao != null && acao.equals("atualizar")) {
            atualizarQuarto(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/QuartoServlet?acao=listar");
        }
    }

    private void listarQuartos(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Quartos> listaQuartos = quartoDAO.listarTodos();
        request.setAttribute("quartos", listaQuartos);
        request.getRequestDispatcher("listar_quartos.jsp").forward(request, response);
    }
    
    private void salvarQuarto(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Quartos novoQuarto = new Quartos();
        
        try {
            String numeroStr = request.getParameter("numero");
            String capacidadeStr = request.getParameter("capacidadeMaxima");
            String precoStr = request.getParameter("precoDiaria");
            String disponivelStr = request.getParameter("disponivel"); 

            boolean disponivel = (disponivelStr != null);
            
            novoQuarto.setNumero(Integer.parseInt(numeroStr));
            novoQuarto.setCapacidadeMaxima(Integer.parseInt(capacidadeStr)); 
            novoQuarto.setPrecoDiaria(Double.parseDouble(precoStr));
            novoQuarto.setTipo(request.getParameter("tipo"));
            novoQuarto.setDescricao(request.getParameter("descricao"));
            novoQuarto.setDisponivel(disponivel); 

            quartoDAO.inserir(novoQuarto);
            
            response.sendRedirect(request.getContextPath() + "/QuartoServlet?acao=listar&msg=adicionado");
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/QuartoServlet?acao=listar&erro=Dados numéricos inválidos.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/QuartoServlet?acao=listar&erro=Falha ao salvar o novo quarto.");
        }
    }

    private void exibirFormularioEdicao(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Quartos quartoExistente = quartoDAO.buscarporId(id);
            
            if (quartoExistente != null) {
                request.setAttribute("quarto", quartoExistente);
                request.getRequestDispatcher("editar_quarto.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/QuartoServlet?acao=listar&erro=quarto_nao_encontrado");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/QuartoServlet?acao=listar&erro=id_invalido");
        }
    }
    
    private void atualizarQuarto(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Quartos quartoAtualizado = new Quartos();
        
        try {
            int id = Integer.parseInt(request.getParameter("idQuarto"));
            String numeroStr = request.getParameter("numero");
            String capacidadeStr = request.getParameter("capacidadeMaxima");
            String precoStr = request.getParameter("precoDiaria");
            String disponivelStr = request.getParameter("disponivel");

            boolean disponivel = (disponivelStr != null);
            
            quartoAtualizado.setIdQuarto(id);
            quartoAtualizado.setNumero(Integer.parseInt(numeroStr));
            quartoAtualizado.setCapacidadeMaxima(Integer.parseInt(capacidadeStr));
            quartoAtualizado.setPrecoDiaria(Double.parseDouble(precoStr));
            quartoAtualizado.setTipo(request.getParameter("tipo"));
            quartoAtualizado.setDescricao(request.getParameter("descricao"));
            quartoAtualizado.setDisponivel(disponivel);

            quartoDAO.atualizar(quartoAtualizado); 
            
            response.sendRedirect(request.getContextPath() + "/QuartoServlet?acao=listar&msg=atualizado");
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/QuartoServlet?acao=listar&erro=Dados de edição inválidos.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/QuartoServlet?acao=listar&erro=Falha ao atualizar o quarto.");
        }
    }

    private void deletarQuarto(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            quartoDAO.deletar(id);
            response.sendRedirect(request.getContextPath() + "/QuartoServlet?acao=listar&msg=deletado");
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/QuartoServlet?acao=listar&erro=id_invalido");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/QuartoServlet?acao=listar&erro=Falha ao deletar o quarto.");
        }
    }
}