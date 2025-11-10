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
<section class="hero">
    <div class="container hero-content">
      <h2>Bem-vindo ao Paraíso</h2>
      <p>Desfrute de momentos únicos à beira-mar em nossa pousada aconchegante. Conforto, tranquilidade e a beleza natural de Santa Catarina.</p>
      <div class="hero-buttons">
      </div>
    </div>
  </section>

  <section class="rooms">
    <div class="container">
      <h2 class="text-center">Nossos Quartos</h2>
      <div class="room-list">
        <div class="room-card">
          <img src="imagens/QuartoVistaMar.jpg" alt="Quarto Vista Mar">
          <h3>Quarto Vista Mar</h3>
          <p>Experimente o nascer do sol sobre o oceano. Acomoda até 4 pessoas.</p>
          <span class="preco">R$ 280/noite</span>
          <a href="quartos.html#quarto-vista-mar" class="btn btn-primary">Ver Mais</a>
        </div>
        <div class="room-card">
          <img src="imagens/QuartoSuite.jpg" alt="Suíte Família">
          <h3>Suíte Família</h3>
          <p>Conforto e espaço para toda a família. Acomoda até 6 pessoas.</p>
          <span class="preco">R$ 450/noite</span>
          <a href="quartos.html#suite-familia" class="btn btn-primary">Ver Mais</a>
        </div>
        <div class="room-card">
          <img src="imagens/QuartoStandard.avif" alt="Quarto Standard">
          <h3>Quarto Standard</h3>
          <p>Perfeito para casais, com todo o conforto e privacidade. Acomoda 2 pessoas.</p>
          <span class="preco">R$ 180/noite</span>
          <a href="quartos.html#quarto-standard" class="btn btn-primary">Ver Mais</a>
        </div>
      </div>
    </div>
  </section>

  <!-- 💬 Depoimentos de hóspedes -->
  <section class="testimonials">
    <div class="container">
      <h2>O que dizem nossos hóspedes</h2>
      <div class="testimonial-list">
        <!-- Depoimento 1 -->
        <div class="testimonial-card">
          <div class="avatar">
            <img src="imagens/paula.jpg" alt="Paula" />
          </div>
          <p>“Lugar incrível! A vista do mar é deslumbrante e o atendimento é excepcional. Voltaremos com certeza!”</p>
          <span>– Paula</span>
          <div class="stars">⭐⭐⭐⭐⭐</div>
        </div>

        <!-- Depoimento 2 -->
        <div class="testimonial-card">
          <div class="avatar">
            <img src="imagens/lucas.jpg" alt="Lucas" />
          </div>
          <p>“Perfeito para relaxar! Quartos limpos, café da manhã delicioso e funcionários muito atenciosos.”</p>
          <span>– Lucas</span>
          <div class="stars">⭐⭐⭐⭐⭐</div>
        </div>
      </div>
    </div>
  </section>

  <section class="contact">
    <div class="container">
      <h2 class="text-center">Fale Conosco</h2>
      <form id="contactForm">
        <label for="nome">Nome:</label>
        <input type="text" id="nome" required>
        <label for="email">E-mail:</label>
        <input type="email" id="email" required>
        <label for="mensagem">Mensagem:</label>
        <textarea id="mensagem" rows="4" required></textarea>
        <button type="submit" class="btn btn-primary">Enviar Mensagem</button>
      </form>
    </div>
  </section>
<%@ include file="_footer.jsp" %>

</body>
</html>
    





