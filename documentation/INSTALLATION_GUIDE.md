# 📋 Installation Guide

## Complete Installation Instructions

---

## **Requirements**

### Hardware:
- 2GB RAM minimum
- 500MB disk space
- Internet connection

### Software:
- Java 21+ (for backend)
- Node.js 16+ (for frontend)
- MySQL 8.0+ (database)
- Git (version control)

---

## **Step 1: Install Java**

### Windows:
1. Download JDK 21: https://jdk.java.net/21/
2. Run installer
3. Follow steps
4. Add to PATH

Verify:
```bash
java -version
javac -version
```

### Mac:
```bash
brew install openjdk@21
```

### Linux:
```bash
sudo apt-get install openjdk-21-jdk
```

---

## **Step 2: Install Node.js**

### Windows/Mac:
1. Download: https://nodejs.org/ (LTS version)
2. Run installer
3. Follow steps

### Linux:
```bash
sudo apt-get install nodejs npm
```

Verify:
```bash
node -v
npm -v
```

---

## **Step 3: Install MySQL**

### Windows:
1. Download: https://dev.mysql.com/downloads/mysql/
2. Run installer
3. Choose "Developer Default"
4. Click "Execute"
5. Set password
6. Complete installation

### Mac:
```bash
brew install mysql
brew services start mysql
```

### Linux:
```bash
sudo apt-get install mysql-server
sudo systemctl start mysql
```

Verify:
```bash
mysql --version
mysql -u root -p
```

---

## **Step 4: Install Git**

### Windows/Mac:
Download from: https://git-scm.com/

### Linux:
```bash
sudo apt-get install git
```

Verify:
```bash
git --version
```

---

## **Step 5: Clone Project**

```bash
git clone https://github.com/yourusername/nanourl.git
cd NanoURL
```

---

## **Step 6: Setup Backend**

```bash
cd backend

# Build project
mvnw clean install

# Or on Mac/Linux
./mvnw clean install
```

---

## **Step 7: Setup Database**

```bash
# Go to project root
cd ..

# Create database
mysql -u root -p < database/database_schema.sql

# When prompted, enter your MySQL root password
```

---

## **Step 8: Setup Frontend**

```bash
cd frontend/nanourl-frontend

# Install dependencies
npm install
```

---

## **Step 9: Start Services**

Open 3 terminals:

### Terminal 1 (Backend):
```bash
cd backend
mvnw spring-boot:run
```

Wait for "Started NanoUrlApplication"

### Terminal 2 (Frontend):
```bash
cd frontend/nanourl-frontend
npm run dev
```

Wait for "Local: http://localhost:5173"

### Terminal 3 (MySQL):
```bash
mysql -u nanourl_user -p nanourl_db
# Password: NanoURL@SecurePass123
```

---

## **Step 10: Test Everything**

### Backend:
Open browser: http://localhost:8080/

Should show: "Welcome to NanoURL!"

### Frontend:
Open browser: http://localhost:5173/

Should show the React app.

### Database:
```bash
# In Terminal 3 (MySQL)
SELECT * FROM users;
```

Should show 3 sample users.

---

## **Troubleshooting**

### Java not found:
- Verify Java installed: `java -version`
- Add to PATH if needed
- Restart terminal

### Node not found:
- Verify Node installed: `node -v`
- Restart terminal after installation

### MySQL not running:
- Windows: Start "MySQL80" in Services
- Mac: `brew services start mysql`
- Linux: `sudo systemctl start mysql`

### Port already in use:
- Backend (8080): `netstat -ano | find "8080"`
- Frontend (5173): `netstat -ano | find "5173"`
- Kill process or change port

### Database connection error:
- Check MySQL running
- Verify username/password
- Check database exists

---

## **Next Steps**

1. Read [QUICK_START.md](QUICK_START.md)
2. Shorten a URL
3. View database data
4. Try all features
5. Deploy when ready

---

**Installation complete! 🎉**
