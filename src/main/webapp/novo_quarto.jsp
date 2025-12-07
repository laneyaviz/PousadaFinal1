<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin - Novo Quarto</title>
    <link rel="stylesheet" href="css/style.css"/>
    
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
            max-width: 500px; /* Mantém a largura máxima original de 500px */
            text-align: center; /* Centraliza o título */
        }

        .form-container h2 {
            margin-bottom: 25px;
            color: #333;
        }
        
        .admin-form-content {
            /* Estilos específicos do formulário para garantir o alinhamento */
            text-align: left; /* Alinha labels e campos à esquerda dentro da caixa */
        }

        .admin-form-content label {
            display: block; 
            margin-top: 15px;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }

        /* Garante que os inputs, textarea e select preencham 100% da largura da caixa */
        .admin-form-content input[type="number"],
        .admin-form-content input[type="text"],
        .admin-form-content textarea,
        .admin-form-content select {
            width: 100%; 
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box; 
            font-size: 16px;
        }

        /* Botão Salvar */
        .admin-form-content .btn-primary {
            /* Mantido o width 100% para alinhamento total */
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
        
        .admin-form-content .btn-primary:hover {
            background-color: #0056b3;
        }
        
        .link-container {
            text-align: center;
            margin-top: 15px;
        }
        
        /* Ajuste para o botão voltar */
        .btn-secondary {
            display: inline-block;
            padding: 10px 20px;
            background-color: #6c757d;
            color: white;
            border-radius: 4px;
            text-decoration: none;
            transition: background-color 0.3s;
        }
        
        .btn-secondary:hover {
            background-color: #5a6268;
        }
    </style>
</head>
<body>
    <%@ include file="_header.jsp" %>
    
    <div class="form-page-container">
        <main class="form-container">
            <h2>👑 Adicionar Novo Quarto</h2>
            
            <form action="<%= request.getContextPath() %>/QuartoServlet" method="post" class="admin-form-content">
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
                
                <button type="submit" class="btn btn-primary">Salvar Quarto</button>
            </form>
            
            <div class="link-container">
                <a href="<%= request.getContextPath() %>/QuartoServlet?acao=listar" class="btn btn-secondary">Voltar para a Lista</a>
            </div>
        </main>
    </div>
    
    <%@ include file="_footer.jsp" %>
</body>
</html>