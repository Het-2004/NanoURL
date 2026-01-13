# NanoURL Backend Dockerfile
FROM maven:3.9.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY Backend/pom.xml ./pom.xml
COPY Backend/src ./src
RUN mvn clean package -DskipTests

FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENV PORT=8080
CMD ["java", "-jar", "-Dserver.port=${PORT}", "app.jar"]
