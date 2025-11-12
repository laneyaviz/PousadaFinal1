# Etapa 1: Compilar código Java
FROM eclipse-temurin:17-jdk AS build

WORKDIR /app

# Copia código-fonte e recursos
COPY src/main/java/ /app/src/
COPY src/main/webapp/ /app/WebContent/

# Cria diretório de classes compiladas
RUN mkdir -p /app/WebContent/WEB-INF/classes

# Cria pasta para dependências
RUN mkdir -p /app/lib

# Baixa dependências necessárias
RUN wget -O /app/lib/jakarta-servlet.jar https://repo1.maven.org/maven2/jakarta/servlet/jakarta.servlet-api/5.0.0/jakarta.servlet-api-5.0.0.jar && \
    wget -O /app/lib/mysql-connector.jar https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.0.33/mysql-connector-j-8.0.33.jar

# Compila os arquivos Java com classpath explícito
RUN find /app/src -name "*.java" > sources.txt && \
    javac -cp "/app/lib/jakarta-servlet.jar:/app/lib/mysql-connector.jar" -d /app/WebContent/WEB-INF/classes @sources.txt

# Etapa 2: Executar no Tomcat
FROM tomcat:10.1.26-jdk17

# Remove o ROOT padrão do Tomcat
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copia a aplicação compilada
COPY --from=build /app/WebContent /usr/local/tomcat/webapps/ROOT

EXPOSE 8080

CMD ["catalina.sh", "run"]
