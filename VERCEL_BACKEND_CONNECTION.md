# 🚀 Vercel Frontend & Backend Connection Setup

## ✅ Configuration Complete

### Frontend (Vercel)
- **URL:** `https://nano-url-indol.vercel.app`
- **Environment:** `.env.production`
- **API Base URL:** `https://nanourl-backend.onrender.com`

### Backend (Render)
- **URL:** `https://nanourl-backend.onrender.com`
- **CORS Allowed Origins:**
  - `http://localhost:5173` (local dev)
  - `http://localhost:3000` (local dev)
  - `https://nano-url-indol.vercel.app` ✅ (Vercel production)
  - `https://*.vercel.app` ✅ (all Vercel subdomains)

---

## 📝 What Was Updated

### 1. Frontend Configuration
**File:** `frontend/nanourl-frontend/.env.production`
```env
VITE_API_URL=https://nanourl-backend.onrender.com
```
- Frontend now points to production backend on Render

### 2. Backend CORS Configuration
**File:** `backend/src/main/java/com/NanoURL/config/WebConfig.java`
```java
String allowedOrigins = System.getenv().getOrDefault("ALLOWED_ORIGINS", 
    "http://localhost:5173,http://localhost:3000,https://nano-url-indol.vercel.app,https://*.vercel.app");
```
- Backend now accepts requests from Vercel frontend
- Supports both local development and production

---

## 🔧 Deployment Steps

### Step 1: Deploy Backend to Render
1. Go to **https://render.com**
2. Connect your GitHub repository
3. Create **Web Service** from `backend` folder
4. Set environment variables:
   ```
   SPRING_DATASOURCE_URL=jdbc:mysql://your-db-host:3306/nanourl_db
   SPRING_DATASOURCE_USERNAME=nanourl_user
   SPRING_DATASOURCE_PASSWORD=your-password
   SPRING_PROFILES_ACTIVE=prod
   ALLOWED_ORIGINS=https://nano-url-indol.vercel.app,https://*.vercel.app
   ```
5. Deploy
6. Note the backend URL: `https://nanourl-backend.onrender.com`

### Step 2: Deploy Frontend to Vercel
1. Go to **https://vercel.com**
2. Connect your GitHub repository
3. Import the project
4. Set root directory: `frontend/nanourl-frontend`
5. Set environment variables:
   ```
   VITE_API_URL=https://nanourl-backend.onrender.com
   ```
6. Deploy

### Step 3: Test Connection
1. Open frontend: `https://nano-url-indol.vercel.app`
2. Try to **Sign Up**
3. If successful → Backend is connected ✅

---

## 🔐 Environment Variables Checklist

### Backend (Render Dashboard)
```
SPRING_DATASOURCE_URL = jdbc:mysql://host:3306/db
SPRING_DATASOURCE_USERNAME = user
SPRING_DATASOURCE_PASSWORD = password
SPRING_PROFILES_ACTIVE = prod
JWT_SECRET = (minimum 32 characters)
ALLOWED_ORIGINS = https://nano-url-indol.vercel.app,https://*.vercel.app
```

### Frontend (Vercel Dashboard)
```
VITE_API_URL = https://nanourl-backend.onrender.com
VITE_APP_NAME = NanoURL
```

---

## ✨ Features That Will Work

Once connected:
- ✅ User Registration/Login
- ✅ Create Short URLs
- ✅ View URL History
- ✅ Generate QR Codes
- ✅ Delete URLs
- ✅ Analytics Tracking
- ✅ Contact Form

---

## 🆘 Troubleshooting

### Frontend can't reach backend
1. Check backend URL in `.env.production`
2. Verify backend is running on Render
3. Check CORS settings in WebConfig.java
4. Open browser DevTools → Network tab → check API requests

### CORS Error (No 'Access-Control-Allow-Origin' header)
1. Backend CORS not configured correctly
2. Verify `WebConfig.java` has Vercel URL
3. Check `ALLOWED_ORIGINS` environment variable on Render

### 404 Error on API endpoints
1. Check backend is deployed properly
2. Verify API endpoints exist in controllers
3. Check endpoint paths match frontend requests

### JWT Token Issues
1. Ensure `JWT_SECRET` is set on Render
2. Verify token is sent with Authorization header
3. Check token expiration

---

## 📚 Reference

- **Frontend Code:** `/frontend/nanourl-frontend/`
- **Backend Code:** `/backend/`
- **CORS Config:** `/backend/src/main/java/com/NanoURL/config/WebConfig.java`
- **API Endpoints:** `/backend/src/main/java/com/NanoURL/controller/`

---

## ✅ Status

- [x] Frontend configuration updated
- [x] Backend CORS configuration updated
- [x] Ready for deployment
- [ ] Backend deployed to Render
- [ ] Frontend deployed to Vercel
- [ ] Connection tested

---

**Last Updated:** January 6, 2026
