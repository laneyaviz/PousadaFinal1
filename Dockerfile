# Etapa 1: Compilar as classes Java
FROM eclipse-temurin:17-jdk AS build

WORKDIR /app

# Copia o código-fonte
COPY src/ src/
COPY WebContent/ WebContent/

# Cria o diretório de classes compiladas
RUN mkdir -p WebContent/WEB-INF/classes

# Compila todos os .java para dentro de WEB-INF/classes
RUN find src -name "*.java" > sources.txt && javac -d WebContent/WEB-INF/classes @sources.txt

# Etapa 2: Rodar no Tomcat
FROM tomcat:10.1.26-jdk17

# Remove o app padrão
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copia o app compilado para o Tomcat
COPY --from=build /app/WebContent /usr/local/tomcat/webapps/ROOT

# Expõe a porta 8080 (Render usa automaticamente)
EXPOSE 8080

# Inicia o Tomcat
CMD ["catalina.sh", "run"]
