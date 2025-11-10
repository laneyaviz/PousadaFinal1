<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="modelos.Quartos" %>
<% 
    // Tenta obter o objeto Quarto do request
    Quartos quarto = (Quartos) request.getAttribute("quarto");

    // Verifica se o objeto quarto é nulo (erro de busca)
    if (quarto == null) {
        // Redireciona de volta para a listagem ou exibe uma mensagem de erro
        response.sendRedirect(request.getContextPath() + "/QuartoServlet?acao=listar&erro=quarto_nao_encontrado");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Editar Quarto <%= quarto.getNumero() %></title>
    <link rel="stylesheet" href="css/style.css"/>
    <style>
        /* Estilos básicos para formulário de administração */
        .form-admin {
            max-width: 500px;
            margin: 0 auto;
            padding: 30px;
            border: 1px solid #ccc;
            border-radius: 8px;
            background-color: #f9f9f9;
        }
    </style>
</head>
<body>
    
    <%-- O Admin deve estar logado. O header.jsp será incluído. --%>
    <%@ include file="_header.jsp" %>

    <main class="container" style="padding: 40px 0;">
        <div class="form-admin">
            <h2>Editar Quarto #<%= quarto.getNumero() %></h2>
            
            <form action="<%= request.getContextPath() %>/QuartoServlet" method="post">
                <input type="hidden" name="acao" value="atualizar">
                <input type="hidden" name="idQuarto" value="<%= quarto.getIdQuarto() %>">
                
                <label for="numero">Número do Quarto:</label>
                <input type="number" id="numero" name="numero" value="<%= quarto.getNumero() %>" required>

                <label for="tipo">Tipo de Quarto:</label>
                <select id="tipo" name="tipo" required>
                    <option value="Quarto Vista Mar" <%= "Quarto Vista Mar".equals(quarto.getTipo()) ? "selected" : "" %>>Quarto Vista Mar</option>
                    <option value="Suíte Família" <%= "Suíte Família".equals(quarto.getTipo()) ? "selected" : "" %>>Suíte Família</option>
                    <option value="Quarto Standard" <%= "Quarto Standard".equals(quarto.getTipo()) ? "selected" : "" %>>Quarto Standard</option>
                    <option value="Outro" <%= !"Quarto Vista Mar".equals(quarto.getTipo()) && !"Suíte Família".equals(quarto.getTipo()) && !"Quarto Standard".equals(quarto.getTipo()) ? "selected" : "" %>>Outro</option>
                </select>

                <label for="precoDiaria">Preço da Diária (R$):</label>
                <input type="number" step="0.01" id="precoDiaria" name="precoDiaria" value="<%= quarto.getPrecoDiaria() %>" required>

                <label for="capacidadeMaxima">Capacidade Máxima:</label>
                <input type="number" id="capacidadeMaxima" name="capacidadeMaxima" value="<%= quarto.getCapacidadeMaxima() %>" min="1" required>

                <label for="descricao">Descrição:</label>
                <textarea id="descricao" name="descricao" rows="4"><%= quarto.getDescricao() != null ? quarto.getDescricao() : "" %></textarea>

                <label for="status">Status (Disponível para Reservas):</label>
                <select id="status" name="status" required>
                    <!-- 🚨 Correção: Usando isDisponivel() do modelo para pré-seleção -->
                    <option value="true" <%= quarto.isDisponivel() ? "selected" : "" %>>Livre (Disponível)</option>
                    <option value="false" <%= !quarto.isDisponivel() ? "selected" : "" %>>Ocupado/Manutenção</option>
                </select>
                
                <button type="submit" class="btn btn-primary" style="margin-top: 20px;">Salvar Alterações</button>
                <a href="<%= request.getContextPath() %>/QuartoServlet?acao=listar" class="btn btn-secondary">Voltar</a>
            </form>
        </div>
    </main>

    <%@ include file="_footer.jsp" %>
</body>
</html>