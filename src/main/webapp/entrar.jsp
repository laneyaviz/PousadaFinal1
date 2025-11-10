<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <!DOCTYPE html>
    <html>
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Pousada Azul do Mar</title>

  <link rel="stylesheet" href="css/style.css" />
</head>
<body>

  
 <%@ include file="_header.jsp" %>
  <main class="container" style="padding:40px 0;">
  <h2>Entrar</h2>
  
  <%-- Exibir mensagem de erro do LoginServlet (via request.getAttribute, após forward) --%>
  <% String erro = (String) request.getAttribute("erroLogin");
if (erro != null) { %>
    <p style="color: red; font-weight: bold;"><%= erro %></p>
  <% } %>
  
  <%-- Exibir mensagem de sucesso do HospedeServlet (via parâmetro URL, após redirect) --%>
  <% if ("sucesso".equals(request.getParameter("cadastro"))) { %>
    <p style="color: green; font-weight: bold;">Cadastro realizado com sucesso! Faça login abaixo.</p>
  <% } %>
  
  <%-- Exibir erro de login necessário (usando parâmetro URL 'erro') --%>
  <% if ("login_necessario".equals(request.getParameter("erro"))) { %>
    <p style="color: red; font-weight: bold;">Você precisa estar logado para fazer uma reserva.</p>
  <% } %>
  
  <%-- Exibir mensagem de logout (usando parâmetro URL 'logout') --%>
  <% if ("sucesso".equals(request.getParameter("logout"))) { %>
    <p style="color: green; font-weight: bold;">Sessão encerrada com sucesso.</p>
  <% } %>
  
  <form id="loginForm" action="LoginServlet" method="post">
    <label for="loginEmail">E-mail:</label>
    <input type="email" name="email" id="loginEmail" required>
    <label for="loginSenha">Senha:</label>
    <input type="password" name="senha" id="loginSenha" required>
    <button type="submit" class="btn btn-primary">Login</button>
 
  </form>
  <p style="margin-top: 15px;">Não tem conta? <a href="registro.jsp">Crie uma aqui.</a></p>
</main>
 
   <%@ include file="_footer.jsp" %>
  <script src="js/script.js"></script>
</body>
</html>