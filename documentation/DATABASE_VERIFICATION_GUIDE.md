# Database Verification & Setup Guide

## Current Status

Your NanoURL application now uses **MySQL** for persistent data storage. All user signups, shortened URLs, login history, and URL access logs are saved in the database.

## What Gets Saved in Database?

### 1. **Users Table** (`users`)
```sql
SELECT * FROM users;
```
Stores:
- User ID, Email, Password Hash
- Name, Contact Number
- Auth Provider (EMAIL, GOOGLE, GITHUB)
- Created/Updated timestamps

### 2. **URLs Table** (`urls`)
```sql
SELECT * FROM urls;
```
Stores:
- URL ID, Short Code, Long URL
- Click Count
- User ID (who created it)
- Created timestamp

### 3. **Login History** (`login_history`)
```sql
SELECT * FROM login_history;
```
Stores:
- Login ID, User ID
- Login Time, IP Address
- User Agent (browser info)
- Login Method (EMAIL, GOOGLE, GITHUB)

### 4. **URL Access Log** (`url_access_log`)
```sql
SELECT * FROM url_access_log;
```
Stores:
- Access Log ID, URL ID
- Access Time, IP Address
- User Agent, Referer
- Every time someone clicks a shortened URL

### 5. **Contact Messages** (`contact_messages`)
```sql
SELECT * FROM contact_messages;
```
Stores:
- Message ID, Name, Email
- Message Content
- Created timestamp

## Setup Instructions

### Step 1: Install MySQL
Make sure MySQL server is installed and running on your machine.

### Step 2: Create Database & User
Run these commands in MySQL:

```sql
-- Create database
CREATE DATABASE IF NOT EXISTS nanourl_db;
USE nanourl_db;

-- Create user
DROP USER IF EXISTS 'nanourl_user'@'localhost';
CREATE USER 'nanourl_user'@'localhost' IDENTIFIED BY 'NanoURL@SecurePass123';

-- Grant permissions
GRANT ALL PRIVILEGES ON nanourl_db.* TO 'nanourl_user'@'localhost';
FLUSH PRIVILEGES;
```

### Step 3: Run the Schema Script
Execute the database schema:

```bash
mysql -u nanourl_user -p nanourl_db < database/database_schema.sql
```

Password: `NanoURL@SecurePass123`

### Step 4: Start the Backend
```bash
cd backend
mvn spring-boot:run
```

The application will:
- Connect to MySQL
- Create/update tables automatically
- Start accepting requests on `http://localhost:8080`

### Step 5: Test Data Flow

#### A. Register a User
```bash
curl -X POST http://localhost:8080/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "Test@123",
    "name": "Test User",
    "contactNumber": "9876543210"
  }'
```

#### B. Shorten a URL
```bash
curl -X POST http://localhost:8080/api/shorten \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "url": "https://www.google.com"
  }'
```

#### C. Access the Shortened URL
```bash
curl -L http://localhost:8080/abc123
```

#### D. Generate QR Code
```bash
curl -X POST http://localhost:8080/api/qr/generate/dataurl \
  -H "Content-Type: application/json" \
  -d '{"text": "http://localhost:8080/abc123"}'
```

## Verify Data in Database

### Method 1: MySQL Command Line

```bash
# Connect to database
mysql -u nanourl_user -p nanourl_db

# View all users
SELECT * FROM users;

# View all shortened URLs
SELECT * FROM urls;

# View login history
SELECT * FROM login_history;

# View URL access logs
SELECT * FROM url_access_log;

# Count records
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM urls;
SELECT COUNT(*) FROM login_history;
SELECT COUNT(*) FROM url_access_log;
```

### Method 2: MySQL Workbench
1. Open MySQL Workbench
2. Connect to localhost:3306
3. User: `nanourl_user`
4. Password: `NanoURL@SecurePass123`
5. Select database `nanourl_db`
6. Browse tables in left panel

