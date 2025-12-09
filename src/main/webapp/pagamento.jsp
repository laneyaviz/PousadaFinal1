<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="modelos.Reserva, modelos.Hospedes, java.text.DecimalFormat, java.text.SimpleDateFormat" %>
<%@ page import="java.text.NumberFormat, java.util.Locale" %>

<%
    // Formatador de Moeda (R$ X.XXX,XX)
    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("pt", "BR"));

    Reserva reserva = (Reserva) request.getAttribute("reserva");
    Hospedes usuario = (Hospedes) session.getAttribute("usuarioLogado");
    
    // Verificação de segurança
    if (reserva == null || usuario == null || reserva.getQuarto() == null) {
        // Redireciona se os objetos essenciais não estiverem na sessão/request
        response.sendRedirect(request.getContextPath() + "/reservas.jsp?erro=reserva_invalida");
        return;
    }
    
    // Formatador de Data
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Pagamento - Pousada Azul do Mar</title>
<link rel="stylesheet" href="css/style.css"/>

<style>
    /* --- Layout e Elementos do Padrão (Consistente) --- */
    main.container {
        max-width: 800px;
        padding: 40px 20px;
    }
    
    h2 {
        font-size: 2em;
        color: #2c3e50; 
        border-bottom: 3px solid #3498db; /* Linha de destaque */
        padding-bottom: 10px;
        margin-bottom: 30px;
    }
    
    /* Resumo da Reserva (Box de Informação) */
    .resumo {
        background-color: #f0f8ff; /* Fundo Suave */
        padding: 20px;
        border-radius: 8px;
        margin-bottom: 30px;
        border-left: 5px solid #1e40af; /* Linha de destaque azul (Primary Color) */
        line-height: 1.8;
        box-shadow: 0 2px 5px rgba(0,0,0,0.05);
    }
    
    .resumo strong {
        color: #1e40af; /* Azul Escuro */
        font-weight: 700;
    }
    
    /* --- Estilos Específicos do PIX --- */
    .pix-info {
        background-color: #e6f7e9; /* Fundo Verde claro (Para PIX/Sucesso Simulado) */
        padding: 25px;
        border-radius: 8px;
        border: 1px solid #2ecc71;
        text-align: center;
        margin-bottom: 25px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.08);
    }
    .pix-info h3 {
        color: #27ae60;
        margin-bottom: 15px;
        font-size: 1.4em;
    }
    /* O estilo .qrcode-placeholder foi removido */
    
    /* Estilo para o botão de confirmação (usando .btn-primary) */
    .btn-confirmar {
        width: 100%;
        padding: 15px;
        font-size: 1.1em;
        margin-top: 20px;
    }
    
    /* Estilo para o campo de seleção (Select - mantido por segurança, embora não seja usado) */
    select {
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 4px;
        width: 100%;
        margin-bottom: 15px;
        box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.07);
    }

</style>
</head>
<body>
<%@ include file="_header.jsp" %>

<main class="container">
    <h2>Pagamento da Reserva</h2>

    <div class="resumo">
        <p><strong>Hóspede:</strong> <%= usuario.getNome() %></p>
        <p><strong>Quarto:</strong> <%= reserva.getQuarto().getTipo() %> - Nº <%= reserva.getQuarto().getNumero() %></p>
        <p><strong>Check-in:</strong> <%= sdf.format(java.sql.Date.valueOf(reserva.getDataCheckin())) %></p>
        <p><strong>Check-out:</strong> <%= sdf.format(java.sql.Date.valueOf(reserva.getDataCheckout())) %></p>
        <p><strong>Valor Total:</strong> <span style="font-size: 1.1em; color: #d97706; font-weight: bold;"><%= currencyFormat.format(reserva.getValorTotal()) %></span></p>
    </div>

    <div class="pix-info">
        <h3>Método de Pagamento: PIX</h3>
        
        <p>Confirme o pagamento de **<%= currencyFormat.format(reserva.getValorTotal()) %>** para finalizar sua reserva.</p>
        
        <p style="font-size: 1em; font-weight: bold; color: #1e40af; margin-top: 20px; margin-bottom: 20px;">
            Chave PIX (Simulação): pousada.azuldumar@pix.com
        </p>
        
        <p style="font-style: italic; color: #7f8c8d; font-size: 0.9em;">
            * Ao confirmar, sua reserva será marcada como **Pendente** e aguardará a confirmação simulada da transferência.
        </p>
    </div>

    <form action="${pageContext.request.contextPath}/PagamentoServlet" method="post">
        <input type="hidden" name="idReserva" value="<%= reserva.getIdReserva() %>">
        <input type="hidden" name="valorTotal" value="<%= reserva.getValorTotal() %>">
        <input type="hidden" name="metodo" value="PIX"> 
        
        <button type="submit" class="btn btn-primary btn-confirmar">
            ✅ CONFIRMAR E AGUARDAR PAGAMENTO
        </button>
    </form>
</main>

<%@ include file="_footer.jsp" %>
</body>
</html>