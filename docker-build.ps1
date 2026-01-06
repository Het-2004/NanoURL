#!/usr/bin/env pwsh
# Docker Build and Deploy Script for NanoURL

param(
    [Parameter(Position=0)]
    [ValidateSet('build', 'up', 'down', 'logs', 'clean', 'push', 'test', 'status')]
    [string]$Command
)

function Write-Header {
    param([string]$Message)
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host " $Message" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Success {
    param([string]$Message)
    Write-Host "✅ $Message" -ForegroundColor Green
}

function Write-Error {
    param([string]$Message)
    Write-Host "❌ $Message" -ForegroundColor Red
}

function Write-Info {
    param([string]$Message)
    Write-Host "ℹ️ $Message" -ForegroundColor Cyan
}

# Check if Docker is running
try {
    docker ps | Out-Null
    Write-Success "Docker is running"
} catch {
    Write-Error "Docker is not running. Please start Docker Desktop and try again."
    exit 1
}

if (-not $Command) {
    Write-Header "NanoURL Docker Build Script"
    Write-Host "Usage: .\docker-build.ps1 [command]" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Commands:" -ForegroundColor Yellow
    Write-Host "  build      - Build all Docker images"
    Write-Host "  up         - Start containers with docker-compose"
    Write-Host "  down       - Stop containers"
    Write-Host "  logs       - View container logs"
    Write-Host "  clean      - Remove all containers and images"
    Write-Host "  push       - Push images to Docker Hub"
    Write-Host "  test       - Run health checks"
    Write-Host "  status     - Check container status"
    Write-Host ""
    exit 0
}

switch ($Command) {
    'build' {
        Write-Header "🔨 Building Docker Images"
        docker-compose build
        if ($LASTEXITCODE -eq 0) {
            Write-Success "Build successful!"
        } else {
            Write-Error "Build failed!"
            exit 1
        }
    }

    'up' {
        Write-Header "🚀 Starting Containers"
        docker-compose up -d
        Write-Success "Containers started!"
        Write-Info "Access your application:"
        Write-Host "  Frontend: http://localhost:3000" -ForegroundColor Yellow
        Write-Host "  Backend:  http://localhost:8080" -ForegroundColor Yellow
        Write-Host "  MySQL:    localhost:33061" -ForegroundColor Yellow
        Write-Host "  Redis:    localhost:6379" -ForegroundColor Yellow
        Write-Host ""
        Write-Info "View logs with: .\docker-build.ps1 logs"
    }

    'down' {
        Write-Header "🛑 Stopping Containers"
        docker-compose down
        Write-Success "Containers stopped!"
    }

    'logs' {
        Write-Header "📋 Container Logs"
        docker-compose logs -f
    }

    'clean' {
        Write-Header "🧹 Cleaning Up Docker Resources"
        docker-compose down -v
        docker system prune -f
        Write-Success "Cleanup complete!"
    }

    'push' {
        Write-Header "📤 Pushing to Docker Hub"
        $Username = Read-Host "Enter your Docker Hub username"
        
        if ([string]::IsNullOrWhiteSpace($Username)) {
            Write-Error "Username required!"
            exit 1
        }

        Write-Host ""
        Write-Info "Tagging images..."
        docker tag nanourl-backend:latest "$Username/nanourl-backend:latest"
        docker tag nanourl-frontend:latest "$Username/nanourl-frontend:latest"

        Write-Host ""
        Write-Info "Logging into Docker Hub..."
        docker login

        Write-Host ""
        Write-Info "Pushing backend..."
        docker push "$Username/nanourl-backend:latest"

        Write-Host ""
        Write-Info "Pushing frontend..."
        docker push "$Username/nanourl-frontend:latest"

        Write-Success "Push complete!"
        Write-Host ""
        Write-Info "Your images are now available at:"
        Write-Host "  $Username/nanourl-backend:latest" -ForegroundColor Yellow
        Write-Host "  $Username/nanourl-frontend:latest" -ForegroundColor Yellow
    }

    'test' {
        Write-Header "🧪 Running Health Checks"
        
        Start-Sleep -Seconds 2

        Write-Host "Checking Backend..."
        try {
            $response = Invoke-WebRequest -Uri "http://localhost:8080/api/health" -ErrorAction SilentlyContinue
            if ($response.StatusCode -eq 200) {
                Write-Success "Backend is healthy"
            }
        } catch {
            Write-Error "Backend is not responding"
        }

        Write-Host ""
        Write-Host "Checking Frontend..."
        try {
            $response = Invoke-WebRequest -Uri "http://localhost:3000" -ErrorAction SilentlyContinue
            if ($response.StatusCode -eq 200) {
                Write-Success "Frontend is healthy"
            }
        } catch {
            Write-Error "Frontend is not responding"
        }

        Write-Host ""
        Write-Host "Checking MySQL..."
        $mysqlCheck = docker exec nanourl-mysql mysqladmin ping -h localhost 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Success "MySQL is healthy"
        } else {
            Write-Error "MySQL is not responding"
        }

        Write-Host ""
        Write-Host "Checking Redis..."
        $redisCheck = docker exec nanourl-redis redis-cli ping 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Success "Redis is healthy"
        } else {
            Write-Error "Redis is not responding"
        }
    }

    'status' {
        Write-Header "📊 Container Status"
        docker-compose ps
    }
}
