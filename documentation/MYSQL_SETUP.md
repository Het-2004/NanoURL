# 🔧 MySQL Configuration Reference

## Quick Configuration Guide

---

## **Connection String**

### Local Development:
```
jdbc:mysql://localhost:3306/nanourl_db?useSSL=false&serverTimezone=UTC
```

### Remote Server:
```
jdbc:mysql://192.168.1.100:3306/nanourl_db?useSSL=true&serverTimezone=UTC
```

### Docker Container:
```
jdbc:mysql://mysql-container:3306/nanourl_db?useSSL=false&serverTimezone=UTC
```

---

## **Application Configuration**

### application.yaml (Development):

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
        format_sql: true
        use_sql_comments: true

server:
  port: 8080

app:
  base-url: http://localhost:8080
```

### application-prod.yaml (Production):

```yaml
spring:
  datasource:
    url: ${DB_URL:jdbc:mysql://localhost:3306/nanourl_db}
    username: ${DB_USER:nanourl_prod}
    password: ${DB_PASSWORD}
    driver-class-name: com.mysql.cj.jdbc.Driver
    hikari:
      maximum-pool-size: 20
      minimum-idle: 5
      connection-timeout: 20000
      idle-timeout: 300000
      max-lifetime: 1200000
  
  jpa:
    hibernate:
      ddl-auto: validate
    properties:
      hibernate:
        dialect: org.hibernate.dialect.MySQLDialect
        generate_statistics: false

server:
  port: ${PORT:8080}

app:
  base-url: ${APP_BASE_URL}
```

---

## **Maven Dependency**

### pom.xml:

```xml
<!-- MySQL Connector -->
<dependency>
    <groupId>com.mysql</groupId>
    <artifactId>mysql-connector-j</artifactId>
    <version>8.0.33</version>
</dependency>

<!-- JPA/Hibernate -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>
```

---

## **Environment Variables**

### For Development:

No need - uses defaults in application.yaml

### For Production:

```bash
# Database
export DB_URL="jdbc:mysql://prod-server:3306/nanourl_db"
export DB_USER="nanourl_prod"
export DB_PASSWORD="SecurePassword123!"

# Application
export APP_BASE_URL="https://nanourl.example.com"
export PORT="8080"

# Security
export JWT_SECRET="your-jwt-secret-key"
```

### Docker Environment:

```dockerfile
ENV DB_URL=jdbc:mysql://mysql:3306/nanourl_db
ENV DB_USER=nanourl_prod
ENV DB_PASSWORD=SecurePassword123!
ENV APP_BASE_URL=https://nanourl.onrender.com
```

---

## **Connection Pool Settings**

### Default (HikariCP):

```yaml
spring:
  datasource:
    hikari:
      maximum-pool-size: 10        # Max connections
      minimum-idle: 2              # Min idle connections
      connection-timeout: 20000    # 20 seconds
      idle-timeout: 300000         # 5 minutes
      max-lifetime: 1200000        # 20 minutes
      auto-commit: true
```

### For High Traffic:

```yaml
spring:
  datasource:
    hikari:
      maximum-pool-size: 50
      minimum-idle: 10
      connection-timeout: 30000
      idle-timeout: 600000
      max-lifetime: 1800000
```

### For Low Traffic:

```yaml
spring:
  datasource:
    hikari:
      maximum-pool-size: 5
      minimum-idle: 1
      connection-timeout: 15000
      idle-timeout: 180000
      max-lifetime: 600000
```

---

## **Hibernate Properties**

### For Development:

```yaml
jpa:
  hibernate:
    ddl-auto: update              # Auto-update schema
  properties:
    hibernate:
      format_sql: true            # Pretty print SQL
      use_sql_comments: true       # Add comments to SQL
      generate_statistics: true    # Track statistics
      dialect: org.hibernate.dialect.MySQLDialect
```

### For Production:

```yaml
jpa:
  hibernate:
    ddl-auto: validate            # Only validate schema
  properties:
    hibernate:
      format_sql: false           # Don't format SQL
      use_sql_comments: false      # No SQL comments
      generate_statistics: false   # Don't track stats
      dialect: org.hibernate.dialect.MySQLDialect
```

---

## **Character Encoding**

### MySQL Character Set:

```sql
-- Create database with correct encoding
CREATE DATABASE nanourl_db 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;
```

### JDBC Connection String:

```
jdbc:mysql://localhost:3306/nanourl_db?characterEncoding=utf8mb4&useUnicode=true
```

### Hibernate Configuration:

```yaml
jpa:
  properties:
    hibernate:
      jdbc:
        batch_size: 20
        fetch_size: 50
      connection:
        CharSet: utf8mb4
```

---

## **Connection Verification**

### Test Connection:

```bash
# Command line
mysql -u nanourl_user -p -h localhost nanourl_db

# Check tables
mysql> SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'nanourl_db';

# Check data
mysql> SELECT * FROM users LIMIT 1;
```

### In Application:

```java
@Component
public class DataSourceValidator {
    @PostConstruct
    public void validate() {
        try (Connection conn = dataSource.getConnection()) {
            System.out.println("Database connection successful!");
        } catch (SQLException e) {
            System.err.println("Database connection failed!");
            e.printStackTrace();
        }
    }
}
```

---

## **Port Mapping**

### Default MySQL Port:
```
3306
```

### Change MySQL Port:

**my.cnf or my.ini:**
```ini
[mysqld]
port = 3307
```

### Update Connection String:
```
jdbc:mysql://localhost:3307/nanourl_db
```

---

## **SSL/TLS Configuration**

### Enable SSL:

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/nanourl_db?useSSL=true&serverSslCertificate=/path/to/cert.pem
    username: nanourl_user
    password: nanourl_password
```

### Require SSL:

```sql
ALTER USER 'nanourl_user'@'localhost' REQUIRE SSL;
FLUSH PRIVILEGES;
```

---

## **Timezone Configuration**

### Set Timezone in Connection:

```
jdbc:mysql://localhost:3306/nanourl_db?serverTimezone=UTC
```

### Common Timezones:

```
UTC                 - Coordinated Universal Time
America/New_York    - Eastern Time
America/Chicago     - Central Time
America/Denver      - Mountain Time
America/Los_Angeles - Pacific Time
Europe/London       - GMT
Europe/Paris        - CET
Asia/Tokyo          - JST
Australia/Sydney    - AEDT
```

### In Application:

```yaml
spring:
  jpa:
    properties:
      hibernate:
        jdbc:
          time_zone: UTC
```

---

## **Common Issues & Solutions**

### Issue: "Unknown database 'nanourl_db'"
**Solution:** Create database first
```sql
CREATE DATABASE nanourl_db CHARACTER SET utf8mb4;
```

### Issue: "Access denied for user"
**Solution:** Check credentials and permissions
```sql
-- Check user exists
SELECT * FROM mysql.user WHERE user = 'nanourl_user';

-- Check grants
SHOW GRANTS FOR 'nanourl_user'@'localhost';
```

### Issue: "Connection refused"
**Solution:** Verify MySQL is running
```bash
mysql -u root -p
STATUS;
EXIT;
```

### Issue: "MySQL server has gone away"
**Solution:** Add connection pooling settings
```yaml
datasource:
  hikari:
    connection-timeout: 20000
    idle-timeout: 300000
```

### Issue: "Character encoding error"
**Solution:** Use UTF8MB4
```
jdbc:mysql://localhost/nanourl_db?characterEncoding=utf8mb4
```

---

## **Quick Setup Commands**

### Create Database:
```bash
mysql -u root -p < database/database_schema.sql
```

### Verify Setup:
```bash
mysql -u nanourl_user -p nanourl_db
SELECT * FROM users;
EXIT;
```

### Change User Password:
```sql
ALTER USER 'nanourl_user'@'localhost' IDENTIFIED BY 'NewPassword123!';
FLUSH PRIVILEGES;
```

### Grant User Privileges:
```sql
GRANT ALL PRIVILEGES ON nanourl_db.* TO 'nanourl_user'@'localhost';
FLUSH PRIVILEGES;
```

---

## **Performance Tuning**

### Connection Pool Size:
```
Small app (< 100 users):   5-10 connections
Medium app (100-1000):      15-25 connections
Large app (> 1000):         50+ connections
```

### Query Optimization:
```yaml
jpa:
  properties:
    hibernate:
      jdbc:
        batch_size: 20           # Batch insert size
      order_inserts: true        # Order inserts for batch
      order_updates: true        # Order updates for batch
```

---

## **Backup Configuration**

### Automatic Backup:

```sql
-- View backup variables
SHOW VARIABLES LIKE 'bin%';

-- Enable binary logging
SET GLOBAL binlog_format = 'ROW';
```

---

## **More Information**

- Quick setup: [QUICK_START.md](QUICK_START.md)
- Complete setup: [MYSQL_COMPLETE_SETUP.md](MYSQL_COMPLETE_SETUP.md)
- Database security: [DATABASE_SETUP.md](DATABASE_SETUP.md)
- Deployment: [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)
- All docs: [README.md](README.md)

---

**Configuration is ready! 🚀**
