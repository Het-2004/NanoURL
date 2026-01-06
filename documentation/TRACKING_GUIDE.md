# Login & URL Access Tracking Guide

## Overview
The NanoURL application now tracks all user logins and URL accesses using JDBC and stores them in the database for analytics.

## Database Tables

### 1. login_history
Tracks every user login event:
- `id`: Primary key
- `user_id`: Reference to users table
- `login_time`: Timestamp of login
- `ip_address`: Client IP address
- `user_agent`: Browser/client information
- `login_method`: LOGIN type (EMAIL, GOOGLE, GITHUB)

### 2. url_access_log
Tracks every URL redirect/access:
- `id`: Primary key
- `url_id`: Reference to urls table
- `access_time`: Timestamp of access
- `ip_address`: Client IP address
- `user_agent`: Browser/client information
- `referer`: HTTP referer header

## Automatic Tracking

### Login Tracking
Every time a user logs in (via signup, signin, or OAuth), the system automatically records:
- User who logged in
- Login timestamp
- IP address
- Browser/device information
- Authentication method used

### URL Access Tracking
Every time someone accesses a shortened URL, the system automatically records:
- Which URL was accessed
- Access timestamp
- Visitor's IP address
- Browser/device information
- Referring page

## API Endpoints

### Get My Login History
```
GET /api/analytics/login-history
Authorization: Bearer <token>
```
Returns all login events for the authenticated user.

### Get URL Access Logs
```
GET /api/analytics/url-access/{shortCode}
```
Returns all access logs for a specific shortened URL.

### Get Recent Logins
```
GET /api/analytics/recent-logins?days=7
```
Returns login events from the last N days (default: 7).

### Get Recent URL Accesses
```
GET /api/analytics/recent-access?days=7
```
Returns URL access events from the last N days (default: 7).

### Get URL Access Count
```
GET /api/analytics/url-access-count/{urlId}
```
Returns total access count for a specific URL.

## Database Queries

See [ANALYTICS_QUERIES.sql](../database/ANALYTICS_QUERIES.sql) for example SQL queries to view the data directly in the database.

### Quick Examples:

#### View All Logins
```sql
SELECT 
    u.email,
    lh.login_time,
    lh.ip_address,
    lh.login_method
FROM login_history lh
JOIN users u ON lh.user_id = u.id
ORDER BY lh.login_time DESC;
```

#### View URL Access Logs
```sql
SELECT 
    u.short_code,
    u.long_url,
    ual.access_time,
    ual.ip_address
FROM url_access_log ual
JOIN urls u ON ual.url_id = u.id
ORDER BY ual.access_time DESC;
```

#### Most Accessed URLs
```sql
SELECT 
    u.short_code,
    COUNT(*) as total_accesses
FROM url_access_log ual
JOIN urls u ON ual.url_id = u.id
GROUP BY u.short_code
ORDER BY total_accesses DESC
LIMIT 10;
```

## Usage in Application

The tracking is completely automatic. No additional code is needed in your frontend or when making API calls. Simply:

1. **For Login Tracking**: Use the existing auth endpoints (`/api/auth/signin`, `/api/auth/signup`, `/api/auth/oauth/{provider}`)
2. **For URL Tracking**: Access shortened URLs normally (`/{shortCode}`)

## Security & Privacy

- IP addresses are stored for security and analytics
- All analytics endpoints require authentication
- Users can only view their own login history
- URL access logs are visible to URL owners

## Maintenance

To keep the database size manageable, you can periodically clean old logs:

```sql
-- Clean login history older than 90 days
DELETE FROM login_history WHERE login_time < DATE_SUB(NOW(), INTERVAL 90 DAY);

-- Clean URL access logs older than 90 days
DELETE FROM url_access_log WHERE access_time < DATE_SUB(NOW(), INTERVAL 90 DAY);
```

## Examples

### View Your Login History
```bash
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://localhost:8080/api/analytics/login-history
```

### View URL Access Stats
```bash
curl http://localhost:8080/api/analytics/url-access/abc123
```

### Check Recent Activity
```bash
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://localhost:8080/api/analytics/recent-logins?days=30
```
