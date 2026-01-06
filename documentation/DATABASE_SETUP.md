# ⚙️ Database Setup - Production Configuration

## Security & Best Practices for Production

---

## **Part 1: Secure MySQL Installation**

### Windows Production Setup:

```bash
# 1. Install MySQL with password
mysql_install_db

# 2. Secure installation
mysql_secure_installation
```

When prompted:
- Change root password: **YES**
- Remove anonymous users: **YES**
- Disable root login remotely: **YES**
- Remove test database: **YES**
- Reload privilege tables: **YES**

### Verify Secure Installation:

```bash
# Test local root access works
mysql -u root -p

# Test remote root access fails (should error)
mysql -u root -p -h remote-server
```

---

## **Part 2: Create Production User**

### Create User with Limited Privileges:

```sql
-- Connect as root
mysql -u root -p

-- Create production user
CREATE USER 'nanourl_prod'@'localhost' IDENTIFIED WITH mysql_native_password BY 'StrongPass@2025!';

-- Create user for remote access
CREATE USER 'nanourl_prod'@'%' IDENTIFIED WITH mysql_native_password BY 'StrongPass@2025!';

-- Grant only needed privileges
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON nanourl_db.* 
TO 'nanourl_prod'@'localhost';

GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON nanourl_db.* 
TO 'nanourl_prod'@'%';

-- Do NOT grant CREATE, ALTER, DROP (unless needed)

-- Apply changes
FLUSH PRIVILEGES;

-- Verify
SELECT user, host, authentication_string FROM mysql.user WHERE user LIKE 'nanourl%';

-- Exit
EXIT;
```

### Why This Setup?

✅ **Least Privilege Principle:** User only has needed permissions  
✅ **No root access:** Reduces attack surface  
✅ **Strong password:** Prevents brute force  
✅ **Local + Remote access:** Flexibility  

---

## **Part 3: Configure MySQL for Production**

### Edit MySQL Configuration File:

**Windows:** `C:\ProgramData\MySQL\MySQL Server 8.0\my.ini`

**Mac:** `/usr/local/etc/my.cnf`

**Linux:** `/etc/mysql/my.cnf`

### Add These Settings:

```ini
[mysqld]

# Performance
max_connections = 1000
max_allowed_packet = 256M
sort_buffer_size = 1M
bulk_insert_buffer_size = 16M

# Security
bind-address = 127.0.0.1  # Only localhost
skip_name_resolve = 1      # Faster authentication
default_storage_engine = InnoDB

# Logging
log_error = /var/log/mysql/mysql-error.log
log_queries_not_using_indexes = 1
slow_query_log = 1
slow_query_log_file = /var/log/mysql/mysql-slow.log
long_query_time = 2

# Backup & Recovery
innodb_file_per_table = 1
innodb_buffer_pool_size = 1GB
innodb_log_file_size = 256MB

# Character Set
character_set_server = utf8mb4
collation_server = utf8mb4_unicode_ci
```

### Restart MySQL:

**Windows:**
```bash
net stop MySQL80
net start MySQL80
```

**Mac/Linux:**
```bash
sudo systemctl restart mysql
```

---

## **Part 4: Enable Remote Access (If Needed)**

### Allow Remote Connections:

```bash
# Edit configuration
sudo nano /etc/mysql/my.cnf

# Find or add:
# bind-address = 0.0.0.0

# Save and restart
sudo systemctl restart mysql
```

### Update Firewall:

**Windows:**
```bash
# Allow port 3306
netsh advfirewall firewall add rule name="MySQL 3306" dir=in action=allow protocol=tcp localport=3306
```

**Linux:**
```bash
# Open port 3306
sudo ufw allow 3306/tcp
```

---

## **Part 5: Backup Strategy**

### Daily Backup Script:

**Windows (backup.bat):**
```batch
@echo off
setlocal enabledelayedexpansion

set BACKUP_DIR=D:\Backups\NanoURL
set TIMESTAMP=%date:~-4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%
set TIMESTAMP=%TIMESTAMP: =0%

mkdir "%BACKUP_DIR%" 2>nul

mysql -u nanourl_prod -p"StrongPass@2025!" nanourl_db > "%BACKUP_DIR%\backup_%TIMESTAMP%.sql"

echo Backup completed: %TIMESTAMP%
```

**Linux (backup.sh):**
```bash
#!/bin/bash

BACKUP_DIR=/home/user/backups/nanourl
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

mkdir -p "$BACKUP_DIR"

mysqldump -u nanourl_prod -p"StrongPass@2025!" nanourl_db > "$BACKUP_DIR/backup_$TIMESTAMP.sql"

echo "Backup completed: $TIMESTAMP"

# Delete backups older than 30 days
find "$BACKUP_DIR" -name "backup_*.sql" -mtime +30 -delete
```

### Schedule Backups:

**Windows (Task Scheduler):**
1. Open Task Scheduler
2. Create Basic Task
3. Name: "NanoURL Daily Backup"
4. Trigger: Daily at 2:00 AM
5. Action: Start program → backup.bat

**Linux (Cron):**
```bash
# Add to crontab
0 2 * * * /home/user/backup.sh
```

---

## **Part 6: Monitor Performance**

### Check Slow Queries:

```sql
-- View slow query log
SHOW VARIABLES LIKE 'slow_query%';

-- Check which queries are slow
SELECT * FROM mysql.slow_log ORDER BY start_time DESC;

-- Clear slow log
TRUNCATE TABLE mysql.slow_log;
```

### Monitor Connections:

