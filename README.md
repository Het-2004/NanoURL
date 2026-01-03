# 🚀 NanoURL - Professional URL Shortener

A modern, full-stack URL shortening service with user authentication, analytics, and MySQL database.

[![Java](https://img.shields.io/badge/Java-21-blue?logo=java)](https://www.java.com/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-4.0-green?logo=spring)](https://spring.io/)
[![React](https://img.shields.io/badge/React-19-blue?logo=react)](https://react.dev/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-blue?logo=mysql)](https://www.mysql.com/)

## ✨ Key Features

- 🔗 **URL Shortening** - Convert long URLs to short, shareable links
- 👤 **User Authentication** - Sign up/Sign in with email, Google, or GitHub
- 📊 **Analytics Dashboard** - Track clicks and view URL history
- 💾 **Data Persistence** - All data stored securely in MySQL
- 🎨 **Modern UI** - Beautiful, responsive React interface
- 📱 **Mobile Friendly** - Works seamlessly on all devices
- 🔐 **JWT Security** - Secure token-based authentication
- 🌐 **OAuth2 Support** - Google and GitHub integration

---

## 🚀 Quick Start (5 Minutes)

### 1. Setup MySQL
```bash
# Install MySQL or use existing instance
# Create database:
mysql -u root -p
CREATE DATABASE nanourl_db;
EXIT;
```

### 2. Start Backend (Terminal 1)
```bash
cd backend
mvnw.cmd spring-boot:run    # Windows
./mvnw spring-boot:run      # Mac/Linux
# Runs on http://localhost:8080
```

### 3. Start Frontend (Terminal 2)
```bash
cd frontend/nanourl-frontend
npm install
npm run dev
# Runs on http://localhost:5173
```

### 4. Open Browser
```
http://localhost:5173
```

✅ **Done!** Your NanoURL instance is running.

---

## 📱 How to Use

### First Time Users (Sign Up)
1. Click **"Sign In"** button in header
2. Select sign up option
3. Choose auth method:
   - **Email/Password** - Enter name, email, password
   - **Google** - Click "Continue with Google"
   - **GitHub** - Click "Continue with GitHub"
4. Account created! You're now logged in

### Shorten URLs
1. Paste your long URL in the input field
2. Click **"Shorten URL"** button
3. Your short URL appears instantly
4. Click to copy or share

### View Your History
1. Click **"My URLs"** in navigation (when logged in)
2. See all your shortened URLs with:
   - Original and short URLs
   - Click counts
   - Creation dates
   - Quick copy button
   - Delete option
3. Sort by:
   - Most Recent (default)
   - Oldest First
   - Most Clicked

### Learn More Features
1. Click **"Features & Help"** button in header
2. Browse interactive guides:
   - Getting Started
   - URL Shortening
   - History Management
   - Key Features
   - Pro Tips

---

## 🛠️ Installation & Configuration

### Full Setup Guide
See [SETUP_GUIDE.md](SETUP_GUIDE.md) for detailed instructions including:
- MySQL installation on all platforms
- Backend configuration
- Frontend setup
- OAuth2 configuration
- Troubleshooting

### Optional: Google OAuth Setup
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create project, enable Google+ API
3. Create OAuth 2.0 Web credentials
4. Add redirect URI: `http://localhost:8080/login/oauth2/code/google`
5. Add credentials to `application.yaml`:
```yaml
spring:
  security:
    oauth2:
      client:
        registration:
          google:
            client-id: YOUR_ID
            client-secret: YOUR_SECRET
            scope: profile, email
```

### Optional: GitHub OAuth Setup
1. Go to GitHub Settings → Developer settings → OAuth Apps
2. Create new app with callback: `http://localhost:8080/login/oauth2/code/github`
3. Add credentials to `application.yaml`:
```yaml
spring:
  security:
    oauth2:
      client:
        registration:
          github:
            client-id: YOUR_ID
            client-secret: YOUR_SECRET
            scope: user:email
```

---

## 🏗️ Project Structure

### Backend (Spring Boot)
```
backend/
├── src/main/java/com/NanoURL/
│   ├── NanoUrlApplication.java      # Main app
│   ├── controller/
│   │   ├── AuthController.java      # Auth endpoints
│   │   └── UrlController.java       # URL endpoints
│   ├── service/
│   │   ├── UserService.java         # User logic
│   │   └── UrlService.java          # URL logic
│   ├── model/
│   │   ├── User.java                # User entity
│   │   └── Url.java                 # URL entity
│   ├── repository/
│   │   ├── UserRepository.java      # User queries
│   │   └── UrlRepository.java       # URL queries
│   ├── config/
│   │   ├── SecurityConfig.java      # Spring Security
│   │   ├── JwtRequestFilter.java    # JWT validation
│   │   ├── WebConfig.java           # CORS config
│   │   └── JwtUtil.java             # JWT utilities
│   └── resources/
│       └── application.yaml         # App config
├── pom.xml                          # Maven dependencies
└── mvnw.cmd / mvnw                 # Maven wrapper
```

### Frontend (React + Vite)
```
frontend/nanourl-frontend/
├── src/
│   ├── App.jsx                      # Main component
│   ├── App.css                      # Global styles
│   ├── main.jsx                     # Entry point
│   ├── components/
│   │   ├── Header.jsx               # Navigation
│   │   ├── UrlShortener.jsx         # Shortener form
│   │   ├── Result.jsx               # Result display
│   │   ├── History.jsx              # History list
│   │   ├── FeaturesModal.jsx        # Help modal
│   │   └── FeaturesModal.css        # Modal styles
│   ├── pages/
│   │   ├── AuthPage.jsx             # Login/signup
│   │   ├── AuthPage.css
│   │   ├── HistoryPage.jsx          # URL history
│   │   ├── HistoryPage.css
│   │   ├── FeaturesPage.jsx         # Features page
│   │   └── FeaturesPage.css
│   ├── context/
│   │   └── AuthContext.jsx          # Auth state
│   ├── hooks/
│   │   └── useUrlHistory.js         # History hook
│   ├── services/
│   │   └── api.js                   # API calls
│   ├── assets/                      # Images, fonts
│   └── styles/                      # Global styles
├── package.json                     # Dependencies
├── vite.config.js                   # Vite config
└── index.html                       # HTML template
```

---

## 📡 API Reference

### Authentication Endpoints
| Method | Endpoint | Request | Response |
|--------|----------|---------|----------|
| POST | `/api/auth/signup` | `{email, password, name}` | `{token, user}` |
| POST | `/api/auth/signin` | `{email, password}` | `{token, user}` |
| POST | `/api/auth/oauth/{provider}` | `{email, name, providerId}` | `{token, user}` |
| GET | `/api/auth/verify` | Bearer token | `{user}` |
| GET | `/api/auth/me` | Bearer token | `{user}` |

### URL Endpoints
| Method | Endpoint | Request | Response |
|--------|----------|---------|----------|
| POST | `/api/shorten` | `{url}` | `{shortCode, shortUrl, longUrl}` |
| GET | `/api/{code}` | - | `{url}` (redirect) |
| GET | `/api/urls/history` | Bearer token | `[{id, shortCode, longUrl, ...}]` |
| DELETE | `/api/urls/{id}` | Bearer token | Status 200 |

---

## 🗄️ Database Schema

### Users Table
```sql
CREATE TABLE users (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  email VARCHAR(255) UNIQUE NOT NULL,
  name VARCHAR(255) NOT NULL,
  password_hash VARCHAR(255),
  auth_provider VARCHAR(50),
  provider_id VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### URLs Table
```sql
CREATE TABLE urls (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  short_code VARCHAR(255) UNIQUE NOT NULL,
  long_url LONGTEXT NOT NULL,
  user_id BIGINT,
  click_count BIGINT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

---

## 🔐 Security Features

- **JWT Authentication** - Secure token-based auth
- **Password Encryption** - BCrypt hashing
- **OAuth2 Integration** - Google & GitHub
- **CORS Protection** - Configured for security
- **CSRF Prevention** - Spring Security CSRF token
- **SQL Injection Prevention** - JPA Parameterized queries
- **XSS Protection** - React automatic escaping

---

## 🐛 Troubleshooting

### Common Issues

**MySQL Connection Failed**
```bash
# Verify MySQL is running
mysql -u root -p

# Check credentials in application.yaml
# Default: username=root, password=root, port=3306
```

**Port Already in Use**
```bash
# Windows - Find process using port 8080
netstat -ano | findstr :8080

# Change port in application.yaml:
server:
  port: 8081
```

**Frontend Can't Connect to Backend**
1. Verify backend is running (`http://localhost:8080`)
2. Check browser console for CORS errors
3. Verify JWT token in localStorage (Dev Tools)
4. Clear browser cache and cookies

**User Data Not Saving**
1. Check MySQL database is created: `SHOW DATABASES;`
2. Verify Hibernate logging shows CREATE TABLE queries
3. Check for SQL errors in backend logs
4. Ensure `ddl-auto: update` in application.yaml

See [SETUP_GUIDE.md](SETUP_GUIDE.md) for more solutions.

---

## 📊 Project Statistics

| Component | Technology | Lines |
|-----------|-----------|-------|
| Backend | Spring Boot 4.0 | ~1000 |
| Frontend | React 19 | ~1500 |
| Database | MySQL 8.0 | Auto-generated |
| Total | Full-stack | ~2500+ |

---

## 🚀 Deployment

### Production Checklist
- [ ] Change JWT secret to strong random value
- [ ] Update OAuth redirect URIs to production domain
- [ ] Configure MySQL with strong password
- [ ] Enable HTTPS/SSL
- [ ] Update CORS allowed origins
- [ ] Set `spring.jpa.hibernate.ddl-auto: validate`
- [ ] Configure environment variables
- [ ] Setup database backups
- [ ] Monitor logs and errors
- [ ] Performance testing

### Docker Deployment
```bash
docker-compose up
# Access on http://localhost:5173
```

---

## 📚 Additional Resources

- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [React Documentation](https://react.dev)
- [MySQL Documentation](https://dev.mysql.com/doc/)
- [OAuth 2.0 Guide](https://oauth.net/2/)
- [JWT.io](https://jwt.io)

---

## 📄 License

MIT License - Feel free to use, modify, and distribute.

```
MIT License

Copyright (c) 2026 NanoURL

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
...
```

---

## 👥 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

## 🤝 Support

- 📖 Check [SETUP_GUIDE.md](SETUP_GUIDE.md) for detailed setup instructions
- 🐛 Report bugs as GitHub Issues
- 💡 Suggest features via Discussions
- 📧 Email support available

---

## 🎉 Thank You!

Thank you for using NanoURL! We hope you find it useful.

**Happy URL Shortening!** 🚀


## 🚀 Quick Start

### 1. Setup Database

**Option A: MySQL (Recommended for Production)**
```sql
CREATE DATABASE nanourl;
CREATE USER 'nanourl_user'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON nanourl.* TO 'nanourl_user'@'localhost';
FLUSH PRIVILEGES;
```

Update `backend/src/main/resources/application.yaml`:
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/nanourl
    username: nanourl_user
    password: your_password
```

**Option B: H2 (For Development)**

The test configuration already uses H2. You can use it for development too.

### 2. Start Backend Server

```bash
cd backend

# Windows
.\mvnw.cmd spring-boot:run

# Linux/Mac
./mvnw spring-boot:run
```

Backend will start at: **http://localhost:8080**

### 3. Start Frontend Development Server

```bash
cd frontend/nanourl-frontend

# Install dependencies (first time only)
npm install

# Start dev server
npm run dev
```

Frontend will start at: **http://localhost:5173**

### 4. Access the Application

Open your browser and navigate to:
- **Frontend**: http://localhost:5173
- **Backend API**: http://localhost:8080/api

## 🔌 API Documentation

### Shorten URL
```http
POST /api/shorten
Content-Type: application/json

{
  "url": "https://example.com/very-long-url"
}
```

**Response:**
```json
{
  "shortCode": "a1B2c3",
  "shortUrl": "http://localhost:8080/a1B2c3",
  "longUrl": "https://example.com/very-long-url"
}
```

### Get Original URL
```http
GET /api/{shortCode}
```

**Response:**
```json
{
  "url": "https://example.com/very-long-url"
}
```

## 🧪 Running Tests

### Backend Tests
```bash
cd backend
.\mvnw.cmd test
```

### Frontend Tests
```bash
cd frontend/nanourl-frontend
npm test
```

## 📦 Building for Production

### Backend
```bash
cd backend
.\mvnw.cmd clean package

# Run the JAR
java -jar target/NanoURL-0.0.1-SNAPSHOT.jar
```

### Frontend
```bash
cd frontend/nanourl-frontend
npm run build

# Serve the build folder with any static server
```

## 🔧 Technology Stack

### Backend
- **Java 21** - Latest LTS version
- **Spring Boot 4.0.1** - Framework
- **Spring Data JPA** - ORM
- **MySQL** - Database
- **Maven** - Build tool

### Frontend
- **React 18** - UI Library
- **Vite** - Build tool
- **Modern CSS** - Styling

## 📊 Database Schema

```sql
CREATE TABLE urls (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    short_code VARCHAR(255) UNIQUE,
    long_url VARCHAR(255) NOT NULL,
    click_count BIGINT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 🛠️ Configuration

### Backend Configuration

Edit `backend/src/main/resources/application.yaml`:

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/nanourl
    username: your_username
    password: your_password
  jpa:
    hibernate:
      ddl-auto: update  # Use 'validate' in production

server:
  port: 8080
```

### Frontend Configuration

Edit `frontend/nanourl-frontend/src/services/api.js`:

```javascript
const BASE_URL = "http://your-backend-url:8080/api";
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License.

---

**Made with ❤️ using Spring Boot & React**
