# 🚀 Vercel Deployment Guide - Frontend & Backend Connection

## Overview
This guide shows how to deploy your **NanoURL frontend to Vercel** and connect it to your **backend** (running anywhere).

---

## 📋 Prerequisites

- ✅ Vercel API Key (you already have this!)
- ✅ GitHub account with NanoURL repository pushed
- ✅ Backend running somewhere (local, server, or cloud)
- ✅ Backend URL (e.g., http://localhost:8080 or https://your-backend.com)

---

## 🎯 Step 1: Prepare Your Environment

### 1.1 Backend Configuration

Your backend needs to be running and accessible. You have three options:

#### Option A: Local Backend (Development)
- Backend URL: `http://localhost:8080`
- Good for: Testing locally
- Command: `cd backend && mvn spring-boot:run`

#### Option B: Backend on Server/Cloud
- Backend URL: `https://your-backend-domain.com`
- Good for: Production deployment
- Examples: AWS, Railway, Render, Heroku

#### Option C: Docker Compose
- Backend URL: `http://backend:8080` (internal) or `http://localhost:8080` (external)
- Good for: Local full-stack testing
- Command: `docker-compose up -d`

---

## 📝 Step 2: Configure Frontend for Vercel

### 2.1 Create Environment Files

Create `.env` and `.env.production` files in `frontend/nanourl-frontend/`:

**File: `frontend/nanourl-frontend/.env`**
```env
# Development
VITE_API_BASE_URL=http://localhost:8080
VITE_APP_NAME=NanoURL
VITE_APP_VERSION=1.0.0
```

**File: `frontend/nanourl-frontend/.env.production`**
```env
# Production (Vercel)
VITE_API_BASE_URL=https://your-backend-url.com
VITE_APP_NAME=NanoURL
VITE_APP_VERSION=1.0.0
```

### 2.2 Update API Configuration

Make sure your API service uses the environment variable:

**File: `frontend/nanourl-frontend/src/config/api.js`**
```javascript
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080';

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Add request interceptor for JWT token
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('authToken');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

export default api;
```

---

## 🌐 Step 3: Deploy Frontend to Vercel

### 3.1 Connect GitHub Repository to Vercel

1. **Go to Vercel Dashboard**: https://vercel.com/dashboard
2. **Click "Add New"** → **"Project"**
3. **Import Git Repository**
   - Select your GitHub account
   - Search for `NanoURL`
   - Click "Import"

### 3.2 Configure Vercel Project

1. **Project Settings:**
   - Framework Preset: **Vite**
   - Build Command: `cd frontend/nanourl-frontend && npm run build`
   - Output Directory: `frontend/nanourl-frontend/dist`
   - Install Command: `cd frontend/nanourl-frontend && npm install`
   - Root Directory: `/` (leave as is)

2. **Environment Variables** (Add these in Vercel dashboard):
   ```
   VITE_API_BASE_URL = https://your-backend-url.com
   VITE_APP_NAME = NanoURL
   VITE_APP_VERSION = 1.0.0
   ```

3. **Click "Deploy"**
   - Wait for build to complete
   - Your frontend will be live at: `https://nanourl-yourusername.vercel.app`

---

## 🔗 Step 4: Connect Backend to Frontend

### 4.1 Backend CORS Configuration

Update your backend's CORS settings to allow requests from Vercel:

**File: `backend/src/main/java/com/NanoURL/config/SecurityConfig.java`**

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .cors(cors -> cors.configurationSource(corsConfigurationSource()))
            .csrf(AbstractHttpConfigurer::disable)
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/auth/**").permitAll()
                .requestMatchers("/api/public/**").permitAll()
                .anyRequest().authenticated()
            )
            .httpBasic(Customizer.withDefaults());
        
        return http.build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOrigins(Arrays.asList(
            "http://localhost:5173",           // Development
            "http://localhost:3000",           // Alternative dev
            "https://nanourl-yourusername.vercel.app",  // Your Vercel URL
            "https://*.vercel.app"             // All Vercel apps
        ));
        configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        configuration.setAllowedHeaders(Arrays.asList("*"));
        configuration.setAllowCredentials(true);
        configuration.setMaxAge(3600L);
        
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
}
```

### 4.2 Backend Environment Configuration

Create `.env` file in backend:

**File: `backend/.env`** (Production)
```env
# Server
SERVER_PORT=8080
SERVER_SERVLET_CONTEXT_PATH=/api

# Database
SPRING_DATASOURCE_URL=jdbc:mysql://your-db-host:3306/nanourl_db
SPRING_DATASOURCE_USERNAME=nanourl_user
SPRING_DATASOURCE_PASSWORD=your-password
SPRING_JPA_HIBERNATE_DDL_AUTO=update

# JWT
JWT_SECRET=your-secret-key-min-32-characters-long
JWT_EXPIRATION=86400000

# CORS
ALLOWED_ORIGINS=https://nanourl-yourusername.vercel.app,http://localhost:5173
```

---

## 🚀 Step 5: Deploy Backend

You have several options:

### Option A: Railway.app (Recommended)
```bash
# 1. Create account at https://railway.app
# 2. Connect GitHub
# 3. Create new project from GitHub
# 4. Add MySQL service
# 5. Deploy
# Your backend URL: https://your-app-production.railway.app
```

### Option B: Render.com
```bash
# 1. Create account at https://render.com
# 2. Connect GitHub
# 3. Create new Web Service
# 4. Add MySQL database
# 5. Deploy
# Your backend URL: https://your-app.onrender.com
```

### Option C: Docker on Any Server
```bash
# Using docker-compose on your server
docker-compose up -d
# Your backend URL: https://your-server-domain.com:8080
```

---

## 🔗 Step 6: Update Vercel Environment Variables

Once your backend is deployed:

1. **Go to Vercel Dashboard**
2. **Select your NanoURL project**
3. **Settings** → **Environment Variables**
4. **Update:**
   ```
   VITE_API_BASE_URL = https://your-backend-url.com
   ```
5. **Redeploy** project (redeploy from git)

---

## ✅ Step 7: Test Connection

### 7.1 Test Frontend
1. Open: `https://nanourl-yourusername.vercel.app`
2. Try to **Register** a new account
3. Check if data saves in backend database
4. **Login** with your account
5. Try to **shorten a URL**
6. Check if URL is saved and redirects work

### 7.2 Verify Backend Connection

Open browser console (F12) and check:
- **Network tab** - API requests should go to your backend URL
- **No CORS errors** - If you see CORS errors, update SecurityConfig
- **Response data** - Should get real data from backend

### 7.3 Database Check
```bash
# Connect to your database
mysql -u nanourl_user -p nanourl_db

# Check if data is being saved
SELECT * FROM users;
SELECT * FROM urls;
```

---

## 🐛 Troubleshooting

### Problem 1: Login fails, no error in console
**Solution:**
- Check if backend URL is correct in Vercel environment variables
- Check backend CORS configuration
- Verify backend is running

### Problem 2: CORS Error
**Error:** `Access to XMLHttpRequest blocked by CORS policy`

**Solution:**
- Update SecurityConfig.java with your Vercel URL
- Add your domain to `setAllowedOrigins()`
- Restart backend
- Redeploy backend if on cloud

### Problem 3: 404 errors on API calls
**Error:** `GET https://your-backend/api/auth/login 404`

**Solution:**
- Check if VITE_API_BASE_URL includes `/api` or not
- Check backend routing configuration
- Verify backend server context path

### Problem 4: Blank page on Vercel
**Solution:**
- Check Vercel build logs
- Run `npm run build` locally to test
- Check if all dependencies are installed
- Verify environment variables are set

---

## 📊 Deployment Summary

### Frontend Deployed ✅
- **URL**: https://nanourl-yourusername.vercel.app
- **Hosted on**: Vercel (Free tier available)
- **Auto-deployed**: On every GitHub push

### Backend Deployed ✅
- **URL**: https://your-backend-url.com
- **Hosted on**: Railway/Render/Your Server
- **Database**: MySQL

### Connection ✅
- Frontend → Backend API calls working
- CORS configured
- JWT authentication working
- Data persists in database

---

## 🔄 After Deployment: What Happens

### When User Registers:
1. Frontend (Vercel) sends registration request to Backend
2. Backend creates user in database
3. Backend returns auth token
4. Frontend stores token in localStorage
5. User is logged in

### When User Shortens URL:
1. Frontend sends URL + auth token to Backend
2. Backend validates URL
3. Backend generates short code
4. Backend saves to database
5. Backend returns short URL
6. Frontend displays result

### When User Clicks Short URL:
1. User goes to: https://nanourl-yourusername.vercel.app/abc123
2. Frontend redirects to original URL
3. Backend logs access
4. User goes to original website

---

## 📱 Deployment Checklist

- [ ] Frontend environment variables configured in Vercel
- [ ] Backend CORS settings updated with Vercel URL
- [ ] Backend deployed and accessible
- [ ] Database is running and accessible
- [ ] Frontend can reach backend API
- [ ] Registration works
- [ ] Login works
- [ ] URL shortening works
- [ ] Redirects work
- [ ] Analytics tracking works

---

## 🆘 Need Help?

### Check These Guides:
1. [Backend Guide](documentation/BACKEND_GUIDE.md) - Backend setup details
2. [Frontend Guide](documentation/FRONTEND_GUIDE.md) - Frontend setup details
3. [Backend-Frontend Connection](documentation/BACKEND_FRONTEND_CONNECTION.md) - Connection details
4. [Security Guide](documentation/SECURITY_GUIDE.md) - Security best practices
5. [Deployment Guide](documentation/DEPLOYMENT_GUIDE.md) - Complete deployment

### Quick Fixes:
1. **Check network in browser** (F12 → Network tab)
2. **Check browser console** (F12 → Console tab)
3. **Check backend logs** (if local, check terminal output)
4. **Verify URLs** match exactly
5. **Test with Postman** - Test backend API directly

---

## 🎉 You're Done!

Your NanoURL is now:
- ✅ Frontend live on Vercel
- ✅ Backend running somewhere
- ✅ Both connected and working
- ✅ Ready for real users!

**Share your link**: https://nanourl-yourusername.vercel.app

---

**Last Updated**: January 6, 2026