### Method 3: DBeaver (Free Tool)
1. Download DBeaver
2. Create new connection → MySQL
3. Host: localhost
4. Port: 3306
5. User: nanourl_user
6. Password: NanoURL@SecurePass123
7. Database: nanourl_db

## Configuration Details

**File**: `backend/src/main/resources/application.yaml`

```yaml
datasource:
  url: jdbc:mysql://localhost:3306/nanourl_db
  username: nanourl_user
  password: NanoURL@SecurePass123
  driver-class-name: com.mysql.cj.jdbc.Driver

jpa:
  hibernate:
    ddl-auto: update  # Auto-creates/updates tables
```

## Useful Queries

### See All User Activity
```sql
SELECT 
    u.email,
    u.name,
    COUNT(url.id) as urls_created,
    COUNT(lh.id) as login_count,
    MAX(lh.login_time) as last_login
FROM users u
LEFT JOIN urls url ON u.id = url.user_id
LEFT JOIN login_history lh ON u.id = lh.user_id
GROUP BY u.id, u.email, u.name;
```

### See Most Popular URLs
```sql
SELECT 
    u.short_code,
    u.long_url,
    COUNT(ual.id) as click_count,
    MAX(ual.access_time) as last_accessed
FROM urls u
LEFT JOIN url_access_log ual ON u.id = ual.url_id
GROUP BY u.id, u.short_code, u.long_url
ORDER BY click_count DESC;
```

### See Login Attempts
```sql
SELECT 
    u.email,
    lh.login_time,
    lh.ip_address,
    lh.login_method
FROM login_history lh
JOIN users u ON lh.user_id = u.id
ORDER BY lh.login_time DESC
LIMIT 20;
```

## Troubleshooting

### Issue: "Access denied for user 'nanourl_user'@'localhost'"
**Solution**: 
1. Check MySQL credentials in application.yaml
2. Verify user exists in MySQL
3. Verify password matches

### Issue: "Unknown database 'nanourl_db'"
**Solution**:
1. Run: `CREATE DATABASE nanourl_db;`
2. Verify database exists: `SHOW DATABASES;`
3. Restart application

### Issue: "No data appears in database"
**Solution**:
1. Check application is running: `curl http://localhost:8080/api/auth/verify`
2. Check logs for errors
3. Verify MySQL connection is active
4. Test with simple curl request and verify response

### Issue: "Cannot connect to MySQL"
**Solution**:
1. Verify MySQL is running: `mysql -u root -p`
2. Check firewall settings
3. Verify host/port in application.yaml
4. Check MySQL logs for errors

## Data Flow Diagram

```
User Action          →  API Endpoint       →  Database Operation
                                           
Register            →  /api/auth/signup   →  INSERT INTO users
Login               →  /api/auth/signin   →  INSERT INTO login_history
Shorten URL         →  /api/shorten       →  INSERT INTO urls
Click Short URL     →  /{shortCode}       →  INSERT INTO url_access_log
Generate QR         →  /api/qr/generate   →  (No DB save, uses URL)
View History        →  /api/urls          →  SELECT FROM urls
View Analytics      →  /api/analytics     →  SELECT FROM login_history/url_access_log
```

## Important Notes

1. **Automatic Table Creation**: With `ddl-auto: update`, tables are created automatically
2. **Data Persistence**: All data is saved in MySQL database files
3. **Transaction Safe**: All operations use Spring Data JPA transactions
4. **Indexed**: Common queries are indexed for performance
5. **Cascading**: User deletion cascades to related records

## Next Steps

1. ✅ Update application.yaml to use MySQL
2. ✅ Create database and user in MySQL
3. ✅ Start the backend application
4. ✅ Test with sample requests
5. ✅ Verify data in database
6. ✅ Monitor logs for any errors

## Support

For more information:
- See `BACKEND_GUIDE.md` for backend setup
- See `DATABASE_SETUP.md` for database configuration
- See `QUICK_START.md` for quick reference
- Check logs: `backend/target/spring.log`

---

**Status**: ✅ Database is now properly configured to save all data to MySQL
