package controles;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import DAO.HospedeDAO;
import modelos.Hospedes;

@WebServlet("/HospedeServlet")
public class HospedeServlet extends HttpServlet{
	private static final long serialVersionUID = 1L;
	
    /**
     * Tratamento de requisições POST: Realiza o Cadastro de um novo Hóspede.
     */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            Hospedes hospede = new Hospedes();
            hospede.setNome(request.getParameter("nome"));
            hospede.setTelefone(request.getParameter("telefone"));
            hospede.setEmail(request.getParameter("email"));
            hospede.setSenha(request.getParameter("senha")); 

            // Salva o novo hóspede no banco
            new HospedeDAO().salvar(hospede);
            
            // Redireciona para a página de login com mensagem de sucesso
            response.sendRedirect("entrar.jsp?cadastro=sucesso");

        } catch (RuntimeException e) {
            // Em caso de erro (ex: e-mail duplicado, erro de banco), volta para o cadastro com erro
            System.err.println("Erro ao salvar hóspede: " + e.getMessage());
            request.setAttribute("erroCadastro", "Erro ao cadastrar. E-mail já pode estar em uso ou dados inválidos.");
            request.getRequestDispatcher("cadastro.jsp").forward(request, response);
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Redireciona qualquer GET para a página de cadastro.
        response.sendRedirect("cadastro.jsp");
    }
}