# 🔗 Backend & Frontend Connection Guide

## **LOCAL DEVELOPMENT** (Your Computer)

### Start Backend
```powershell
cd D:\JAVA\Project\NanoURL\backend
mvnw.cmd spring-boot:run
```

**Expected Output:**
```
Tomcat started on port(s): 8080 (http)
NanoURL started successfully
```

### Start Frontend
```powershell
cd D:\JAVA\Project\NanoURL\frontend\nanourl-frontend
npm run dev
```

**Expected Output:**
```
VITE v7.x.x  ready in 234 ms

➜  Local:   http://localhost:5173/
➜  press h to show help
```

### Test Connection
1. Open: http://localhost:5173
2. Try to **Sign Up**
3. If it connects, you'll see the app
4. If **error**: Check backend is running on 8080

---

## **PRODUCTION** (Vercel + Railway)

### Frontend on Vercel
1. **Environment Variable**: `VITE_API_URL=https://nanourl-backend-xxx.railway.app`
2. Auto-deploys from GitHub

### Backend on Railway
1. **Environment Variables**:
   ```
   JWT_SECRET = your-secret-key-here
   ALLOWED_ORIGINS = https://nanourl-frontend-xxx.vercel.app
   ```
2. Auto-deploys from GitHub (Docker)

---

## **Configuration Files**

### `.env.development` (Local)
```
VITE_API_URL=http://localhost:8080
```

### `.env.production` (Vercel)
```
VITE_API_URL=https://nanourl-backend-xxx.railway.app
```

### `application.yaml` (Backend)
```yaml
spring:
  web:
    cors:
      allowed-origins: http://localhost:5173,http://localhost:3000
      allowed-methods: GET,POST,PUT,DELETE,OPTIONS
      allow-credentials: true
```

### Railway Environment Variables
```
JWT_SECRET = your-secret-key
ALLOWED_ORIGINS = https://your-frontend.vercel.app
```

---

## **Troubleshooting**

### ❌ "Failed to fetch" Error
**Cause**: Frontend can't reach backend
**Fix**: 
- Check backend is running: http://localhost:8080/health
- Check ALLOWED_ORIGINS matches your frontend URL
- Check API_URL in .env file

### ❌ "CORS Error"
**Cause**: Backend doesn't allow frontend origin
**Fix**: Update ALLOWED_ORIGINS in backend:
- Local: `http://localhost:5173`
- Production: Your Vercel URL

### ❌ Backend not starting
**Cause**: Port 8080 already in use
**Fix**:
```powershell
netstat -ano | findstr :8080
taskkill /PID <PID> /F
```

### ❌ Frontend won't load
**Cause**: Node modules corrupted
**Fix**:
```powershell
cd frontend\nanourl-frontend
rmdir /s /q node_modules
npm install
npm run dev
```

---

## **Quick Start Commands**

**Local Development:**
```powershell
# Terminal 1 - Backend
cd backend
mvnw.cmd spring-boot:run

# Terminal 2 - Frontend
cd frontend\nanourl-frontend
npm run dev

# Open browser
http://localhost:5173
```

**Production Check:**
- Frontend: `https://nanourl-frontend-xxx.vercel.app`
- Backend: `https://nanourl-backend-xxx.railway.app`
- API: `https://nanourl-backend-xxx.railway.app/health`

---

## **Testing Endpoints**

### Backend Endpoints
```
✅ GET  http://localhost:8080/               → Welcome message
✅ GET  http://localhost:8080/health         → Health check
✅ GET  http://localhost:8080/h2-console    → Database console
✅ POST http://localhost:8080/api/auth/signin
✅ POST http://localhost:8080/api/shorten
✅ GET  http://localhost:8080/api/urls/history
```

### Test with curl
```powershell
# Test backend
curl http://localhost:8080/health

# Test auth
curl -X POST http://localhost:8080/api/auth/signin `
  -H "Content-Type: application/json" `
  -d '{"email":"test@example.com","password":"password"}'
```

---

Done! Now backend and frontend are properly connected! 🚀
