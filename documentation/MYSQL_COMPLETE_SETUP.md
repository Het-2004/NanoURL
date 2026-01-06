# 📚 Complete MySQL Setup Guide (45 Minutes)

## Detailed Step-by-Step Setup

This comprehensive guide covers everything for production-ready setup.

---

## **Part 1: Install MySQL (10 minutes)**

### Windows Installation

1. **Download MySQL**
   - Go to: https://dev.mysql.com/downloads/mysql/
   - Click "Download" for latest version
   - Click "No thanks, just start my download"

2. **Run Installer**
   - Double-click `mysql-8.0.x-winx64.msi`
   - Click "Yes" on User Account Control
   - Click "Next"

3. **Setup Type**
   - Select: "Developer Default" (includes Workbench)
   - Click "Next"

4. **Installation**
   - Click "Execute"
   - Wait for download and installation
   - Click "Next"

5. **MySQL Server Configuration**
   - Click "Next"
   - Port: Keep as `3306`
   - Config Type: "Development Machine"
   - Click "Next"

6. **MySQL Server Configuration - Account**
   - MySQL Root Password: Set a strong password
   - Confirm Password
   - Click "Next"

7. **Windows Service**
   - Keep checked: "Configure MySQL Server as a Windows Service"
   - Service Name: "MySQL80"
   - Click "Next"

8. **Complete Installation**
   - Click "Execute"
   - Click "Finish"

### Mac Installation

```bash
# Install Homebrew if not installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install MySQL
brew install mysql

# Start MySQL
brew services start mysql

# Set root password (optional - press Enter to skip)
mysql_secure_installation

# Verify
mysql --version
```

### Linux (Ubuntu/Debian) Installation

```bash
# Update package list
sudo apt-get update

# Install MySQL Server
sudo apt-get install mysql-server

# Start MySQL
sudo systemctl start mysql

# Secure installation (optional)
sudo mysql_secure_installation

# Verify
mysql --version
```

---

## **Part 2: Create Database User (5 minutes)**

### Using Command Line

```bash
# Connect to MySQL as root
mysql -u root -p

# When prompted, enter your root password
```

Then run these SQL commands:

```sql
-- Create database
CREATE DATABASE IF NOT EXISTS nanourl_db 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- Create user
CREATE USER 'nanourl_user'@'localhost' IDENTIFIED BY 'NanoURL@SecurePass123';

-- Grant privileges
GRANT ALL PRIVILEGES ON nanourl_db.* TO 'nanourl_user'@'localhost';

-- Apply changes
FLUSH PRIVILEGES;

-- Verify user was created
SELECT User, Host FROM mysql.user WHERE User = 'nanourl_user';

-- Exit
EXIT;
```

### Using MySQL Workbench (GUI)

1. Open MySQL Workbench
2. Click "+" next to "MySQL Connections"
3. Connection Name: `Local MySQL`
4. Hostname: `127.0.0.1`
5. Port: `3306`
6. Username: `root`
7. Click "Store in Vault" and enter root password
8. Click "Test Connection"
9. Click "OK"

Then to create the user:

1. Double-click the connection to open it
2. File → Open SQL Script
3. Create new file with above SQL commands
4. Click lightning bolt icon to execute

---

## **Part 3: Load Database Schema (3 minutes)**

### Option A: Command Line (Fastest)

```bash
cd D:\JAVA\Project\NanoURL
mysql -u nanourl_user -p nanourl_db < database/database_schema.sql
```

When prompted: Enter password `NanoURL@SecurePass123`

### Option B: Using MySQL Workbench

1. Open MySQL Workbench
2. File → Open SQL Script
3. Navigate to: `database/database_schema.sql`
4. Click "Open"
5. Click the lightning bolt icon (Execute)
6. Check notification: "Finished executing"

### Option C: Copy-Paste in Command Line

```bash
mysql -u nanourl_user -p nanourl_db
```

Then copy all content from `database/database_schema.sql` and paste it into the command line.

---

## **Part 4: Verify Database (5 minutes)**

### Check Database Exists

```bash
mysql -u nanourl_user -p nanourl_db

# Type password: NanoURL@SecurePass123
```

Then:

```sql
-- Show tables
SHOW TABLES;
```

Expected output:
```
+------------------------+
| Tables_in_nanourl_db   |
+------------------------+
| contact_messages       |
| urls                   |
| users                  |
+------------------------+
```

### Check Sample Data

```sql
-- Count users
SELECT COUNT(*) as user_count FROM users;

-- See all users
SELECT id, email, name FROM users;

-- See all URLs
SELECT id, short_code, long_url, user_id FROM urls;

-- See contact messages
SELECT id, name, email, message FROM contact_messages;
```

Expected:
- 3 users
- 5 URLs (distributed across users)
- 3 contact messages

---

## **Part 5: Configure Backend (5 minutes)**

1. Open file: `backend/src/main/resources/application.yaml`

2. Verify this section:

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/nanourl_db?useSSL=false&serverTimezone=UTC
    username: nanourl_user
    password: NanoURL@SecurePass123
    driver-class-name: com.mysql.cj.jdbc.Driver
  jpa:
    hibernate:
      ddl-auto: update
    properties:
      hibernate:
        dialect: org.hibernate.dialect.MySQLDialect
