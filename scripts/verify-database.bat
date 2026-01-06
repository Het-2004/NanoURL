@echo off
REM NanoURL Database Verification Script
REM This script helps verify MySQL connection and database setup

echo.
echo ======================================
echo NanoURL Database Verification
echo ======================================
echo.

REM Check if MySQL is installed
mysql --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] MySQL is not installed or not in PATH
    echo Please install MySQL and add it to PATH environment variable
    echo.
    pause
    exit /b 1
)

echo [OK] MySQL found
mysql --version
echo.

REM Check MySQL connection
echo [TEST] Attempting to connect to MySQL...
mysql -h localhost -u root -e "SELECT 1" >nul 2>&1

if %errorlevel% neq 0 (
    echo [ERROR] Cannot connect to MySQL with root user
    echo Troubleshooting:
    echo 1. Check if MySQL service is running
    echo 2. Verify localhost is accessible
    echo 3. Check root password
    echo.
    pause
    exit /b 1
)

echo [OK] Connected to MySQL
echo.

REM Check if database exists
echo [TEST] Checking if nanourl_db database exists...
mysql -h localhost -u root -e "USE nanourl_db; SHOW TABLES;" >nul 2>&1

if %errorlevel% neq 0 (
    echo [WARNING] Database nanourl_db not found
    echo Creating database and user...
    echo.
    
    mysql -h localhost -u root -e "CREATE DATABASE IF NOT EXISTS nanourl_db;"
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to create database
        pause
        exit /b 1
    )
    
    mysql -h localhost -u root -e "DROP USER IF EXISTS 'nanourl_user'@'localhost';"
    mysql -h localhost -u root -e "CREATE USER 'nanourl_user'@'localhost' IDENTIFIED BY 'NanoURL@SecurePass123';"
    mysql -h localhost -u root -e "GRANT ALL PRIVILEGES ON nanourl_db.* TO 'nanourl_user'@'localhost';"
    mysql -h localhost -u root -e "FLUSH PRIVILEGES;"
    
    echo [OK] Database and user created
    echo.
) else (
    echo [OK] Database nanourl_db exists
    echo.
)

REM Verify nanourl_user can connect
echo [TEST] Verifying nanourl_user account...
mysql -h localhost -u nanourl_user -pNanoURL@SecurePass123 -e "USE nanourl_db; SHOW TABLES;" >nul 2>&1

if %errorlevel% neq 0 (
    echo [ERROR] Cannot connect as nanourl_user
    echo Recreating user account...
    echo.
    
    mysql -h localhost -u root -e "DROP USER IF EXISTS 'nanourl_user'@'localhost';"
    mysql -h localhost -u root -e "CREATE USER 'nanourl_user'@'localhost' IDENTIFIED BY 'NanoURL@SecurePass123';"
    mysql -h localhost -u root -e "GRANT ALL PRIVILEGES ON nanourl_db.* TO 'nanourl_user'@'localhost';"
    mysql -h localhost -u root -e "FLUSH PRIVILEGES;"
    
    echo [OK] User account recreated
    echo.
) else (
    echo [OK] nanourl_user can connect
    echo.
)

REM Show tables
echo [INFO] Tables in nanourl_db:
echo.
mysql -h localhost -u nanourl_user -pNanoURL@SecurePass123 nanourl_db -e "SHOW TABLES;"
echo.

REM Show table row counts
echo [INFO] Data in each table:
echo.
mysql -h localhost -u nanourl_user -pNanoURL@SecurePass123 nanourl_db -e "SELECT 'users' as table_name, COUNT(*) as record_count FROM users UNION SELECT 'urls', COUNT(*) FROM urls UNION SELECT 'login_history', COUNT(*) FROM login_history UNION SELECT 'url_access_log', COUNT(*) FROM url_access_log UNION SELECT 'contact_messages', COUNT(*) FROM contact_messages;"
echo.

echo ======================================
echo [SUCCESS] Database verification complete!
echo ======================================
echo.
echo Next steps:
echo 1. Start the backend: cd backend && mvn spring-boot:run
echo 2. Start the frontend: cd frontend/nanourl-frontend && npm run dev
echo 3. Test the application: http://localhost:5173
echo.
pause
