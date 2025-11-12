<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, modelos.Reserva" %>
<%
    List<Reserva> reservasHospede = (List<Reserva>) request.getAttribute("reservasHospede");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Minhas Reservas - Pousada Azul do Mar</title>
<link rel="stylesheet" href="css/style.css"/>
</head>
<body>
<%@ include file="_header.jsp" %>

<main class="container" style="padding:40px;">
    <h2>Minhas Reservas</h2>

    <%
        if (reservasHospede == null || reservasHospede.isEmpty()) {
    %>
        <p>Você ainda não possui reservas.</p>
    <%
        } else {
    %>
        <table border="1" cellpadding="8" cellspacing="0" style="width:100%; border-collapse:collapse;">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Quarto</th>
                    <th>Check-in</th>
                    <th>Check-out</th>
                    <th>Pessoas</th>
                    <th>Valor Total</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
            <%
                for (Reserva r : reservasHospede) {
            %>
                <tr>
                    <td><%= r.getIdReserva() %></td>
                    <td><%= (r.getQuarto() != null ? r.getQuarto().getTipo() : "N/D") %></td>
                    <td><%= r.getDataCheckin() %></td>
                    <td><%= r.getDataCheckout() %></td>
                    <td><%= r.getNumAdultos() %> / <%= r.getNumCriancas() %></td>
                    <td>R$ <%= r.getValorTotal() %></td>
                    <td><%= r.getStatus() %></td>
                </tr>
            <%
                }
            %>
            </tbody>
        </table>
    <%
        }
    %>
</main>

<%@ include file="_footer.jsp" %>
</body>
</html>
