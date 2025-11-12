# Etapa 1: Usar JDK para compilar as classes Java
FROM eclipse-temurin:17-jdk AS build

WORKDIR /app

# Copia código-fonte Java e JSP
COPY src/ /app/src/

# Compila as classes Java (ajuste se necessário)
RUN mkdir -p /app/src/WEB-INF/classes && \
    find /app/src -name "*.java" > sources.txt && \
    javac -d /app/src/WEB-INF/classes @sources.txt

# Etapa 2: Servir via Tomcat
FROM tomcat:10.1.26-jdk17

# Remove o ROOT padrão do Tomcat
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copia a aplicação para a pasta ROOT do Tomcat
COPY --from=build /app/src /usr/local/tomcat/webapps/ROOT

EXPOSE 8080

CMD ["catalina.sh", "run"]
