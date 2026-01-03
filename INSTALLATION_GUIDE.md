# 🚀 NanoURL - Complete Installation & Usage Guide

## ✨ What's New - Features Included

Your NanoURL application now includes these professional features:

### ✅ Completed Features
1. **Professional UI** - Modern, gradient design with smooth animations
2. **NanoURL Branding** - Custom logo and favicon throughout the app
3. **URL Shortening** - Instantly create short links
4. **Copy to Clipboard** - One-click copy with visual feedback
5. **URL History** - Track your last 10 shortened URLs (stored locally)
6. **Features Grid** - Showcase 4 key features
7. **Responsive Design** - Works on desktop, tablet, and mobile
8. **Beautiful Animations** - Smooth transitions and hover effects

## 🎯 Quick Start (5 Minutes)

### Step 1: Prerequisites Check
Make sure you have:
- ✅ Java 21 installed (`java -version` should show 21.x.x)
- ✅ Node.js 18+ installed (`node -v` should show 18+)
- ✅ MySQL running (or using H2 database)

### Step 2: One-Click Startup ⚡

**Option A: Windows (Recommended)**
```bash
Double-click: start.bat
```

**Option B: Manual Start**

Terminal 1 - Backend:
```bash
cd backend
mvnw.cmd spring-boot:run
```

Terminal 2 - Frontend:
```bash
cd frontend\nanourl-frontend
npm install
npm run dev
```

### Step 3: Open in Browser

Once both servers are running, open:
```
http://localhost:5173
```

## 🎨 Website Features

### Header Section
- NanoURL logo and branding
- Navigation menu with placeholder links
- Professional gradient design

### Main Content Area
- **Hero Section**: Compelling headline and description
- **Shorten Form**: 
  - Input field with icon
  - "Shorten URL" button with loading state
  - Error messages with visual feedback
  
### After Shortening
- **Result Card**: Shows both original and short URLs
- **Copy Button**: Click to copy short URL to clipboard
- **Test Button**: Quick test of the shortened link
- **History Button**: View your recent URLs

### Features Section
Shows 4 key features:
- ⚡ Lightning Fast
- 🔒 Secure & Reliable  
- 📊 Track Analytics
- 🎯 Custom Links

### Footer
- Copyright information
- Links section (Privacy, Terms, Contact)

## 📱 Using the Application

### How to Shorten a URL

1. **Open** http://localhost:5173
2. **Paste** your long URL in the input field
3. **Click** "Shorten URL" button
4. **Wait** for the shortened URL
5. **Copy** the short URL using the copy button
6. **Share** your shortened link!

### URL History Feature

- Click the **History button** (shows count of saved URLs)
- View your last 10 shortened URLs
- Each entry shows:
  - Original URL
  - Short URL
  - Date and time created
- **Delete** individual entries with the trash icon
- **Clear All** to remove all history
- History saves automatically to browser storage

## 🔧 Configuration

### Database Options

**Option 1: H2 (Recommended for Testing)**
- No setup needed
- Automatically creates database in memory
- Perfect for development
- Data resets on application restart

**Option 2: MySQL (Production)**

1. Install MySQL 8.0+
2. Create database:
```sql
CREATE DATABASE nanourl;
```

3. Update `backend/src/main/resources/application.yaml`:
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/nanourl
    username: root
    password: your_password
```

4. Restart backend server

## 🧪 Testing the API

### Using the Web UI
1. Visit http://localhost:5173
2. Enter a URL
3. Click "Shorten URL"
4. View results and history

### Using curl (Command Line)
```bash
# Shorten a URL
curl -X POST http://localhost:8080/api/shorten \
  -H "Content-Type: application/json" \
  -d "{\"url\": \"https://www.example.com/very/long/url\"}"

# Expected response:
# {
#   "shortCode": "abc123",
#   "shortUrl": "http://localhost:8080/abc123",
#   "longUrl": "https://www.example.com/very/long/url"
# }

