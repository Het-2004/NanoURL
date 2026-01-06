@echo off
REM MySQL Setup Script for NanoURL
REM Run with administrator privileges

echo.
echo ======================================
echo NanoURL MySQL Setup
echo ======================================
echo.

setlocal enabledelayedexpansion

REM Ask for root password
echo Please enter your MySQL root password:
set /p MYSQL_ROOT_PASSWORD="Password: "

echo.
echo [INFO] Attempting to create database and user...
echo.

REM Create database and user
mysql -u root -p%MYSQL_ROOT_PASSWORD% -e "CREATE DATABASE IF NOT EXISTS nanourl_db;" 2>nul

if %errorlevel% neq 0 (
    echo [ERROR] Failed to connect to MySQL with provided password
    echo Troubleshooting:
    echo 1. Make sure MySQL Server is running
    echo 2. Verify root password is correct
    echo 3. Try opening MySQL Workbench to confirm connection
    pause
    exit /b 1
)

echo [OK] Database created/verified
echo.

REM Create user
mysql -u root -p%MYSQL_ROOT_PASSWORD% -e "DROP USER IF EXISTS 'nanourl_user'@'localhost';" 2>nul
mysql -u root -p%MYSQL_ROOT_PASSWORD% -e "CREATE USER 'nanourl_user'@'localhost' IDENTIFIED BY 'NanoURL@SecurePass123';" 2>nul
mysql -u root -p%MYSQL_ROOT_PASSWORD% -e "GRANT ALL PRIVILEGES ON nanourl_db.* TO 'nanourl_user'@'localhost';" 2>nul
mysql -u root -p%MYSQL_ROOT_PASSWORD% -e "FLUSH PRIVILEGES;" 2>nul

echo [OK] User created with credentials:
echo     Username: nanourl_user
echo     Password: NanoURL@SecurePass123
echo.

REM Verify connection
echo [TEST] Verifying nanourl_user can connect...
mysql -u nanourl_user -pNanoURL@SecurePass123 nanourl_db -e "SELECT 1;" >nul 2>&1

if %errorlevel% neq 0 (
    echo [ERROR] Failed to verify user connection
    pause
    exit /b 1
)

echo [OK] Connection verified
echo.

REM Show tables
echo [INFO] Creating tables...
mysql -u nanourl_user -pNanoURL@SecurePass123 nanourl_db < "%~dp0database\database_schema.sql" 2>nul

if %errorlevel% neq 0 (
    echo [WARNING] Could not auto-run schema. Application will create tables on startup.
) else (
    echo [OK] Tables created from schema
)

echo.
echo ======================================
echo [SUCCESS] Setup Complete!
echo ======================================
echo.
echo Database: nanourl_db
echo User: nanourl_user
echo Password: NanoURL@SecurePass123
echo.
echo Next steps:
echo 1. Start backend: cd backend && mvn spring-boot:run
echo 2. Tables will be created automatically if not present
echo 3. Start frontend: cd frontend\nanourl-frontend && npm run dev
echo 4. Test at http://localhost:5173
echo.
pause
