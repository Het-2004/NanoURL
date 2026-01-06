# ⚡ Quick Deploy Backend - Checklist

## Your Setup
- ✅ GitHub Repository: `https://github.com/Het-2004/NanoURL`
- ✅ Frontend (Vercel): `https://nano-url-indol.vercel.app`
- ✅ Backend (Will be): `https://nanourl-backend.onrender.com`

---

## 5-Minute Deployment Steps

### 1️⃣ Push Latest Code to GitHub (2 min)
```bash
cd d:\JAVA\Project\NanoURL
git add .
git commit -m "Deploy backend with CORS configuration"
git push origin main
```

### 2️⃣ Go to Render Dashboard (1 min)
1. Visit: **https://render.com/dashboard**
2. Click **"New +"** → **"Web Service"**
3. Search for **"NanoURL"** and click **"Connect"**

### 3️⃣ Configure Service (1 min)

Fill in exactly:
```
Name: nanourl-backend
Environment: Docker
Region: (your choice)
Branch: main
Root Directory: backend ⭐ IMPORTANT
Dockerfile Path: Dockerfile
Auto-Deploy: Yes
```

### 4️⃣ Add Environment Variables (1 min)

Click **"Advanced"** and copy-paste these:
```
SPRING_DATASOURCE_URL=jdbc:mysql://localhost:3306/nanourl_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
SPRING_DATASOURCE_USERNAME=nanourl_user
SPRING_DATASOURCE_PASSWORD=NanoURL@SecurePass123
SPRING_PROFILES_ACTIVE=prod
JWT_SECRET=9d8f0c6b2e5a4c1f7d9b6a8c3e4f1a0d9c7b5a3e1f6d8c2b4a9e7c5d3b1f0a2c
ALLOWED_ORIGINS=https://nano-url-indol.vercel.app,https://*.vercel.app
```

### 5️⃣ Click "Create Web Service" and Wait ⏳

Takes 2-5 minutes to build and deploy.

**You'll see:** `"Your service is live!"`

---

## Verify It's Working

### Test 1: Check Backend Health
Open in browser:
```
https://nanourl-backend.onrender.com/health
```

Should show:
```json
{"status":"UP","message":"Backend is healthy"}
```

### Test 2: Check Frontend Connects
1. Go to: `https://nano-url-indol.vercel.app`
2. Try **Sign Up**
3. If it works → ✅ Connected!

---

## 🆘 If Something Goes Wrong

### Build Failed?
→ Check **Render Logs** tab for errors

### Service Down?
→ Check database connection URL is correct

### Frontend Can't Reach Backend?
→ Verify `VITE_API_URL` in Vercel is: `https://nanourl-backend.onrender.com`

---

## ✅ Done!

Your backend is now:
- 🌐 Live on Render
- 🔄 Auto-deploying on GitHub push
- 🔗 Connected to frontend
- ✨ Ready for production

**Congratulations! Your app is deployed!** 🎉
