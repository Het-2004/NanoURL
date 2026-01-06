# Quick Start - Database Setup

## TL;DR - 3 Steps to Get Data Saving

### Step 1: Verify Database Configuration ✅
```bash
# Go to project root
cd d:\JAVA\Project\NanoURL

# Run verification script
verify-database.bat
```

This will check MySQL and create database/user if needed.

### Step 2: Start Backend
```bash
cd backend
mvn spring-boot:run
```

Backend will:
- Connect to MySQL
- Create tables automatically
- Start on http://localhost:8080

### Step 3: Test & Verify
1. Open http://localhost:5173 (frontend)
2. Create account
3. Shorten a URL
4. Check database:

```bash
mysql -u nanourl_user -p nanourl_db
# Password: NanoURL@SecurePass123

mysql> SELECT COUNT(*) FROM users;
mysql> SELECT COUNT(*) FROM urls;
mysql> SELECT * FROM users;
```

**Done!** All data is now saved to MySQL database.

---

## What Data is Being Saved?

| When User Does | Data Saved To | What's Stored |
|---|---|---|
| **Register** | `users` table | Email, password, name |
| **Login** | `login_history` table | Time, IP, browser, method |
| **Shorten URL** | `urls` table | Short code, long URL |
| **Click Short URL** | `url_access_log` table | Time, IP, browser, referer |
| **Generate QR** | (memory) | QR code image only |
| **Contact Form** | `contact_messages` table | Name, email, message |

---

## Verify Data Exists

### Quick Check
```bash
# Open database
mysql -u nanourl_user -p nanourl_db
# Password: NanoURL@SecurePass123

# Check what's in database
SHOW TABLES;
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM urls;
SELECT COUNT(*) FROM login_history;
SELECT * FROM users;
```

### Using GUI (MySQL Workbench)
1. Open MySQL Workbench
2. Click + to create new connection
3. Fill in:
   - Host: `localhost`
   - Port: `3306`
   - Username: `nanourl_user`
   - Password: `NanoURL@SecurePass123`
4. Click "Test Connection"
5. Connect and browse database

---

## Configuration Changed

**Before**: Used H2 database (temporary file) ❌
**After**: Uses MySQL database (permanent) ✅

```yaml
# Now using this in application.yaml:
datasource:
  url: jdbc:mysql://localhost:3306/nanourl_db
  username: nanourl_user
  password: NanoURL@SecurePass123
```

---

## MySQL Credentials

| Item | Value |
|---|---|
| Host | localhost |
| Port | 3306 |
| Database | nanourl_db |
| Username | nanourl_user |
| Password | NanoURL@SecurePass123 |

---

## Useful Queries

**See all users:**
```sql
SELECT * FROM users;
```

**See all shortened URLs:**
```sql
SELECT * FROM urls;
```

**See login history:**
```sql
SELECT * FROM login_history;
```

**See URL clicks:**
```sql
SELECT * FROM url_access_log;
```

**See most clicked URLs:**
```sql
SELECT short_code, COUNT(*) as clicks 
FROM url_access_log ual 
JOIN urls u ON ual.url_id = u.id 
GROUP BY u.id, short_code 
ORDER BY clicks DESC;
```

---

## If Something Goes Wrong

### MySQL not found
```bash
# Install MySQL or add to PATH
# Verify: mysql --version
```

### Can't connect to database
```bash
# Check MySQL is running
# Windows: mysql -u root -p

# Verify database exists
mysql> SHOW DATABASES;
mysql> USE nanourl_db;
mysql> SHOW TABLES;
```

### No data after using app
1. Check backend logs for errors
2. Verify MySQL connection works
3. Check database has tables
4. Restart backend: `mvn spring-boot:run`

---

## Files Updated

✅ `application.yaml` - Now uses MySQL  
✅ `application-prod.yaml` - Production MySQL config  
✅ `verify-database.bat` - Helper script  

---

## Next Steps

1. ✅ Run `verify-database.bat`
2. ✅ Start backend: `mvn spring-boot:run`
3. ✅ Start frontend: `npm run dev`
4. ✅ Use the app to create data
5. ✅ Verify in MySQL: `mysql -u nanourl_user -p nanourl_db`

**Everything is configured! Your data is now being saved to MySQL.** 🚀
