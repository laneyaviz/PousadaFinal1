<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="modelos.Reserva" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%
    // Formatador de moeda (Brasil)
    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("pt", "BR"));

    // Recupera a lista de reservas do hóspede
    List<Reserva> reservasHospede = (List<Reserva>) request.getAttribute("reservasHospede");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Minhas Reservas - Pousada Azul do Mar</title>
    <link rel="stylesheet" href="css/style.css"/>

    <style>
        /* Reutilizando classes de Admin para consistência visual */
        
        /* Layout e Título (Consistente com a Gestão de Reservas) */
        .user-main {
            padding: 40px 20px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .user-main h2 {
            font-size: 2em;
            color: #2c3e50; 
            border-bottom: 3px solid #3498db; 
            padding-bottom: 10px;
            margin-bottom: 30px;
        }

        /* Estilos da Tabela (Baseado em .data-table do Admin) */
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
        
        /* Cabeçalho */
        .reservation-table thead th {
            background-color: #007bff; /* Azul de Destaque */
            color: white;
            padding: 15px 10px;
            text-align: left;
            font-weight: 700;
            text-transform: uppercase;
            font-size: 0.85em;
            letter-spacing: 0.5px;
        }

        /* Células */
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
            cursor: default;
        }
        
        /* Estilo para Status (Pílula) */
        .status-badge {
            padding: 6px 12px;
            border-radius: 15px; 
            font-weight: 600;
            font-size: 0.8em;
            display: inline-block;
            text-transform: uppercase;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }
        /* Cores dos Status */
        .status-badge.confirmada { background-color: #2ecc71; color: white; } 
        .status-badge.pendente { background-color: #f39c12; color: white; } 
        .status-badge.cancelada { background-color: #e74c3c; color: white; } 
        .status-badge.checkin { background-color: #3498db; color: white; } 
        .status-badge.checkout { background-color: #95a5a6; color: white; } 

        /* Mensagem de Ausência */
        .no-reservation {
            text-align: center;
            padding: 30px;
            font-weight: 600;
            color: #7f8c8d;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
            margin-top: 20px;
        }

        /* --- Estilos Mobile (Data-label) --- */
        @media (max-width: 600px) {
            .reservation-table { box-shadow: none; }
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

    <main class="user-main">
        <h2>Minhas Reservas</h2>

        <%
            if (reservasHospede == null || reservasHospede.isEmpty()) {
        %>
            <div class="no-reservation">
                Você ainda não possui reservas ativas ou históricas.
            </div>
        <%
            } else {
        %>
            <table class="reservation-table">
                <thead>
                    <tr>
                        <th>ID</th>
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
                    for (Reserva r : reservasHospede) {
                        // Converte o status para minúsculas e remove espaços para uso na classe CSS
                        String status = r.getStatus() != null ? r.getStatus() : "Pendente";
                        String statusClass = status.toLowerCase().replace(" ", "");
                %>
                    <tr>
                        <td data-label="ID"><%= r.getIdReserva() %></td>
                        <td data-label="Quarto">
                            **<%= (r.getQuarto() != null ? r.getQuarto().getTipo() : "N/D") %>**
                        </td>
                        <td data-label="Check-in"><%= r.getDataCheckin() %></td>
                        <td data-label="Check-out"><%= r.getDataCheckout() %></td>
                        <td data-label="Hóspedes">
                            <%= r.getNumAdultos() %> Ad. / <%= r.getNumCriancas() %> Cr.
                        </td>
                        <td data-label="Valor Total" style="font-weight: 600;">
                            <%= currencyFormat.format(r.getValorTotal()) %>
                        </td>
                        <td data-label="Status">
                            <span class="status-badge <%= statusClass %>"><%= status %></span>
                        </td>
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