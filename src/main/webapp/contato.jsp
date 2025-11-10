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
    <h2>Fale Conosco</h2>
    <p>Você pode entrar em contato conosco pelos seguintes canais:</p>
    <ul>
      <li>📞 Telefone: (47) 99999-0000</li>
      <li>📧 E-mail: contato@azuldomar.com</li>
      <li>📍 Endereço: Rua das Ondas, 123 – Bombinhas, SC</li>
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
   <%@ include file="_footer.jsp" %>
    </body>
    </html>

