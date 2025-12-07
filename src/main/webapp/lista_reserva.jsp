<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="modelos.Reserva" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<% 
    // Formatador de moeda (Brasil)
    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("pt", "BR"));

    // Converte a lista do Request para o tipo correto
    List<Reserva> reservas = (List<Reserva>) request.getAttribute("reservas");
    
    // Captura parâmetros de mensagem/erro, se aplicável em páginas de gestão
    String msg = request.getParameter("msg");
    String erro = request.getParameter("erro");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Gestão de Reservas - Admin</title>
    <link rel="stylesheet" href="css/style.css"> 

    <style>
        /* --- ESTILOS EXCLUSIVOS PARA A PÁGINA DE RESERVAS --- */

        /* Layout (Ajustado para usar a classe .container se for o padrão do seu style.css) */
        .admin-main {
            padding: 40px 20px;
            max-width: 1200px;
            margin: 0 auto;
        }

        /* Título */
        .admin-main h2 {
            font-size: 2em;
            color: #2c3e50; 
            border-bottom: 3px solid #3498db; 
            padding-bottom: 10px;
            margin-bottom: 30px;
        }
        
        /* Mensagens de Feedback (Consistência com estilos de Admin) */
        .feedback {
            padding: 15px;
            margin: 20px 0;
            border-radius: 6px;
            font-weight: bold;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .feedback.success { background-color: #e6f7e9; color: #27ae60; border: 1px solid #2ecc71; }
        .feedback.error { background-color: #fcebeb; color: #c0392b; border: 1px solid #e74c3c; }

        /* Estilo básico da tabela (Melhorias no design flat) */
        .reservation-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1); 
            border-radius: 8px;
            overflow: hidden; 
            background-color: white;
            margin-top: 25px;
        }
        
        /* Cabeçalho da Tabela */
        .reservation-table thead th {
            background-color: #007bff; 
            color: white;
            padding: 15px 10px;
            text-align: left;
            font-weight: 700;
            text-transform: uppercase;
            font-size: 0.85em;
            letter-spacing: 0.5px;
        }

        /* Linhas do Corpo da Tabela */
        .reservation-table tbody td {
            padding: 14px 10px;
            border-bottom: 1px solid #ecf0f1; 
            font-size: 0.9em;
            color: #444;
        }

        /* Linhas Zebradas e Hover */
        .reservation-table tbody tr:nth-child(even) { background-color: #f9fbfd; } 
        .reservation-table tbody tr:hover {
            background-color: #eef2ff; 
            cursor: pointer;
        }
        
        /* Estilo para a célula de Status (Badge/Pílula) */
        .status-badge {
            padding: 6px 12px;
            border-radius: 15px; /* Formato pílula */
            font-weight: 600;
            font-size: 0.8em;
            display: inline-block;
            text-transform: uppercase;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }
        
        /* Cores do Badge de Status */
        .status-badge.confirmada { background-color: #2ecc71; color: white; } /* Verde - Confirmada */
        .status-badge.pendente { background-color: #f39c12; color: white; } /* Laranja - Pendente */
        .status-badge.cancelada { background-color: #e74c3c; color: white; } /* Vermelho - Cancelada */
        .status-badge.checkin { background-color: #3498db; color: white; } /* Azul - Checkin/Ativa */
        .status-badge.checkout { background-color: #95a5a6; color: white; } /* Cinza - Checkout/Finalizada */
        
        /* Estilo para a mensagem de nenhuma reserva */
        .no-reservation {
            text-align: center;
            padding: 30px;
            font-weight: bold;
            color: #7f8c8d;
            font-style: italic;
            background-color: white;
        }

        /* --- Estilos Mobile (Mantidos e Otimizados) --- */
        @media (max-width: 600px) {
            .reservation-table {
                box-shadow: none; /* Remove a sombra da tabela principal */
            }
            .reservation-table thead { display: none; }
            .reservation-table, .reservation-table tbody, .reservation-table tr, .reservation-table td {
                display: block;
                width: 100%;
            }
            .reservation-table tr {
                margin-bottom: 15px;
                border: 1px solid #ddd;
                border-radius: 4px;
                box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            }
            .reservation-table tbody td {
                text-align: right;
                padding-left: 50%;
                position: relative;
                border: none;
                border-bottom: 1px dotted #eee;
            }
            .reservation-table td::before {
                content: attr(data-label);
                position: absolute;
                left: 10px;
                width: 45%;
                padding-right: 10px;
                white-space: nowrap;
                font-weight: bold;
                text-align: left;
                color: #555;
            }
            .reservation-table tbody td:last-child {
                border-bottom: none;
            }
        }
    </style>
</head>
<body>
    <%@ include file="_header.jsp" %>

    <div class="admin-main">
        <h2>🗓️ Gestão de Reservas</h2>
        
        <% if (msg != null && !msg.isEmpty()) { %>
            <div class="feedback success">✅ **Sucesso!** <%= msg %></div>
        <% } %>
        <% if (erro != null && !erro.isEmpty()) { %>
            <div class="feedback error">❌ **Erro:** <%= erro %></div>
        <% } %>

        <table class="reservation-table">
            <thead>
                <tr>
                    <th>ID Res.</th>
                    <th>ID Hóspede</th>
                    <th>Quarto</th>
                    <th>Check-in</th>
                    <th>Check-out</th>
                    <th>Hóspedes</th>
                    <th>Valor Total</th>
                    <th>Status</th>
                    <th>Ações</th> </tr>
            </thead>
            <tbody>
                <%
                    if (reservas == null || reservas.isEmpty()) {
                %>
                        <tr><td colspan="9" class="no-reservation">Nenhuma reserva encontrada.</td></tr>
                <%
                    } else {
                        for (Reserva r : reservas) {
                            // Converte o status para minúsculas e remove espaços para uso na classe CSS
                            String status = r.getStatus() != null ? r.getStatus() : "Pendente";
                            String statusClass = status.toLowerCase().replace(" ", "");
                %>
                        <tr>
                            <td data-label="ID Res."><%= r.getIdReserva() %></td>
                            <td data-label="ID Hóspede"><%= r.getIdHospede() %></td>
                            <td data-label="Quarto">
                                <% if (r.getQuarto() != null) { %>
                                    **Nº <%= r.getQuarto().getNumero() %>** - <%= r.getQuarto().getTipo() %>
                                <% } else { %>
                                    (Quarto Removido)
                                <% } %>
                            </td>
                            <td data-label="Check-in"><%= r.getDataCheckin() %></td>
                            <td data-label="Check-out"><%= r.getDataCheckout() %></td>
                            <td data-label="Hóspedes"><%= r.getNumAdultos() %> Ad. / <%= r.getNumCriancas() %> Cr.</td>
                            <td data-label="Valor Total" style="font-weight: 600;">
                                <%= currencyFormat.format(r.getValorTotal()) %>
                            </td>
                            <td data-label="Status">
                                <span class="status-badge <%= statusClass %>"><%= status %></span>
                            </td>
                            <td data-label="Ações">
                                <a href="ReservaServlet?acao=detalhes&id=<%= r.getIdReserva() %>" class="btn btn-secondary btn-small">👁️ Detalhes</a>
                            </td>
                        </tr>
                <%
                        }
                    }
                %>
            </tbody>
        </table>
    </div>

    <%@ include file="_footer.jsp" %>
</body>
</html>