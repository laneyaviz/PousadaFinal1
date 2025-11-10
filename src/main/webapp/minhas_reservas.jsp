<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="modelos.Reserva" %>
<%@ page import="modelos.Hospedes" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<% 
    // Formatadores para moeda e data
    DecimalFormat df = new DecimalFormat("#,##0.00");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
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
    
    <% 

        if (usuarioLogado == null) {
            response.sendRedirect("entrar.jsp?erro=login_necessario");
            return;
        }

        // Captura a lista de reservas enviada pelo ReservaServlet
        List<Reserva> reservas = (List<Reserva>) request.getAttribute("reservasHospede");
    %>
    
    <main class="container" style="padding: 40px 0;">
        <h2>Olá, <%= usuarioLogado.getNome() %>!
        Suas Reservas</h2>
        
        <% 
        if (reservas == null || reservas.isEmpty()) { 
        %>
            <p style="margin-top: 20px;">Você não possui nenhuma reserva ativa no momento.</p>
            <p><a href="quartos.jsp" class="btn btn-primary">Fazer uma Nova Reserva</a></p>
        <% 
        } else { 
        %>
        
        <table class="data-table" style="margin-top: 20px;">
            <thead>
                <tr>
                    <th>ID Res.</th>
                    <th>Quarto</th>
                    <th>Check-in</th>
                    <th>Check-out</th>
                    <th>Hóspedes</th>
                    <th>Valor Total</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    for (Reserva reserva : reservas) { 
                %>
                    <tr>
                        <td><%= reserva.getIdReserva() %></td>
                        
                        <td>Quarto <%= reserva.getQuarto().getNumero() %> - <%= reserva.getQuarto().getTipo() %></td>
                        
                        <td><%= sdf.format(reserva.getDataCheckin()) %></td>
                        <td><%= sdf.format(reserva.getDataCheckout()) %></td>
                        <td><%= reserva.getNumAdultos() %> A / <%= reserva.getNumCriancas() %> C</td>
                        <td>R$ <%= df.format(reserva.getValorTotal()) %></td>
                        <td>
                            <span class="status <%= reserva.getStatus().toLowerCase() %>"><%= reserva.getStatus() %></span>
                        </td>
                    </tr>
                <%  
                    }
                %>
            </tbody>
        </table>
        
        <% } %>
    </main>
    
    <%@ include file="_footer.jsp" %>
</body>
</html>