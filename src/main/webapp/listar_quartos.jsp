<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="modelos.Quartos" %>
<%@ page import="java.text.DecimalFormat" %>
<% 
    // Formatador para o preço da diária
    DecimalFormat df = new DecimalFormat("#,##0.00");
    
    // Converte a lista do Request para o tipo correto
    // É crucial que "quartos" seja o nome do atributo definido no seu Servlet
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
        /* --- ESTILOS MODERNOS FOCADOS NO CONTEÚDO (APLICADOS NA TAG <MAIN>) --- */
        
        /* Layout */
        main.container {
            padding: 40px 20px;
            max-width: 1200px;
            margin: 0 auto;
        }

        h2 {
            font-size: 2em;
            color: #2c3e50; /* Azul escuro moderno */
            border-bottom: 3px solid #3498db; /* Linha azul de destaque */
            padding-bottom: 10px;
            margin-bottom: 30px;
        }

        /* Mensagens de Feedback */
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
        .feedback.success {
            background-color: #e6f7e9;
            color: #27ae60; /* Verde escuro */
            border: 1px solid #2ecc71;
        }
        .feedback.error {
            background-color: #fcebeb;
            color: #c0392b; /* Vermelho escuro */
            border: 1px solid #e74c3c;
        }

        /* Botões */
        .btn {
            display: inline-flex; 
            align-items: center;
            gap: 5px;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            text-decoration: none;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            margin: 5px 2px;
            text-transform: uppercase;
            font-size: 0.9em;
        }
        .btn-primary {
            background-color: #3498db; /* Azul primário */
            color: white;
        }
        .btn-primary:hover {
            background-color: #2980b9;
            transform: translateY(-1px);
        }
        .btn-secondary {
            background-color: #95a5a6; /* Cinza suave */
            color: white;
        }
        .btn-secondary:hover {
            background-color: #7f8c8d;
        }
        .btn-danger {
            background-color: #e74c3c; /* Vermelho forte */
            color: white;
        }
        .btn-danger:hover {
            background-color: #c0392b;
        }
        .btn-small {
            padding: 6px 12px;
            font-size: 0.8em;
            text-transform: none; 
        }
        
        /* Tabela de Dados (data-table) */
        .data-table {
            width: 100%;
            border-collapse: separate; 
            border-spacing: 0;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1); 
            background-color: white;
            margin-top: 25px;
            border-radius: 8px; /* Cantos arredondados */
            overflow: hidden; 
        }
        .data-table thead {
            background-color: #f4f6f9; 
            color: #333;
        }
        .data-table th, .data-table td {
            padding: 15px 18px;
            text-align: left;
            border-bottom: 1px solid #ecf0f1; 
        }
        .data-table th {
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-size: 0.9em;
        }
        .data-table tbody tr:last-child td {
            border-bottom: none;
        }
        .data-table tbody tr:hover {
            background-color: #f7f9fb; 
            transition: background-color 0.2s ease;
        }
        
        /* Alinhamento de Conteúdo Numérico e Status */
        .align-center { text-align: center !important; }
        .data-table th:nth-child(4), .data-table td:nth-child(4), /* Diária */
        .data-table th:nth-child(5), .data-table td:nth-child(5) /* Capacidade */
        {
            text-align: center;
        }

        /* Estilos para o status de disponibilidade (Formato Pílula) */
        .status-sim { 
            color: white;
            font-weight: bold; 
            padding: 5px 10px;
            border-radius: 15px; 
            background-color: #2ecc71; /* Verde */
            display: inline-block;
            font-size: 0.9em;
        }
        .status-nao { 
            color: white;
            font-weight: bold; 
            padding: 5px 10px;
            border-radius: 15px; 
            background-color: #e74c3c; /* Vermelho */
            display: inline-block;
            font-size: 0.9em;
        }
    </style>
</head>
<body>
    <%@ include file="_header.jsp" %>
    
    <main class="container">
        <h2>✨ Gestão de Quartos</h2>
        
        <p><a href="novo_quarto.jsp" class="btn btn-primary">➕ Adicionar Novo Quarto</a></p>
        
        <div style="margin-top: 20px;">
            <% if (msg != null && !msg.isEmpty()) { %>
                <div class="feedback success">✅ Quarto **<%= msg %>** com sucesso.</div>
            <% } %>
            <% if (erro != null && !erro.isEmpty()) { %>
                <div class="feedback error">❌ Erro: **<%= erro %>**</div>
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
                if (quartos != null && !quartos.isEmpty()) { 
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
                        <td style="font-weight: bold;">R$ <%= df.format(quarto.getPrecoDiaria()) %></td>
                        <td><%= quarto.getCapacidadeMaxima() %></td>
                        <td>
                            <span class="<%= statusClass %>"><%= statusText %></span>
                        </td>
                        <td>
                            <a href="<%= request.getContextPath() %>/QuartoServlet?acao=editar&id=<%= quarto.getIdQuarto() %>" 
                               class="btn btn-secondary btn-small">✏️ Editar</a>
                            <a href="<%= request.getContextPath() %>/QuartoServlet?acao=deletar&id=<%= quarto.getIdQuarto() %>" 
                               onclick="return confirm('Tem certeza que deseja deletar o Quarto <%= quarto.getNumero() %>?');" 
                               class="btn btn-danger btn-small">🗑️ Deletar</a>
                        </td>
                    </tr>
                <%  
                    }
                } else {
                %>
                    <tr>
                        <td colspan="7" style="text-align: center; padding: 30px; color: #7f8c8d; font-style: italic;">
                            Nenhum quarto cadastrado. Utilize o botão **"Adicionar Novo Quarto"** acima para cadastrar.
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </main>
    
    <%@ include file="_footer.jsp" %>
</body>
</html>