<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="modelos.Hospedes" %>
<%@ page import="modelos.Reserva" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<% 
    // Formatadores
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
        /* Estilos adicionais */
        .resumo-reserva, .form-pagamento {
            border: 1px solid #ddd;
            padding: 25px;
            border-radius: 8px;
            margin-bottom: 30px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        .campos-cartao {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        .campos-cartao > div {
            grid-column: span 1;
        }
        .campos-cartao .campo-completo {
            grid-column: span 2;
        }
        @media (max-width: 600px) {
            .campos-cartao {
                grid-template-columns: 1fr;
            }
            .campos-cartao .campo-completo {
                grid-column: span 1;
            }
        }
    </style>
</head>
<body>
    
    <%@ include file="_header.jsp" %>

    <% 
        

        // Captura a Reserva pendente do Request
        Reserva reservaPendente = (Reserva) request.getAttribute("reservaPendente");

        // Lógica de segurança/erro: Se não houver reserva pendente ou login, redireciona
        if (reservaPendente == null || usuarioLogado == null) {
            response.sendRedirect("quartos.jsp?erro=reserva_invalida");
            return;
        }
    %>
    
    <main class="container" style="padding: 40px 0;">
        <h2>Confirmação e Pagamento</h2>
        
        <div class="resumo-reserva" style="max-width: 700px;">
            <h3>Detalhes da Sua Reserva</h3>
            <p><strong>Hóspede:</strong> <%= usuarioLogado.getNome() %></p>
            <p><strong>Quarto ID:</strong> <%= reservaPendente.getIdQuarto() %></p>
            <p><strong>Período:</strong> <%= sdf.format(reservaPendente.getDataCheckin()) %> a <%= sdf.format(reservaPendente.getDataCheckout()) %></p>
            <p><strong>Pessoas:</strong> <%= reservaPendente.getNumAdultos() %> Adultos e <%= reservaPendente.getNumCriancas() %> Crianças</p>
            <hr>
            <h2>Valor Total a Pagar: <span style="color: green;">R$ <%= df.format(reservaPendente.getValorTotal()) %></span></h2>
        </div>
        
        <div class="form-pagamento" style="max-width: 700px;">
            <h3>Informações do Cartão</h3>
            
            <form action="ReservaServlet" method="post">
                <input type="hidden" name="acao" value="confirmarPagamento">
                
                <%-- Campos Ocultos com os dados da reserva --%>
                <input type="hidden" name="idQuarto" value="<%= reservaPendente.getIdQuarto() %>">
                <input type="hidden" name="dataEntrada" value="<%= sdf.format(reservaPendente.getDataCheckin()) %>">
                <input type="hidden" name="dataSaida" value="<%= sdf.format(reservaPendente.getDataCheckout()) %>">
                <input type="hidden" name="numAdultos" value="<%= reservaPendente.getNumAdultos() %>">
                <input type="hidden" name="numCriancas" value="<%= reservaPendente.getNumCriancas() %>">
                <input type="hidden" name="valorTotal" value="<%= reservaPendente.getValorTotal() %>">

                <label for="metodo">Método de Pagamento:</label>
                <select id="metodo" name="metodoPagamento" required>
                    <option value="CARTAO">Cartão de Crédito/Débito</option>
                    <option value="PIX">PIX (Chave enviada após confirmação)</option>
                    <option value="BOLETO">Boleto Bancário (Processamento em 1-2 dias)</option>
                </select>

                <div class="campos-cartao" style="margin-top: 20px;">
                    
                    <div class="campo-completo">
                        <label for="numeroCartao">Número do Cartão:</label>
                        <input type="text" id="numeroCartao" name="numeroCartao" placeholder="XXXX XXXX XXXX XXXX" required>
                    </div>

                    <div class="campo-completo">
                        <label for="nomeCartao">Nome Impresso no Cartão:</label>
                        <input type="text" id="nomeCartao" name="nomeCartao" required>
                    </div>

                    <div>
                        <label for="validade">Validade (MM/AA):</label>
                        <input type="text" id="validade" name="validade" placeholder="MM/AA" required>
                    </div>
                    
                    <div>
                        <label for="cvv">CVV:</label>
                        <input type="text" id="cvv" name="cvv" placeholder="123" required>
                    </div>
                    
                    <div class="campo-completo">
                        <label for="parcelas">Parcelamento:</label>
                        <select id="parcelas" name="parcelas">
                            <option value="1">1x sem juros</option>
                            <option value="2">2x sem juros</option>
                            <option value="3">3x sem juros</option>
                            <option value="4">4x</option>
                        </select>
                    </div>
                </div>

                <p style="margin-top: 20px;">Ao clicar em "Finalizar Reserva", você confirma a leitura e aceitação dos nossos termos de serviço.</p>
                
                <button type="submit" class="btn btn-primary" style="margin-top: 10px;">Finalizar Reserva e Pagar</button>
                <a href="quartos.jsp" class="btn btn-secondary">Voltar para Quartos</a>
            </form>
        </div>
    </main>
    
    <%@ include file="_footer.jsp" %>
</body>
</html>