<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="modelos.Reserva" %>
<%@ page import="java.text.SimpleDateFormat" %>
<% 
    // Formatador para garantir o formato correto para o input type="date"
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    
    // Captura o objeto Reserva do Request
    Reserva reserva = (Reserva) request.getAttribute("reserva");
    String erroRemarcacao = (String) request.getAttribute("erroRemarcacao");

    // Validação de segurança, caso o objeto não tenha sido encontrado
    if (reserva == null) {
        response.sendRedirect("minhas_reservas.jsp?erro=reserva_nao_encontrada");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin - Remarcar Reserva</title>
    <link rel="stylesheet" href="css/style.css"/>
</head>
<body>
    <%@ include file="_header.jsp" %>
    
    <main class="container" style="padding: 40px 0;">
        <h2>👑 Remarcar Reserva #<%= reserva.getIdReserva() %></h2>
        
        <% if (erroRemarcacao != null) { %>
            <p style="color: red; font-weight: bold;">Erro: <%= erroRemarcacao %></p>
        <% } %>
        
        <form action="ReservaServlet" method="post" style="max-width: 500px;">
            <input type="hidden" name="acao" value="finalizarRemarcacao"> 
            <input type="hidden" name="idReserva" value="<%= reserva.getIdReserva() %>">
            
            <p>Cliente: <strong>ID <%= reserva.getIdHospede() %></strong></p>
            <p>Quarto: <strong>ID <%= reserva.getIdQuarto() %></strong> (Adultos: <%= reserva.getNumAdultos() %> / Crianças: <%= reserva.getNumCriancas() %>)</p>
            <p>Valor Original: <strong>R$ <%= String.format("%.2f", reserva.getValorTotal()) %></strong></p>
            
            <label for="dataEntrada">Nova Data de Check-in:</label>
            <input type="date" id="dataEntrada" name="dataEntrada" 
                   value="<%= sdf.format(reserva.getDataCheckin()) %>" required> <label for="dataSaida">Nova Data de Check-out:</label>
            <input type="date" id="dataSaida" name="dataSaida" 
                   value="<%= sdf.format(reserva.getDataCheckout()) %>" required> <label for="numAdultos">Adultos:</label>
            <input type="number" id="numAdultos" name="numAdultos" min="1" 
                   value="<%= reserva.getNumAdultos() %>" required>
            
            <label for="numCriancas">Crianças:</label>
            <input type="number" id="numCriancas" name="numCriancas" min="0" 
                   value="<%= reserva.getNumCriancas() %>" required>

            <p style="margin-top: 10px; color: #888;">*Atenção: A remarcação está sujeita à disponibilidade e limite de dias.</p>
            
            <button type="submit" class="btn btn-primary" style="margin-top: 20px;">Salvar Remarcação</button>
            <a href="ReservaServlet?acao=listar" class="btn btn-secondary">Voltar</a>
        </form>
    </main>
    
    <%@ include file="_footer.jsp" %>
</body>
</html>