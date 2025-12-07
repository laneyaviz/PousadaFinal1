<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Entrar - Pousada Azul do Mar</title>
<link rel="stylesheet" href="css/style.css">

<%-- Bloco de estilo ADICIONAL para focar no formulário como caixa CENTRALIZADA --%>
<style>
    .form-page-container {
        /* Centraliza a caixa na página */
        display: flex;
        justify-content: center;
        align-items: center;
        padding: 40px 0;
        min-height: 80vh; 
    }
    
    .form-container {
        /* Cria o efeito de "caixa" (card) */
        background-color: #ffffff; 
        padding: 30px 40px;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); 
        width: 100%;
        max-width: 400px; /* Largura da caixa de login */
        text-align: center; /* Centraliza h2 e parágrafos */
    }

    .form-container h2 {
        margin-bottom: 25px;
        color: #333;
    }
    
    .login-form-content {
        /* Estilos específicos do formulário para garantir o alinhamento */
        text-align: left; /* Alinha labels à esquerda dentro da caixa */
    }

    .login-form-content label {
        display: block; 
        margin-top: 15px;
        margin-bottom: 5px;
        font-weight: bold;
        color: #555;
    }

    /* Garante que os inputs preencham 100% da largura da caixa */
    .login-form-content input[type="email"],
    .login-form-content input[type="password"] {
        width: 100%; 
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 4px;
        box-sizing: border-box; 
        font-size: 16px;
        margin-bottom: 0px; /* Remove o espaçamento extra do <br><br> original */
    }

    /* Estilização do botão */
    .form-container .btn-primary {
        width: 100%;
        padding: 12px;
        margin-top: 30px;
        background-color: #007bff;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-size: 18px;
        transition: background-color 0.3s;
    }
    
    .form-container .btn-primary:hover {
        background-color: #0056b3;
    }

    /* Estilo para a mensagem de erro */
    .error-message {
        color: red;
        font-weight: bold;
        text-align: center;
        margin-bottom: 15px;
    }
</style>
</head>
<body>
<%@ include file="_header.jsp" %>

<div class="form-page-container">
    <main class="form-container">
      <h2>Entrar</h2>

      <%-- Exibe mensagem de ERRO com classe específica --%>
      <% if (request.getAttribute("erroLogin") != null) { %>
        <p class="error-message"><%= request.getAttribute("erroLogin") %></p>
      <% } %>

      <form action="${pageContext.request.contextPath}/LoginServlet" method="post" class="login-form-content">
        <label for="email">E-mail:</label>
        <input type="email" name="email" required>
        
        <label for="senha">Senha:</label>
        <input type="password" name="senha" required>
        
        <button type="submit" class="btn btn-primary">Entrar</button>
      </form>

      <p style="margin-top:20px;">Não tem uma conta? <a href="registrar.jsp">Registre-se</a></p>
    </main>
</div>

<%@ include file="_footer.jsp" %>
</body>
</html>