package controles;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Invalida a sessão atual (encerra login)
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        // Redireciona para a tela de login com mensagem
        response.sendRedirect("entrar.jsp?logout=sucesso");
    }
}