```sql
-- Current connections
SHOW PROCESSLIST;

-- Kill slow query
KILL <process_id>;

-- View max connections
SHOW VARIABLES LIKE 'max_connections';
```

### Check Database Size:

```sql
-- Size of entire database
SELECT 
  table_schema,
  ROUND(SUM(data_length + index_length) / 1024 / 1024) as size_mb
FROM information_schema.tables
GROUP BY table_schema;

-- Size by table
SELECT 
  table_name,
  ROUND((data_length + index_length) / 1024 / 1024) as size_mb
FROM information_schema.tables
WHERE table_schema = 'nanourl_db'
ORDER BY size_mb DESC;
```

---

## **Part 7: Regular Maintenance**

### Check Table Integrity:

```sql
-- Check all tables
CHECK TABLE users, urls, contact_messages;

-- Repair if needed
REPAIR TABLE users;
```

### Optimize Tables:

```sql
-- Optimize all tables
OPTIMIZE TABLE users;
OPTIMIZE TABLE urls;
OPTIMIZE TABLE contact_messages;
```

### Update Statistics:

```sql
-- Analyze all tables
ANALYZE TABLE users;
ANALYZE TABLE urls;
ANALYZE TABLE contact_messages;
```

---

## **Part 8: Use Environment Variables**

### Never commit passwords!

**Create `.env` file (don't commit):**
```env
DB_USER=nanourl_prod
DB_PASSWORD=StrongPass@2025!
DB_HOST=localhost
DB_PORT=3306
DB_NAME=nanourl_db
```

### In `application-prod.yaml`:

```yaml
spring:
  datasource:
    url: jdbc:mysql://${DB_HOST:localhost}:${DB_PORT:3306}/${DB_NAME:nanourl_db}
    username: ${DB_USER:nanourl_prod}
    password: ${DB_PASSWORD:NanoURL@SecurePass123}
```

### Pass via Environment:

**Java command:**
```bash
java -jar app.jar \
  --spring.datasource.username=$DB_USER \
  --spring.datasource.password=$DB_PASSWORD
```

---

## **Part 9: Security Checklist**

- ✅ Root user password changed
- ✅ Anonymous users removed
- ✅ Root remote login disabled
- ✅ Test database removed
- ✅ Production user created with limited privileges
- ✅ Strong password used (special characters, numbers)
- ✅ bind-address restricted
- ✅ Firewall configured
- ✅ SSL/TLS configured (optional)
- ✅ Regular backups enabled
- ✅ Monitoring enabled
- ✅ Passwords in environment variables only
- ✅ git ignore includes .env

---

## **Part 10: SSL/TLS Configuration (Advanced)**

### Generate SSL Certificate:

```bash
# Generate private key
openssl genrsa -out private_key.pem 2048

# Generate certificate
openssl req -new -x509 -key private_key.pem -out certificate.pem -days 365
```

### Update MySQL Config:

```ini
[mysqld]
ssl_key = /path/to/private_key.pem
ssl_cert = /path/to/certificate.pem
```

### Require SSL:

```sql
ALTER USER 'nanourl_prod'@'localhost' REQUIRE SSL;
FLUSH PRIVILEGES;
```

---

## **Part 11: Production Deployment Checklist**

Before going live:

- ✅ MySQL installed and secured
- ✅ Production user created
- ✅ Strong passwords set
- ✅ Database backed up
- ✅ SSL certificates generated
- ✅ Firewall configured
- ✅ Monitoring enabled
- ✅ Backup schedule created
- ✅ Application tested
- ✅ Disaster recovery plan documented

---

## **Command Quick Reference**

### Backup Database:
```bash
mysqldump -u nanourl_prod -p nanourl_db > backup.sql
```

### Restore Database:
```bash
mysql -u nanourl_prod -p nanourl_db < backup.sql
```

### Check User Privileges:
```sql
SHOW GRANTS FOR 'nanourl_prod'@'localhost';
```

### Monitor Queries:
```sql
SHOW PROCESSLIST;
```

### Check Database Size:
```sql
SELECT SUM(data_length + index_length) 
FROM information_schema.tables 
WHERE table_schema = 'nanourl_db';
```

---

## **Production Password Policy**

### Strong Password Requirements:
- ✅ Minimum 12 characters
- ✅ At least 1 uppercase letter
- ✅ At least 1 lowercase letter
- ✅ At least 1 number
- ✅ At least 1 special character (!@#$%^&*)
- ✅ Change every 90 days
- ✅ Never reuse last 5 passwords

### Example Strong Password:
```
StrongPass@2025!
MyDataBase#Secure123
NanoURL$Production2025
```

---

## **Disaster Recovery Plan**

### If Database Crashes:

1. Stop application
2. Check MySQL error log: `/var/log/mysql/mysql-error.log`
3. Try to restart: `sudo systemctl restart mysql`
4. If doesn't work, restore from latest backup:
   ```bash
   mysql -u nanourl_prod -p nanourl_db < latest_backup.sql
   ```
5. Restart application
6. Verify data integrity

### Regular Testing:

Test recovery monthly:
1. Create backup
2. Simulate database corruption
3. Restore from backup
4. Verify data complete

---

## **More Help**

- See quick setup: [QUICK_START.md](QUICK_START.md)
- See complete setup: [MYSQL_COMPLETE_SETUP.md](MYSQL_COMPLETE_SETUP.md)
- See how to view data: [HOW_TO_VIEW_DATA.md](HOW_TO_VIEW_DATA.md)
- See deployment: [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)
- All docs: [README.md](README.md)

---

**Your production database is secure! 🔒🚀**
