document.addEventListener("DOMContentLoaded", function () {
  // --- FORMULÁRIO DE CONTATO ---
  const contactForm = document.getElementById("contactForm");

  if (contactForm) {
    contactForm.addEventListener("submit", function (event) {
      const nome = document.getElementById("nome").value.trim();
      const mensagem = document.getElementById("mensagem").value.trim();

      if (nome === "" || mensagem === "") {
        alert("Por favor, preencha todos os campos.");
        event.preventDefault();
        return;
      }

      alert(`Obrigado, ${nome}! Sua mensagem foi enviada com sucesso.`);
    });
  }

  // --- MODAL DE RESERVA ---
  const reservaModal = document.getElementById("reservaModal");
  const closeModal = document.getElementById("closeModal");
  const roomNameSpan = document.getElementById("roomName");
  const reservaForm = document.getElementById("reservaForm");
  const idQuartoInput = document.getElementById("idQuartoInput");

  // Abrir o modal ao clicar em "Reservar"
  document.querySelectorAll(".open-reserva").forEach((btn) => {
    btn.addEventListener("click", () => {
      const roomName = btn.getAttribute("data-room");
      const idQuarto = btn.getAttribute("data-id-quarto");

      if (roomNameSpan) roomNameSpan.textContent = `- ${roomName}`;
      if (idQuartoInput) idQuartoInput.value = idQuarto;

      reservaModal.style.display = "flex";
    });
  });

  // Fechar o modal
  if (closeModal) {
    closeModal.addEventListener("click", () => {
      reservaModal.style.display = "none";
    });
  }

  // Fechar modal clicando fora dele
  window.addEventListener("click", (e) => {
    if (e.target === reservaModal) {
      reservaModal.style.display = "none";
    }
  });

  // Validação do formulário de reserva
  if (reservaForm) {
    reservaForm.addEventListener("submit", (e) => {
      const dataEntradaInput = document.getElementById("dataEntrada");
      const dataSaidaInput = document.getElementById("dataSaida");
      const dataEntrada = new Date(dataEntradaInput.value);
      const dataSaida = new Date(dataSaidaInput.value);
      const hoje = new Date();
      hoje.setHours(0, 0, 0, 0);

      if (dataEntrada < hoje) {
        alert("Você não pode reservar uma data que já passou!");
        e.preventDefault();
        return;
      }

      if (dataSaida <= dataEntrada) {
        alert("A data de saída deve ser posterior à data de entrada!");
        e.preventDefault();
        return;
      }

      alert("Reserva enviada com sucesso! Aguarde confirmação.");
    });
  }

  // --- EXIBE ALERTA DE SUCESSO APÓS REDIRECIONAMENTO ---
  const urlParams = new URLSearchParams(window.location.search);
  if (urlParams.get("reserva") === "sucesso") {
    alert("✅ Sua reserva foi realizada com sucesso!");
  }
});
