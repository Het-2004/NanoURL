-- ============================================
-- NanoURL Analytics Query Examples
-- ============================================
-- Queries to view login and URL access logs
-- ============================================

USE nanourl_db;

-- ============================================
-- LOGIN HISTORY QUERIES
-- ============================================

-- View all login history
SELECT 
    lh.id,
    u.email,
    u.name,
    lh.login_time,
    lh.ip_address,
    lh.user_agent,
    lh.login_method
FROM login_history lh
JOIN users u ON lh.user_id = u.id
ORDER BY lh.login_time DESC;

-- View login history for specific user by email
SELECT 
    lh.id,
    u.email,
    lh.login_time,
    lh.ip_address,
    lh.login_method
FROM login_history lh
JOIN users u ON lh.user_id = u.id
WHERE u.email = 'test@nanourl.com'
ORDER BY lh.login_time DESC;

-- Count logins per user
SELECT 
    u.email,
    u.name,
    COUNT(*) as login_count,
    MAX(lh.login_time) as last_login
FROM login_history lh
JOIN users u ON lh.user_id = u.id
GROUP BY u.id, u.email, u.name
ORDER BY login_count DESC;

-- Recent logins (last 7 days)
SELECT 
    u.email,
    lh.login_time,
    lh.ip_address,
    lh.login_method
FROM login_history lh
JOIN users u ON lh.user_id = u.id
WHERE lh.login_time >= DATE_SUB(NOW(), INTERVAL 7 DAY)
ORDER BY lh.login_time DESC;

-- Logins by method
SELECT 
    lh.login_method,
    COUNT(*) as count
FROM login_history lh
GROUP BY lh.login_method
ORDER BY count DESC;

-- ============================================
-- URL ACCESS LOG QUERIES
-- ============================================

-- View all URL accesses
SELECT 
    ual.id,
    u.short_code,
    u.long_url,
    ual.access_time,
    ual.ip_address,
    ual.user_agent,
    ual.referer
FROM url_access_log ual
JOIN urls u ON ual.url_id = u.id
ORDER BY ual.access_time DESC;

-- View access logs for specific short code
SELECT 
    ual.access_time,
    ual.ip_address,
    ual.user_agent,
    ual.referer
FROM url_access_log ual
JOIN urls u ON ual.url_id = u.id
WHERE u.short_code = 'abc123'
ORDER BY ual.access_time DESC;

-- Count accesses per URL
SELECT 
    u.short_code,
    u.long_url,
    COUNT(*) as access_count,
    MAX(ual.access_time) as last_access
FROM url_access_log ual
JOIN urls u ON ual.url_id = u.id
GROUP BY u.id, u.short_code, u.long_url
ORDER BY access_count DESC;

-- Recent URL accesses (last 24 hours)
SELECT 
    u.short_code,
    u.long_url,
    ual.access_time,
    ual.ip_address
FROM url_access_log ual
JOIN urls u ON ual.url_id = u.id
WHERE ual.access_time >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
ORDER BY ual.access_time DESC;

-- Most accessed URLs
SELECT 
    u.short_code,
    u.long_url,
    COUNT(*) as total_accesses
FROM url_access_log ual
JOIN urls u ON ual.url_id = u.id
GROUP BY u.id, u.short_code, u.long_url
ORDER BY total_accesses DESC
LIMIT 10;

-- ============================================
-- COMBINED ANALYTICS QUERIES
-- ============================================

-- User activity (logins + URL creations)
SELECT 
    u.email,
    u.name,
    COUNT(DISTINCT lh.id) as login_count,
    COUNT(DISTINCT url.id) as urls_created,
    u.created_at as user_since
FROM users u
LEFT JOIN login_history lh ON u.id = lh.user_id
LEFT JOIN urls url ON u.id = url.user_id
GROUP BY u.id, u.email, u.name, u.created_at
ORDER BY login_count DESC;

-- URLs with access details for specific user
SELECT 
    u.email as owner,
    url.short_code,
    url.long_url,
    url.created_at,
    COUNT(ual.id) as total_accesses,
    MAX(ual.access_time) as last_accessed
FROM urls url
JOIN users u ON url.user_id = u.id
LEFT JOIN url_access_log ual ON url.id = ual.url_id
WHERE u.email = 'test@nanourl.com'
GROUP BY url.id, u.email, url.short_code, url.long_url, url.created_at
ORDER BY total_accesses DESC;

-- Daily login statistics
SELECT 
    DATE(lh.login_time) as login_date,
    COUNT(*) as login_count,
    COUNT(DISTINCT lh.user_id) as unique_users
FROM login_history lh
GROUP BY DATE(lh.login_time)
ORDER BY login_date DESC;

-- Daily URL access statistics
SELECT 
    DATE(ual.access_time) as access_date,
    COUNT(*) as total_accesses,
    COUNT(DISTINCT ual.url_id) as unique_urls_accessed
FROM url_access_log ual
GROUP BY DATE(ual.access_time)
ORDER BY access_date DESC;

-- ============================================
-- MAINTENANCE QUERIES
-- ============================================

-- Clean old login history (older than 90 days)
-- DELETE FROM login_history WHERE login_time < DATE_SUB(NOW(), INTERVAL 90 DAY);

-- Clean old URL access logs (older than 90 days)
-- DELETE FROM url_access_log WHERE access_time < DATE_SUB(NOW(), INTERVAL 90 DAY);

-- ============================================
-- END OF ANALYTICS QUERIES
-- ============================================
