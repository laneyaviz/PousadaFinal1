<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Entrar - Pousada Azul do Mar</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>
<%@ include file="_header.jsp" %>

<main style="text-align:center;padding:40px;">
  <h2>Entrar</h2>

  <% if (request.getAttribute("erroLogin") != null) { %>
    <p style="color:red;"><%= request.getAttribute("erroLogin") %></p>
  <% } %>

  <form action="${pageContext.request.contextPath}/LoginServlet" method="post" style="max-width:300px;margin:auto;">
    <label for="email">E-mail:</label><br>
    <input type="email" name="email" required><br><br>
    <label for="senha">Senha:</label><br>
    <input type="password" name="senha" required><br><br>
    <button type="submit" class="btn btn-primary">Entrar</button>
  </form>

  <p style="margin-top:10px;">Não tem uma conta? <a href="registrar.jsp">Registre-se</a></p>
</main>

<%@ include file="_footer.jsp" %>
</body>
</html>