```

3. If you used different credentials, update username/password

4. Save file

---

## **Part 6: Start Backend (5 minutes)**

Open terminal in project root (`D:\JAVA\Project\NanoURL`)

### Windows:
```bash
cd backend
mvnw spring-boot:run
```

### Mac/Linux:
```bash
cd backend
./mvnw spring-boot:run
```

Wait for output:
```
Started NanoUrlApplication in X.XXX seconds
```

This means backend is running on `http://localhost:8080`

---

## **Part 7: Test Everything (5 minutes)**

### Test 1: Check API is Running

Open browser: `http://localhost:8080/`

You should see: **Welcome to NanoURL!**

### Test 2: Check Database Connection

In new terminal:

```bash
mysql -u nanourl_user -p nanourl_db
SELECT * FROM users;
EXIT;
```

You should see the 3 sample users.

### Test 3: Start Frontend (Optional)

In new terminal:

```bash
cd frontend/nanourl-frontend
npm install
npm run dev
```

Open: `http://localhost:5173`

---

## **Part 8: Test with Queries (5 minutes)**

### See Available Sample Data

```bash
mysql -u nanourl_user -p nanourl_db
```

Password: `NanoURL@SecurePass123`

```sql
-- See all users
SELECT * FROM users;

-- See URLs created by user_id=1
SELECT * FROM urls WHERE user_id = 1;

-- See contact messages
SELECT * FROM contact_messages;

-- See which user created which URL
SELECT u.short_code, u.long_url, user.email 
FROM urls u 
JOIN users user ON u.user_id = user.id;

-- Exit
EXIT;
```

---

## **Troubleshooting**

### Error: "Access denied for user 'nanourl_user'"
**Problem:** Wrong password or user not created  
**Solution:**
```bash
mysql -u root -p
# Enter root password
# Recreate user from Part 2
```

### Error: "Unknown database 'nanourl_db'"
**Problem:** Database not created  
**Solution:** Run database_schema.sql again

### Error: "Connection refused at 127.0.0.1:3306"
**Problem:** MySQL not running  
**Solution:**
- Windows: `mysql.server start` or restart MySQL Service in Services
- Mac: `brew services start mysql`
- Linux: `sudo systemctl start mysql`

### Error: "Can't create table (errno: 150)"
**Problem:** Foreign key constraint issue  
**Solution:** Drop and recreate database
```bash
mysql -u root -p
DROP DATABASE nanourl_db;
# Run database_schema.sql again
```

### Backend Won't Start
**Problem:** Port 8080 in use or database connection error  
**Solution:**
1. Check if another Java process is running: `netstat -ano | find ":8080"`
2. Verify MySQL is running: `mysql -u root -p`
3. Check application.yaml credentials
4. Check pom.xml has MySQL driver: search for "mysql-connector-j"

### Frontend Can't Connect to Backend
**Problem:** CORS error or wrong API URL  
**Solution:**
1. Check backend is running: visit `http://localhost:8080`
2. Check frontend API URL in `src/services/api.js`
3. Should be: `http://localhost:8080`

---

## **✅ What You Have Now**

✅ MySQL 8.0+ installed and running  
✅ Database `nanourl_db` created  
✅ User `nanourl_user` with full privileges  
✅ 3 tables with sample data  
✅ Backend configured and running  
✅ Frontend ready to use  
✅ Full test suite passed  

---

## **📊 Database Summary**

### Tables Created:
- **users** (3 rows)
  - id, email, password, name, contact, created_at, updated_at

- **urls** (5 rows)
  - id, short_code, long_url, click_count, created_at, user_id

- **contact_messages** (3 rows)
  - id, name, email, message, created_at

### Sample Credentials:

**Database:**
- Username: `nanourl_user`
- Password: `NanoURL@SecurePass123`
- Database: `nanourl_db`

**Backend:**
- URL: `http://localhost:8080`
- Port: `8080`

---

## **🔐 Security Notes**

⚠️ **For Development Only:**
- Sample password is visible in files
- Root access not restricted

⚠️ **For Production:**
- Change all passwords in application.yaml
- Use environment variables for credentials
- Restrict user permissions
- Enable SSL/TLS
- Use strong passwords

See [DATABASE_SETUP.md](DATABASE_SETUP.md) for production configuration.

---

## **📚 Next Steps**

1. **View Data:** [HOW_TO_VIEW_DATA.md](HOW_TO_VIEW_DATA.md)
2. **Run Queries:** `database/QUERY_EXAMPLES.sql`
3. **Understand Schema:** [DATABASE_SCHEMA_DIAGRAM.md](DATABASE_SCHEMA_DIAGRAM.md)
4. **Deploy to Production:** [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)
5. **More Help:** [README.md](README.md)

---

## **⏱️ Setup Time Summary**

- Install MySQL: 10 min
- Create database: 5 min
- Load schema: 3 min
- Verify: 5 min
- Configure backend: 5 min
- Start backend: 5 min
- Test: 5 min
- **Total: ~45 minutes**

---

**Congratulations! Your database is ready! 🎉**
