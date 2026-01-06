# Database Configuration - Complete Guide

## Summary

Your NanoURL project **DOES save all data to SQL database**. However, it was previously configured to use **H2 Database** (temporary file-based) instead of **MySQL** (persistent database). I've now fixed this configuration.

## What Changed?

### Before ❌
```yaml
datasource:
  url: jdbc:h2:file:./data/nanourl_db  # H2 File Database
  driver: org.h2.Driver
```
**Problem**: Data was stored in local file, not in a proper SQL database

### After ✅
```yaml
datasource:
  url: jdbc:mysql://localhost:3306/nanourl_db  # MySQL Database
  username: nanourl_user
  password: NanoURL@SecurePass123
  driver: com.mysql.cj.jdbc.Driver
```
**Solution**: Data is now stored in proper MySQL database on your server

## Data Flow

When you use the application, **all these actions save data to MySQL**:

```
Action                    →  Database Table      →  What Gets Saved
=========================================================================
User Registration         →  users               →  Email, Password, Name
User Login                →  login_history       →  Time, IP, Browser, Method
Shorten URL               →  urls                →  Short Code, Long URL
Click Shortened URL       →  url_access_log      →  Time, IP, Browser, Referer
Generate QR Code          →  (no DB)            →  (Generated on-the-fly)
Submit Contact Form       →  contact_messages    →  Name, Email, Message
```

## Files Updated

### 1. `application.yaml` (Default Configuration)
```yaml
datasource:
  url: jdbc:mysql://localhost:3306/nanourl_db
  username: nanourl_user
  password: NanoURL@SecurePass123
```

### 2. `application-prod.yaml` (Production Configuration)
```yaml
datasource:
  url: ${DB_URL:jdbc:mysql://localhost:3306/nanourl_db}
  username: ${DB_USER:nanourl_user}
  password: ${DB_PASSWORD:NanoURL@SecurePass123}
```
Uses environment variables for security in production.

## How to Verify Data is Being Saved

### Option 1: Using the Verification Script
```bash
# Run the verification script
cd d:\JAVA\Project\NanoURL
verify-database.bat
```

This will:
- Check MySQL is installed
- Verify database exists
- Create user if needed
- Show table record counts

### Option 2: Manual Verification

**Step 1**: Connect to MySQL
```bash
mysql -h localhost -u nanourl_user -p nanourl_db
Password: NanoURL@SecurePass123
```

**Step 2**: Check if data exists
```sql
-- See all tables
SHOW TABLES;

-- Count users
SELECT COUNT(*) FROM users;

-- Count shortened URLs
SELECT COUNT(*) FROM urls;

-- Count login events
SELECT COUNT(*) FROM login_history;

-- Count URL accesses
SELECT COUNT(*) FROM url_access_log;
```

### Option 3: Using MySQL Workbench (GUI)
1. Open MySQL Workbench
2. Create connection:
   - Host: `localhost`
   - Port: `3306`
   - User: `nanourl_user`
   - Password: `NanoURL@SecurePass123`
3. Select database `nanourl_db`
4. Browse tables and data visually

## Tables and Their Data

### 1. users
```
id | email          | password_hash | name      | auth_provider | created_at
---+----------------+---------------+-----------+---------------+----------
1  | john@test.com  | $2a$10$...    | John Doe  | EMAIL         | 2026-01-05
2  | jane@test.com  | $2a$10$...    | Jane Doe  | GOOGLE        | 2026-01-05
```

### 2. urls
```
id | short_code | long_url                  | click_count | user_id | created_at
---+------------+---------------------------+-------------+---------+----------
1  | abc123     | https://google.com        | 5           | 1       | 2026-01-05
2  | def456     | https://github.com        | 12          | 1       | 2026-01-05
```

### 3. login_history
```
id | user_id | login_time          | ip_address    | user_agent     | login_method
---+---------+---------------------+---------------+----------------+-----------
1  | 1       | 2026-01-05 10:30:00 | 192.168.1.100 | Mozilla/5.0... | EMAIL
2  | 1       | 2026-01-05 11:45:00 | 192.168.1.100 | Mozilla/5.0... | EMAIL
```

### 4. url_access_log
```
id | url_id | access_time         | ip_address    | user_agent     | referer
---+--------+---------------------+---------------+----------------+---------
1  | 1      | 2026-01-05 10:31:00 | 203.0.113.45  | Mozilla/5.0... | (null)
2  | 1      | 2026-01-05 11:50:00 | 203.0.113.46  | Mozilla/5.0... | twitter.com
```

### 5. contact_messages
```
id | name      | email           | message              | created_at
---+-----------+-----------------+----------------------+----------
1  | John Doe  | john@email.com  | Great service! ...   | 2026-01-05
```

## Setup Instructions

### Step 1: Ensure MySQL is Running
```bash
# Windows
net start MySQL80

# Or open MySQL Workbench
```

### Step 2: Create Database & User (if not exists)
```bash
mysql -u root -p
```

