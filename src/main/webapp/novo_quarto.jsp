<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin - Novo Quarto</title>
    <link rel="stylesheet" href="css/style.css"/>
</head>
<body>
    <%@ include file="_header.jsp" %>
    
    <main class="container" style="padding: 40px 0;">
        <h2>👑 Adicionar Novo Quarto</h2>
        
        <!-- 🚨 CORREÇÃO: Usando request.getContextPath() na action -->
        <form action="<%= request.getContextPath() %>/QuartoServlet" method="post" style="max-width: 500px;">
            <input type="hidden" name="acao" value="salvar">
            
            <label for="numero">Número do Quarto:</label>
            <input type="number" id="numero" name="numero" required>
            
            <label for="tipo">Tipo:</label>
            <input type="text" id="tipo" name="tipo" required>

            <label for="capacidadeMaxima">Capacidade Máxima:</label>
            <input type="number" id="capacidadeMaxima" name="capacidadeMaxima" min="1" required>

            <label for="precoDiaria">Preço da Diária:</label>
            <input type="number" step="0.01" id="precoDiaria" name="precoDiaria" required>
            
            <label for="descricao">Descrição:</label>
            <textarea id="descricao" name="descricao" rows="4" required></textarea>
            
            <label for="status">Disponível (boolean):</label>
            <select id="status" name="status">
                <option value="true">Sim</option>
                <option value="false">Não</option>
            </select>
            
            <button type="submit" class="btn btn-primary" style="margin-top: 20px;">Salvar Quarto</button>
            
            <!-- 🚨 CORREÇÃO: Usando request.getContextPath() no link -->
            <a href="<%= request.getContextPath() %>/QuartoServlet?acao=listar" class="btn btn-secondary">Voltar</a>
        </form>
    </main>
    
    <%@ include file="_footer.jsp" %>
</body>
</html>