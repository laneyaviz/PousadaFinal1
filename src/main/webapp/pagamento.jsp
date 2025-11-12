<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="modelos.Reserva, modelos.Hospedes, java.text.DecimalFormat, java.text.SimpleDateFormat" %>

<%
    Reserva reserva = (Reserva) request.getAttribute("reserva");
    Hospedes usuario = (Hospedes) session.getAttribute("usuarioLogado");
    if (reserva == null || usuario == null) {
        response.sendRedirect(request.getContextPath() + "/reservas.jsp?erro=reserva_invalida");
        return;
    }
    DecimalFormat df = new DecimalFormat("#,##0.00");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Pagamento - Pousada Azul do Mar</title>
<link rel="stylesheet" href="css/style.css"/>
<style>
.cartao { margin-top: 20px; }
.cartao label { display: block; margin-top: 10px; }
.cartao input { width: 100%; padding: 8px; }
</style>
</head>
<body>
<%@ include file="_header.jsp" %>

<main class="container" style="padding:40px;">
    <h2>Pagamento da Reserva</h2>

    <div class="resumo">
        <p><strong>Hóspede:</strong> <%= usuario.getNome() %></p>
        <p><strong>Check-in:</strong> <%= sdf.format(java.sql.Date.valueOf(reserva.getDataCheckin())) %></p>
        <p><strong>Check-out:</strong> <%= sdf.format(java.sql.Date.valueOf(reserva.getDataCheckout())) %></p>
        <p><strong>Valor Total:</strong> R$ <%= df.format(reserva.getValorTotal()) %></p>
    </div>

    <form action="${pageContext.request.contextPath}/PagamentoServlet" method="post">
        <input type="hidden" name="idReserva" value="<%= reserva.getIdReserva() %>">
        <input type="hidden" name="valorTotal" value="<%= reserva.getValorTotal() %>">

        <label for="metodo">Método de Pagamento:</label>
        <select id="metodo" name="metodo" required>
            <option value="CARTAO">Cartão</option>
            <option value="PIX">PIX</option>
            <option value="BOLETO">Boleto</option>
        </select>

        <div class="cartao">
            <label for="numero">Número do Cartão:</label>
            <input type="text" id="numero" name="numero" maxlength="19">

            <label for="nome">Nome no Cartão:</label>
            <input type="text" id="nome" name="nome">

            <label for="validade">Validade:</label>
            <input type="text" id="validade" name="validade" placeholder="MM/AA">

            <label for="cvv">CVV:</label>
            <input type="text" id="cvv" name="cvv" maxlength="3">
        </div>

        <button type="submit" class="btn btn-primary">Confirmar Pagamento</button>
    </form>
</main>

<script>
document.addEventListener('DOMContentLoaded', () => {
  const metodoSelect = document.getElementById('metodo');
  const camposCartao = document.querySelector('.cartao');

  function atualizarCampos() {
    const metodo = metodoSelect.value;
    camposCartao.style.display = (metodo === 'CARTAO') ? 'block' : 'none';
  }

  metodoSelect.addEventListener('change', atualizarCampos);
  atualizarCampos();
});
</script>

<%@ include file="_footer.jsp" %>
</body>
</html>
