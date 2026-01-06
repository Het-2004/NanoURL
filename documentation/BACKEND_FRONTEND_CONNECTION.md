# 🔗 Backend & Frontend Connection Guide

## How to Connect Your Frontend to Backend

---

## **Part 1: Backend Configuration**

### Step 1: Update BaseUrl

Edit `backend/src/main/resources/application.yaml`:

```yaml
app:
  base-url: http://localhost:8080
```

For production:
```yaml
app:
  base-url: https://your-backend-url.onrender.com
```

### Step 2: Verify CORS Configuration

Check `backend/src/main/java/com/NanoURL/config/WebConfig.java`:

```java
@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins(
                    "http://localhost:5173",
                    "http://localhost:3000",
                    "https://your-frontend-url.onrender.com"
                )
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*")
                .allowCredentials(true);
    }
}
```

### Step 3: Start Backend

```bash
cd backend
mvnw spring-boot:run
```

Backend runs on: **http://localhost:8080**

---

## **Part 2: Frontend Configuration**

### Step 1: Update API Base URL

Edit `frontend/nanourl-frontend/src/services/api.js`:

```javascript
// Development
const API_BASE = 'http://localhost:8080';

// Production
// const API_BASE = 'https://your-backend-url.onrender.com';
```

### Step 2: Update Axios Instance

Make sure this is in `api.js`:

```javascript
import axios from 'axios';

const api = axios.create({
  baseURL: API_BASE,
  withCredentials: true,
  headers: {
    'Content-Type': 'application/json'
  }
});

// Add JWT token to requests
api.interceptors.request.use(config => {
  const token = localStorage.getItem('token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export default api;
```

### Step 3: Update Environment Files (If Using)

Create `.env` or `.env.local`:

```
VITE_API_URL=http://localhost:8080
VITE_APP_NAME=NanoURL
```

In `api.js`:
```javascript
const API_BASE = import.meta.env.VITE_API_URL || 'http://localhost:8080';
```

### Step 4: Install Dependencies

```bash
cd frontend/nanourl-frontend
npm install
```

### Step 5: Start Frontend

```bash
npm run dev
```

Frontend runs on: **http://localhost:5173**

---

## **Part 3: Test Connection**

### Step 1: Check Backend is Running

Open in browser:
```
http://localhost:8080/
```

Should show:
```
Welcome to NanoURL!
```

### Step 2: Check Frontend is Running

Open in browser:
```
http://localhost:5173
```

Should load the React app.

### Step 3: Test API Calls

Try to:
1. Sign up with email
2. Login
3. Create short URL
4. View history
5. Logout

All should work without CORS errors!

---

## **Part 4: API Endpoints Reference**

### Authentication:

| Method | Endpoint | Body | Response |
|--------|----------|------|----------|
| POST | `/api/auth/signup` | {email, password, name} | {token, user} |
| POST | `/api/auth/login` | {email, password} | {token, user} |

### URLs:

| Method | Endpoint | Body | Response |
|--------|----------|------|----------|
| POST | `/api/urls/shorten` | {longUrl} | {id, shortCode, shortUrl} |
| GET | `/api/urls/history` | - | [{id, shortCode, longUrl, clicks}] |
| GET | `/{shortCode}` | - | Redirects to original URL |
| DELETE | `/api/urls/{id}` | - | {message: "Deleted"} |

### Contact:

| Method | Endpoint | Body | Response |
|--------|----------|------|----------|
| POST | `/api/contact` | {name, email, message} | {message: "Sent"} |

---

## **Part 5: Troubleshooting Connection Issues**

### Error: "CORS error" or "Access to XMLHttpRequest blocked"

**Problem:** Frontend can't reach backend  
**Solution:**

1. Check backend is running:
```bash
curl http://localhost:8080/
```

2. Check WebConfig.java has correct frontend URL
3. Check frontend API_BASE is correct
4. Verify both are running on correct ports

### Error: "Failed to fetch"

**Problem:** Network error  
**Solution:**

1. Check both services are running
2. Check firewall allows connections
3. Check you're not using VPN that blocks localhost

### Error: "Unauthorized" on API calls

**Problem:** JWT token not sent correctly  
**Solution:**

1. Check token is in localStorage:
```javascript
console.log(localStorage.getItem('token'));
```

2. Check token is sent in header:
```javascript
// In api.js interceptor
console.log(config.headers);
```

3. Check token is valid (not expired)

### Error: "404 Not Found"

**Problem:** Endpoint doesn't exist  
**Solution:**

1. Check API endpoint name spelling
2. Check backend has the route:
```bash
# Backend logs should show routes
```

3. Compare with this guide's endpoints

### Frontend loads but API calls fail

**Problem:** CORS configured but something else wrong  
**Solution:**

1. Open browser DevTools (F12)
2. Go to Network tab
3. Try API call
4. Check request headers:
   - Should have Authorization header
