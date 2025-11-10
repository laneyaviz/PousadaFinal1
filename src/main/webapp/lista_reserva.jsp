<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="modelos.Reserva" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<% 
    // Formatadores para moeda e data
    DecimalFormat df = new DecimalFormat("#,##0.00");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    
    List<Reserva> reservas = (List<Reserva>) request.getAttribute("reservas");
    // Captura parâmetros de mensagem/erro da URL
    String msg = request.getParameter("msg");
    String erro = request.getParameter("erro");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin - Gestão de Reservas</title>
    <link rel="stylesheet" href="css/style.css"/>
</head>
<body>
    <%@ include file="_header.jsp" %>
    
    <main class="container" style="padding: 40px 0;">
        <h2>👑 Gestão de Reservas</h2>
        
        <div style="margin-top: 20px;">
            <% if (msg != null && !msg.isEmpty()) { %>
            
            <p style="color: green; font-weight: bold;">Reserva <%= msg %> com sucesso.</p>
            <% } %>
            <% if (erro != null && !erro.isEmpty()) { %>
                <p style="color: red; font-weight: bold;">Erro: <%= erro %></p>
            <% } %>
        </div>
        
        <table class="data-table">
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
                    <th>Ações</th>
                </tr>
            </thead>
            <tbody>
                <% 
                if (reservas != null) { 
                    for (Reserva reserva : reservas) { 
                %>
                    <tr>
                        <td><%= reserva.getIdReserva() %></td>
                        <td><%= reserva.getIdHospede() %></td>
                        
                        <td><%= reserva.getQuarto().getNumero() %> - <%= reserva.getQuarto().getTipo() %></td>
                        
                        <td><%= sdf.format(reserva.getDataCheckin()) %></td>
                        <td><%= sdf.format(reserva.getDataCheckout()) %></td>
                        <td><%= reserva.getNumAdultos() %> A / <%= reserva.getNumCriancas() %> C</td>
                        <td>R$ <%= df.format(reserva.getValorTotal()) %></td>
                        <td>
                            <span class="status <%= reserva.getStatus().toLowerCase() %>"><%= reserva.getStatus() %></span>
                        </td>
                        <td>
                            <% if (!"CANCELADA".equals(reserva.getStatus())) { %>
                            <a href="ReservaServlet?acao=remarcar&id=<%= reserva.getIdReserva() %>" class="btn btn-secondary btn-small">Remarcar</a>
                                <a href="ReservaServlet?acao=reembolsar&id=<%= reserva.getIdReserva() %>" 
                                   onclick="return confirm('Confirma o cancelamento (reembolso) desta reserva?');" 
                                   class="btn btn-danger btn-small">Reembolsar</a>
                            <% } %>
                        </td>
                    </tr>
                <%  
                    }
                } 
                %>
            </tbody>
        </table>
    </main>
    
    <%@ include file="_footer.jsp" %>
</body>
</html>