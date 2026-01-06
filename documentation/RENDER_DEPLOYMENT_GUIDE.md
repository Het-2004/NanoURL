# 🚀 Render.com Free Deployment Guide

## ✅ Why Render.com?

- ✅ **100% FREE** (no credit card needed)
- ✅ **Persistent database** (free PostgreSQL)
- ✅ **GitHub integration** (auto-deploy on push)
- ✅ **Simple setup** (5 minutes)
- ✅ **Always running** (doesn't sleep like Heroku)

---

## 📋 Prerequisites

- ✅ GitHub account with NanoURL pushed
- ✅ Backend running locally (Docker)
- ✅ Vercel frontend already deployed

---

## 🎯 Step 1: Create Render Account

1. **Go to**: https://render.com
2. **Sign Up** → Choose "Sign up with GitHub"
3. **Authorize** GitHub
4. **Email verification** (check your email)

---

## 🔧 Step 2: Create Web Service

### 2.1 Start New Service

1. **Go to Dashboard**: https://dashboard.render.com
2. **Click** "New" button (top right)
3. **Select** "Web Service"
4. **Connect GitHub**:
   - Click "Connect account"
   - Authorize Render to access GitHub
   - Select "NanoURL" repository

### 2.2 Configure Service

**Name**: `nanourl-backend`

**Environment**: Docker

**Region**: Choose closest to you (e.g., Singapore, US)

**Branch**: main

**Root Directory**: `backend` ⭐ **IMPORTANT!**

This tells Render to run the app from the `backend` folder, not the root.

**Dockerfile Path**: `Dockerfile` (Render will look for `backend/Dockerfile`)

**Auto-Deploy**: Yes (auto-deploy on GitHub push)

### 2.3 Free Instance

**Instance Type**: Free
- 0.5 CPU
- 512 MB RAM
- Perfect for testing

---

## 💾 Step 3: Create Free PostgreSQL Database

Instead of MySQL, Render offers free PostgreSQL:

### 3.1 Create Database

1. **Dashboard** → **New**
2. **Select** "PostgreSQL"
3. **Name**: `nanourl-db`
4. **PostgreSQL Version**: 15 (latest free)
5. **Region**: Same as web service
6. **Create Database**

### 3.2 Get Database Credentials

Render will show:
```
Host: xxx.render.com
Port: 5432
Database: nanourl
User: nanourl_user
Password: [auto-generated]
```

**Copy these!** You'll need them in environment variables.

---

## 🔐 Step 4: Set Environment Variables

### 4.1 Add to Render Web Service

In Render Dashboard:
1. **Your Web Service** → **Settings**
2. **Environment**
3. **Add Environment Variable** for each:

```
DATABASE_URL = postgres://nanourl_user:PASSWORD@HOST:5432/nanourl
SPRING_JPA_DATABASE_PLATFORM = org.hibernate.dialect.PostgreSQLDialect
SPRING_JPA_HIBERNATE_DDL_AUTO = update
SPRING_PROFILES_ACTIVE = prod
JWT_SECRET = your-secret-key-min-32-characters-long
JWT_EXPIRATION = 86400000
ALLOWED_ORIGINS = https://nano-url-indol.vercel.app
```

### 4.2 Update Backend application-prod.yaml

**File**: `backend/src/main/resources/application-prod.yaml`

```yaml
spring:
  datasource:
    url: ${DATABASE_URL}
    driver-class-name: org.postgresql.Driver
  jpa:
    hibernate:
      ddl-auto: update
    database-platform: org.hibernate.dialect.PostgreSQLDialect
  
server:
  port: ${PORT:8080}

jwt:
  secret: ${JWT_SECRET}
  expiration: ${JWT_EXPIRATION}

cors:
  allowed-origins: ${ALLOWED_ORIGINS:http://localhost:5173}
```

---

## 📝 Step 5: Update Backend Dependencies (PostgreSQL)

### 5.1 Add PostgreSQL Driver

**File**: `backend/pom.xml`

Find the MySQL dependency:
```xml
<dependency>
    <groupId>com.mysql</groupId>
    <artifactId>mysql-connector-j</artifactId>
    <scope>runtime</scope>
</dependency>
```

Add PostgreSQL below it:
```xml
<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
    <scope>runtime</scope>
</dependency>
```

### 5.2 Update CorsConfig.java

**File**: `backend/src/main/java/com/NanoURL/config/CorsConfig.java`

```java
configuration.setAllowedOrigins(Arrays.asList(
    "http://localhost:5173",
    "http://localhost:3000",
    "https://nano-url-indol.vercel.app",  // Your Vercel URL
    "https://*.vercel.app"
));
```

---

## 🚀 Step 6: Deploy!

### 6.1 Push to GitHub

```bash
git add .
git commit -m "Add PostgreSQL support and Render deployment configuration"
git push origin main
```

### 6.2 Render Auto-Deploys

Once pushed to GitHub:
1. Render **automatically detects changes**
2. **Builds Docker image** (takes 2-3 minutes)
3. **Deploys** your backend

**Check Progress**:
- Render Dashboard → Your Web Service → Logs
- Watch the deployment logs

### 6.3 Get Your Backend URL

Once deployed, Render shows:
```
Your service is live at:
https://nanourl-backend.onrender.com
```

---

## ✅ Step 7: Connect Everything

### 7.1 Update Vercel Environment Variables

1. **Go to**: https://vercel.com/dashboard
2. **Select** "nanourl" project
3. **Settings** → **Environment Variables**
4. **Update**:
   ```
   VITE_API_BASE_URL = https://nanourl-backend.onrender.com
   ```
5. **Redeploy**:
   - Go to **Deployments**
   - Click the latest deployment
   - Click "Redeploy"

### 7.2 Test Connection

1. **Open frontend**: https://nano-url-indol.vercel.app
2. **Try to Register**: 
   - Fill in username, email, password
   - Click "Register"
3. **Check if it works**:
   - If successful → Backend connected! ✅
   - If error → Check logs

---

## 🐛 Troubleshooting

### Problem 1: Build Fails
**Error**: `Failed to build Docker image`

**Solution**:
- Check logs in Render dashboard
- Ensure Root Directory is set to `backend`
- Verify Dockerfile exists in backend folder

### Problem 2: Database Connection Error
**Error**: `Connection refused` or `Unknown database`

**Solution**:
- Check DATABASE_URL in environment variables
- Verify PostgreSQL credentials are correct
- Check database was created in Render

### Problem 3: CORS Error on Frontend
**Error**: `Access to XMLHttpRequest blocked by CORS`

**Solution**:
- Update CorsConfig.java with your Vercel URL
- Rebuild and push to GitHub
- Wait for Render to redeploy

### Problem 4: Service Still Starting
**Error**: Shows "Building" or "Deploying" for long time

**Solution**:
- Free tier rebuilds can take 3-5 minutes
- Check logs for errors
- If stuck, manually trigger redeploy

---

## 📊 What You Get

### ✅ Backend
- **URL**: https://nanourl-backend.onrender.com
- **Database**: Free PostgreSQL
- **Auto-Deploy**: On every GitHub push
- **Always Running**: No sleeping

### ✅ Frontend  
- **URL**: https://nano-url-indol.vercel.app
- **Auto-Deploy**: On every GitHub push
- **Fast**: Global CDN

### ✅ Both Connected
- Frontend can reach backend
- Data persists in PostgreSQL
- Registration/Login works
- URL shortening works

---

## 🔄 Deployment Flow

```
Your Computer (GitHub)
        ↓
   git push origin main
        ↓
GitHub Repository
        ↓
(1) Render detects change
    - Builds Docker image
    - Runs in container
    - Connects to PostgreSQL
    - URL: https://nanourl-backend.onrender.com
        
(2) Vercel detects change
    - Builds React app
    - Deploys to CDN
    - URL: https://nano-url-indol.vercel.app
        ↓
User accesses: https://nano-url-indol.vercel.app
    ↓
Frontend connects to: https://nanourl-backend.onrender.com
    ↓
Backend saves to: PostgreSQL database (on Render)
```

---

## 💡 Pro Tips

1. **Free tier can take 30+ seconds to start** after inactivity
2. **Auto-deploy saves time** - no manual pushing
3. **Check logs often** - Render logs are helpful for debugging
4. **PostgreSQL is more powerful** than MySQL for free tier
5. **Monitor disk usage** - free tier has 1GB limit

---

## 🎯 Next Steps

1. ✅ Create Render account
2. ✅ Create Web Service with Root Directory = `backend`
3. ✅ Create PostgreSQL database
4. ✅ Set environment variables
5. ✅ Push to GitHub (triggers auto-deploy)
6. ✅ Update Vercel with backend URL
7. ✅ Test frontend → backend connection
8. ✅ Celebrate! 🎉

---

## 📱 Test Your Deployment

### Test 1: Backend Health Check
```bash
curl https://nanourl-backend.onrender.com/api/health
```

Expected:
```json
{"status":"UP"}
```

### Test 2: Frontend Registration
1. Open https://nano-url-indol.vercel.app
2. Click "Register"
3. Fill in details
4. Click "Register"
5. Should login automatically ✅

### Test 3: Shorten URL
1. Enter a long URL
2. Click "Shorten"
3. Should get short URL back ✅

### Test 4: Database Check
In Render dashboard:
- PostgreSQL → Database
- See tables created ✅

---

## 🆘 Need Help?

1. **Check Render logs**: Dashboard → Web Service → Logs
2. **Check GitHub Actions**: Your repository → Actions
3. **Check browser console**: F12 → Console tab
4. **Check network tab**: F12 → Network tab
5. **Check Vercel logs**: Vercel Dashboard → Logs

---

## ✨ Congratulations!

Your NanoURL is now:
- ✅ Frontend live on Vercel (global CDN)
- ✅ Backend live on Render (free tier)
- ✅ Database live on PostgreSQL (free)
- ✅ Both connected and working
- ✅ Auto-deployed on GitHub push

**You have a production-ready URL shortener!** 🚀

---

**Last Updated**: January 6, 2026