# Get original URL
curl http://localhost:8080/api/abc123
```

## 🐛 Troubleshooting

### Backend won't start
**Error**: "Port 8080 already in use"
- Kill the process using port 8080 or change port in `application.yaml`

**Error**: "Database connection refused"
- Make sure MySQL is running
- Or use H2 database (no setup needed)

**Error**: "Java version mismatch"
- Verify Java 21: `java -version`
- Should show `java version "21.x.x"`

### Frontend won't start
**Error**: "Port 5173 already in use"
- Kill the process or wait for it to free up

**Error**: "npm not found"
- Install Node.js from nodejs.org
- Restart your terminal

**Error**: "Cannot find module"
- Run `npm install` in `frontend/nanourl-frontend/`

### CORS errors in browser
**Error**: "Access to XMLHttpRequest blocked by CORS"
- Backend includes CORS configuration for localhost:5173
- If using different port, update `WebConfig.java` with your port

### URL Shortener not working
**Error**: "Failed to shorten URL"
- Check if backend is running: http://localhost:8080/api/shorten (should get 405 GET error, which is fine)
- Check browser console for detailed error message
- Verify API URL in `src/services/api.js` matches your backend URL

## 📊 Project Structure

```
NanoURL/
├── backend/
│   ├── src/main/java/com/NanoURL/
│   │   ├── controller/    # REST endpoints
│   │   ├── service/       # Business logic
│   │   ├── model/         # Database entities
│   │   ├── repository/    # Data access
│   │   ├── config/        # Spring configuration
│   │   └── util/          # Utility functions
│   └── src/main/resources/
│       └── application.yaml  # Configuration
│
├── frontend/nanourl-frontend/
│   ├── src/
│   │   ├── components/    # React components
│   │   │   ├── Header.jsx
│   │   │   ├── UrlShortener.jsx
│   │   │   ├── Result.jsx
│   │   │   └── History.jsx
│   │   ├── services/      # API calls
│   │   │   └── api.js
│   │   ├── hooks/         # Custom hooks
│   │   │   └── useUrlHistory.js
│   │   ├── App.jsx
│   │   ├── App.css
│   │   └── index.css
│   └── index.html
│
├── start.bat              # One-click startup (Windows)
├── README.md              # Project documentation
└── SETUP_GUIDE.md         # This file!
```

## 🚀 Next Steps - Enhancement Ideas

### Easy Additions
1. **Customizable Short Codes** - Let users choose custom codes
2. **QR Codes** - Generate QR codes for each shortened URL
3. **Share Buttons** - Direct share to Twitter, Facebook, LinkedIn
4. **Dark Mode** - Add theme toggle
5. **Link Expiration** - Set URL expiry dates

### Medium Difficulty
1. **User Accounts** - Login/signup with Spring Security
2. **URL Statistics** - Track clicks, referrers, geo-location
3. **Analytics Dashboard** - Visual charts of URL performance
4. **API Keys** - Generate keys for programmatic access
5. **Bulk URL Shortening** - Process multiple URLs at once

### Advanced Features
1. **Custom Domains** - Use your own domain for short links
2. **Link Redirection Analytics** - Track who clicks links
3. **Admin Panel** - Manage users and view system stats
4. **Webhook Support** - Send notifications on events
5. **Multi-language** - Support multiple languages

## 📚 Useful URLs

- **Frontend App**: http://localhost:5173
- **Backend API**: http://localhost:8080/api
- **H2 Database Console**: http://localhost:8080/h2-console
- **Swagger API Docs** (if added): http://localhost:8080/swagger-ui.html

## 💡 Pro Tips

1. **Browser Storage**: History is stored in browser localStorage (survives page refresh)
2. **API Response Format**: All responses are JSON with proper HTTP status codes
3. **URL Validation**: Backend validates URLs before shortening
4. **Base62 Encoding**: Short codes use Base62 for compact representation
5. **Auto Table Creation**: JPA automatically creates tables on first run

## 🆘 Need Help?

1. Check the error message in browser console (F12)
2. Check terminal output where servers are running
3. Verify both ports (5173, 8080) are available
4. Ensure database is running (if using MySQL)
5. Restart both servers and try again

## 📝 License

MIT License - Feel free to use and modify!

---

**Happy URL Shortening! 🎉**

For questions or issues, check the README.md or GitHub Issues.
