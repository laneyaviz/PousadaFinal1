<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="modelos.Quartos" %>
<%@ page import="java.text.DecimalFormat" %>
<% 
    // Formatador para o preço da diária
    DecimalFormat df = new DecimalFormat("#,##0.00");
    
    // Converte a lista do Request para o tipo correto
    List<Quartos> quartos = (List<Quartos>) request.getAttribute("quartos");
    
    // Captura parâmetros de mensagem/erro da URL
    String msg = request.getParameter("msg");
    String erro = request.getParameter("erro");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin - Gestão de Quartos</title>
    <link rel="stylesheet" href="css/style.css"/>
    <style>
        /* Estilos adicionais para o status de disponibilidade */
        .status-sim { color: green; font-weight: bold; }
        .status-nao { color: red; font-weight: bold; }
    </style>
</head>
<body>
    <%@ include file="_header.jsp" %>
    
    <main class="container" style="padding: 40px 0;">
        <h2>👑 Gestão de Quartos</h2>
        
        <p><a href="novo_quarto.jsp" class="btn btn-primary">Adicionar Novo Quarto</a></p>
        
        <div style="margin-top: 20px;">
            <% if (msg != null && !msg.isEmpty()) { %>
                <p style="color: green; font-weight: bold;">Quarto <%= msg %> com sucesso.</p>
            <% } %>
            <% if (erro != null && !erro.isEmpty()) { %>
                <p style="color: red; font-weight: bold;">Erro: <%= erro %></p>
            <% } %>
        </div>
        
        <table class="data-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Número</th>
                    <th>Tipo</th>
                    <th>Diária</th>
                    <th>Capacidade</th>
                    <th>Disponível</th> 
                    <th>Ações</th>
                </tr>
            </thead>
            <tbody>
                <% 
                if (quartos != null) { 
                    for (Quartos quarto : quartos) { 
                        // Verifica se está disponível para definir a classe de status
                        boolean isDisponivel = quarto.isDisponivel();
                        String statusClass = isDisponivel ? "status-sim" : "status-nao";
                        String statusText = isDisponivel ? "Sim" : "Não";
                %>
                    <tr>
                        <td><%= quarto.getIdQuarto() %></td>
                        <td><%= quarto.getNumero() %></td>
                        <td><%= quarto.getTipo() %></td>
                        <td>R$ <%= df.format(quarto.getPrecoDiaria()) %></td>
                        <td><%= quarto.getCapacidadeMaxima() %></td>
                        <td>
                            <span class="<%= statusClass %>"><%= statusText %></span>
                        </td>
                        <td>
                            <!-- 🚨 CORREÇÃO: Usando request.getContextPath() para editar/deletar -->
                            <a href="<%= request.getContextPath() %>/QuartoServlet?acao=editar&id=<%= quarto.getIdQuarto() %>" class="btn btn-secondary btn-small">Editar</a>
                            <a href="<%= request.getContextPath() %>/QuartoServlet?acao=deletar&id=<%= quarto.getIdQuarto() %>" 
                               onclick="return confirm('Tem certeza que deseja deletar este quarto?');" 
                               class="btn btn-danger btn-small">Deletar</a>
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