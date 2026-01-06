# 📋 Docker Deployment Checklist

Use this checklist to ensure your NanoURL is properly deployed publicly.

## Pre-Deployment ✓

- [ ] All code committed to GitHub main branch
- [ ] Docker images build successfully: `docker-compose build`
- [ ] Containers start without errors: `docker-compose up -d`
- [ ] Health checks pass: `docker-compose logs`
- [ ] Frontend loads: http://localhost:3000
- [ ] Backend responds: http://localhost:8080/api/health
- [ ] Database connection works
- [ ] Redis is running

## Configuration ✓

- [ ] `.env` file created with secure passwords
- [ ] JWT_SECRET changed from default
- [ ] MYSQL_ROOT_PASSWORD set
- [ ] MYSQL_PASSWORD set
- [ ] APP_BASE_URL matches your domain
- [ ] VITE_API_BASE_URL set correctly

## Deployment Platform Choice ✓

Choose ONE:

### Render (Recommended)
- [ ] Render account created (render.com)
- [ ] GitHub connected to Render
- [ ] Blueprint deployment initiated
- [ ] Environment variables set in Render dashboard
- [ ] Database created in Render
- [ ] Services deployed successfully
- [ ] **Frontend URL:** https://nanourl-frontend-xxxxx.onrender.com
- [ ] **Backend URL:** https://nanourl-backend-xxxxx.onrender.com

### Railway
- [ ] Railway account created (railway.app)
- [ ] GitHub connected to Railway
- [ ] Project created from GitHub repo
- [ ] Services deployed
- [ ] Environment variables configured
- [ ] **Frontend URL:** https://yourproject-frontend.railway.app
- [ ] **Backend URL:** https://yourproject-backend.railway.app

### Docker Hub + VPS
- [ ] Docker Hub account created
- [ ] Images built locally
- [ ] Images tagged with username
- [ ] Images pushed to Docker Hub
- [ ] VPS/Server prepared
- [ ] Docker installed on server
- [ ] docker-compose.prod.yml uploaded
- [ ] .env file with production values
- [ ] `docker-compose -f docker-compose.prod.yml up -d` executed
- [ ] **App URL:** Your server's public IP or domain

## Testing ✓

### Frontend
- [ ] Loads without errors
- [ ] Can create short URL
- [ ] Can view URL statistics
- [ ] Can copy link to clipboard
- [ ] Responsive on mobile
- [ ] All assets load (images, CSS, JS)

### Backend
- [ ] GET `/api/health` returns 200
- [ ] GET `/api/urls` works
- [ ] POST `/api/urls` creates URL
- [ ] GET `/api/urls/{id}` retrieves URL
- [ ] CORS headers present
- [ ] Error messages clear

### Database
- [ ] Data persists after restart
- [ ] Tables created automatically
- [ ] Can query data via tools
- [ ] Backups working (if configured)

### Security
- [ ] HTTPS enabled (cloud providers do this)
- [ ] CORS properly configured
- [ ] JWT validation working
- [ ] No sensitive data in logs
- [ ] Secrets not in code

## Monitoring ✓

### Logs
- [ ] Can view application logs
- [ ] No error messages
- [ ] Startup messages show success
- [ ] Container health checks passing

### Metrics (if available)
- [ ] CPU usage reasonable
- [ ] Memory usage acceptable
- [ ] Network traffic normal
- [ ] No timeout errors

## Domain & Public Access ✓

- [ ] App accessible from public Internet
- [ ] Can share unique URL with others
- [ ] HTTPS certificate valid
- [ ] DNS pointing correctly (if custom domain)
- [ ] Firewall rules allow traffic

## Documentation ✓

- [ ] README updated with public URL
- [ ] Deployment steps documented
- [ ] Environment variables listed
- [ ] Troubleshooting guide reviewed
- [ ] Team has access information

## Post-Deployment ✓

- [ ] Backups configured (if applicable)
- [ ] Monitoring alerts set up (if available)
- [ ] Log rotation configured
- [ ] Scaling strategy planned
- [ ] Update process documented
- [ ] Team trained on deployment process

---

## Your Public URLs

When deployment is complete, you'll have:

```
Frontend: https://nanourl-frontend-[UNIQUE-ID].onrender.com
Backend:  https://nanourl-backend-[UNIQUE-ID].onrender.com
API:      https://nanourl-backend-[UNIQUE-ID].onrender.com/api
```

Share these URLs with your users!

---

## Troubleshooting Quick Links

| Issue | Solution |
|-------|----------|
| Service won't start | Check logs: `docker logs [service-name]` |
| Database can't connect | Verify `SPRING_DATASOURCE_URL` in env |
| Frontend shows blank page | Check `VITE_API_BASE_URL` |
| API returns 404 | Verify backend is running and listening |
| Can't access publicly | Check firewall and cloud provider settings |
| HTTPS not working | Cloud provider should auto-enable this |

---

## Success Criteria ✓

You're done when:

✅ Your NanoURL has a unique public address  
✅ Frontend and backend are accessible from anywhere  
✅ URL shortening works end-to-end  
✅ Data persists properly  
✅ No error messages in logs  
✅ Performance is acceptable  
✅ Team can access and use the application  

---

Congratulations! 🎉 Your NanoURL is now live!
