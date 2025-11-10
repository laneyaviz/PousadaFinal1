<%@ include file="_header.jsp" %>

<main class="container" style="padding:40px 0;">
  <h2 class="text-center">Faça sua Reserva</h2>
  <div class="room-list">
    <!-- Cards dos quartos com botão Reservar -->
  </div>
</main>

<div class="modal" id="reservaModal">
  <div class="modal-content">
    <span class="close-btn" id="closeModal">&times;</span>
    <h2>Reserva <span id="roomName"></span></h2>
    <form id="reservaForm">
      <label for="nome">Nome:</label>
      <input type="text" id="nome" required>
      <label for="dataEntrada">Data de Entrada:</label>
      <input type="date" id="dataEntrada" required>
      <label for="hospedes">Número de Hóspedes:</label>
      <input type="number" id="hospedes" min="1" max="6" required>
      <button type="submit" class="btn btn-primary">Confirmar Reserva</button>
    </form>
  </div>
</div>

<%@ include file="_footer.jsp" %>

