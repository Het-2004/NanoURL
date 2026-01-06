-- ============================================
-- NanoURL Database Schema Setup
-- ============================================
-- Database: nanourl_db
-- Created: 2026-01-04
-- ============================================

-- Step 1: Create Database
CREATE DATABASE IF NOT EXISTS nanourl_db;
USE nanourl_db;

-- ============================================
-- TABLE 1: USERS
-- ============================================
CREATE TABLE IF NOT EXISTS users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    contact VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_email (email),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Stores user account information';

-- ============================================
-- TABLE 2: URLS (Shortened URLs per User)
-- ============================================
CREATE TABLE IF NOT EXISTS urls (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    short_code VARCHAR(50) UNIQUE NOT NULL,
    long_url VARCHAR(2048) NOT NULL,
    click_count BIGINT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id BIGINT NOT NULL,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_short_code (short_code),
    INDEX idx_user_id (user_id),
    INDEX idx_created_at (created_at),
    CONSTRAINT fk_urls_user FOREIGN KEY (user_id) 
        REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Stores shortened URLs with user association';

-- ============================================
-- TABLE 3: CONTACT_MESSAGES (Form Submissions)
-- ============================================
CREATE TABLE IF NOT EXISTS contact_messages (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_email (email),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Stores contact form submissions';

-- ============================================
-- TABLE 4: LOGIN_HISTORY (User Login Tracking)
-- ============================================
CREATE TABLE IF NOT EXISTS login_history (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip_address VARCHAR(45),
    user_agent VARCHAR(500),
    login_method VARCHAR(50),
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_login_time (login_time),
    CONSTRAINT fk_login_history_user FOREIGN KEY (user_id) 
        REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Stores user login events and tracking';

-- ============================================
-- TABLE 5: URL_ACCESS_LOG (URL Click Tracking)
-- ============================================
CREATE TABLE IF NOT EXISTS url_access_log (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    url_id BIGINT NOT NULL,
    access_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip_address VARCHAR(45),
    user_agent VARCHAR(500),
    referer VARCHAR(500),
    
    FOREIGN KEY (url_id) REFERENCES urls(id) ON DELETE CASCADE,
    INDEX idx_url_id (url_id),
    INDEX idx_access_time (access_time),
    CONSTRAINT fk_url_access_log_url FOREIGN KEY (url_id) 
        REFERENCES urls(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Stores URL access/click events for analytics';

-- ============================================
-- CREATE DATABASE USER (For Security)
-- ============================================
-- Note: Run these commands separately with root account
-- Compatible with MySQL 5.6+ and MariaDB

-- Drop user if exists (for clean setup)
DROP USER IF EXISTS 'nanourl_user'@'localhost';

-- Create application user
CREATE USER 'nanourl_user'@'localhost' IDENTIFIED BY 'NanoURL@SecurePass123';

-- Grant privileges
GRANT ALL PRIVILEGES ON nanourl_db.* TO 'nanourl_user'@'localhost';

-- For production (remote database)
-- DROP USER IF EXISTS 'nanourl_user'@'%';
-- CREATE USER 'nanourl_user'@'%' IDENTIFIED BY 'NanoURL@SecurePass123';
-- GRANT ALL PRIVILEGES ON nanourl_db.* TO 'nanourl_user'@'%';

-- Apply changes
FLUSH PRIVILEGES;

-- ============================================
-- SAMPLE DATA (For Testing)
-- ============================================
-- NOTE: Use these test credentials to login:
-- Email: test@nanourl.com | Password: Test@123
-- Email: admin@nanourl.com | Password: Admin@123

-- Insert Sample Users (passwords are BCrypt hashed)
INSERT INTO users (email, password, name, contact) VALUES
-- Password: Test@123
('test@nanourl.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye0MQ8VpbLZ7VDGL0E/pKpL7VvVTf3QKa', 'Test User', '9876543210'),
-- Password: Admin@123  
('admin@nanourl.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Admin User', '9876543211'),
-- Password: Demo@123
('demo@nanourl.com', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'Demo User', '9876543212');

-- Insert Sample URLs for Test User
INSERT INTO urls (short_code, long_url, click_count, user_id) VALUES
('abc123', 'https://www.example.com/very/long/url/that/needs/shortening', 5, 1),
('def456', 'https://www.github.com/nanourl/project', 12, 1),
('ghi789', 'https://www.linkedin.com/in/testuser', 3, 1);

-- Insert Sample URLs for Admin User
INSERT INTO urls (short_code, long_url, click_count, user_id) VALUES
('jkl012', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 25, 2),
('mno345', 'https://www.twitter.com/adminuser', 8, 2);

-- Insert Sample Contact Messages
INSERT INTO contact_messages (name, email, message) VALUES
('John Customer', 'customer@example.com', 'Great service! Love NanoURL.'),
('Support User', 'support@example.com', 'Need help with my account'),
('Feedback User', 'feedback@example.com', 'Feature request: Custom short codes');

-- ============================================
-- VERIFICATION QUERIES
-- ============================================
-- Run these to verify setup:

-- Show all tables
-- SHOW TABLES;

-- Show users table structure
-- DESCRIBE users;
-- DESCRIBE urls;
-- DESCRIBE contact_messages;

-- Check record counts
-- SELECT COUNT(*) as total_users FROM users;
-- SELECT COUNT(*) as total_urls FROM urls;
-- SELECT COUNT(*) as total_messages FROM contact_messages;

-- ============================================
-- END OF SCHEMA
-- ============================================
