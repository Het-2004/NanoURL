# NanoURL MySQL Setup Script (PowerShell)
# Run with administrator privileges

Write-Host "`n======================================" -ForegroundColor Cyan
Write-Host "NanoURL MySQL Setup" -ForegroundColor Cyan
Write-Host "======================================`n" -ForegroundColor Cyan

# Check if MySQL is in PATH
$mysqlPath = Get-Command mysql -ErrorAction SilentlyContinue
if (-not $mysqlPath) {
    Write-Host "[ERROR] MySQL not found in PATH" -ForegroundColor Red
    Write-Host "Please add MySQL to PATH first:`n" -ForegroundColor Yellow
    Write-Host "`$env:Path += ';C:\Program Files\MySQL\MySQL Server 8.0\bin'" -ForegroundColor Gray
    Write-Host "[Environment]::SetEnvironmentVariable('Path', `$env:Path, 'User')`n" -ForegroundColor Gray
    exit 1
}

Write-Host "[OK] MySQL found: " -NoNewline -ForegroundColor Green
Write-Host "$($mysqlPath.Source)`n" -ForegroundColor Gray

# Ask for root password
$credential = Read-Host "Enter MySQL root password (or press Enter if no password)"

# Prepare password parameter
$passwordParam = if ($credential) { "-p$credential" } else { "" }

# Test connection
Write-Host "[TEST] Testing MySQL connection..." -ForegroundColor Yellow
$testCmd = "mysql -u root $passwordParam -e `"SELECT 1;`" 2>&1"

try {
    $result = Invoke-Expression $testCmd -ErrorAction Stop
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] MySQL connection successful`n" -ForegroundColor Green
    } else {
        Write-Host "[ERROR] Cannot connect to MySQL" -ForegroundColor Red
        Write-Host "Verify:" -ForegroundColor Yellow
        Write-Host "  1. MySQL Server is running" -ForegroundColor Gray
        Write-Host "  2. Root password is correct" -ForegroundColor Gray
        Write-Host "  3. No special characters in password" -ForegroundColor Gray
        exit 1
    }
} catch {
    Write-Host "[ERROR] Connection failed: $_" -ForegroundColor Red
    exit 1
}

# Create database
Write-Host "[INFO] Creating database..." -ForegroundColor Yellow
$dbCmd = "mysql -u root $passwordParam -e `"CREATE DATABASE IF NOT EXISTS nanourl_db;`""
Invoke-Expression $dbCmd | Out-Null

if ($LASTEXITCODE -eq 0) {
    Write-Host "[OK] Database created/verified`n" -ForegroundColor Green
} else {
    Write-Host "[ERROR] Failed to create database`n" -ForegroundColor Red
    exit 1
}

# Create user
Write-Host "[INFO] Setting up database user..." -ForegroundColor Yellow
$dropUserCmd = "mysql -u root $passwordParam -e `"DROP USER IF EXISTS 'nanourl_user'@'localhost';`""
$createUserCmd = "mysql -u root $passwordParam -e `"CREATE USER 'nanourl_user'@'localhost' IDENTIFIED BY 'NanoURL@SecurePass123';`""
$grantCmd = "mysql -u root $passwordParam -e `"GRANT ALL PRIVILEGES ON nanourl_db.* TO 'nanourl_user'@'localhost';`""
$flushCmd = "mysql -u root $passwordParam -e `"FLUSH PRIVILEGES;`""

Invoke-Expression $dropUserCmd | Out-Null
Invoke-Expression $createUserCmd | Out-Null
Invoke-Expression $grantCmd | Out-Null
Invoke-Expression $flushCmd | Out-Null

Write-Host "[OK] User created with credentials:`n" -ForegroundColor Green
Write-Host "  Username: nanourl_user" -ForegroundColor Gray
Write-Host "  Password: NanoURL@SecurePass123`n" -ForegroundColor Gray

# Verify new user
Write-Host "[TEST] Verifying nanourl_user connection..." -ForegroundColor Yellow
$verifyCmd = "mysql -u nanourl_user -pNanoURL@SecurePass123 nanourl_db -e `"SELECT 1;`" 2>&1"
$verifyResult = Invoke-Expression $verifyCmd

if ($LASTEXITCODE -eq 0) {
    Write-Host "[OK] User verified`n" -ForegroundColor Green
} else {
    Write-Host "[WARNING] Could not verify user connection`n" -ForegroundColor Yellow
}

# Create tables from schema
Write-Host "[INFO] Creating tables from schema..." -ForegroundColor Yellow
$schemaFile = Join-Path $PSScriptRoot "database\database_schema.sql"

if (Test-Path $schemaFile) {
    $schemaCmd = "mysql -u nanourl_user -pNanoURL@SecurePass123 nanourl_db -e `"source $schemaFile`""
    Invoke-Expression $schemaCmd | Out-Null
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] Tables created from schema`n" -ForegroundColor Green
    } else {
        Write-Host "[INFO] Will auto-create tables on app startup`n" -ForegroundColor Cyan
    }
} else {
    Write-Host "[INFO] Schema file not found, will auto-create tables on app startup`n" -ForegroundColor Cyan
}

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "[SUCCESS] MySQL Setup Complete!" -ForegroundColor Green
Write-Host "======================================`n" -ForegroundColor Cyan

Write-Host "Database Configuration:" -ForegroundColor Cyan
Write-Host "  Host: localhost" -ForegroundColor Gray
Write-Host "  Port: 3306" -ForegroundColor Gray
Write-Host "  Database: nanourl_db" -ForegroundColor Gray
Write-Host "  User: nanourl_user" -ForegroundColor Gray
Write-Host "  Password: NanoURL@SecurePass123`n" -ForegroundColor Gray

Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "  1. Start Backend: cd backend; mvn spring-boot:run" -ForegroundColor Yellow
Write-Host "  2. Start Frontend: cd frontend\nanourl-frontend; npm run dev" -ForegroundColor Yellow
Write-Host "  3. Test Application: http://localhost:5173`n" -ForegroundColor Yellow

# Optional: Show how to verify
Write-Host "To verify data in database later, run:" -ForegroundColor Cyan
Write-Host "  mysql -u nanourl_user -p nanourl_db" -ForegroundColor Gray
Write-Host "  (password: NanoURL@SecurePass123)`n" -ForegroundColor Gray

Write-Host "Useful MySQL commands:" -ForegroundColor Cyan
Write-Host "  SHOW TABLES;" -ForegroundColor Gray
Write-Host "  SELECT COUNT(*) FROM users;" -ForegroundColor Gray
Write-Host "  SELECT COUNT(*) FROM urls;" -ForegroundColor Gray
