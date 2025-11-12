<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, modelos.Quartos" %>
<%@ page import="DAO.QuartoDAO" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Pousada Azul do Mar - Reservas</title>
<link rel="stylesheet" href="css/style.css"/>
<link rel="stylesheet" href="css/quartos.css">
</head>
<body>

<%@ include file="_header.jsp" %>

<main class="container" style="padding:40px 0;">
  <h2>Escolha seu Quarto</h2>

  <%
      String erro = request.getParameter("erro");
      if (erro != null) {
          String mensagem = "";
          switch (erro) {
              case "login_necessario":
                  mensagem = "⚠️ Você precisa estar logado para reservar um quarto.";
                  break;
              case "dados_invalidos":
                  mensagem = "⚠️ Datas inválidas. Verifique entrada e saída.";
                  break;
              case "limite_dias":
                  mensagem = "⚠️ A reserva não pode ultrapassar 7 dias.";
                  break;
              case "capacidade_excedida":
                  mensagem = "⚠️ O número de hóspedes excede a capacidade do quarto.";
                  break;
              case "indisponivel":
                  mensagem = "⚠️ Este quarto não está disponível nas datas escolhidas.";
                  break;
              default:
                  mensagem = "⚠️ Ocorreu um erro ao tentar reservar. Tente novamente.";
          }
  %>
      <p style="color:red; text-align:center; font-weight:bold; margin:20px 0;"><%= mensagem %></p>
  <% } %>

  <div class="lista-quartos">
  <%
      QuartoDAO quartoDAO = new QuartoDAO();
      List<Quartos> quartos = quartoDAO.getAll();
      if (quartos != null && !quartos.isEmpty()) {
          for (Quartos q : quartos) {
  %>
      <div class="room-card">
          <img src="imagens/quarto<%= q.getIdQuarto() %>.jpg" alt="Imagem do quarto.jpg" <%= q.getTipo() %>" style="width:200px;height:auto;border-radius:10px;">
          <h3><%= q.getTipo() %></h3>
          <p>Capacidade: <%= q.getCapacidadeMaxima() %> pessoas</p>
          <p>Preço por diária: <strong>R$ <%= q.getPrecoDiaria() %></strong></p>
          <button class="btn btn-primary open-reserva"
                  data-id-quarto="<%= q.getIdQuarto() %>"
                  data-nome="<%= q.getTipo() %>">
              Reservar
          </button>
      </div>
  <%
          }
      } else {
  %>
      <p>Nenhum quarto cadastrado ainda.</p>
  <%
      }
  %>
  </div>
</main>

<!-- Modal de Reserva -->
<div id="reservaModal" class="modal" style="display:none;">
  <div class="modal-content">
    <span class="close-btn" id="closeModal">&times;</span>
    <h2>Reserva: <span id="nomeQuarto"></span></h2>

    <form action="${pageContext.request.contextPath}/ReservaServlet" method="post" id="reservaForm">
    
        <input type="hidden" name="acao" value="reservar">
        <input type="hidden" name="idQuarto" id="idQuarto">

        <label for="dataEntrada">Data de Check-in:</label>
        <input type="date" id="dataEntrada" name="dataEntrada" required>

        <label for="dataSaida">Data de Check-out:</label>
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
    const modal = document.getElementById('reservaModal');
    const closeModal = document.getElementById('closeModal');
    const nomeQuarto = document.getElementById('nomeQuarto');
    const idQuartoInput = document.getElementById('idQuarto');
    const dataEntrada = document.getElementById('dataEntrada');
    const dataSaida = document.getElementById('dataSaida');

    document.querySelectorAll('.open-reserva').forEach(button => {
        button.addEventListener('click', (e) => {
            nomeQuarto.textContent = e.target.getAttribute('data-nome');
            idQuartoInput.value = e.target.getAttribute('data-id-quarto');
            modal.style.display = 'block';
        });
    });

    closeModal.addEventListener('click', () => modal.style.display = 'none');
    window.addEventListener('click', (e) => { if (e.target == modal) modal.style.display = 'none'; });

    // define data mínima (hoje)
    const hoje = new Date();
    const hojeStr = hoje.toISOString().split('T')[0];
    dataEntrada.setAttribute('min', hojeStr);

    dataEntrada.addEventListener('change', () => {
        if (dataEntrada.value) {
            const d = new Date(dataEntrada.value);
            d.setDate(d.getDate() + 1);
            dataSaida.setAttribute('min', d.toISOString().split('T')[0]);
        }
    });
});
</script>
<script>
document.addEventListener('DOMContentLoaded', () => {
  const metodoSelect = document.getElementById('metodo');
  const camposCartao = document.querySelector('.cartao');

  function atualizarCampos() {
    const metodo = metodoSelect.value;
    if (metodo === 'CARTAO') {
      camposCartao.style.display = 'block';
    } else {
      camposCartao.style.display = 'none';
    }
  }

  metodoSelect.addEventListener('change', atualizarCampos);
  atualizarCampos(); // executa ao carregar
});
</script>

</body>
</html>
