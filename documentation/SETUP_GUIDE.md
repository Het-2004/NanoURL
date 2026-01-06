# ⚙️ Setup Guide

Quick setup reference.

---

## **Prerequisites**

- Java 21+
- Node.js 16+
- MySQL 8.0+
- Git

---

## **1. Install Components**

```bash
# Java: https://jdk.java.net/21/
# Node: https://nodejs.org/
# MySQL: https://dev.mysql.com/downloads/mysql/
```

---

## **2. Clone Project**

```bash
git clone https://github.com/yourusername/nanourl.git
cd NanoURL
```

---

## **3. Create Database**

```bash
mysql -u root -p < database/database_schema.sql
# Password: (your MySQL root password)
```

---

## **4. Start Backend**

```bash
cd backend
mvnw spring-boot:run
```

Runs on: http://localhost:8080

---

## **5. Start Frontend**

New terminal:
```bash
cd frontend/nanourl-frontend
npm install
npm run dev
```

Runs on: http://localhost:5173

---

## **6. Test**

- Open: http://localhost:5173
- Sign up
- Create short URL
- Works!

---

## **More Help**

- See [QUICK_START.md](QUICK_START.md) for 30-min setup
- See [README.md](README.md) for all docs

---

**Setup done! 🚀**
