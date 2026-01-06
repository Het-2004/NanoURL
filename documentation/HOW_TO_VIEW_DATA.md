# 👀 7 Ways to View Your Database Data

## See Your Database in Different Ways

Choose the method that works best for you!

---

## **Method 1: Command Line (Fastest)**

### Open MySQL:
```bash
mysql -u nanourl_user -p nanourl_db
```

Password: `NanoURL@SecurePass123`

### View All Users:
```sql
SELECT * FROM users;
```

### View All URLs:
```sql
SELECT * FROM urls;
```

### View Contact Messages:
```sql
SELECT * FROM contact_messages;
```

### Exit:
```sql
EXIT;
```

**⏱️ Time:** 2 minutes  
**✨ Best for:** Quick checking, scripting

---

## **Method 2: MySQL Workbench (GUI - Easiest)**

### Installation:
- Comes with MySQL installer on Windows
- Or download from: https://dev.mysql.com/downloads/workbench/

### Steps:

1. **Open MySQL Workbench**

2. **Create Connection:**
   - Click "+" next to "MySQL Connections"
   - Connection Name: `Local MySQL`
   - Hostname: `127.0.0.1`
   - Port: `3306`
   - Username: `nanourl_user`
   - Click "Store in Vault" → password: `NanoURL@SecurePass123`
   - Click "Test Connection" → "OK"

3. **Connect:**
   - Double-click the connection

4. **View Data:**
   - Left sidebar: expand `nanourl_db`
   - Right-click table → "Select Rows - Limit 1000"
   - Or click table name to see data

5. **Run Queries:**
   - File → Open SQL Script
   - Or create new query tab
   - Type SQL, click lightning bolt

**⏱️ Time:** 5 minutes  
**✨ Best for:** Visual browsing, GUI lovers

---

## **Method 3: DBeaver (Powerful & Free)**

### Installation:
- Download: https://dbeaver.io/download/
- Windows/Mac/Linux available

### Steps:

1. **Create Connection:**
   - File → New Database Connection
   - Select "MySQL"
   - Click "Next"

2. **Configure:**
   - Server Host: `localhost`
   - Port: `3306`
   - Database: (leave empty)
   - Username: `nanourl_user`
   - Password: `NanoURL@SecurePass123`
   - Click "Test Connection"

3. **Browse Data:**
   - Left sidebar → expand MySQL connection
   - Expand → nanourl_db → Tables
   - Right-click table → "Select Rows"

4. **Advanced Queries:**
   - Right-click "nanourl_db"
   - New → SQL Script
   - Write SQL, press Ctrl+Enter to run

**⏱️ Time:** 5 minutes  
**✨ Best for:** Advanced users, powerful features

---

## **Method 4: Visual Studio Code (Built-in)**

### Install Extension:
- Install "MySQL" by Weijan Chen (or similar)
- Or "Database Client" by Weijan Chen

### Steps:

1. **Open VS Code**
2. **Click Extensions** (Ctrl+Shift+X)
3. **Search:** "MySQL"
4. **Click Install** on MySQL extension

5. **Create Connection:**
   - Click Data Explorer icon on left
   - Click "+" → "MySQL"
   - Host: `localhost`
   - User: `nanourl_user`
   - Password: `NanoURL@SecurePass123`
   - Database: `nanourl_db`

6. **Browse Data:**
   - Expand connection in Data Explorer
   - Right-click table → "Show Records"

**⏱️ Time:** 3 minutes  
**✨ Best for:** VS Code users

---

## **Method 5: phpMyAdmin (Web-Based)**

### Installation:

**Windows:**
1. Install XAMPP: https://www.apachefriends.org/
2. Start Apache + MySQL
3. Open: http://localhost/phpmyadmin

**Mac/Linux:**
```bash
docker run --rm -d \
  -p 8081:80 \
  --name phpmyadmin \
  -e PMA_HOST=host.docker.internal \
  -e PMA_USER=nanourl_user \
  -e PMA_PASSWORD="NanoURL@SecurePass123" \
  phpmyadmin
```

Open: http://localhost:8081

### Browse Data:
1. Login with `nanourl_user` / `NanoURL@SecurePass123`
2. Select `nanourl_db` from left sidebar
3. Click table to see data
4. Click "SQL" tab to run queries

**⏱️ Time:** 5 minutes  
**✨ Best for:** Web browser, no installation

---

## **Method 6: DataGrip (JetBrains - Professional)**

### Installation:
- Download: https://www.jetbrains.com/datagrip/
- 30-day free trial

### Steps:

1. **Open DataGrip**

2. **Create Connection:**
   - Data Source → New Connection → MySQL
   - Host: `localhost`
   - Port: `3306`
   - User: `nanourl_user`
   - Password: `NanoURL@SecurePass123`
   - Database: `nanourl_db`
   - Test Connection

