@echo off
REM Docker Build and Deploy Script for NanoURL

setlocal enabledelayedexpansion

echo.
echo ========================================
echo  NanoURL Docker Build Script
echo ========================================
echo.

REM Check if Docker is running
docker ps >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker is not running. Please start Docker Desktop and try again.
    exit /b 1
)

echo ✅ Docker is running

REM Get command from parameter
set COMMAND=%1

if "%COMMAND%"=="" (
    echo.
    echo Usage: %0 [command]
    echo.
    echo Commands:
    echo   build      - Build all Docker images
    echo   up         - Start containers with docker-compose
    echo   down       - Stop containers
    echo   logs       - View container logs
    echo   clean      - Remove all containers and images
    echo   push       - Push images to Docker Hub (requires setup)
    echo   test       - Run health checks
    echo.
    exit /b 0
)

if "%COMMAND%"=="build" (
    echo.
    echo 🔨 Building Docker images...
    docker-compose build
    if !errorlevel! equ 0 (
        echo ✅ Build successful!
    ) else (
        echo ❌ Build failed!
        exit /b 1
    )
)

if "%COMMAND%"=="up" (
    echo.
    echo 🚀 Starting containers...
    docker-compose up -d
    echo ✅ Containers started!
    echo.
    echo 📍 Access your application:
    echo    Frontend: http://localhost:3000
    echo    Backend:  http://localhost:8080
    echo    MySQL:    localhost:33061
    echo    Redis:    localhost:6379
    echo.
    echo 📊 View logs with: %0 logs
)

if "%COMMAND%"=="down" (
    echo.
    echo 🛑 Stopping containers...
    docker-compose down
    echo ✅ Containers stopped!
)

if "%COMMAND%"=="logs" (
    echo.
    echo 📋 Showing container logs...
    docker-compose logs -f
)

if "%COMMAND%"=="clean" (
    echo.
    echo 🧹 Cleaning up Docker resources...
    docker-compose down -v
    docker system prune -f
    echo ✅ Cleanup complete!
)

if "%COMMAND%"=="push" (
    echo.
    echo 📤 Pushing to Docker Hub...
    echo.
    set /p USERNAME="Enter your Docker Hub username: "
    if "!USERNAME!"=="" (
        echo ❌ Username required!
        exit /b 1
    )
    
    echo.
    echo Tagging images...
    docker tag nanourl-backend:latest !USERNAME!/nanourl-backend:latest
    docker tag nanourl-frontend:latest !USERNAME!/nanourl-frontend:latest
    
    echo.
    echo Logging into Docker Hub...
    docker login
    
    echo.
    echo Pushing backend...
    docker push !USERNAME!/nanourl-backend:latest
    
    echo.
    echo Pushing frontend...
    docker push !USERNAME!/nanourl-frontend:latest
    
    echo ✅ Push complete!
    echo.
    echo Your images are now available at:
    echo   !USERNAME!/nanourl-backend:latest
    echo   !USERNAME!/nanourl-frontend:latest
)

if "%COMMAND%"=="test" (
    echo.
    echo 🧪 Running health checks...
    echo.
    
    timeout /t 2 >nul
    
    echo Checking Backend...
    curl -s http://localhost:8080/api/health >nul 2>&1
    if !errorlevel! equ 0 (
        echo ✅ Backend is healthy
    ) else (
        echo ❌ Backend is not responding
    )
    
    echo.
    echo Checking Frontend...
    curl -s http://localhost:3000 >nul 2>&1
    if !errorlevel! equ 0 (
        echo ✅ Frontend is healthy
    ) else (
        echo ❌ Frontend is not responding
    )
    
    echo.
    echo Checking MySQL...
    docker exec nanourl-mysql mysqladmin ping -h localhost >nul 2>&1
    if !errorlevel! equ 0 (
        echo ✅ MySQL is healthy
    ) else (
        echo ❌ MySQL is not responding
    )
    
    echo.
    echo Checking Redis...
    docker exec nanourl-redis redis-cli ping >nul 2>&1
    if !errorlevel! equ 0 (
        echo ✅ Redis is healthy
    ) else (
        echo ❌ Redis is not responding
    )
)

endlocal