5. Check response status:
   - 200 = OK
   - 401 = Unauthorized
   - 403 = Forbidden
   - 404 = Not Found
   - 500 = Server Error

---

## **Part 6: Build for Production**

### Build Backend:

```bash
cd backend
mvnw clean package
```

Creates `target/nanourl-0.0.1-SNAPSHOT.jar`

### Build Frontend:

```bash
cd frontend/nanourl-frontend
npm run build
```

Creates `dist/` folder with static files.

### Run Production Build:

**Backend:**
```bash
java -jar backend/target/*.jar
```

**Frontend:**
```bash
# Use any static server
python -m http.server 5173 -d frontend/nanourl-frontend/dist
# Or
npx serve frontend/nanourl-frontend/dist
```

---

## **Part 7: Deploy to Render**

### Deploy Backend:

1. Push to GitHub
2. Go to Render.com
3. Create Web Service
4. Connect repository
5. Set environment variables
6. Deploy

### Deploy Frontend:

1. Build locally: `npm run build`
2. Push to GitHub
3. Go to Render.com
4. Create Static Site
5. Set build command: `cd frontend/nanourl-frontend && npm run build`
6. Set publish directory: `frontend/nanourl-frontend/dist`
7. Deploy

---

## **Part 8: Environment Comparison**

| Setting | Development | Production |
|---------|-------------|-----------|
| Backend | http://localhost:8080 | https://backend.onrender.com |
| Frontend | http://localhost:5173 | https://frontend.onrender.com |
| CORS Origins | localhost:5173 | frontend.onrender.com |
| Database | Local MySQL | Cloud/Remote MySQL |
| JWT Secret | (in code) | Environment variable |
| SSL | No | Yes |
| Debug | Yes | No |

---

## **Part 9: Security Checklist**

- ✅ CORS only allows known origins
- ✅ JWT tokens in Authorization header
- ✅ Credentials sent with requests (withCredentials: true)
- ✅ API validates JWT on every request
- ✅ Passwords never exposed
- ✅ Tokens stored securely (localStorage okay for development)
- ✅ HTTPS used in production

---

## **Part 10: Performance Tips**

### Frontend:

1. **Lazy load components:**
```javascript
const LazyComponent = React.lazy(() => import('./Component'));
```

2. **Use React.memo for expensive components:**
```javascript
const MyComponent = React.memo(function MyComponent(props) {
  // Only re-render if props change
});
```

3. **Debounce API calls:**
```javascript
const debounce = (func, delay) => {
  let timeoutId;
  return (...args) => {
    clearTimeout(timeoutId);
    timeoutId = setTimeout(() => func(...args), delay);
  };
};
```

### Backend:

1. **Use database indexes** (already in schema.sql)
2. **Enable query caching**
3. **Use pagination:**
```java
Page<Url> urls = urlRepository.findByUserId(userId, PageRequest.of(0, 20));
```

---

## **Part 11: Monitoring**

### Check Backend Health:

```javascript
// In frontend
fetch('http://localhost:8080/')
  .then(r => r.text())
  .then(console.log)
  .catch(() => console.error('Backend down'));
```

### Check API Responses:

```javascript
// In browser console
fetch('http://localhost:8080/api/auth/login', {
  method: 'POST',
  headers: {'Content-Type': 'application/json'},
  body: JSON.stringify({email: 'test@test.com', password: 'password'})
})
.then(r => r.json())
.then(console.log);
```

---

## **Useful Commands**

### Backend:
```bash
# Development
mvnw spring-boot:run

# Production build
mvnw clean package

# Run production build
java -jar target/*.jar

# View logs
mvnw spring-boot:run -X
```

### Frontend:
```bash
# Development
npm run dev

# Production build
npm run build

# Preview build
npm run preview

# Lint code
npm run lint
```

---

## **Common Ports**

| Service | Port | URL |
|---------|------|-----|
| Backend | 8080 | http://localhost:8080 |
| Frontend (Dev) | 5173 | http://localhost:5173 |
| MySQL | 3306 | localhost:3306 |
| Frontend (Serve) | 5000 | http://localhost:5000 |

---

## **Quick Checklist**

Before deploying:
- ✅ Backend runs and responds to requests
- ✅ Frontend loads without errors
- ✅ Can login/signup
- ✅ Can create shortened URL
- ✅ Can view history
- ✅ Can logout
- ✅ Database has data
- ✅ No CORS errors
- ✅ No JWT errors
- ✅ All CRUD operations work

---

## **More Help**

- Backend setup: [MYSQL_COMPLETE_SETUP.md](MYSQL_COMPLETE_SETUP.md)
- Frontend build: [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)
- Database config: [MYSQL_SETUP.md](MYSQL_SETUP.md)
- All docs: [README.md](README.md)

---

**Your frontend and backend are connected! 🎉**
