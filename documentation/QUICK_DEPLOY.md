# 🚀 Quick Deploy

Quick deployment commands for Render.

---

## **Deploy Backend (Docker)**

```bash
# 1. Build Docker image
docker build -t nanourl-backend backend/

# 2. Push to Render
# Go to https://render.com
# Create Web Service
# Connect GitHub repo
# Set build command: (empty - uses Dockerfile)
# Set port: 8080
# Deploy!
```

---

## **Deploy Frontend (Static)**

```bash
# 1. Build frontend
cd frontend/nanourl-frontend
npm run build

# 2. Go to Render
# Create Static Site
# Set build: cd frontend/nanourl-frontend && npm run build
# Set publish: frontend/nanourl-frontend/dist
# Deploy!
```

---

## **Environment Variables**

Set in Render dashboard:

**Backend:**
```
APP_BASE_URL=https://nanourl-backend.onrender.com
DB_URL=jdbc:mysql://localhost:3306/nanourl_db
DB_USER=nanourl_prod
DB_PASSWORD=YourSecurePassword
```

**Frontend:**
```
VITE_API_URL=https://nanourl-backend.onrender.com
```

---

## **DNS Setup**

1. Go to Render
2. Service → Custom Domain
3. Add your domain
4. Update DNS with Render's nameservers
5. Wait 24 hours

---

## **Done! 🎉**

See [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) for detailed steps.
