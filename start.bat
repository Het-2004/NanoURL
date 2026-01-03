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
echo    5. Clean Build (Fix Errors)
echo    6. Exit
echo.
echo ========================================
echo.
set /p choice="Enter your choice (1-6): "

if "%choice%"=="1" goto START
if "%choice%"=="2" goto STOP
if "%choice%"=="3" goto RESTART
if "%choice%"=="4" goto STATUS
if "%choice%"=="5" goto CLEAN
if "%choice%"=="6" goto END
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
if not exist "backend\mvnw.cmd" (
    echo ❌ Error: backend\mvnw.cmd not found
    echo Please run this script from the project root directory
    pause
    goto MENU
)

echo [1/3] Starting Backend Server...
echo.
start "NanoURL Backend" cmd /k "cd /d "%SCRIPT_DIR%backend" && echo Starting Spring Boot Backend... && mvnw.cmd spring-boot:run"

echo [2/3] Waiting for backend to initialize...
timeout /t 10 /nobreak

echo.
echo [3/3] Starting Frontend Server...
echo.
if not exist "frontend\nanourl-frontend\node_modules" (
    echo Installing frontend dependencies first...
    cd /d "%SCRIPT_DIR%frontend\nanourl-frontend"
    call npm install
)

cd /d "%SCRIPT_DIR%"
start "NanoURL Frontend" cmd /k "cd /d "%SCRIPT_DIR%frontend\nanourl-frontend" && echo Starting React Frontend... && npm run dev"

echo.
echo ========================================
echo ✅ Both Servers Started Successfully!
echo ========================================
echo.
echo 🌐 Frontend:    http://localhost:5173
echo 🔧 Backend:     http://localhost:8080
echo 📊 H2 Console:  http://localhost:8080/h2-console
echo 📁 Database:    backend\Database\nanourl.mv.db
echo.
echo ℹ️  To stop servers: Choose option 2 from menu
echo ℹ️  Press any key to return to menu...
echo ========================================
pause >nul
goto MENU

:STOP
cls
echo.
echo ========================================
echo    🛑 Stopping All Servers
echo ========================================
echo.

echo [1/2] Stopping Backend (Java)...
taskkill /F /IM java.exe 2>nul
if %errorlevel%==0 (
    echo ✅ Backend stopped successfully
) else (
    echo ℹ️  Backend was not running
)

echo.
echo [2/2] Stopping Frontend (Node)...
taskkill /F /IM node.exe 2>nul
if %errorlevel%==0 (
    echo ✅ Frontend stopped successfully
) else (
    echo ℹ️  Frontend was not running
)

echo.
echo ========================================
echo ✅ All Servers Stopped!
echo ========================================
echo.
echo Press any key to return to menu...
pause >nul
goto MENU

:RESTART
cls
echo.
echo ========================================
echo    🔄 Restarting All Servers
echo ========================================
echo.
call :STOP
timeout /t 3 /nobreak >nul
call :START
goto MENU

:STATUS
cls
echo.
echo ========================================
echo    📊 Server Status
echo ========================================
echo.

echo Checking Backend (Port 8080)...
netstat -ano | findstr :8080 >nul
if %errorlevel%==0 (
    echo ✅ Backend is RUNNING on port 8080
) else (
    echo ❌ Backend is NOT running
)

echo.
echo Checking Frontend (Port 5173)...
netstat -ano | findstr :5173 >nul
if %errorlevel%==0 (
    echo ✅ Frontend is RUNNING on port 5173
) else (
    echo ❌ Frontend is NOT running
)

echo.
echo Checking Database...
if exist "backend\Database\nanourl.mv.db" (
    echo ✅ Database file exists: backend\Database\nanourl.mv.db
) else (
    echo ℹ️  Database will be created on first run in backend\Database\
)

echo.
echo ========================================
echo Press any key to return to menu...
pause >nul
goto MENU

:CLEAN
cls
echo.
echo ========================================
echo    🧹 Clean Build (Fix Errors)
echo ========================================
echo.

echo [1/2] Cleaning Backend...
cd /d "%~dp0backend"
call mvnw.cmd clean
echo ✅ Backend cleaned

echo.
echo [2/2] Cleaning Frontend...
cd /d "%~dp0frontend\nanourl-frontend"
if exist "node_modules" (
    echo Removing node_modules...
    rmdir /s /q node_modules
)
if exist "package-lock.json" (
    del package-lock.json
)
echo Installing fresh dependencies...
call npm install
echo ✅ Frontend cleaned and reinstalled

cd /d "%~dp0"
echo.
echo ========================================
echo ✅ Clean Build Complete!
echo ========================================
echo.
echo Press any key to return to menu...
pause >nul
goto MENU

:END
cls
echo.
echo ========================================
echo    👋 Thank you for using NanoURL!
echo ========================================
echo.
echo Stopping all servers before exit...
echo.
taskkill /F /IM java.exe 2>nul
taskkill /F /IM node.exe 2>nul
echo.
echo ✅ All servers stopped
echo ✅ Database saved in: backend\Database\
echo.
echo Goodbye! 🚀
timeout /t 2 /nobreak >nul
exit
