@echo off
setlocal enabledelayedexpansion
color 0A

:MENU
cls
echo.
echo ========================================
echo    🚀 NanoURL - Control Panel
echo ========================================
echo.
echo    1. Start All Servers
echo    2. Stop All Servers
echo    3. Restart All Servers
echo    4. View Server Status
echo    5. Setup MySQL Database
echo    6. Verify Database Connection
echo    7. Clean Build
echo    8. Exit
echo.
echo ========================================
echo.
set /p choice="Enter your choice (1-8): "

if "%choice%"=="1" goto START
if "%choice%"=="2" goto STOP
if "%choice%"=="3" goto RESTART
if "%choice%"=="4" goto STATUS
if "%choice%"=="5" goto SETUP_MYSQL
if "%choice%"=="6" goto VERIFY_DB
if "%choice%"=="7" goto CLEAN
if "%choice%"=="8" goto END
echo Invalid choice! Please try again.
timeout /t 2 /nobreak >nul
goto MENU

:START
cls
echo.
echo ========================================
echo    🚀 Starting NanoURL Application
echo ========================================
echo.

REM Get the directory where this script is located
set SCRIPT_DIR=%~dp0
cd /d "%SCRIPT_DIR%"

REM Check if backend mvnw exists
if not exist "Backend\mvnw.cmd" (
    echo ❌ Error: Backend\mvnw.cmd not found
    echo Please run this script from the project root directory
    pause
    goto MENU
)

echo [1/2] Starting Backend Server...
echo.
start "NanoURL Backend" cmd /k "cd /d "%SCRIPT_DIR%Backend" && mvnw.cmd spring-boot:run"
echo [INFO] Backend started in new window. Waiting 10 seconds for initialization...
timeout /t 10 /nobreak

echo.
echo [2/2] Starting Frontend Server...
echo.
if not exist "Frontend\node_modules" (
    echo Installing frontend dependencies...
    cd /d "%SCRIPT_DIR%Frontend"
    call npm install
)

cd /d "%SCRIPT_DIR%"
start "NanoURL Frontend" cmd /k "cd /d "%SCRIPT_DIR%Frontend" && npm run dev"

echo.
echo ========================================
echo ✅ Both Servers Started!
echo ========================================
echo.
echo 🌐 Frontend:    http://localhost:5173
echo 🔧 Backend:     http://localhost:8080
echo 📊 H2 Console:  http://localhost:8080/h2-console
echo.
echo Press any key to return to menu...
pause >nul
goto MENU

:STOP
cls
echo.
echo ========================================
echo    🛑 Stopping All Servers
echo ========================================
echo.

echo Stopping Backend...
taskkill /F /IM java.exe 2>nul
if %errorlevel%==0 (
    echo ✅ Backend stopped
) else (
    echo ℹ️  Backend was not running
)

echo.
echo Stopping Frontend...
taskkill /F /IM node.exe 2>nul
if %errorlevel%==0 (
    echo ✅ Frontend stopped
) else (
    echo ℹ️  Frontend was not running
)

echo.
echo ========================================
echo ✅ All Servers Stopped!
echo ========================================
echo.
pause >nul
goto MENU

:RESTART
cls
echo.
echo ========================================
echo    🔄 Restarting All Servers
echo ========================================
echo.
call :STOP_QUIET
timeout /t 3 /nobreak >nul
goto START

:STOP_QUIET
taskkill /F /IM java.exe 2>nul
taskkill /F /IM node.exe 2>nul
exit /b 0

:STATUS
cls
echo.
echo ========================================
echo    📊 Server Status
echo ========================================
echo.

echo Checking Backend (Port 8080)...
netstat -ano 2>nul | findstr ":8080" >nul
if %errorlevel%==0 (
    echo ✅ Backend is RUNNING on port 8080
) else (
    echo ❌ Backend is NOT running
)

echo.
echo Checking Frontend (Port 5173)...
netstat -ano 2>nul | findstr ":5173" >nul
if %errorlevel%==0 (
    echo ✅ Frontend is RUNNING on port 5173
) else (
    echo ❌ Frontend is NOT running
)

echo.
echo Checking Database...
if exist "Backend\Database\nanourl.mv.db" (
    echo ✅ Database exists: Backend\Database\nanourl.mv.db
) else (
    echo ℹ️  Database will be created on first backend run
)

echo.
echo ========================================
echo.
pause >nul
goto MENU

:CLEAN
cls
echo.
echo ========================================
echo    🧹 Clean Build
echo ========================================
echo.

echo [1/2] Cleaning Backend...
cd /d "%~dp0Backend"
call mvnw.cmd clean -q
echo ✅ Backend cleaned

echo.
echo [2/2] Cleaning Frontend...
cd /d "%~dp0Frontend"
if exist "node_modules" (
    rmdir /s /q node_modules >nul 2>&1
)
if exist "package-lock.json" (
    del package-lock.json >nul 2>&1
)
echo Installing fresh dependencies...
call npm install -q >nul 2>&1
echo ✅ Frontend cleaned

cd /d "%~dp0"
echo.
echo ========================================
echo ✅ Clean Complete!
echo ========================================
echo.
pause >nul
goto MENU

:SETUP_MYSQL
cls
echo.
echo ========================================
echo    🗄️  MySQL Database Setup
echo ========================================
echo.
echo [INFO] This will setup the MySQL database for NanoURL
echo.

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
    goto MENU
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
    goto MENU
)

echo [OK] Connection verified
echo.

REM Show tables
echo [INFO] Creating tables...
mysql -u nanourl_user -pNanoURL@SecurePass123 nanourl_db < "%~dp0Database\database_schema.sql" 2>nul

if %errorlevel% neq 0 (
    echo [WARNING] Could not auto-run schema. Application will create tables on startup.
) else (
    echo [OK] Tables created from schema
)

echo.
echo ======================================
echo [SUCCESS] MySQL Setup Complete!
echo ======================================
echo.
echo Database: nanourl_db
echo User: nanourl_user
echo Password: NanoURL@SecurePass123
echo.
echo Next steps:
echo 1. Start all servers using menu option 1
echo 2. Tables will be created automatically if not present
echo 3. Test at http://localhost:5173
echo.
pause >nul
goto MENU

:VERIFY_DB
cls
echo.
echo ========================================
echo    📋 Database Verification
echo ========================================
echo.

REM Check if MySQL is installed
mysql --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] MySQL is not installed or not in PATH
    echo Please install MySQL and add it to PATH environment variable
    echo.
    pause
    goto MENU
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
    goto MENU
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
        goto MENU
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
echo 1. Start all servers using menu option 1
echo 2. Test the application at http://localhost:5173
echo.
pause >nul
goto MENU

:END
cls
echo.
echo Stopping all servers...
taskkill /F /IM java.exe 2>nul
taskkill /F /IM node.exe 2>nul
echo.
echo Thank you for using NanoURL!
echo.
endlocal
exit /b 0
