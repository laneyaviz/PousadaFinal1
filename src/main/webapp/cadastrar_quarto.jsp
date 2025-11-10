<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cadastrar Novo Quarto</title>
    <link rel="stylesheet" href="css/style.css"/>
    <style>
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
    
    <%@ include file="_header.jsp" %>

    <main class="container" style="padding: 40px 0;">
        <div class="form-admin">
            <h2>Cadastrar Novo Quarto</h2>
            
            <%-- Exibir mensagem de erro do Servlet --%>
            <% String erro = (String) request.getAttribute("erro");
               if (erro != null) { %>
                <p style="color: red; font-weight: bold;"><%= erro %></p>
            <% } %>

            
            <form action="<%= request.getContextPath() %>/QuartoServlet" method="post">
                
                <input type="hidden" name="acao" value="salvar">

                <label for="numero">Número do Quarto:</label>
                <input type="number" id="numero" name="numero" required>

                <label for="tipo">Tipo de Quarto:</label>
                <select id="tipo" name="tipo" required>
                    <option value="Quarto Vista Mar">Quarto Vista Mar</option>
                    <option value="Suíte Família">Suíte Família</option>
                    <option value="Quarto Standard">Quarto Standard</option>
                    <option value="Outro">Outro</option>
                </select>

                <label for="precoDiaria">Preço da Diária (R$):</label>
                <input type="number" step="0.01" id="precoDiaria" name="precoDiaria" required>

                <label for="capacidadeMaxima">Capacidade Máxima:</label>
                <input type="number" id="capacidadeMaxima" name="capacidadeMaxima" min="1" required>

                <label for="descricao">Descrição:</label>
                <textarea id="descricao" name="descricao" rows="4"></textarea>

                <%-- Status para novo quarto deve ser "true" (Disponível) --%>
                <input type="hidden" name="status" value="true">
                
                <button type="submit" class="btn btn-primary" style="margin-top: 20px;">Salvar Quarto</button>
                <a href="<%= request.getContextPath() %>/QuartoServlet?acao=listar" class="btn btn-secondary">Cancelar</a>
            </form>
        </div>
    </main>

    <%@ include file="_footer.jsp" %>
</body>
</html>