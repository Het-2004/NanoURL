# 📋 Backend Deployment - Visual Guide

## Your Current Status

```
┌─────────────────────────────────────────────────────┐
│                   YOUR NANOURL SETUP                │
├─────────────────────────────────────────────────────┤
│                                                       │
│  GitHub Repository                                   │
│  └─ https://github.com/Het-2004/NanoURL             │
│     ├─ backend/        (Not deployed yet)           │
│     └─ frontend/       (Need to push latest)        │
│                                                       │
│  Frontend (Vercel) ✅ LIVE                           │
│  └─ https://nano-url-indol.vercel.app               │
│                                                       │
│  Backend (Render) ❌ NOT DEPLOYED YET               │
│  └─ https://nanourl-backend.onrender.com (soon!)    │
│                                                       │
│  Database (MySQL)                                    │
│  └─ Running locally (needs to be on cloud)          │
│                                                       │
└─────────────────────────────────────────────────────┘
```

---

## Step-by-Step Deployment Flow

### Phase 1: Prepare Code (5 minutes)

```
┌─ Step 1: Push to GitHub
│  └─ git add .
│  └─ git commit -m "Deploy backend"
│  └─ git push origin main
│
└─ ✅ Code is on GitHub
```

**Run these commands:**
```bash
cd d:\JAVA\Project\NanoURL
git add .
git commit -m "Update backend CORS and deploy"
git push origin main
```

### Phase 2: Deploy to Render (10 minutes)

```
┌─ Step 2: Create Web Service on Render
│  └─ Go to: https://render.com
│  └─ Click: "New +" → "Web Service"
│  └─ Select: Your NanoURL repository
│
├─ Step 3: Configure Service
│  ├─ Name: nanourl-backend
│  ├─ Environment: Docker
│  ├─ Root Directory: backend ⭐ IMPORTANT
│  └─ Auto-Deploy: Yes
│
├─ Step 4: Add Environment Variables
│  ├─ SPRING_DATASOURCE_URL
│  ├─ SPRING_DATASOURCE_USERNAME
│  ├─ SPRING_DATASOURCE_PASSWORD
│  ├─ JWT_SECRET
│  └─ ALLOWED_ORIGINS
│
└─ Step 5: Click "Create Web Service"
   └─ Wait 2-5 minutes for build
   └─ ✅ Backend is live!
```

### Phase 3: Connect Frontend & Backend (2 minutes)

```
┌─ Step 6: Update Vercel Environment Variable
│  ├─ Go to: https://vercel.com
│  ├─ Project: nano-url-indol
│  ├─ Settings → Environment Variables
│  ├─ VITE_API_URL: https://nanourl-backend.onrender.com
│  └─ Redeploy
│
└─ ✅ Frontend can now reach backend
```

### Phase 4: Test & Verify (1 minute)

```
┌─ Step 7: Verify Everything Works
│  ├─ Test 1: Check backend health
│  │  └─ https://nanourl-backend.onrender.com/health
│  │
│  ├─ Test 2: Try frontend features
│  │  ├─ Open: https://nano-url-indol.vercel.app
│  │  ├─ Sign Up
│  │  ├─ Create Short URL
│  │  └─ View History
│  │
│  └─ ✅ Everything works!
```

---

## Current Git Status

**Files ready to push:**
```
✏️  Modified:
    - backend/pom.xml (added validation dependency)
    - backend/src/main/java/com/NanoURL/config/WebConfig.java (CORS updated)
    - database/database_schema.sql
    - docker-compose.yml

📄 New Files:
    - DEPLOY_BACKEND_GUIDE.md
    - NETWORK_ERROR_FIX.md
    - QUICK_BACKEND_DEPLOY.md
    - VERCEL_BACKEND_CONNECTION.md
    - backend/src/main/java/com/NanoURL/config/CorsConfig.java
    - frontend/nanourl-frontend/Dockerfile
```

---

## Commands to Run NOW

### Command 1: Push to GitHub
```bash
cd d:\JAVA\Project\NanoURL
git add .
git commit -m "Update CORS for Vercel and prepare for backend deployment"
git push origin main
```

### Command 2: Then Deploy on Render
1. Visit: https://render.com/dashboard
2. Click: "New +" → "Web Service"
3. Select: Het-2004/NanoURL
4. Fill form (see above)
5. Add env variables
6. Click "Create Web Service"
7. Wait 2-5 minutes ⏳

### Command 3: Update Vercel
1. Visit: https://vercel.com
2. Select: nano-url-indol project
3. Settings → Environment Variables
4. Update: `VITE_API_URL=https://nanourl-backend.onrender.com`
5. Redeploy

---

## Expected Results

### After Pushing to GitHub
```
✅ Your code is on GitHub
✅ Render can see your code
✅ Ready for deployment
```

### After Deploying on Render
```
✅ Backend URL: https://nanourl-backend.onrender.com
✅ Health check working
✅ Database connected
✅ Ready for frontend
```

### After Connecting Frontend
```
✅ Frontend can reach backend
✅ Sign Up works
✅ Login works
✅ Create Short URLs works
✅ All features working!
```

---

## 🎯 Your Next Steps

1. **RIGHT NOW:** Run the git commands above
2. **THEN:** Go to Render and create Web Service
3. **FINALLY:** Update Vercel environment variable

**Total time: ~20 minutes**

---

## 💡 Tips

- 💻 Keep this file open while deploying
- ⏰ Render build takes 2-5 minutes (it's normal)
- 📝 Save all environment variable values somewhere safe
- 🔄 Every GitHub push auto-deploys to Render
- 📊 Check logs if something fails

---

## Need Help?

| Issue | Solution |
|-------|----------|
| Can't find Root Directory | Make sure it's `backend` not `backend/` |
| Build keeps failing | Check environment variables are set |
| Frontend can't reach backend | Verify `VITE_API_URL` in Vercel |
| Database connection error | Check MySQL is running and URL is correct |

**Remember:** Your GitHub repo is already connected!
You just need to create the Render Web Service and that's it!

---

## Ready? Let's Go! 🚀

1. Run the git commands
2. Go to Render
3. Create Web Service
4. You're done!
