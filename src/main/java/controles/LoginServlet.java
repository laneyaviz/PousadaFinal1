package controles;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import DAO.HospedeDAO;
import modelos.Hospedes;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 1️⃣ Obtém parâmetros enviados do formulário
		String emailParam = request.getParameter("email");
		String senhaParam = request.getParameter("senha");

		// 2️⃣ Normaliza valores (remove espaços e evita NullPointer)
		String email = (emailParam != null) ? emailParam.trim() : "";
		String senha = (senhaParam != null) ? senhaParam.trim() : "";

		// 3️⃣ Prepara variáveis auxiliares
		HospedeDAO hospedeDAO = new HospedeDAO();
		Hospedes hospedeLogado = null;
		String mensagemErro = null;

		if (email.isEmpty() || senha.isEmpty()) {
			mensagemErro = "Por favor, preencha todos os campos antes de continuar.";
		} else {
			try {
				hospedeLogado = hospedeDAO.Login(email, senha);

				if (hospedeLogado != null) {
					
					// ✅ Login bem-sucedido → cria sessão
					HttpSession session = request.getSession();
					session.setAttribute("usuarioLogado", hospedeLogado);

					// Redireciona para página inicial ou painel
					response.sendRedirect("index.jsp");
					return;
				} else {
					// ❌ Login inválido
					mensagemErro = "E-mail ou senha incorretos.";
				}

			} catch (RuntimeException e) {
				// ❗ Erros inesperados (ex: banco, conexão)
				e.printStackTrace();
				mensagemErro = "Erro interno no sistema. Tente novamente mais tarde.";
			}
		}

		// 6️⃣ Retorna para página de login com mensagem de erro
		request.setAttribute("erroLogin", mensagemErro);
		RequestDispatcher rd = request.getRequestDispatcher("index.jsp");
		rd.forward(request, response);
	}
}
