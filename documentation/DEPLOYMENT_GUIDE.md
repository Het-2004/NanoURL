# 🚀 Deployment Guide

## Deploy NanoURL to Production (Render)

This guide shows how to deploy both backend and frontend to Render for free.

---

## **Overview**

We'll deploy:
- **Backend** (Spring Boot) → Render Docker Container
- **Frontend** (React) → Render Static Site
- **Database** (MySQL) → External provider or local

---

## **Part 1: Prepare MySQL (5 minutes)**

You have 3 options:

### Option A: Cloud MySQL (Recommended)
- JawsDB (free tier on Render)
- ClearDB
- AWS RDS

### Option B: Local MySQL (Simple)
- Keep running on your machine
- Backend connects remotely

### Option C: Docker MySQL (Advanced)
- Deploy MySQL in container too

**For now, we'll use local MySQL.**

---

## **Part 2: Prepare Backend (10 minutes)**

### Step 1: Update Configuration

Edit `backend/src/main/resources/application-prod.yaml`:

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/nanourl_db?useSSL=false&serverTimezone=UTC
    username: nanourl_user
    password: NanoURL@SecurePass123
  jpa:
    hibernate:
      ddl-auto: update
    properties:
      hibernate:
        dialect: org.hibernate.dialect.MySQLDialect

server:
  port: 8080
  servlet:
    context-path: /

app:
  base-url: https://your-app-name.onrender.com
```

Replace `your-app-name` with your actual Render app name.

### Step 2: Verify Dockerfile

Check `backend/Dockerfile`:

```dockerfile
FROM openjdk:21-slim

WORKDIR /app

COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src

RUN chmod +x mvnw && ./mvnw clean package -DskipTests

EXPOSE 8080

CMD ["java", "-jar", "target/*.jar"]
```

This should already exist. If not, create it.

### Step 3: Push to GitHub

```bash
cd d:\JAVA\Project\NanoURL

git add .
git commit -m "Prepare for deployment"
git push origin main
```

---

## **Part 3: Deploy Backend (15 minutes)**

### Step 1: Go to Render.com

1. Visit https://render.com
2. Click "Sign Up" (use GitHub)
3. Authorize GitHub

### Step 2: Create Web Service

1. Click "New +" → "Web Service"
2. Connect your repository (NanoURL)
3. Select the repository

### Step 3: Configure Service

**Basic Settings:**
- Name: `nanourl-backend`
- Environment: `Docker`
- Region: `Oregon` (or closest to you)
- Branch: `main`

**Build & Deploy:**
- Build Command: (leave empty)
- Start Command: (leave empty)
- Auto-deploy: Enabled

**Environment Variables:**
Click "Add Environment Variable"

| Key | Value |
|-----|-------|
| `APP_BASE_URL` | `https://nanourl-backend.onrender.com` |
| `SPRING_DATASOURCE_URL` | `jdbc:mysql://your-local-ip:3306/nanourl_db` |
| `SPRING_DATASOURCE_USERNAME` | `nanourl_user` |
| `SPRING_DATASOURCE_PASSWORD` | `NanoURL@SecurePass123` |

### Step 4: Deploy

1. Click "Create Web Service"
2. Wait for build (5-10 minutes)
3. Check logs for errors
4. When done, you'll see: "Deploy successful"

### Step 5: Get Your URL

Your backend is at: `https://nanourl-backend.onrender.com`

Test it:
```
https://nanourl-backend.onrender.com/
```

You should see: **"Welcome to NanoURL!"**

---

## **Part 4: Deploy Frontend (10 minutes)**

### Step 1: Build React App

```bash
cd frontend/nanourl-frontend
npm run build
```

Creates `dist/` folder with static files.

### Step 2: Update API URL

Edit `frontend/nanourl-frontend/src/services/api.js`:

Change from:
```javascript
const API_BASE = 'http://localhost:8080';
```

To:
```javascript
const API_BASE = 'https://nanourl-backend.onrender.com';
```

### Step 3: Commit Changes

```bash
git add .
git commit -m "Update API URL for production"
git push origin main
```

### Step 4: Deploy Frontend

1. Go to https://render.com
2. Click "New +" → "Static Site"
3. Connect repository
4. Select it

**Configure:**
- Name: `nanourl-frontend`
- Build Command: `cd frontend/nanourl-frontend && npm install && npm run build`
- Publish Directory: `frontend/nanourl-frontend/dist`

