<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, modelos.Reserva" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Gestão de Reservas - Admin</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>
<%@ include file="_header.jsp" %>

<h2>Gestão de Reservas</h2>

<table border="1" width="100%" style="border-collapse:collapse;">
    <thead>
        <tr>
            <th>ID Res.</th>
            <th>ID Hóspede</th>
            <th>Quarto</th>
            <th>Check-in</th>
            <th>Check-out</th>
            <th>Adultos/Crianças</th>
            <th>Valor Total</th>
            <th>Status</th>
        </tr>
    </thead>
    <tbody>
        <%
            List<Reserva> reservas = (List<Reserva>) request.getAttribute("reservas");
            if (reservas == null || reservas.isEmpty()) {
        %>
            <tr><td colspan="8" style="text-align:center;">Nenhuma reserva encontrada.</td></tr>
        <%
            } else {
                for (Reserva r : reservas) {
        %>
            <tr>
                <td><%= r.getIdReserva() %></td>
                <td><%= r.getIdHospede() %></td>
                <td>
                    <% if (r.getQuarto() != null) { %>
                        Nº <%= r.getQuarto().getNumero() %> - <%= r.getQuarto().getTipo() %>
                    <% } else { %>
                        (sem quarto)
                    <% } %>
                </td>
                <td><%= r.getDataCheckin() %></td>
                <td><%= r.getDataCheckout() %></td>
                <td><%= r.getNumAdultos() %> / <%= r.getNumCriancas() %></td>
                <td>R$ <%= String.format("%.2f", r.getValorTotal()) %></td>
                <td><%= r.getStatus() %></td>
            </tr>
        <%
                }
            }
        %>
    </tbody>
</table>

<%@ include file="_footer.jsp" %>
</body>
</html>
