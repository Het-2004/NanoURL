# Multi-stage build for optimized image size - Optimized for Render
FROM maven:3.9.9-eclipse-temurin-21 AS build

WORKDIR /app

# Copy pom.xml and download dependencies (cached layer)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code and build
COPY src ./src
RUN mvn clean package -DskipTests

# Runtime stage
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Install wget for health check
RUN apk add --no-cache wget

# Create database directory
RUN mkdir -p /app/Database

# Copy the built JAR from build stage
COPY --from=build /app/target/*.jar app.jar

# Expose port (Render will use PORT environment variable)
EXPOSE 8080

# Set default environment variables (will be overridden by Render)
ENV SPRING_PROFILES_ACTIVE=prod
ENV PORT=8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:${PORT}/actuator/health || exit 1

# Run the application with dynamic port
ENTRYPOINT ["sh", "-c", "java -Dserver.port=${PORT} -jar app.jar"]