5. Click "Create Static Site"
6. Wait for build (2-3 minutes)

### Step 5: Get Frontend URL

Your frontend is at: `https://nanourl-frontend.onrender.com`

---

## **Part 5: Enable CORS (5 minutes)**

Update `backend/src/main/java/com/NanoURL/config/WebConfig.java`:

```java
@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins(
                    "http://localhost:5173",
                    "https://nanourl-frontend.onrender.com"
                )
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*")
                .allowCredentials(true);
    }
}
```

Commit and push:
```bash
git add .
git commit -m "Enable CORS for production"
git push origin main
```

Render will auto-redeploy.

---

## **Part 6: Connect Frontend to Backend**

### After both are deployed:

1. Open frontend: `https://nanourl-frontend.onrender.com`
2. Try to login or shorten a URL
3. It should work!

If you get CORS errors:
- Check WebConfig.java has correct frontend URL
- Check backend environment variables
- Check frontend API URL matches backend

---

## **Part 7: Test Everything (5 minutes)**

### Test Backend:

```
https://nanourl-backend.onrender.com/
```

Should show: "Welcome to NanoURL!"

### Test Frontend:

```
https://nanourl-frontend.onrender.com
```

Should load the UI.

### Test Full Flow:

1. Sign up with email
2. Shorten a URL
3. Click the short link
4. Should redirect to original URL

---

## **Part 8: Custom Domain (Optional)**

### Add Your Domain

1. Go to your service settings
2. Click "Custom Domain"
3. Add your domain (e.g., nanourl.com)
4. Update DNS records as instructed
5. Wait 24 hours for DNS

---

## **Troubleshooting**

### Backend Build Fails
- Check Docker syntax in Dockerfile
- Verify all Java files compile
- Check pom.xml for errors

### Backend Crashes After Deploy
- Check environment variables are set
- Check database connection string
- Check database is running and accessible
- View logs in Render dashboard

### Frontend Can't Connect to Backend
- Check CORS settings
- Check API URL in frontend code
- Check WebConfig.java is updated
- Test backend URL in browser

### Database Connection Error
- If using local MySQL, make sure:
  - MySQL is running on your machine
  - Firewall allows port 3306
  - username/password are correct
  - database exists
- If using cloud MySQL, check credentials

### "Deployment failed" Error
- View build logs in Render
- Fix the error shown
- Push fix to GitHub
- Render will auto-redeploy

---

## **Important Notes**

⚠️ **Render Free Tier:**
- Services spin down after 15 minutes of inactivity
- First request takes 30-60 seconds
- Limited to 750 hours/month
- No SSL certificate issues (included)

⚠️ **Database Security:**
- Store passwords as environment variables
- Don't commit credentials to Git
- Use strong passwords
- Enable MySQL backup

---

## **Cost**

- **Backend (Docker):** Free tier available
- **Frontend (Static):** Free tier available
- **Database:** Your choice (local = free, cloud = varies)
- **Domain:** Optional ($10-15/year)

Total: **$0 - $15/month**

---

## **Monitoring**

1. Go to Render dashboard
2. View service logs
3. Check for errors
4. Monitor performance

---

## **Update Code (Later)**

When you update code:

```bash
git add .
git commit -m "Your changes"
git push origin main
```

Render auto-deploys!

---

## **Rollback (If Needed)**

1. Go to Render service
2. Click "Deployments"
3. Select previous version
4. Click "Redeploy"

---

## **Environment Summary**

| Service | URL | Type |
|---------|-----|------|
| Backend | https://nanourl-backend.onrender.com | Docker Container |
| Frontend | https://nanourl-frontend.onrender.com | Static Site |
| Database | (Your choice) | MySQL |

---

## **Next Steps**

1. Deploy backend
2. Deploy frontend
3. Test connection
4. Add custom domain (optional)
5. Monitor performance

---

## **More Help**

- See setup: [MYSQL_COMPLETE_SETUP.md](MYSQL_COMPLETE_SETUP.md)
- See configuration: [DATABASE_SETUP.md](DATABASE_SETUP.md)
- See connection: [BACKEND_FRONTEND_CONNECTION.md](BACKEND_FRONTEND_CONNECTION.md)
- All docs: [README.md](README.md)

---

**Your app is ready for the world! 🚀**
