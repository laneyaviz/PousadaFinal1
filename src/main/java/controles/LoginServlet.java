package controles;

import java.io.IOException;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt; 

import DAO.HospedeDAO;
import modelos.Hospedes;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private HospedeDAO hospedeDAO;

    public LoginServlet() {
        super();
        this.hospedeDAO = new HospedeDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String senha = request.getParameter("senha"); 

        Hospedes hospede = hospedeDAO.buscarPorEmail(email); 

        if (hospede != null) {
            
            if (BCrypt.checkpw(senha, hospede.getSenha())) { 
                
                HttpSession session = request.getSession();
                
                session.setAttribute("usuarioLogado", hospede);
                
                response.sendRedirect(request.getContextPath() + "/index.jsp"); 
                return;
            }
        }

        
        request.setAttribute("erroLogin", "E-mail ou senha inválidos.");
        
        RequestDispatcher rd = request.getRequestDispatcher("entrar.jsp");
        rd.forward(request, response);
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String acao = request.getParameter("acao");
        
        if ("logout".equals(acao)) {
            request.getSession().invalidate();
            
            response.sendRedirect(request.getContextPath() + "/entrar.jsp?logout=sucesso");
        } else {
             response.sendRedirect(request.getContextPath() + "/entrar.jsp");
        }
    }
}