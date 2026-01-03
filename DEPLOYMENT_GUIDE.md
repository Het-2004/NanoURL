# 🚀 NanoURL Deployment Guide

Complete guide to deploy NanoURL to production with Backend on Docker and Frontend on Render.

---

## 📋 Prerequisites

- GitHub account
- Docker Hub account (for backend Docker image)
- Render account (free tier available)
- Git installed on your computer

---

## 1️⃣ Upload to GitHub

### Step 1: Initialize Git Repository

```bash
cd D:\JAVA\Project\NanoURL
git init
git add .
git commit -m "Initial commit: NanoURL application"
```

### Step 2: Create GitHub Repository

1. Go to https://github.com/new
2. Repository name: `NanoURL`
3. Description: `URL Shortener with JWT Authentication`
4. Choose **Public** or **Private**
5. **DON'T** initialize with README (we already have files)
6. Click **Create repository**

### Step 3: Push to GitHub

```bash
git remote add origin https://github.com/YOUR_USERNAME/NanoURL.git
git branch -M main
git push -u origin main
```

✅ **Your code is now on GitHub!**

---

## 2️⃣ Deploy Backend with Docker

### Option A: Deploy to Render (Recommended - Free Tier)

1. **Go to Render Dashboard**: https://dashboard.render.com/
2. Click **"New +"** → **"Web Service"**
3. Connect your GitHub repository
4. Configure:
   - **Name**: `nanourl-backend`
   - **Environment**: `Docker`
   - **Branch**: `main`
   - **Root Directory**: `backend`
   - **Plan**: Free
5. **Environment Variables** (click "Advanced"):
   ```
   JWT_SECRET=your-super-secret-jwt-key-change-this-to-something-very-secure
   ALLOWED_ORIGINS=https://your-frontend-name.onrender.com
   ```
6. Click **"Create Web Service"**

**Your backend will be at**: `https://nanourl-backend-xxxx.onrender.com`

---

### Option B: Deploy to Any Docker Platform

#### Build and Push to Docker Hub

```bash
# Login to Docker Hub
docker login

# Navigate to backend
cd backend

# Build the image
docker build -t YOUR_DOCKERHUB_USERNAME/nanourl-backend:latest .

# Push to Docker Hub
docker push YOUR_DOCKERHUB_USERNAME/nanourl-backend:latest
```

#### Run on Any Platform

```bash
docker run -d \
  -p 8080:8080 \
  -e JWT_SECRET="your-secret-key" \
  -e ALLOWED_ORIGINS="https://your-frontend.com" \
  --name nanourl-backend \
  YOUR_DOCKERHUB_USERNAME/nanourl-backend:latest
```

---

## 3️⃣ Deploy Frontend to Render

### Step 1: Update API URL

1. Edit `frontend/nanourl-frontend/.env.production`
2. Replace with your backend URL:
   ```
   VITE_API_URL=https://nanourl-backend-xxxx.onrender.com
   ```
3. Commit and push:
   ```bash
   git add .
   git commit -m "Update production API URL"
   git push
   ```

### Step 2: Create Render Service

1. Go to **Render Dashboard**: https://dashboard.render.com/
2. Click **"New +"** → **"Static Site"**
3. Connect your GitHub repository
4. Configure:
   - **Name**: `nanourl-frontend`
   - **Branch**: `main`
   - **Root Directory**: `frontend/nanourl-frontend`
   - **Build Command**: `npm install && npm run build`
   - **Publish Directory**: `dist`
5. Click **"Create Static Site"**

**Your frontend will be at**: `https://nanourl-frontend.onrender.com`

---

## 4️⃣ Update CORS Settings

After both are deployed, update the backend CORS:

1. Go to Render Backend service
2. **Environment** → Add/Update:
   ```
   ALLOWED_ORIGINS=https://nanourl-frontend.onrender.com
   ```
3. Save (auto-redeploys)

---

## 5️⃣ Update Frontend URLs

Update all API calls to use environment variables:

### In `src/services/api.js`:
```javascript
const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:8080';
```

### Update all fetch calls:
Replace `http://localhost:8080` with `${API_URL}`

Example:
```javascript
// Before
fetch('http://localhost:8080/api/auth/signin', ...)

// After
fetch(`${API_URL}/api/auth/signin`, ...)
```

---

## 🔐 OAuth Setup (Optional)

### Google OAuth

1. **Google Cloud Console**: https://console.cloud.google.com/
2. Create Project → Enable Google+ API
3. **Credentials** → **Create OAuth 2.0 Client ID**
4. Authorized redirect URIs:
   ```
   https://nanourl-backend-xxxx.onrender.com/login/oauth2/code/google
   ```
5. Copy **Client ID** and **Client Secret**
6. Add to Render Backend Environment Variables:
   ```
   GOOGLE_CLIENT_ID=your-client-id
   GOOGLE_CLIENT_SECRET=your-client-secret
   ```

### GitHub OAuth

1. **GitHub Settings**: https://github.com/settings/developers
2. **New OAuth App**
3. Authorization callback URL:
   ```
   https://nanourl-backend-xxxx.onrender.com/login/oauth2/code/github
   ```
4. Copy **Client ID** and **Client Secret**
5. Add to Render Backend Environment Variables:
   ```
   GITHUB_CLIENT_ID=your-client-id
   GITHUB_CLIENT_SECRET=your-client-secret
   ```

---

## 📊 Database Persistence on Render

⚠️ **Important**: Render's free tier may delete files on restart!

### Solution 1: Use Render Persistent Disk (Paid)

1. Backend Service → **Disks**
2. Add Disk: `/app/Database` (7GB free with paid plan)

### Solution 2: Use PostgreSQL (Free)

1. Render Dashboard → **New** → **PostgreSQL**
2. Update `pom.xml` and `application-prod.yaml` to use PostgreSQL

---

## ✅ Final Checklist

- [ ] Code pushed to GitHub
- [ ] Backend deployed on Render/Docker
- [ ] Frontend deployed on Render
- [ ] CORS origins updated
- [ ] Environment variables set (JWT_SECRET, API_URL)
- [ ] OAuth credentials configured (if using)
- [ ] Test login functionality
- [ ] Test URL shortening
- [ ] Test redirects

---

## 🌐 Your Live URLs

| Service | URL |
|---------|-----|
| Frontend | `https://nanourl-frontend.onrender.com` |
| Backend API | `https://nanourl-backend-xxxx.onrender.com` |
| GitHub Repo | `https://github.com/YOUR_USERNAME/NanoURL` |

---

## 🆘 Troubleshooting

### Backend not starting?
- Check Render logs
- Verify JWT_SECRET is set
- Check Dockerfile builds locally: `docker build -t test .`

### Frontend can't connect to backend?
- Check `.env.production` has correct backend URL
- Verify CORS settings on backend
- Check browser console for errors

### OAuth not working?
- Verify redirect URIs match exactly
- Check client IDs/secrets are correct
- Ensure HTTPS (not HTTP) in production

---

## 🎉 Success!

Your NanoURL app is now live! Share your link and start shortening URLs! 🚀
