# 🚀 MySQL Setup - QUICK START (30 Minutes)

## ⚡ Fastest Way to Get Started

This guide will get your MySQL database running in **30 minutes or less**.

---

## **Step 1: Install MySQL** (5 minutes)

### Windows:
1. Download: https://dev.mysql.com/downloads/mysql/
2. Run installer
3. Choose "Setup Type: Developer Default"
4. Click "Execute"
5. Click "Next" through configuration
6. Set password for root user
7. Click "Execute"

### Mac:
```bash
brew install mysql
brew services start mysql
```

### Linux:
```bash
sudo apt-get install mysql-server
sudo systemctl start mysql
```

---

## **Step 2: Verify MySQL is Running** (2 minutes)

```bash
mysql --version
mysql -u root -p
```

If you see `mysql>` prompt, MySQL is working! Type `EXIT;` to exit.

---

## **Step 3: Create Database** (3 minutes)

### Option A: Command Line (Easiest)
```bash
mysql -u root -p < database/database_schema.sql
```

When prompted, enter your MySQL root password.

### Option B: MySQL Workbench
1. Open MySQL Workbench
2. Click "+" next to MySQL Connections
3. Enter connection details (localhost, root, your password)
4. Click "Test Connection"
5. Click "OK"
6. Double-click to connect
7. File → Open SQL Script
8. Select `database/database_schema.sql`
9. Click "Execute"

---

## **Step 4: Verify Database Created** (2 minutes)

```bash
mysql -u root -p
```

Enter password, then:

```sql
SHOW DATABASES;
```

You should see `nanourl_db` in the list!

Check tables:
```sql
USE nanourl_db;
SHOW TABLES;
```

You should see:
- `users`
- `urls`
- `contact_messages`

---

## **Step 5: Test Connection** (5 minutes)

1. Open `backend/src/main/resources/application.yaml`
2. Check this section:

```yaml
datasource:
  url: jdbc:mysql://localhost:3306/nanourl_db
  username: nanourl_user
  password: NanoURL@SecurePass123
```

3. If you want to use root instead, change username/password to match your setup

---

## **Step 6: Start Backend** (8 minutes)

### Windows:
```bash
cd backend
mvnw spring-boot:run
```

### Mac/Linux:
```bash
cd backend
./mvnw spring-boot:run
```

Wait for message: **"Started NanoUrlApplication"**

---

## **Step 7: View Your Data** (5 minutes)

Open MySQL and run:

```bash
mysql -u root -p
USE nanourl_db;
SELECT * FROM users;
```

You should see 3 sample users!

---

## **Done! 🎉**

Your database is ready!

---

## 🐛 **Troubleshooting**

### Error: "Access denied for user"
- Check password in application.yaml
- Or use your correct MySQL password

### Error: "Database 'nanourl_db' doesn't exist"
- Run Step 3 again: `mysql -u root -p < database/database_schema.sql`

### Error: "Connection refused"
- Make sure MySQL is running: `mysql -u root -p`
- If it doesn't work, restart MySQL

### Error: "Can't connect on 'localhost:3306'"
- Verify MySQL port is 3306: `SHOW VARIABLES LIKE 'port';`

---

## ✨ **What You Have Now**

✅ MySQL database running  
✅ Tables created (users, urls, contact_messages)  
✅ Sample data loaded (3 users)  
✅ Backend configured to use MySQL  
✅ Ready to test the application  

---

## 📚 **Next Steps**

1. **View Data:** See [HOW_TO_VIEW_DATA.md](HOW_TO_VIEW_DATA.md)
2. **Understand Schema:** See [DATABASE_SCHEMA_DIAGRAM.md](DATABASE_SCHEMA_DIAGRAM.md)
3. **Run Queries:** See `database/QUERY_EXAMPLES.sql`
4. **Full Guide:** See [MYSQL_COMPLETE_SETUP.md](MYSQL_COMPLETE_SETUP.md)
5. **Deploy:** See [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)

---

## 📖 **More Help?**

- See full guide: [MYSQL_COMPLETE_SETUP.md](MYSQL_COMPLETE_SETUP.md)
- See all guides: [README.md](README.md)
- See data viewing methods: [HOW_TO_VIEW_DATA.md](HOW_TO_VIEW_DATA.md)

---

**You're all set! Enjoy! 🚀**
