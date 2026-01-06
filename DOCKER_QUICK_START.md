# 🐳 NanoURL Docker Setup - Quick Start

Your project is fully containerized! Here's how to get started:

## 🚀 Quick Deploy (5 minutes)

### Step 1: Choose Your Platform

**Best Option: Render (Easiest)**
1. Go to [render.com](https://render.com)
2. Click "New +" → "Blueprint"
3. Select your GitHub repo (NanoURL)
4. Click "Create from Blueprint"
5. **Done!** Your app will have unique URLs like:
   - Frontend: `https://nanourl-frontend-xxxxx.onrender.com`
   - Backend: `https://nanourl-backend-xxxxx.onrender.com`

**Alternative: Railway**
1. Go to [railway.app](https://railway.app)
2. Click "New Project"
3. Select "Deploy from GitHub Repo"
4. Choose NanoURL
5. Railway reads `railway.json` automatically
6. **Done!** URLs will be auto-generated

**Alternative: Docker Hub + Your Own Server**
```bash
docker-compose -f docker-compose.prod.yml up -d
```

---

## 🏃 Run Locally First (Optional)

Test everything locally before deploying:

### Windows (PowerShell)
```bash
# Start all containers
.\docker-build.ps1 up

# Check health
.\docker-build.ps1 test

# View logs
.\docker-build.ps1 logs

# Stop
.\docker-build.ps1 down
```

### Windows (Command Prompt)
```bash
# Start
docker-build.bat up

# Test
docker-build.bat test

# Stop
docker-build.bat down
```

### Linux/Mac
```bash
docker-compose up -d
docker-compose logs -f
docker-compose down
```

**Access locally:**
- Frontend: http://localhost:3000
- Backend: http://localhost:8080

---

## 📦 What's Included

✅ **Backend** (Spring Boot Java)
- Multi-stage Docker build (optimized)
- Health checks enabled
- Production configuration
- Environment variable support

✅ **Frontend** (React)
- Production build included
- Dynamic API configuration
- Nginx serving optimization (via serve)

✅ **Database** (MySQL 8.0)
- Auto-initialization
- Persistent volumes
- Health checks

✅ **Cache** (Redis 7)
- Session caching
- Data caching
- Persistence enabled

✅ **Networking**
- Internal network for services
- Service discovery by name
- Isolated from host

✅ **Configuration**
- `.env` file for secrets
- Environment variable support
- Production and development profiles
- Docker Compose for orchestration

---

## 🔐 Security Setup

Before deploying to production:

1. **Update `.env` file:**
   ```bash
   # Copy template
   cp .env.example .env
   
   # Edit with secure values
   # Change all default passwords!
   ```

2. **Generate new JWT secret:**
   ```powershell
   # PowerShell
   [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes((Get-Random -Count 64 | ForEach-Object {[char](48..122|Get-Random)})) -join '')
   ```

3. **Set in your deployment platform:**
   - Render: Dashboard → Environment
   - Railway: Dashboard → Variables
   - Docker Hub: Pass as env vars

---

## 📊 Docker Images

### Backend
- **Base:** Eclipse Temurin 21 (JRE Alpine)
- **Size:** ~200MB (optimized multi-stage)
- **Port:** 8080

### Frontend
- **Base:** Node 18 Alpine
- **Size:** ~100MB (optimized)
- **Port:** 5173

### Database
- **Image:** MySQL 8.0
- **Port:** 3306

### Cache
- **Image:** Redis 7 Alpine
- **Port:** 6379

---

## 🌐 Your Unique Public Addresses

### After Render Deployment:
```
Frontend: https://nanourl-frontend-a1b2c3d4.onrender.com
Backend:  https://nanourl-backend-a1b2c3d4.onrender.com
API:      https://nanourl-backend-a1b2c3d4.onrender.com/api
```

### After Railway Deployment:
```
Frontend: https://yourproject-frontend-xxxxx.railway.app
Backend:  https://yourproject-backend-xxxxx.railway.app
API:      https://yourproject-backend-xxxxx.railway.app/api
```

---

## 📝 Configuration Files

| File | Purpose |
|------|---------|
| `docker-compose.yml` | Development setup |
| `docker-compose.prod.yml` | Production setup |
| `.env.example` | Environment template |
| `render.yaml` | Render deployment config |
| `railway.json` | Railway deployment config |
| `app.json` | Heroku deployment config |
| `.github/workflows/docker-build.yml` | CI/CD pipeline |

---

## 🆘 Troubleshooting

### "Docker daemon not running"
→ Start Docker Desktop

### "Port already in use"
→ Change port in `.env`:
```env
BACKEND_PORT=8081
FRONTEND_PORT=3001
```

### "Database connection failed"
→ Check `SPRING_DATASOURCE_URL` matches MySQL service name
→ Ensure MySQL container is healthy: `docker ps`

### "Frontend can't reach backend"
→ Update `VITE_API_BASE_URL` to your public backend URL
→ On Render: Render auto-updates this

### "Can't access publicly"
→ Check firewall settings
→ Verify service is running: `docker logs nanourl-backend`
→ Check cloud provider port settings

---

## 📚 More Resources

- [Full Deployment Guide](./DOCKER_PUBLIC_DEPLOYMENT.md)
- [Project Structure](./PROJECT_STRUCTURE.md)
- [Backend Guide](./documentation/BACKEND_GUIDE.md)
- [Frontend Guide](./documentation/FRONTEND_GUIDE.md)

---

## ✨ Next Steps

1. **Commit to GitHub:**
   ```bash
   git add .
   git commit -m "Add Docker configuration for public deployment"
   git push origin main
   ```

2. **Choose deployment platform** (Render recommended)

3. **Connect GitHub** and deploy

4. **Get your unique public address!**

---

Your NanoURL is ready to go global! 🚀
