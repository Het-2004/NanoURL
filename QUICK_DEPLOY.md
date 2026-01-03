# 🚀 Quick Deployment Commands

## Upload to GitHub

```bash
# Navigate to project
cd D:\JAVA\Project\NanoURL

# Initialize Git
git init
git add .
git commit -m "Initial commit: NanoURL application with JWT auth"

# Create repo on GitHub first, then:
git remote add origin https://github.com/YOUR_USERNAME/NanoURL.git
git branch -M main
git push -u origin main
```

## Deploy Backend (Render with Docker)

1. Go to https://dashboard.render.com/
2. **New +** → **Web Service**
3. Connect GitHub → Select `NanoURL` repo
4. Settings:
   - **Name**: `nanourl-backend`
   - **Environment**: Docker
   - **Root Directory**: `backend`
   - **Plan**: Free
5. **Environment Variables**:
   ```
   JWT_SECRET=your-super-secret-jwt-key-change-this-to-something-very-secure-and-long
   ALLOWED_ORIGINS=https://YOUR-FRONTEND-NAME.onrender.com
   ```
6. Click **Create Web Service**
7. **Copy your backend URL**: `https://nanourl-backend-xxxx.onrender.com`

## Deploy Frontend (Render Static Site)

1. Edit `.env.production`:
   ```
   VITE_API_URL=https://nanourl-backend-xxxx.onrender.com
   ```
2. Commit and push:
   ```bash
   git add .
   git commit -m "Update production API URL"
   git push
   ```
3. Render Dashboard → **New +** → **Static Site**
4. Connect GitHub → Select `NanoURL` repo
5. Settings:
   - **Name**: `nanourl-frontend`
   - **Root Directory**: `frontend/nanourl-frontend`
   - **Build Command**: `npm install && npm run build`
   - **Publish Directory**: `dist`
6. Click **Create Static Site**

## Update CORS

Go back to backend service → Environment → Update:
```
ALLOWED_ORIGINS=https://YOUR-FRONTEND-NAME.onrender.com
```

## ✅ Done!

Frontend: `https://nanourl-frontend.onrender.com`
Backend: `https://nanourl-backend-xxxx.onrender.com`
