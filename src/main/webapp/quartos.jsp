<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Pousada Azul do Mar</title>
<link rel="stylesheet" href="css/style.css"/>
<link rel="stylesheet" href="css/quartos.css">
</head>
<body>
<%@ include file="_header.jsp" %>

<%
    String erro = request.getParameter("erro");
    if (erro != null) {
        String mensagem = "";
        if ("limite_dias".equals(erro)) {
            mensagem = "A reserva não pode ultrapassar 7 dias.";
        } else if ("capacidade_excedida".equals(erro)) {
            mensagem = "O número de hóspedes excede a capacidade do quarto.";
        } else if ("indisponivel".equals(erro)) {
            mensagem = "O quarto não está disponível para os dados selecionados.";
        } else if ("dados_invalidos".equals(erro)) {
            mensagem = "Dados de entrada ou saída inválidos. Verifique os dados.";
        } else if ("login_necessario".equals(erro)) {
            mensagem = "Você precisa estar logado para fazer uma reserva.";
        } else if ("reserva_invalida".equals(erro)) {
            mensagem = "Erro ao processar a reserva. Tente novamente.";
        }

%>
    <p style="color: red; font-weight: bold; text-align: center; margin-top: 20px;"><%= mensagem %></p>
<% } %>
<div class="room-card" id="quarto-vista-mar">
    <div>
   <img src="imagens/QuartoVistaMar.jpg" align="left"/>
   </div>
      <h3>Quarto Vista Mar</h3>
   <p>Quarto com vista panorâmica para o mar, ar-condicionado e varanda privativa.
possui uma cama dupla e duas de solteiro com frigobar, acomoda 4 pessoas, café incluso</p>
   <ul class="comodidades">
      <li> Wi-Fi</li>
      <li> Ar-condicionado</li>
      <li> TV</li>
      <li> Frigobar</li>
</ul>
<span class="preco">R$ 280/noite</span>
<button class="btn btn-primary open-reserva" data-room="Quarto Vista Mar" data-id-quarto="1">Reservar</button>
</div>

<hr>
<div class="room-card" id="suite-familia">
  <div>
<img src="imagens/QuartoSuite.jpg" alt="Suíte Família" align="left"/>
  </div>
  <h3>Suíte Família</h3>
  <p>Suíte ampla com dois quartos interligados, ideal para famílias.
Acomoda até 6 pessoas. </p>
<ul class="comodidades">
      <li> Wi-Fi</li>
      <li> Ar-condicionado</li>
      <li> 2 TVs</li>
      <li> Frigobar</li>
      <li> Varanda</li>
      <li> Vista Jardim</li>
</ul>
<span class="preco">R$ 450/noite</span>
<button class="btn btn-primary open-reserva" data-room="Suíte Família" data-id-quarto="2">Reservar</button>
</div>

<hr>
<div class="room-card" id="quarto-standard">
    <div>
<img src="imagens/QuartoStandard.avif" alt="Quarto Standard"  align="left"/>
   </div>
 <h3>Quarto Standard</h3>
          <p> Quarto confortável e aconchegante com uma cama de casal e uma de solteiro.
acomoda 3 pessoas</p>
          <ul class="comodidades">
      <li> Wi-Fi</li>
      <li> Ar-condicionado</li>
      <li> TV</li>
      
</ul>
<span class="preco">R$ 180/noite</span>
<button class="btn btn-primary open-reserva" data-room="Quarto Standard" data-id-quarto="3">Reservar</button>
</div>

<hr>
<!-- ... outros quartos ... -->

<!-- Modal -->
<div class="modal" id="reservaModal" style="display:none;">
    <div class="modal-content">
      <span class="close-btn" id="closeModal">×</span>
      <h2>Reserva <span id="roomName"></span></h2>
      <form id="reservaForm" action="${pageContext.request.contextPath}/ReservaServlet" method="post">
		    <input type="hidden" name="acao" value="reservar" /> <!-- ✅ CORRIGIDO -->
		    <input type="hidden" name="idQuarto" id="idQuartoInput" value="">
		
		    <label for="dataEntrada">Data de entrada:</label>
		    <input type="date" id="dataEntrada" name="dataEntrada" required>
		
		    <label for="dataSaida">Data de saída:</label>
		    <input type="date" id="dataSaida" name="dataSaida" required>
		
		    <label for="numAdultos">Adultos:</label>
		    <input type="number" id="numAdultos" name="numAdultos" min="1" value="1" required>
		
		    <label for="numCriancas">Crianças:</label>
		    <input type="number" id="numCriancas" name="numCriancas" min="0" value="0" required>
		
		    <button type="submit" class="btn btn-primary">Confirmar Reserva</button>
	  </form>

    </div>
</div>

<%@ include file="_footer.jsp" %>

<script>
document.addEventListener('DOMContentLoaded', () => {
    const reservaModal = document.getElementById('reservaModal');
    const closeModalBtn = document.getElementById('closeModal');
    const idQuartoInput = document.getElementById('idQuartoInput');
    const roomNameSpan = document.getElementById('roomName');
    const dataEntradaInput = document.getElementById('dataEntrada');
    const dataSaidaInput = document.getElementById('dataSaida');

    document.querySelectorAll('.open-reserva').forEach(button => {
        button.addEventListener('click', (event) => {
            const roomName = event.currentTarget.getAttribute('data-room');
            const idQuarto = event.currentTarget.getAttribute('data-id-quarto');
            roomNameSpan.textContent = roomName;
            idQuartoInput.value = idQuarto;
            reservaModal.style.display = 'block';
        });
    });

    closeModalBtn.addEventListener('click', () => {
        reservaModal.style.display = 'none';
    });

    window.addEventListener('click', (event) => {
        if (event.target === reservaModal) {
            reservaModal.style.display = 'none';
        }
    });

    // validações UX
    const hoje = new Date();
    const dataMinima = hoje.toISOString().split('T')[0];
    dataEntradaInput.setAttribute('min', dataMinima);

    dataEntradaInput.addEventListener('change', () => {
        if (dataEntradaInput.value) {
            const dt = new Date(dataEntradaInput.value);
            dt.setDate(dt.getDate() + 1);
            const dataMinimaSaida = dt.toISOString().split('T')[0];
            dataSaidaInput.setAttribute('min', dataMinimaSaida);
            if (dataSaidaInput.value && dataSaidaInput.value <= dataEntradaInput.value) {
                dataSaidaInput.value = dataMinimaSaida;
            }
        }
    });
});
</script>
<script src="js/script.js"></script>
</body>
</html>
