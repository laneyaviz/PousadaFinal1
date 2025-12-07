<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Pousada Azul do Mar</title>
  <link rel="stylesheet" href="css/style.css" />
  
  <%-- Bloco de estilo ADICIONAL para focar o conteúdo na caixa CENTRALIZADA --%>
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
        max-width: 500px; /* Largura adequada para formulário de contato */
    }

    .form-container h2,
    .form-container h3 {
        color: #333;
        margin-bottom: 15px;
    }
    
    /* 🚨 NOVO ESTILO: Lista de Contatos Aprimorada */
    .form-container .contact-list {
        list-style-type: none;
        padding-left: 0;
        margin-bottom: 30px; /* Mais espaço após a lista */
        display: grid;
        gap: 10px; /* Espaçamento entre os itens */
    }
    
    .form-container .contact-list li {
        background-color: #f7f7f7; /* Fundo leve para o bloco */
        padding: 12px 15px;
        border-radius: 6px;
        font-size: 16px;
        color: #333;
        display: flex; /* Para alinhar o ícone e o texto */
        align-items: center;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
    }

    .form-container .contact-list li strong {
        font-weight: bold;
        margin-right: 8px;
        color: #007bff; /* Cor de destaque para o rótulo/ícone */
    }

    .form-container .contact-list li span {
        font-weight: normal;
        color: #555;
    }

    /* Estilos para o formulário */
    #contactForm label {
        display: block; 
        margin-top: 15px;
        margin-bottom: 5px;
        font-weight: bold;
        color: #555;
    }

    /* Garante que os inputs e textarea preencham 100% da largura da caixa */
    #contactForm input[type="text"],
    #contactForm textarea {
        width: 100%; 
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 4px;
        box-sizing: border-box; 
        font-size: 16px;
    }

    /* Estilização do botão */
    #contactForm .btn-primary {
        width: 100%;
        padding: 12px;
        margin-top: 25px;
        background-color: #007bff;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-size: 18px;
        transition: background-color 0.3s;
    }
    
    #contactForm .btn-primary:hover {
        background-color: #0056b3;
    }
  </style>
</head>
<body>
    <%@ include file="_header.jsp" %>
    
    <div class="form-page-container">
        <main class="form-container">
            <h2>Fale Conosco</h2>
            <p>Você pode entrar em contato conosco pelos seguintes canais:</p>
            
            <ul class="contact-list">
                <li>
                    <strong>📞 Telefone:</strong> 
                    <span>(47) 99999-0000</span>
                </li>
                <li>
                    <strong>📧 E-mail:</strong> 
                    <span>contato@azuldomar.com</span>
                </li>
                <li>
                    <strong>📍 Endereço:</strong> 
                    <span>Rua das Ondas, 123 – Bombinhas, SC</span>
                </li>
            </ul>

            <h3>Envie sua mensagem</h3>
            <form id="contactForm">
                <label for="nome">Nome:</label>
                <input type="text" id="nome" required>
                <label for="mensagem">Mensagem:</label>
                <textarea id="mensagem" rows="4" required></textarea>
                <button type="submit" class="btn btn-primary">Enviar</button>
            </form>
        </main>
    </div>
    
   <%@ include file="_footer.jsp" %>
</body>
</html>