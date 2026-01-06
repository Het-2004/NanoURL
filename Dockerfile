# ========================================
# Multi-Service Dockerfile for NanoURL
# Builds Backend (Java Spring Boot) + Frontend (React/Vite)
# Optimized for Render.com Deployment
# ========================================

# ========================================
# Stage 1: Build Backend (Maven + Java)
# ========================================
FROM maven:3.9.9-eclipse-temurin-21 AS backend-build

WORKDIR /app/backend

# Copy backend pom.xml and download dependencies
COPY backend/pom.xml .
RUN mvn dependency:go-offline -B

# Copy backend source and build
COPY backend/src ./src
RUN mvn clean package -DskipTests

# ========================================
# Stage 2: Build Frontend (Node + Vite)
# ========================================
FROM node:18-alpine AS frontend-build

WORKDIR /app/frontend

# Copy frontend package files
COPY frontend/nanourl-frontend/package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy frontend source
COPY frontend/nanourl-frontend/ .

# Build frontend with environment variable support
ARG VITE_API_BASE_URL=http://localhost:8080
ENV VITE_API_BASE_URL=${VITE_API_BASE_URL}

RUN npm run build

# ========================================
# Stage 3: Runtime - Backend + Frontend
# Uses nginx to serve both frontend and proxy backend
# ========================================
FROM nginx:alpine

# Install Java Runtime for backend
RUN apk add --no-cache openjdk21-jre wget

WORKDIR /app

# Copy backend JAR
COPY --from=backend-build /app/backend/target/*.jar /app/backend.jar

# Copy frontend build to nginx
COPY --from=frontend-build /app/frontend/dist /usr/share/nginx/html

# Copy nginx configuration
COPY nginx-full.conf /etc/nginx/conf.d/default.conf

# Create startup script
RUN echo '#!/bin/sh' > /app/start.sh && \
    echo 'java -Dserver.port=8080 -jar /app/backend.jar &' >> /app/start.sh && \
    echo 'nginx -g "daemon off;"' >> /app/start.sh && \
    chmod +x /app/start.sh

# Expose port 80 (Render will map this)
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:80/health || exit 1

# Start both services
CMD ["/app/start.sh"]
