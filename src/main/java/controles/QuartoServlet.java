package controles;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
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

    private QuartoDAO quartoDAO = new QuartoDAO(); 

    public QuartoServlet() {
        super();
    }

    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String acao = request.getParameter("acao");
        if (acao == null) {
            acao = "listar"; // Ação padrão
        }

        try {
            switch (acao) {
                case "listar":
                    listarQuartos(request, response);
                    break;
                case "editar":
                    editarQuarto(request, response);
                    break;
                case "deletar":
                    deletarQuarto(request, response);
                    break;
                default:
                    listarQuartos(request, response);
                    break;
            }
        } catch (Exception ex) {
            throw new ServletException("Erro na execução da ação GET: " + acao, ex);
        }
    }


    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8"); 
        
        String acao = request.getParameter("acao");

        try {
            if ("salvar".equals(acao)) {
                salvarQuarto(request, response); 
            } else if ("atualizar".equals(acao)) {
                atualizarQuarto(request, response); 
            } else {
                doGet(request, response); 
            }
        } catch (Exception ex) {
            throw new ServletException("Erro na execução da ação POST: " + acao, ex);
        }
    }
    
    
    private void listarQuartos(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        
        List<Quartos> listaQuartos = quartoDAO.getAll();
        request.setAttribute("quartos", listaQuartos);
        
        RequestDispatcher rd = request.getRequestDispatcher("listar_quartos.jsp");
        rd.forward(request, response);
    }
    
    private void editarQuarto(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Quartos quarto = quartoDAO.buscarPorId(id);
            
            if (quarto != null) {
                request.setAttribute("quarto", quarto);
                RequestDispatcher rd = request.getRequestDispatcher("editar_quarto.jsp");
                rd.forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/QuartoServlet?acao=listar&erro=quarto_nao_encontrado");
            }
        } catch (NumberFormatException e) {
             response.sendRedirect(request.getContextPath() + "/QuartoServlet?acao=listar&erro=id_invalido");
        }
    }
    
    private void deletarQuarto(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            quartoDAO.deletar(id);
            response.sendRedirect(request.getContextPath() + "/QuartoServlet?acao=listar&msg=deletado");
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/QuartoServlet?acao=listar&erro=id_invalido");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/QuartoServlet?acao=listar&erro=nao_pode_deletar");
        }
    }

    
    private void salvarQuarto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int numero = Integer.parseInt(request.getParameter("numero"));
            String tipo = request.getParameter("tipo");
            double precoDiaria = Double.parseDouble(request.getParameter("precoDiaria"));
            int capacidadeMaxima = Integer.parseInt(request.getParameter("capacidadeMaxima"));
            String descricao = request.getParameter("descricao");
            
            String statusParam = request.getParameter("status");
            boolean status = Boolean.parseBoolean(statusParam != null ? statusParam : "true"); 

            Quartos novoQuarto = new Quartos();
            novoQuarto.setNumero(numero);
            novoQuarto.setTipo(tipo);
            novoQuarto.setPrecoDiaria(precoDiaria);
            novoQuarto.setCapacidadeMaxima(capacidadeMaxima);
            novoQuarto.setDescricao(descricao);
            novoQuarto.setDisponivel(status); 

            quartoDAO.salvar(novoQuarto); 

            response.sendRedirect(request.getContextPath() + "/QuartoServlet?acao=listar&msg=cadastrado");

        } catch (NumberFormatException e) {
            request.setAttribute("erro", "Erro de formato nos dados. Verifique 'Número', 'Preço' e 'Capacidade'.");
            RequestDispatcher rd = request.getRequestDispatcher("cadastrar_quarto.jsp");
            rd.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erro", "Erro ao salvar o quarto: " + e.getMessage());
            RequestDispatcher rd = request.getRequestDispatcher("cadastrar_quarto.jsp");
            rd.forward(request, response);
        }
    }

    
    private void atualizarQuarto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("idQuarto"); 
        
        try {
            int id = Integer.parseInt(idParam); // 🚨 CRÍTICO: ID é obrigatório para atualização
            int numero = Integer.parseInt(request.getParameter("numero"));
            String tipo = request.getParameter("tipo");
            double precoDiaria = Double.parseDouble(request.getParameter("precoDiaria"));
            int capacidadeMaxima = Integer.parseInt(request.getParameter("capacidadeMaxima"));
            String descricao = request.getParameter("descricao");
            boolean status = Boolean.parseBoolean(request.getParameter("status")); 

            Quartos quartoAtualizado = new Quartos();
            quartoAtualizado.setIdQuarto(id); // 🚨 CRÍTICO: Define o ID
            quartoAtualizado.setNumero(numero);
            quartoAtualizado.setTipo(tipo);
            quartoAtualizado.setPrecoDiaria(precoDiaria);
            quartoAtualizado.setCapacidadeMaxima(capacidadeMaxima);
            quartoAtualizado.setDescricao(descricao);
            quartoAtualizado.setDisponivel(status); 

            quartoDAO.atualizar(quartoAtualizado); // Chama o método UPDATE do DAO

            response.sendRedirect(request.getContextPath() + "/QuartoServlet?acao=listar&msg=atualizado");

        } catch (NumberFormatException e) {
            request.setAttribute("erro", "Erro de formato nos dados. Verifique 'Número', 'Preço' e 'Capacidade'.");
            recarregarEdicaoComErro(request, response, idParam, "editar_quarto.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erro", "Erro ao atualizar o quarto: " + e.getMessage());
            recarregarEdicaoComErro(request, response, idParam, "editar_quarto.jsp");
        }
    }
    

    private void recarregarEdicaoComErro(HttpServletRequest request, HttpServletResponse response, 
                                        String idParam, String jspDestino) throws ServletException, IOException {
        try {
             int id = Integer.parseInt(idParam);
             Quartos quarto = quartoDAO.buscarPorId(id);
             request.setAttribute("quarto", quarto); 
             
             RequestDispatcher rd = request.getRequestDispatcher(jspDestino);
             rd.forward(request, response);
        } catch (Exception ex) {
             response.sendRedirect(request.getContextPath() + "/QuartoServlet?acao=listar&erro=erro_validacao");
        }
    }
}