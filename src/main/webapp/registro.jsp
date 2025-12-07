<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Pousada Azul do Mar - Registro</title>
    <link rel="stylesheet" href="css/style.css" />
    
    <%-- Bloco de estilo ADICIONAL para focar no formulário como caixa CENTRALIZADA --%>
    <style>
        /* CSS para a centralização da página e o efeito de 'caixa' no formulário */
        
        .form-page-container {
            /* ESTA SEÇÃO CENTRALIZA O CONTEÚDO NO MEIO DA PÁGINA */
            display: flex;
            justify-content: center; /* Centraliza horizontalmente */
            align-items: center;     /* Centraliza verticalmente (se a altura for suficiente) */
            padding: 40px 0;
            min-height: 80vh; 
            /* background-color: #f8f8f8; <- REMOVIDO, MANTENDO O FUNDO PADRÃO */
        }
        
        .form-container {
            /* ESTA SEÇÃO CRIA O EFEITO DE 'CAIXA' */
            background-color: #ffffff; /* Fundo branco para a caixa */
            padding: 30px 40px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); /* Sombra */
            width: 100%;
            max-width: 400px; /* Largura fixa da caixa */
        }

        .form-container h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #333;
        }
        
        .form-container form label {
            display: block; 
            margin-top: 15px;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }

        /* Garante que os inputs preencham 100% da largura da caixa */
        .form-container form input[type="text"],
        .form-container form input[type="tel"],
        .form-container form input[type="email"],
        .form-container form input[type="password"] {
            width: 100%; 
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box; 
            font-size: 16px;
        }
        
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
        
        .form-container p {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
        }
        
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
            <h2>Criar Conta</h2>
            
            <%-- Exibir mensagem de ERRO com classe específica --%>
            <% 
            String erroCadastro = (String) request.getAttribute("erroCadastro");
            if (erroCadastro != null) { %>
                <p class="error-message"><%= erroCadastro %></p>
            <% } %>

            <form action="HospedeServlet" method="post">
                <label for="nome">Nome Completo:</label>
                <input type="text" id="nome" name="nome" required>
                
                <label for="telefone">Telefone:</label>
                <input type="tel" id="telefone" name="telefone" required>
                
                <label for="email">E-mail:</label>
                <input type="email" id="email" name="email" required>
                
                <label for="senha">Senha:</label>
                <input type="password" id="senha" name="senha" required>
                
                <button type="submit" class="btn btn-primary">Registrar</button>
                <p>Já tem conta? <a href="entrar.jsp">Faça login aqui.</a></p>
            </form>
        </main>
    </div>

    <%@ include file="_footer.jsp" %>
</body>
</html>