package controles;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import modelos.Hospedes;

@WebFilter("/admin/*") // Protege todas as URLs que começam com /admin/
public class AdminFilter implements Filter {

    public AdminFilter() {}

	public void destroy() {}

    /**
     * Verifica se o usuário logado é o Administrador (idHospede == 1).
     */
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        // Converte para objetos HTTP específicos
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        
        HttpSession session = req.getSession(false); // Não cria nova sessão se não existir
        Hospedes usuarioLogado = null;

        if (session != null) {
            usuarioLogado = (Hospedes) session.getAttribute("usuarioLogado");
        }
        
        // 1. VERIFICAÇÃO: O usuário está logado?
        if (usuarioLogado == null) {
            // Se não estiver logado, redireciona para a tela de login
            res.sendRedirect(req.getContextPath() + "/entrar.jsp?erro=acesso_restrito");
            return;
        }

        // 2. VERIFICAÇÃO: O usuário é o Administrador?
        // Assumimos que o Admin tem o ID fixo = 1 no banco de dados.
        if (usuarioLogado.getIdHospede() != 1) {
            // Se não for o Admin, redireciona para uma página de erro ou index
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Acesso negado. Apenas Administradores.");
            return;
        }

        // 3. Permite o prosseguimento da requisição (se for Admin)
		chain.doFilter(request, response);
	}

	public void init(FilterConfig fConfig) throws ServletException {}
}