3. **Browse:**
   - Left sidebar → expand MySQL
   - Expand nanourl_db → Tables
   - Double-click table to see data

4. **Write Queries:**
   - Right-click database → New → Query Console
   - Write SQL, press Ctrl+Enter

**⏱️ Time:** 5 minutes  
**✨ Best for:** Professional developers

---

## **Method 7: HeidiSQL (Windows Only - Lightweight)**

### Installation:
- Download: https://www.heidisql.com/
- Lightweight and fast

### Steps:

1. **Open HeidiSQL**

2. **Create Session:**
   - Click "New" button
   - Library: `MySQL (TCP/IP)`
   - Hostname: `localhost`
   - User: `nanourl_user`
   - Password: `NanoURL@SecurePass123`
   - Port: `3306`
   - Click "Open"

3. **Browse Data:**
   - Left sidebar → expand nanourl_db
   - Click table to see data in right pane
   - Click "Data" tab to edit

4. **Run Queries:**
   - Right-click database → "Create Query"
   - Or press Ctrl+Q
   - Write SQL, press F9 to execute

**⏱️ Time:** 3 minutes  
**✨ Best for:** Windows users, lightweight

---

## **Comparison Table**

| Tool | Time | Effort | Features | Best For |
|------|------|--------|----------|----------|
| **Command Line** | ⚡ 2 min | Beginner | Basic | Quick checks |
| **Workbench** | 5 min | Easy | Good | Most users |
| **DBeaver** | 5 min | Easy | Excellent | Developers |
| **VS Code** | 3 min | Easy | Good | Coders |
| **phpMyAdmin** | 5 min | Easy | Good | Web users |
| **DataGrip** | 5 min | Easy | Excellent | Professionals |
| **HeidiSQL** | 3 min | Very Easy | Very Good | Windows |

---

## **Sample Data to Expect**

### Users Table (3 rows):
```
ID | Email                    | Name          | Contact
1  | alice@example.com        | Alice Johnson | alice@example.com
2  | bob@example.com          | Bob Smith     | bob@example.com
3  | charlie@example.com      | Charlie Brown | charlie@example.com
```

### URLs Table (5 rows):
```
ID | Short Code | Long URL              | User ID | Clicks
1  | abc123     | https://google.com    | 1       | 5
2  | xyz789     | https://github.com    | 1       | 3
3  | def456     | https://stackoverflow | 2       | 12
4  | ghi321     | https://wikipedia.org | 2       | 7
5  | jkl654     | https://medium.com    | 3       | 2
```

### Contact Messages (3 rows):
```
ID | Name          | Email                 | Message
1  | John Doe      | john@example.com      | Great service!
2  | Jane Smith    | jane@example.com      | Love the design
3  | Mike Johnson  | mike@example.com      | Very useful tool
```

---

## **Common Queries**

### See All Users:
```sql
SELECT * FROM users;
```

### See URLs by Specific User:
```sql
SELECT * FROM urls WHERE user_id = 1;
```

### See User Details with Their URLs:
```sql
SELECT 
  u.short_code,
  u.long_url,
  u.click_count,
  user.email
FROM urls u
JOIN users user ON u.user_id = user.id;
```

### See Contact Messages:
```sql
SELECT * FROM contact_messages;
```

### Count Users:
```sql
SELECT COUNT(*) as total_users FROM users;
```

### Count URLs:
```sql
SELECT COUNT(*) as total_urls FROM urls;
```

---

## **Recommended Method by User Type**

👨‍💻 **Developer:** Command Line or DBeaver  
👨‍💼 **Manager:** MySQL Workbench or phpMyAdmin  
🎓 **Student:** VS Code extension  
⚡ **Quick Check:** Command Line  
🖥️ **Windows Only:** HeidiSQL  
🎯 **Best Overall:** MySQL Workbench  

---

## **Quick Reference**

### Command Line Connection:
```bash
mysql -u nanourl_user -p nanourl_db
# Password: NanoURL@SecurePass123
```

### Basic Queries:
```sql
SHOW TABLES;
SELECT * FROM users;
SELECT * FROM urls;
SELECT * FROM contact_messages;
```

---

## **More Help**

- See all queries: `database/QUERY_EXAMPLES.sql`
- Understand schema: [DATABASE_SCHEMA_DIAGRAM.md](DATABASE_SCHEMA_DIAGRAM.md)
- Full setup guide: [MYSQL_COMPLETE_SETUP.md](MYSQL_COMPLETE_SETUP.md)
- All documentation: [README.md](README.md)

---

**Choose your tool and start exploring! 🎉**
