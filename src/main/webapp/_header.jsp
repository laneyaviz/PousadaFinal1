<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="modelos.Hospedes" %>

<%
    // Recupera o usuário logado da sessão
    Hospedes usuarioLogado = (Hospedes) session.getAttribute("usuarioLogado");
    boolean isAdmin = (usuarioLogado != null && usuarioLogado.getIdHospede() == 1);
%>

<header>
  <div class="container header-content">
    <a href="index.jsp" class="logo">
      <img src="imagens/logo.png" alt="Logo">
    </a>
    
    <nav class="menu">
      <a href="index.jsp">Home</a>
      <a href="quartos.jsp">Quartos</a>
      <a href="sobre.jsp">Sobre</a>
      <a href="contato.jsp">Contato</a>
      
      <% if (usuarioLogado != null && !isAdmin) { %>
        <a href="<%= request.getContextPath() %>/ReservaServlet?acao=minhas_reservas">Minhas Reservas</a>
      <% } else if (isAdmin) { %>
        <%-- CORREÇÃO: Usando request.getContextPath() --%>
        <a href="<%= request.getContextPath() %>/ReservaServlet?acao=listar">Gestão Reservas</a>
        <a href="<%= request.getContextPath() %>/QuartoServlet?acao=listar">Gestão Quartos</a>
      <% } %>
    </nav>
    
    <div class="header-buttons">
      <% if (usuarioLogado != null) { %>
        <span class="usuario-logado">Olá, <%= usuarioLogado.getNome() %>!</span>
        <%-- CORREÇÃO: Usando request.getContextPath() --%>
        <a href="<%= request.getContextPath() %>/LoginServlet?acao=logout" class="btn btn-secondary">Sair</a>
      <% } else { %>
        <a href="entrar.jsp" class="btn btn-secondary">Entrar</a>
        <a href="registro.jsp" class="btn btn-primary">Registrar</a>
      <% } %>
    </div>
  </div>
</header>