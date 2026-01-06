# 🐳 Docker Backend Deployment Guide

## Overview
This guide shows how to deploy your **NanoURL backend** on Docker - locally and to cloud services.

---

## 📋 Prerequisites

- ✅ Docker installed ([Download](https://www.docker.com/products/docker-desktop))
- ✅ Docker Desktop running
- ✅ Backend code ready (`backend/` folder)
- ✅ MySQL database ready (or use Docker MySQL)
- ✅ Docker Hub account (optional, for cloud deployment)

---

## ✅ Step 1: Verify Docker Installation

Check if Docker is installed:

```bash
docker --version
```

Expected output:
```
Docker version 24.0.0, build abcdef123
```

Check if Docker is running:

```bash
docker ps
```

If you see a list of containers, Docker is running ✅

---

## 🔨 Step 2: Build Docker Image for Backend

### Option A: Using Existing Dockerfile

Your project already has a `backend/Dockerfile`. Check if it's correct:

**File: `backend/Dockerfile`**
```dockerfile
# Build stage
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Runtime stage
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

### Option B: Create New Dockerfile (if missing)

If you don't have a Dockerfile in backend folder:

```bash
cd backend
```

Create file: `backend/Dockerfile`

```dockerfile
# Step 1: Build with Maven
FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /app

# Copy pom.xml first (for dependency caching)
COPY pom.xml .

# Download dependencies
RUN mvn dependency:resolve

# Copy source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Step 2: Runtime image
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Copy jar from build stage
COPY --from=build /app/target/*.jar app.jar

# Set environment variables
ENV SPRING_PROFILES_ACTIVE=prod
ENV SERVER_PORT=8080

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD java -cp app.jar com.example.HealthCheck || exit 1

# Run application
ENTRYPOINT ["java", "-jar", "app.jar"]
```

---

## 🏗️ Step 3: Build Docker Image Locally

### 3.1 Build the Image

Run this command in your project root:

```bash
cd backend
docker build -t nanourl-backend:latest .
```

**Expected output:**
```
[+] Building 45.2s (12/12) FINISHED
 => [build 1/4] FROM maven:3.9-eclipse-temurin-21
 => [build 2/4] WORKDIR /app
 => ...
 => => naming to docker.io/library/nanourl-backend:latest
```

### 3.2 Verify Image Created

```bash
docker images | grep nanourl-backend
```

Expected output:
```
nanourl-backend    latest    abc123def456    2 minutes ago    250MB
```

---

## 🚀 Step 4: Run Backend Locally with Docker

### Option A: With Docker Compose (Recommended)

Update your `docker-compose.yml` in project root:

**File: `docker-compose.yml`**
```yaml
version: '3.8'

services:
  # MySQL Database
  mysql:
    image: mysql:8.0
    container_name: nanourl-mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: root123
      MYSQL_DATABASE: nanourl_db
      MYSQL_USER: nanourl_user
      MYSQL_PASSWORD: NanoURL@SecurePass123
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql
      - ./database/database_schema.sql:/docker-entrypoint-initdb.d/schema.sql
    networks:
      - nanourl-network
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      timeout: 20s
      retries: 10

  # Backend Application
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    container_name: nanourl-backend
    restart: always
    environment:
      SPRING_DATASOURCE_URL: jdbc:mysql://mysql:3306/nanourl_db
      SPRING_DATASOURCE_USERNAME: nanourl_user
      SPRING_DATASOURCE_PASSWORD: NanoURL@SecurePass123
      SPRING_PROFILES_ACTIVE: prod
      SERVER_PORT: 8080
    ports:
      - "8080:8080"
    depends_on:
      mysql:
        condition: service_healthy
    networks:
      - nanourl-network
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/api/health"]
      timeout: 20s
      retries: 10

  # Frontend Application (Optional)
  frontend:
    build:
      context: ./frontend/nanourl-frontend
      dockerfile: Dockerfile
    container_name: nanourl-frontend
    restart: always
    environment:
      VITE_API_BASE_URL: http://backend:8080
    ports:
      - "5173:5173"
    depends_on:
      - backend
    networks:
      - nanourl-network

networks:
  nanourl-network:
    driver: bridge

volumes:
  mysql_data:
```

### Run Everything with Docker Compose

```bash
# Start all services
docker-compose up -d

# Check if all services are running
docker-compose ps
```

Expected output:
```
NAME                 COMMAND                  SERVICE    STATUS
nanourl-mysql        "docker-entrypoint.s…"   mysql      Up (healthy)
nanourl-backend      "java -jar app.jar"      backend    Up (healthy)
nanourl-frontend     "npm run dev"            frontend   Up
```

### Check Backend Logs

```bash
docker-compose logs -f backend
```

### Stop All Services

```bash
docker-compose down
```

---

## 🌐 Step 5: Test Backend Running on Docker

### Test 1: Check if Backend is Responding

```bash
curl http://localhost:8080/api/health
```

Expected response:
```json
{
  "status": "UP"
}
```

### Test 2: Create a User (Registration)

```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "Test@12345"
  }'
```

Expected response:
```json
{
  "message": "User registered successfully",
  "token": "eyJhbGciOiJIUzI1NiJ9..."
}
```

### Test 3: Check Database

```bash
# Connect to MySQL inside Docker
docker exec -it nanourl-mysql mysql -u nanourl_user -p nanourl_db

# Inside MySQL prompt
SHOW TABLES;
SELECT * FROM users;
```

---

## 📦 Step 6: Push Backend Image to Docker Hub (For Cloud Deployment)

### 6.1 Create Docker Hub Account

1. Go to: https://hub.docker.com
2. Sign up (free account)
3. Verify email

### 6.2 Login to Docker Hub

```bash
docker login
```

**Prompt:**
```
Username: your-docker-hub-username
Password: your-docker-hub-password
```

Expected output:
```
Login Succeeded
```

### 6.3 Tag Your Image

```bash
docker tag nanourl-backend:latest your-docker-hub-username/nanourl-backend:latest
```

Example:
```bash
docker tag nanourl-backend:latest het2004/nanourl-backend:latest
```

### 6.4 Push to Docker Hub

```bash
docker push het2004/nanourl-backend:latest
```

**Output:**
```
The push refers to repository [docker.io/het2004/nanourl-backend]
abc123def456: Pushed
ef789ghi012: Pushed
...
latest: digest: sha256:abcdef1234567890 size: 2048
```

Verify on Docker Hub: https://hub.docker.com/r/your-username/nanourl-backend

---

## ☁️ Step 7: Deploy to Cloud Services

### Option A: Deploy to Railway.app (Easiest)

#### 7A.1 Create Railway Account
1. Go to: https://railway.app
2. Sign up with GitHub
3. Create new project

#### 7A.2 Connect GitHub Repository
1. Click "New Project"
2. Select "Deploy from GitHub repo"
3. Choose your NanoURL repository
4. Click "Deploy"

#### 7A.3 Add Environment Variables
In Railway dashboard, add:
```
SPRING_DATASOURCE_URL=jdbc:mysql://your-db-host:3306/nanourl_db
SPRING_DATASOURCE_USERNAME=nanourl_user
SPRING_DATASOURCE_PASSWORD=your-password
SPRING_PROFILES_ACTIVE=prod
SERVER_PORT=8080
JWT_SECRET=your-secret-key-min-32-characters
JWT_EXPIRATION=86400000
ALLOWED_ORIGINS=https://your-frontend-url.vercel.app
```

#### 7A.4 Deploy
- Railway automatically deploys from GitHub
- Your backend URL: `https://your-app-production.railway.app`

---

### Option B: Deploy to Render.com

#### 7B.1 Create Render Account
1. Go to: https://render.com
2. Sign up with GitHub
3. Create new Web Service

#### 7B.2 Configure Service
- **Build Command**: `cd backend && mvn clean package`
- **Start Command**: `java -jar target/*.jar`
- **Environment**: Java

#### 7B.3 Add Environment Variables
```
SPRING_DATASOURCE_URL=jdbc:mysql://your-db-host:3306/nanourl_db
SPRING_DATASOURCE_USERNAME=nanourl_user
SPRING_DATASOURCE_PASSWORD=your-password
SPRING_PROFILES_ACTIVE=prod
```

#### 7B.4 Deploy
- Click "Deploy Service"
- Your backend URL: `https://your-app.onrender.com`

---

### Option C: Deploy Using Docker Image (Any Cloud Provider)

If your cloud provider supports Docker images:

#### 7C.1 Use Your Docker Hub Image
```bash
docker pull het2004/nanourl-backend:latest
docker run -p 8080:8080 \
  -e SPRING_DATASOURCE_URL=jdbc:mysql://your-db:3306/nanourl_db \
  -e SPRING_DATASOURCE_USERNAME=nanourl_user \
  -e SPRING_DATASOURCE_PASSWORD=your-password \
  het2004/nanourl-backend:latest
```

#### 7C.2 Deploy on AWS, GCP, Azure
- Upload Docker image to their container registry
- Create container instance
- Set environment variables
- Deploy

---

## 📊 Docker Commands Reference

### Image Commands
```bash
# List all images
docker images

# Build image
docker build -t nanourl-backend:latest .

# Remove image
docker rmi nanourl-backend:latest

# Push to Docker Hub
docker push your-username/nanourl-backend:latest

# Pull from Docker Hub
docker pull your-username/nanourl-backend:latest
```

### Container Commands
```bash
# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# Run container
docker run -p 8080:8080 nanourl-backend:latest

# Stop container
docker stop container-name

# Start stopped container
docker start container-name

# Remove container
docker rm container-name

# View logs
docker logs container-name

# View logs in real-time
docker logs -f container-name

# Execute command in container
docker exec -it container-name bash
```

### Docker Compose Commands
```bash
# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# View logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f backend

# Restart services
docker-compose restart

# Rebuild images
docker-compose up -d --build

# Remove volumes (delete data)
docker-compose down -v
```

---

## 🐛 Troubleshooting

### Problem 1: Docker Container Exits Immediately
```
docker logs backend
```
**Check for:**
- Database connection errors
- Missing environment variables
- Missing dependencies

**Solution:**
```bash
docker-compose logs -f backend
```
Look for error messages and fix them.

### Problem 2: CORS Error from Frontend
**Error:** `Access to XMLHttpRequest blocked by CORS`

**Solution:**
Update backend CORS in `SecurityConfig.java`:
```java
configuration.setAllowedOrigins(Arrays.asList(
    "http://localhost:5173",
    "http://frontend:5173",           // Docker network
    "https://your-vercel-url.vercel.app"
));
```

Rebuild image:
```bash
docker-compose up -d --build
```

### Problem 3: Cannot Connect to MySQL
**Error:** `Connection refused: localhost:3306`

**Solution:**
- Make sure MySQL container is running: `docker-compose ps`
- Use `mysql` as hostname (not localhost) inside Docker network
- Check connection string uses: `jdbc:mysql://mysql:3306/nanourl_db`

### Problem 4: Port Already in Use
**Error:** `Bind for 0.0.0.0:8080 failed: port is already allocated`

**Solution:**
```bash
# Find what's using port 8080
netstat -ano | findstr :8080

# Kill the process (Windows)
taskkill /PID 1234 /F

# Or use a different port
docker run -p 9090:8080 nanourl-backend:latest
```

---

## ✅ Complete Deployment Checklist

### Local Docker Setup
- [ ] Docker Desktop installed and running
- [ ] Backend Dockerfile created/verified
- [ ] `docker build` completes successfully
- [ ] Image appears in `docker images`
- [ ] `docker-compose up -d` starts all services
- [ ] Backend responds to `curl http://localhost:8080/api/health`
- [ ] Can register user via API
- [ ] Data appears in MySQL

### Docker Hub
- [ ] Docker Hub account created
- [ ] `docker login` successful
- [ ] Image tagged: `your-username/nanourl-backend:latest`
- [ ] Image pushed: `docker push` successful
- [ ] Image visible on Docker Hub website

### Cloud Deployment
- [ ] Railway/Render account created
- [ ] Repository connected to cloud provider
- [ ] Environment variables set
- [ ] Backend deployed successfully
- [ ] Backend URL accessible from browser
- [ ] Frontend can connect to backend API
- [ ] Login/registration working with backend
- [ ] Data persists in database

---

## 📈 Next Steps

### After Local Deployment:
1. Test all API endpoints
2. Verify database operations
3. Check logs for errors
4. Test with frontend

### After Cloud Deployment:
1. Update Vercel environment variables with backend URL
2. Test frontend connecting to cloud backend
3. Monitor backend logs
4. Set up monitoring (CPU, memory, errors)

---

## 🔗 Connection Flow (Docker)

```
┌─────────────────────────────────────────────┐
│          Your Computer                      │
├─────────────────────────────────────────────┤
│  Docker Container: Backend                  │
│  ├─ Port: 8080                              │
│  ├─ Java Application                        │
│  └─ Connected to MySQL                      │
│                                             │
│  Docker Container: MySQL                    │
│  ├─ Port: 3306                              │
│  ├─ Database: nanourl_db                    │
│  └─ Volume: persistent data                 │
│                                             │
│  Docker Container: Frontend (optional)      │
│  ├─ Port: 5173                              │
│  └─ Connected to Backend at http://backend  │
└─────────────────────────────────────────────┘
```

---

## 💡 Pro Tips

1. **Use Multi-Stage Builds** - Reduces image size (250MB → 150MB)
2. **Layer Caching** - Copy `pom.xml` before `src` for faster builds
3. **Health Checks** - Docker automatically restarts unhealthy containers
4. **Named Volumes** - Data persists even if container is removed
5. **Networks** - Services can communicate by name (mysql, backend)

---

## 🎉 You're Ready!

Your backend is now:
- ✅ Running in Docker locally
- ✅ Pushed to Docker Hub
- ✅ Ready for cloud deployment
- ✅ Can connect to frontend

**Test it**: http://localhost:8080

**Share it**: https://hub.docker.com/r/your-username/nanourl-backend

---

**Last Updated**: January 6, 2026
