# 🚀 How to Deploy Backend to Render - Step by Step

## Prerequisites
- ✅ GitHub account (your code must be on GitHub)
- ✅ Render account (free at https://render.com)
- ✅ Backend code in repository
- ✅ Database (MySQL) ready

---

## Step 1: Push Code to GitHub

First, make sure your code is on GitHub with the latest changes:

```bash
# Navigate to project root
cd d:\JAVA\Project\NanoURL

# Check git status
git status

# Add all changes
git add .

# Commit changes
git commit -m "Update backend CORS configuration for Vercel frontend"

# Push to GitHub
git push origin main
```

**Output should show:**
```
✅ [main abc1234] Update backend CORS configuration for Vercel frontend
 2 files changed, 4 insertions(+), 2 deletions(-)
```

---

## Step 2: Create Render Account

1. Go to **https://render.com**
2. Click **"Sign Up"**
3. Choose **"GitHub"** option
4. Authorize Render to access your GitHub account
5. You'll see your GitHub repositories

---

## Step 3: Create Web Service on Render

1. Click **"New +"** (top right)
2. Select **"Web Service"**
3. Search for **"NanoURL"** repository
4. Click **"Connect"** next to your repo

---

## Step 4: Configure the Service

Fill in these settings:

| Setting | Value | Notes |
|---------|-------|-------|
| **Name** | `nanourl-backend` | Service name on Render |
| **Environment** | `Docker` | ✅ We have Dockerfile |
| **Region** | Closest to you | e.g., Singapore, US East |
| **Branch** | `main` | Deploy from main branch |
| **Root Directory** | `backend` | ⭐ **IMPORTANT!** |
| **Dockerfile Path** | `Dockerfile` | Located in backend folder |
| **Auto-Deploy** | `Yes` | Auto-deploy on GitHub push |

---

## Step 5: Add Environment Variables

Click **"Advanced"** and add these variables:

```
SPRING_DATASOURCE_URL = jdbc:mysql://[YOUR_DB_HOST]:3306/nanourl_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true

SPRING_DATASOURCE_USERNAME = nanourl_user

SPRING_DATASOURCE_PASSWORD = [YOUR_DB_PASSWORD]

SPRING_PROFILES_ACTIVE = prod

JWT_SECRET = 9d8f0c6b2e5a4c1f7d9b6a8c3e4f1a0d9c7b5a3e1f6d8c2b4a9e7c5d3b1f0a2c

ALLOWED_ORIGINS = https://nano-url-indol.vercel.app,https://*.vercel.app
```

**Where to get these values:**
- `SPRING_DATASOURCE_URL` → Your MySQL connection string
- `SPRING_DATASOURCE_USERNAME` → MySQL username
- `SPRING_DATASOURCE_PASSWORD` → MySQL password
- `JWT_SECRET` → Already in your code (keep as is)
- `ALLOWED_ORIGINS` → Your Vercel frontend URL

---

## Step 6: Deploy

1. Click **"Create Web Service"**
2. Wait for build to complete (takes 2-5 minutes)
3. You'll see: **"Your service is live!"** ✅

Your backend URL will be: **`https://nanourl-backend.onrender.com`**

---

## Step 7: Verify Deployment

### Test Backend Health Check

Open in browser:
```
https://nanourl-backend.onrender.com/health
```

Should return:
```json
{
  "status": "UP",
  "message": "Backend is healthy"
}
```

### Check Logs

On Render dashboard:
1. Select your service
2. Click **"Logs"** tab
3. Look for: **"Tomcat started on port 8080"**

If you see errors, scroll up to find the issue.

---

## Step 8: Update Frontend Environment Variable

1. Go to **https://vercel.com**
2. Select **"nano-url-indol"** project
3. Go to **Settings** → **Environment Variables**
4. Update:
   ```
   VITE_API_URL = https://nanourl-backend.onrender.com
   ```
5. Click **"Save"**
6. Go to **Deployments** → **Redeploy** latest deployment

---

## Step 9: Test Connection

Open your frontend:
```
https://nano-url-indol.vercel.app
```

Try to:
1. **Sign Up** with email
2. **Login**
3. **Create Short URL**
4. **View History**

If all work → Backend is connected! ✅

---

## 🆘 Troubleshooting

### Build Failed?

**Check Logs:**
- Render Dashboard → Logs tab
- Look for error messages
- Common issues:
  - Wrong `Root Directory` (should be `backend`)
  - Missing environment variables
  - Database connection failed

### Build Succeeded but Service is Down?

1. Check if database is accessible from Render
2. Verify `SPRING_DATASOURCE_URL` is correct
3. Check if database user has correct permissions

### Frontend can't reach backend?

1. Verify `VITE_API_URL` in Vercel is correct
2. Check backend is running: Open `https://nanourl-backend.onrender.com/health`
3. Check CORS: `ALLOWED_ORIGINS` should include your Vercel URL
4. Browser console (F12) → Network tab → check API requests

### Database Connection Error?

Make sure your MySQL is:
- Running and accessible
- User has correct password
- Database `nanourl_db` exists
- URL includes `allowPublicKeyRetrieval=true`

---

## 📊 After Deployment

### What Happens Next?

1. **Auto-Deploy:** Every time you push to GitHub, Render automatically rebuilds and deploys
2. **Logs:** View deployment logs anytime in Render dashboard
3. **Rollback:** Can revert to previous version from "Deploys" tab
4. **Monitoring:** Render shows uptime and performance metrics

### Keep Your Code Updated

Every time you make changes:

```bash
git add .
git commit -m "Your change description"
git push origin main
```

Render will automatically deploy within 1-2 minutes.

---

## ✅ Deployment Checklist

- [ ] Code pushed to GitHub
- [ ] Render account created
- [ ] GitHub connected to Render
- [ ] Web Service created with correct Root Directory (`backend`)
- [ ] Environment variables added
- [ ] Service deployed successfully
- [ ] Health check returns 200 OK
- [ ] Frontend environment variable updated in Vercel
- [ ] Frontend redeployed
- [ ] Connection tested (Sign Up works)

---

## 📚 Quick Reference

| What | Where | Value |
|------|-------|-------|
| Backend URL | Render | `https://nanourl-backend.onrender.com` |
| Frontend URL | Vercel | `https://nano-url-indol.vercel.app` |
| Database | MySQL | Your DB host |
| Root Directory | Render | `backend` |
| Branch | GitHub | `main` |

---

## 🎉 Success!

Once deployment is complete:
- ✅ Backend running at `https://nanourl-backend.onrender.com`
- ✅ Frontend running at `https://nano-url-indol.vercel.app`
- ✅ Both connected and working
- ✅ Auto-deploying on every GitHub push

**Your NanoURL is now live!** 🚀

---

**Need Help?**
- Check Render logs: Dashboard → Select Service → Logs
- Check Vercel logs: Dashboard → Deployments → Select deployment
- Check browser console: F12 → Console tab
