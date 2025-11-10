<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
        if (erro.equals("limite_dias")) {
            mensagem = "A reserva não pode exceder 7 dias.";
        } else if (erro.equals("capacidade_excedida")) {
            mensagem = "O número de hóspedes excede a capacidade do quarto.";
        } else if (erro.equals("indisponivel")) {
            mensagem = "O quarto não está disponível para as datas selecionadas.";
        } else if (erro.equals("dados_invalidos")) {
            mensagem = "Dados de entrada ou saída inválidos. Verifique as datas.";
        } else if (erro.equals("login_necessario")) {
            // Este erro é geralmente tratado no entrar.jsp, mas é bom ter aqui
            mensagem = "Você precisa estar logado para fazer uma reserva.";
        } else if (erro.equals("reserva_invalida")) {
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

<div class="modal" id="reservaModal">
    <div class="modal-content">
      <span class="close-btn" id="closeModal">&times;</span>
      <h2>Reserva <span id="roomName"></span></h2>
      <form id="reservaForm" action="ReservaServlet" method="post">
        
        <input type="hidden" name="idQuarto" id="idQuartoInput" 
value=""> 
        
        <label for="dataEntrada">Data de Entrada:</label>
        <input type="date" id="dataEntrada" name="dataEntrada" required>
        
        <label for="dataSaida">Data de Saída:</label>
        <input type="date" id="dataSaida" name="dataSaida" required>
        
        <label for="numAdultos">Adultos:</label>
        <input type="number" id="numAdultos" name="numAdultos" min="1" required>
        
        <label for="numCriancas">Crianças (até 12 anos):</label>
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

    // 1. Lógica para abrir o modal e preencher o ID
    document.querySelectorAll('.open-reserva').forEach(button => {
        button.addEventListener('click', (event) => {
            const roomName = event.currentTarget.getAttribute('data-room');
            const idQuarto = event.currentTarget.getAttribute('data-id-quarto');
            
            // Preenche o nome e o ID do quarto
            roomNameSpan.textContent = roomName;
            idQuartoInput.value = idQuarto; 
            
            // Exibe o modal
            reservaModal.style.display = 'block';
        });
    });

    // 2. Lógica para fechar o modal
    closeModalBtn.addEventListener('click', () => {
        reservaModal.style.display = 'none';
    });
    
    // Fechar ao clicar fora do modal
    window.addEventListener('click', (event) => {
        if (event.target === reservaModal) {
            reservaModal.style.display = 'none';
        }
    });

    // 3. Validação de Data (UX)
    const hoje = new Date();
    hoje.setDate(hoje.getDate());
    const dataMinima = hoje.toISOString().split('T')[0];
    dataEntradaInput.setAttribute('min', dataMinima);

    dataEntradaInput.addEventListener('change', () => {
        // Garante que a data de saída seja pelo menos 1 dia após a data de entrada
        const dataEntrada = new Date(dataEntradaInput.value);
        if (dataEntradaInput.value) {
            dataEntrada.setDate(dataEntrada.getDate() + 1); 
            const dataMinimaSaida = dataEntrada.toISOString().split('T')[0];
            dataSaidaInput.setAttribute('min', dataMinimaSaida);
            
            // Se a data de saída for anterior ou igual à data de entrada, reseta o valor
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