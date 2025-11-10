<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Pousada Azul do Mar - Registro</title>
    <link rel="stylesheet" href="css/style.css" />
</head>
<body>
    <%@ include file="_header.jsp" %>
    
    <main class="container" style="padding:40px 0;">
        <h2>Criar Conta</h2>
        
        <%-- 🚨 MUDANÇA: Exibir mensagem de ERRO do HospedeServlet (via RequestDispatcher) --%>
        <% 
String erroCadastro = (String) request.getAttribute("erroCadastro");
           if (erroCadastro != null) { %>
            <p style="color: red; font-weight: bold;"><%= erroCadastro %></p>
        <% } %>

        <form action="HospedeServlet" method="post">
            <label for="nome">Nome Completo:</label>
            <input type="text" id="nome" name="nome" required>
            
          
  <label for="telefone">Telefone:</label>
            <input type="tel" id="telefone" name="telefone" required>
            
            <label for="email">E-mail:</label>
            <input type="email" id="email" name="email" required>
            
            <label for="senha">Senha:</label>
            <input type="password" id="senha" 
name="senha" required>
            
            <button type="submit" class="btn btn-primary">Registrar</button>
            <p style="margin-top: 15px;">Já tem conta? <a href="entrar.jsp">Faça login aqui.</a></p>
        </form>
    </main>

    <%@ include file="_footer.jsp" %>
</body>
</html>