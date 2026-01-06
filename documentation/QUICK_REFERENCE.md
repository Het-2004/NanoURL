# ⚡ Quick Reference

Fast lookup for common tasks.

---

## **Start Services**

### Start MySQL:
```bash
mysql -u nanourl_user -p nanourl_db
```

### Start Backend:
```bash
cd backend
mvnw spring-boot:run
```

### Start Frontend:
```bash
cd frontend/nanourl-frontend
npm run dev
```

---

## **Common Ports**

- Backend: 8080
- Frontend: 5173
- MySQL: 3306

---

## **Database Queries**

### View Users:
```sql
SELECT * FROM users;
```

### View User's URLs:
```sql
SELECT * FROM urls WHERE user_id = 1;
```

### View Messages:
```sql
SELECT * FROM contact_messages;
```

---

## **API Endpoints**

### Auth:
- `POST /api/auth/signup` - Register
- `POST /api/auth/login` - Login

### URLs:
- `POST /api/urls/shorten` - Create short URL
- `GET /api/urls/history` - User's URLs
- `GET /{shortCode}` - Redirect
- `DELETE /api/urls/{id}` - Delete URL

### Contact:
- `POST /api/contact` - Send message

---

## **Deployment**

Push to GitHub:
```bash
git add .
git commit -m "Your changes"
git push origin main
```

Render auto-deploys!

---

## **Troubleshooting**

| Issue | Solution |
|-------|----------|
| Backend won't start | Check MySQL running |
| Frontend can't connect | Check API URL |
| CORS error | Check WebConfig.java |
| Database full | Check backups |

---

## **File Locations**

- **Backend:** `backend/src/main/java/`
- **Frontend:** `frontend/nanourl-frontend/src/`
- **Database Schema:** `database/database_schema.sql`
- **Queries:** `database/QUERY_EXAMPLES.sql`
- **Docs:** `documentation/*.md`

---

## **Help**

See [README.md](README.md) for all documentation.

---

**Quick reference is ready! 🚀**
