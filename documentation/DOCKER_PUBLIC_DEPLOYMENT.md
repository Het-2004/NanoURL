# 🚀 NanoURL - Public Docker Deployment Guide

Your NanoURL application is fully containerized and ready for public deployment! This guide shows how to deploy with a unique public address.

## Quick Start (Choose One)

### Option 1: Render (Recommended - Free)
**Easiest setup, free tier available, auto-HTTPS**

1. Visit [render.com](https://render.com)
2. Sign up with GitHub
3. Click "New +" → "Blueprint" 
4. Connect your GitHub repo (NanoURL)
5. Click "Deploy"
6. Render will auto-create:
   - `nanourl-backend` service (unique URL: `https://nanourl-backend-xxxxx.onrender.com`)
   - `nanourl-frontend` service (unique URL: `https://nanourl-frontend-xxxxx.onrender.com`)
   - MySQL database
   - Redis cache

**Result:** Public URLs like:
- Frontend: `https://nanourl-frontend-abc123.onrender.com`
- Backend API: `https://nanourl-backend-abc123.onrender.com/api`

---

### Option 2: Railway (Free $5/month)
**Fast deployment, good free tier**

1. Visit [railway.app](https://railway.app)
2. Sign up with GitHub
3. Click "New Project"
4. Select "Deploy from GitHub Repo"
5. Choose your NanoURL repo
6. Railway automatically reads `railway.json`
7. Configure env vars in dashboard
8. Deploy

**Result:** Unique URLs assigned automatically

---

### Option 3: Docker Hub + Manual Deployment
**For VPS or personal server**

```bash
# 1. Build images locally
docker-compose build

# 2. Tag for Docker Hub
docker tag nanourl-backend:latest yourusername/nanourl-backend:latest
docker tag nanourl-frontend:latest yourusername/nanourl-frontend:latest

# 3. Push to Docker Hub
docker login
docker push yourusername/nanourl-backend:latest
docker push yourusername/nanourl-frontend:latest

# 4. On your server, pull and run
docker pull yourusername/nanourl-backend:latest
docker pull yourusername/nanourl-frontend:latest
docker-compose -f docker-compose.prod.yml up -d
```

---

### Option 4: Cloud Run (Google Cloud)
**Serverless, pay-as-you-go**

```bash
# Deploy backend
gcloud run deploy nanourl-backend \
  --source ./backend \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated

# Deploy frontend
gcloud run deploy nanourl-frontend \
  --source ./frontend/nanourl-frontend \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated
```

---

## Environment Variables for Public Deployment

Create `.env` file with production values:

```env
# Database
MYSQL_ROOT_PASSWORD=your_secure_password_here
MYSQL_USER=nanourl_user
MYSQL_PASSWORD=another_secure_password

# JWT Secret (change this!)
JWT_SECRET=generate_a_long_random_string_here

# App URLs (use your actual public URLs)
APP_BASE_URL=https://your-frontend-domain.com
VITE_API_BASE_URL=https://your-backend-domain.com

# Spring Profile
SPRING_PROFILES_ACTIVE=prod
```

---

## How to Get Your Unique Address

### On Render:
After deployment, you'll see URLs like:
- `https://nanourl-frontend-a1b2c3d4.onrender.com`

The unique identifier (`a1b2c3d4`) is auto-generated.

### On Railway:
Your project gets an auto-generated domain during deployment.

### On Docker Hub:
You choose your own username and image names:
- `yourusername/nanourl-backend`
- `yourusername/nanourl-frontend`

---

## Testing Your Deployment

```bash
# Test backend API
curl https://your-backend-url/api/health

# Test frontend
curl https://your-frontend-url
```

---

## Features Included

✅ Multi-stage Docker builds (optimized images)  
✅ Docker Compose for local dev  
✅ Production docker-compose.prod.yml  
✅ Environment variable configuration  
✅ GitHub Actions CI/CD pipeline  
✅ Health checks  
✅ Auto-restart on failure  
✅ Persistent volumes for data  
✅ Redis caching  
✅ MySQL database  

---

## Security Best Practices

1. **Change default passwords** in `.env`
2. **Update JWT_SECRET** - generate a random 64+ char string
3. **Use HTTPS** - all cloud providers support it
4. **Set environment variables** on cloud platform, not in code
5. **Rotate secrets regularly**

---

## Troubleshooting

### Container won't start?
```bash
docker logs nanourl-backend
docker logs nanourl-frontend
```

### Can't connect to database?
- Check `SPRING_DATASOURCE_URL` matches your DB service
- Verify MySQL is running: `docker ps`
- Check network connectivity: services must be on same network

### API endpoints not responding?
- Check backend logs: `docker logs nanourl-backend`
- Verify `APP_BASE_URL` and `VITE_API_BASE_URL` are correct
- Ensure frontend has correct backend URL in env vars

---

## Monitor Your Application

### Render Dashboard
- Real-time logs
- Deployment history
- Resource usage
- Restart options

### Railway Dashboard
- Deploy history
- Logs stream
- Metrics
- Environment variables

### Local Testing
```bash
# See all running containers
docker ps

# View logs
docker logs -f nanourl-backend

# Execute command in container
docker exec nanourl-backend ls -la
```

---

## Next Steps

1. Choose your deployment platform (Render recommended)
2. Push code to GitHub
3. Connect GitHub to deployment platform
4. Configure environment variables
5. Deploy and get your unique public address!

Your NanoURL will be live with a unique address like:
- **Frontend:** `https://nanourl-frontend-xxxxx.onrender.com`
- **Backend:** `https://nanourl-backend-xxxxx.onrender.com`
- **API:** `https://nanourl-backend-xxxxx.onrender.com/api`

Enjoy! 🎉
