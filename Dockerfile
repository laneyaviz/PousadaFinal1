# Etapa 1 — Compilar código-fonte Java (Java 11)
FROM eclipse-temurin:11-jdk AS build

WORKDIR /app

# Copia código fonte
COPY src/ /app/src/
COPY webapps/ /app/webapps/

# Cria diretório para classes compiladas
RUN mkdir -p /app/webapps/WEB-INF/classes

# Baixa dependências necessárias (Jakarta Servlet + MySQL)
RUN apt-get update && apt-get install -y wget && \
    mkdir -p /app/lib && \
    wget -O /app/lib/jakarta-servlet.jar https://repo1.maven.org/maven2/jakarta/servlet/jakarta.servlet-api/5.0.0/jakarta.servlet-api-5.0.0.jar && \
    wget -O /app/lib/mysql-connector.jar https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.0.33/mysql-connector-j-8.0.33.jar

# Compila as classes Java com o classpath correto
RUN find /app/src -name "*.java" > sources.txt && \
    javac -cp "/app/lib/jakarta-servlet.jar:/app/lib/mysql-connector.jar" \
          -d /app/webapps/WEB-INF/classes @sources.txt

# Etapa 2 — Executar no Tomcat 10 com Java 11
FROM tomcat:10.1.26-jdk11

# Remove o app padrão
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copia o conteúdo da aplicação compilada
COPY --from=build /app/webapps /usr/local/tomcat/webapps/ROOT

EXPOSE 8080

CMD ["catalina.sh", "run"]