Then run:
```sql
CREATE DATABASE IF NOT EXISTS nanourl_db;
DROP USER IF EXISTS 'nanourl_user'@'localhost';
CREATE USER 'nanourl_user'@'localhost' IDENTIFIED BY 'NanoURL@SecurePass123';
GRANT ALL PRIVILEGES ON nanourl_db.* TO 'nanourl_user'@'localhost';
FLUSH PRIVILEGES;
```

### Step 3: Start Backend (Tables Auto-Create)
```bash
cd backend
mvn spring-boot:run
```

Application will automatically create tables via Hibernate (ddl-auto: update)

### Step 4: Test by Using the App
1. Start Frontend: `npm run dev`
2. Register a user
3. Shorten a URL
4. Click the shortened URL
5. Check database - **Data should be there!**

## Useful SQL Queries

### See All Users and Their Activity
```sql
SELECT 
    u.email,
    u.name,
    COUNT(DISTINCT url.id) as urls_created,
    COUNT(DISTINCT lh.id) as login_count,
    MAX(lh.login_time) as last_login
FROM users u
LEFT JOIN urls url ON u.id = url.user_id
LEFT JOIN login_history lh ON u.id = lh.user_id
GROUP BY u.id, u.email, u.name;
```

### See Most Clicked URLs
```sql
SELECT 
    u.short_code,
    u.long_url,
    COUNT(ual.id) as click_count,
    MAX(ual.access_time) as last_click
FROM urls u
LEFT JOIN url_access_log ual ON u.id = ual.url_id
GROUP BY u.id, u.short_code, u.long_url
ORDER BY click_count DESC;
```

### See All Logins (Recent First)
```sql
SELECT 
    u.email,
    lh.login_time,
    lh.ip_address,
    lh.login_method
FROM login_history lh
JOIN users u ON lh.user_id = u.user_id
ORDER BY lh.login_time DESC
LIMIT 20;
```

### See URL Access Details
```sql
SELECT 
    u.short_code,
    u.long_url,
    ual.access_time,
    ual.ip_address,
    ual.referer
FROM url_access_log ual
JOIN urls u ON ual.url_id = u.id
ORDER BY ual.access_time DESC
LIMIT 50;
```

## Configuration Locations

### Development
- **File**: `backend/src/main/resources/application.yaml`
- **Database**: `jdbc:mysql://localhost:3306/nanourl_db`
- **User**: `nanourl_user`

### Production
- **File**: `backend/src/main/resources/application-prod.yaml`
- **Database**: Uses environment variables
- **Run with**: `java -jar app.jar --spring.profiles.active=prod`

## Environment Variables (Production)

Set these for production deployment:

```bash
# Database
export DB_URL="jdbc:mysql://prod-db-host:3306/nanourl_db"
export DB_USER="prod_user"
export DB_PASSWORD="SecurePassword123"

# JWT Secret
export JWT_SECRET="your-super-secret-key"

# App URL
export APP_BASE_URL="https://yourdomain.com"
```

## Troubleshooting

### "Access denied for user 'nanourl_user'"
```bash
# Verify user exists
mysql -u root -p -e "SELECT user FROM mysql.user;"

# Or recreate user
mysql -u root -p
# Then run the SQL commands above
```

### "Unknown database 'nanourl_db'"
```sql
CREATE DATABASE nanourl_db;
GRANT ALL PRIVILEGES ON nanourl_db.* TO 'nanourl_user'@'localhost';
FLUSH PRIVILEGES;
```

### "Cannot connect to MySQL"
1. Check MySQL service is running
2. Check host/port in application.yaml
3. Check firewall allows port 3306
4. Check credentials are correct

### "Tables don't exist"
- Application will auto-create with `ddl-auto: update`
- Check server logs for errors
- Manually run: `database/database_schema.sql`

## Verification Checklist

- [x] application.yaml configured for MySQL
- [x] application-prod.yaml configured for MySQL
- [x] MySQL driver in pom.xml
- [x] Database schema defined
- [x] User account configured
- [x] JPA/Hibernate configured
- [x] All entities have @Entity annotations
- [x] All repositories extend JpaRepository

## Summary

✅ **Your application now:**
1. Saves **all user data** to MySQL database
2. **Automatically creates tables** on first run
3. **Persists data** permanently
4. Can query data using SQL
5. Is ready for production deployment

✅ **What gets saved:**
- User accounts (email, name, password)
- Shortened URLs (short code, long URL, clicks)
- Login history (time, IP, browser, method)
- URL access logs (every click, IP, referer)
- Contact form messages

✅ **How to verify:**
1. Run `verify-database.bat`
2. Use MySQL Workbench
3. Run manual SQL queries
4. Check application logs

---

**Next Steps:**
1. Run `verify-database.bat` to setup database
2. Start backend: `mvn spring-boot:run`
3. Start frontend: `npm run dev`
4. Test the application
5. Check data in MySQL

All data is now being saved to SQL database! 🎉
