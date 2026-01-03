# 🎯 NanoURL - Complete Setup & Configuration Guide

## Project Overview
NanoURL is a full-stack URL shortener with MySQL database, user authentication (Email/OAuth), and comprehensive URL management dashboard.

---

## Database Setup - MySQL

### 1. Install MySQL Server

**Windows:**
- Download from [mysql.com](https://dev.mysql.com/downloads/mysql/)
- Run installer
- Default port: 3306
- Set password: `root` (or change in application.yaml)

**macOS (Homebrew):**
```bash
brew install mysql
brew services start mysql
```

**Linux:**
```bash
sudo apt-get install mysql-server
sudo mysql_secure_installation
```

### 2. Create Database
```bash
mysql -u root -p
# Enter password: root

# In MySQL shell:
CREATE DATABASE nanourl_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
EXIT;
```

### 3. Verify Connection
```bash
mysql -u root -p -D nanourl_db
```

---

## Backend Setup (Spring Boot)

### 1. Navigate to Backend
```bash
cd backend
```

### 2. Verify MySQL Configuration
File: `src/main/resources/application.yaml` is already configured:
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/nanourl_db?createDatabaseIfNotExist=true
    username: root
    password: root
```

**⚠️ Update password if different from default `root`**

### 3. Build & Run
```bash
# Windows
mvnw.cmd clean compile
mvnw.cmd spring-boot:run

# Linux/macOS
./mvnw clean compile
./mvnw spring-boot:run
```

✅ Backend runs on `http://localhost:8080`

---

## Frontend Setup (React + Vite)

### 1. Navigate to Frontend
```bash
cd frontend/nanourl-frontend
```

### 2. Install Dependencies
```bash
npm install
```

### 3. Run Development Server
```bash
npm run dev
```

✅ Frontend runs on `http://localhost:5173`

---

## Authentication Setup (Optional OAuth2)

### Email/Password Authentication
Already implemented! Users can:
- Sign up with email + password
- Sign in with existing credentials
- Data saved to MySQL database

### Google OAuth Setup

#### 1. Create Google Project
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create new project "NanoURL"
3. Enable "Google+ API"
4. Create OAuth 2.0 Web credentials
5. Add redirect URIs:
   - `http://localhost:8080/login/oauth2/code/google`
   - `http://localhost:8080/oauth2/callback/google`

#### 2. Add to application.yaml
```yaml
spring:
  security:
    oauth2:
      client:
        registration:
          google:
            client-id: YOUR_CLIENT_ID.apps.googleusercontent.com
            client-secret: YOUR_CLIENT_SECRET
            scope: profile, email
```

---

### GitHub OAuth Setup

#### 1. Register OAuth App
1. GitHub Settings → Developer settings → OAuth Apps
2. Create new app:
   - **Name**: NanoURL
   - **Homepage URL**: `http://localhost:5173`
   - **Callback URL**: `http://localhost:8080/login/oauth2/code/github`

#### 2. Add to application.yaml
```yaml
spring:
  security:
    oauth2:
      client:
        registration:
          github:
            client-id: YOUR_GITHUB_CLIENT_ID
            client-secret: YOUR_GITHUB_CLIENT_SECRET
            scope: user:email
```

---

## API Reference

### Authentication Endpoints
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/signup` | Register new user |
| POST | `/api/auth/signin` | Login user |
| GET | `/api/auth/verify` | Verify JWT token |
| GET | `/api/auth/me` | Get current user |

### URL Endpoints
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/shorten` | Create short URL |
| GET | `/api/{code}` | Redirect to original |
| GET | `/api/urls/history` | Get user's URLs |
| DELETE | `/api/urls/{id}` | Delete URL |

---

## User Features

### 1️⃣ Signup/Signin
- Click "Sign In" button
- Choose: Email/Password, Google, or GitHub
- First time = Signup, Then = Signin only

### 2️⃣ Shorten URLs
- Enter long URL
- Click "Shorten URL"
- Copy or share instantly

### 3️⃣ View History
- Click "My URLs" (when logged in)
- See all shortened URLs with:
  - Click counts
  - Original URLs  
  - Creation dates
  - Delete/copy options

### 4️⃣ Features & Help
- Click "Features & Help" button
- Interactive guide with:
  - Getting started steps
  - URL shortening tutorial
  - History management guide
  - Pro tips & tricks

---

## Database Schema

### users table
```sql
CREATE TABLE users (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  email VARCHAR(255) UNIQUE NOT NULL,
  name VARCHAR(255) NOT NULL,
  password_hash VARCHAR(255),
  auth_provider VARCHAR(50),
  provider_id VARCHAR(255),
  created_at TIMESTAMP
);
```

### urls table
```sql
CREATE TABLE urls (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  short_code VARCHAR(255) UNIQUE NOT NULL,
  long_url TEXT NOT NULL,
  user_id BIGINT,
  click_count BIGINT DEFAULT 0,
  created_at TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);
```

---

## Troubleshooting

### MySQL Not Connecting
```bash
# Check if running
mysql -u root -p

# Or restart
# Windows: Services → MySQL → Restart
# Mac: brew services restart mysql
# Linux: sudo systemctl restart mysql
```

### Port 8080 Already in Use
```bash
# Check what's using it
# Windows: netstat -ano | findstr :8080
# Mac/Linux: lsof -i :8080

# Change port in application.yaml:
server:
  port: 8081
```

### Frontend Not Connecting to Backend
1. Ensure backend is running (http://localhost:8080)
2. Check CORS is enabled in SecurityConfig
3. Verify JWT token in localStorage (Dev Tools → Application)
4. Try clearing cache/cookies

### User Data Not Saving
1. Verify MySQL is running: `mysql -u root -p`
2. Check database exists: `SHOW DATABASES;`
3. View Hibernate logs for errors
4. Ensure `ddl-auto: update` is set in application.yaml

---

## Important Notes

### First Time Run
- Backend will auto-create tables (via Hibernate DDL)
- No manual SQL needed
- Tables appear in `nanourl_db` database

### JWT Token
- Stored in browser localStorage
- Expires after 24 hours  
- Automatically verified on each request
- Header format: `Authorization: Bearer {token}`

### Data Persistence
- All user data saved to MySQL
- Survives server restarts
- History permanently stored
- No data loss on logout

---

## Quick Start (TL;DR)

```bash
# 1. Ensure MySQL running
mysql -u root -p

# 2. Create database
CREATE DATABASE nanourl_db;
EXIT;

# 3. Backend
cd backend
mvnw.cmd spring-boot:run

# 4. Frontend (new terminal)
cd frontend/nanourl-frontend
npm install
npm run dev

# 5. Open http://localhost:5173
```

---

## File Structure

```
NanoURL/
├── backend/
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/com/NanoURL/
│   │   │   │   ├── controller/
│   │   │   │   ├── service/
│   │   │   │   ├── model/
│   │   │   │   ├── repository/
│   │   │   │   └── config/
│   │   │   └── resources/application.yaml
│   │   └── test/
│   ├── pom.xml
│   └── mvnw
├── frontend/
│   └── nanourl-frontend/
│       ├── src/
│       │   ├── components/
│       │   ├── pages/
│       │   ├── services/
│       │   ├── context/
│       │   └── hooks/
│       └── package.json
└── README.md
```

---

## Next Steps

1. ✅ Setup MySQL
2. ✅ Start backend
3. ✅ Start frontend
4. 🔐 Configure OAuth (optional)
5. 🚀 Start using NanoURL!

---

**Questions?** Check the features & help section in the app!


**Terminal 1 - Backend:**
```bash
cd backend
.\mvnw.cmd spring-boot:run
```

**Terminal 2 - Frontend:**
```bash
cd frontend\nanourl-frontend
npm install   # First time only
npm run dev
```

### Step 3: Access the Application

- 🌐 **Frontend**: http://localhost:5173
- 🔧 **Backend API**: http://localhost:8080/api
- 📊 **H2 Console** (if using H2): http://localhost:8080/h2-console

## 🎨 What You'll See

The application now features:

1. **Professional Header** with navigation
2. **Hero Section** with compelling copy
3. **URL Shortener Form** with beautiful input and button
4. **Result Display** with:
   - Original URL shown
   - Shortened URL with copy button
   - Test link button
5. **Features Grid** showcasing the app capabilities
6. **Footer** with links

## 🔧 Troubleshooting

### Backend won't start
- Check if port 8080 is available
- Verify Java 21 is installed: `java -version`
- Check database connection in application.yaml

### Frontend won't start
- Check if port 5173 is available
- Install dependencies: `npm install`
- Verify Node.js version: `node -v` (should be 18+)

### CORS errors
- Backend includes CORS configuration for localhost:5173
- If using different port, update `WebConfig.java`

## 📝 Testing the API

### Using curl:
```bash
# Shorten a URL
curl -X POST http://localhost:8080/api/shorten \
  -H "Content-Type: application/json" \
  -d "{\"url\": \"https://www.google.com\"}"

# Get original URL
curl http://localhost:8080/api/{shortCode}
```

### Using the UI:
1. Open http://localhost:5173
2. Enter a long URL (e.g., https://www.google.com/search?q=test)
3. Click "Shorten URL"
4. Copy and test the shortened link

## 🚀 Next Steps

1. **Customize Branding**: Update colors in `index.css` CSS variables
2. **Add Analytics**: Implement click tracking in the backend
3. **Custom Domains**: Add support for custom short domains
4. **User Authentication**: Add login/signup for managing URLs
5. **Dashboard**: Create a dashboard to view all shortened URLs

## 💡 Pro Tips

- The backend auto-creates tables using JPA
- Click count is tracked in the database
- Short codes use Base62 encoding for compact URLs
- All URLs are validated before shortening

---

Need help? Check the main README.md or create an issue on GitHub.
