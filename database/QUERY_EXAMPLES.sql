-- ============================================
-- QUICK REFERENCE QUERIES
-- ============================================
-- Copy-paste these commands to view your data

-- CONNECT TO DATABASE
-- mysql -u root -p
-- (enter password)
-- USE nanourl_db;

-- ============================================
-- 1. SEE ALL USERS
-- ============================================
SELECT 
    id,
    email,
    name,
    contact,
    created_at
FROM users;


-- ============================================
-- 2. SEE USER'S SHORTENED URLS
-- ============================================
-- Change '1' to the user ID you want to see
SELECT 
    u.id,
    u.email,
    u.name,
    url.short_code,
    url.long_url,
    url.click_count,
    url.created_at
FROM users u
LEFT JOIN urls url ON u.id = url.user_id
WHERE u.id = 1
ORDER BY url.created_at DESC;


-- ============================================
-- 3. SEE URL STATISTICS
-- ============================================
-- Who created which URL and how many clicks
SELECT 
    u.name,
    u.email,
    COUNT(url.id) as total_urls,
    COALESCE(SUM(url.click_count), 0) as total_clicks,
    MAX(url.created_at) as last_url_created
FROM users u
LEFT JOIN urls url ON u.id = url.user_id
GROUP BY u.id, u.email, u.name
ORDER BY total_clicks DESC;


-- ============================================
-- 4. SEE MOST POPULAR URLS
-- ============================================
-- Top 10 most clicked URLs
SELECT 
    short_code,
    long_url,
    click_count,
    u.email as created_by,
    created_at
FROM urls url
JOIN users u ON url.user_id = u.id
ORDER BY click_count DESC
LIMIT 10;


-- ============================================
-- 5. SEE CONTACT MESSAGES
-- ============================================
-- All contact form submissions
SELECT 
    id,
    name,
    email,
    message,
    created_at
FROM contact_messages
ORDER BY created_at DESC;


-- ============================================
-- 6. SEARCH USER BY EMAIL
-- ============================================
-- Replace 'john@example.com' with actual email
SELECT * FROM users 
WHERE email = 'john@example.com';


-- ============================================
-- 7. FIND SHORT CODE DETAILS
-- ============================================
-- Find which user created a short code
-- Replace 'abc123' with actual short code
SELECT 
    u.name,
    u.email,
    url.short_code,
    url.long_url,
    url.click_count,
    url.created_at
FROM urls url
JOIN users u ON url.user_id = u.id
WHERE url.short_code = 'abc123';


-- ============================================
-- 8. SEE RECENT ACTIVITY
-- ============================================
-- URLs created in last 7 days
SELECT 
    u.name,
    url.short_code,
    url.long_url,
    url.created_at,
    DATE_FORMAT(url.created_at, '%Y-%m-%d %H:%i:%s') as formatted_time
FROM urls url
JOIN users u ON url.user_id = u.id
WHERE url.created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)
ORDER BY url.created_at DESC;


-- ============================================
-- 9. COUNT STATISTICS
-- ============================================
-- Quick overview of database

-- Total users
SELECT COUNT(*) as total_users FROM users;

-- Total URLs created
SELECT COUNT(*) as total_urls FROM urls;

-- Total clicks across all URLs
SELECT SUM(click_count) as total_clicks FROM urls;

-- Total contact messages
SELECT COUNT(*) as total_messages FROM contact_messages;


-- ============================================
-- 10. VIEW TABLE STRUCTURE
-- ============================================
DESCRIBE users;
DESCRIBE urls;
DESCRIBE contact_messages;


-- ============================================
-- 11. ADMIN OPERATIONS
-- ============================================

-- Update user information
-- UPDATE users 
-- SET name = 'New Name', contact = '9999999999'
-- WHERE email = 'john@example.com';

-- Delete a user (will delete their URLs too - CASCADE)
-- DELETE FROM users WHERE id = 1;

-- Manually increment click count
-- UPDATE urls SET click_count = click_count + 1 
-- WHERE short_code = 'abc123';

-- Delete a specific URL
-- DELETE FROM urls WHERE short_code = 'abc123';


-- ============================================
-- 12. ADVANCED QUERIES
-- ============================================

-- Users sorted by number of URLs created
SELECT 
    u.id,
    u.name,
    COUNT(url.id) as url_count
FROM users u
LEFT JOIN urls url ON u.id = url.user_id
GROUP BY u.id, u.name
ORDER BY url_count DESC;


-- Average clicks per URL (by user)
SELECT 
    u.name,
    ROUND(AVG(url.click_count), 2) as avg_clicks_per_url
FROM users u
LEFT JOIN urls url ON u.id = url.user_id
GROUP BY u.id, u.name
HAVING avg_clicks_per_url > 0;


-- URLs with zero clicks
SELECT 
    u.name,
    url.short_code,
    url.long_url,
    url.created_at
FROM urls url
JOIN users u ON url.user_id = u.id
WHERE url.click_count = 0
ORDER BY url.created_at DESC;


-- ============================================
-- 13. BACKUP & RESTORE
-- ============================================

-- BACKUP (run in command line, not in MySQL console)
-- mysqldump -u nanourl_user -p nanourl_db > backup_$(date +%Y%m%d).sql

-- RESTORE (run in command line)
-- mysql -u nanourl_user -p nanourl_db < backup_20260104.sql


-- ============================================
-- 14. PERFORMANCE QUERIES
-- ============================================

-- Database size
SELECT 
    table_name,
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS size_mb
FROM information_schema.tables 
WHERE table_schema = 'nanourl_db'
ORDER BY size_mb DESC;


-- Check for duplicate short codes (should be 0)
SELECT short_code, COUNT(*) 
FROM urls 
GROUP BY short_code 
HAVING COUNT(*) > 1;


-- Check for orphaned URLs (URLs without user - should be 0)
SELECT COUNT(*) as orphaned_urls
FROM urls
WHERE user_id NOT IN (SELECT id FROM users);


-- ============================================
-- TIPS
-- ============================================

-- ✅ Use LIMIT to avoid large result sets
-- SELECT * FROM urls LIMIT 10;

-- ✅ Use WHERE to filter results
-- SELECT * FROM users WHERE id = 1;

-- ✅ Use ORDER BY to sort results
-- SELECT * FROM urls ORDER BY created_at DESC;

-- ✅ Use JOIN to combine table data
-- SELECT * FROM urls 
-- JOIN users ON urls.user_id = users.id;

-- ✅ Use COUNT, SUM, AVG for statistics
-- SELECT COUNT(*), AVG(click_count) FROM urls;

-- ============================================
-- END OF QUICK REFERENCE
-- ============================================
