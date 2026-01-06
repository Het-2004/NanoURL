# 🔐 Security Guide - Complete Security Practices

## Comprehensive Security Guide for NanoURL

---

## **Part 1: Security Overview**

### Security Layers

1. **Frontend Security** - Client-side protection
2. **API Security** - Backend authentication & authorization
3. **Database Security** - Data protection & access control
4. **Infrastructure Security** - Server & deployment security
5. **User Security** - Password & data protection

---

## **Part 2: Frontend Security**

### 1. Input Validation

**Always validate user input:**

```javascript
// Email validation
const validateEmail = (email) => {
  const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return regex.test(email);
};

// URL validation
const validateUrl = (url) => {
  try {
    new URL(url);
    return true;
  } catch {
    return false;
  }
};

// Usage
if (!validateEmail(email)) {
  setError('Invalid email format');
  return;
}
```

### 2. XSS (Cross-Site Scripting) Prevention

**Never inject HTML directly:**

```javascript
// ❌ DANGEROUS - Don't do this
<div dangerouslySetInnerHTML={{ __html: userInput }} />

// ✅ SAFE - Use text content
<div>{userInput}</div>

// ✅ SAFE - Escape HTML
function escapeHtml(text) {
  const map = {
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#039;'
  };
  return text.replace(/[&<>"']/g, m => map[m]);
}
```

### 3. CSRF (Cross-Site Request Forgery) Prevention

**Use CSRF tokens:**

```javascript
// Get CSRF token from response headers
const getCSRFToken = () => {
  return document.querySelector('meta[name="csrf-token"]')?.content;
};

// Send with requests
api.post('/api/urls/shorten', data, {
  headers: {
    'X-CSRF-Token': getCSRFToken()
  }
});
```

### 4. Secure Token Storage

**Store JWT securely:**

```javascript
// ✅ Acceptable for development
localStorage.setItem('token', jwtToken);
const token = localStorage.getItem('token');

// For production, consider:
// - httpOnly cookies (more secure)
// - Session storage (clears on close)
// - SessionStorage + cookie combination
```

**Remove token on logout:**

```javascript
const logout = () => {
  localStorage.removeItem('token');
  localStorage.removeItem('user');
  window.location.href = '/auth';
};
```

### 5. CORS Configuration

**Only allow known origins:**

```javascript
// Server-side (backend)
registry.addMapping("/**")
  .allowedOrigins(
    "http://localhost:5173",
    "https://frontend.onrender.com"
  )
  .allowedMethods("GET", "POST", "PUT", "DELETE")
  .allowedHeaders("*")
  .allowCredentials(true);
```

### 6. Content Security Policy

**Add CSP headers:**

```html
<!-- In HTML head -->
<meta http-equiv="Content-Security-Policy" 
  content="default-src 'self'; 
           script-src 'self' 'unsafe-inline'; 
           style-src 'self' 'unsafe-inline'; 
           img-src 'self' data: https:; 
           connect-src 'self' https://api.example.com">
```

---

## **Part 3: Backend Security**

### 1. Password Security

**Hash passwords with bcrypt:**

```java
// Don't store plain passwords!
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

// Hash password on registration
String hashedPassword = encoder.encode(password);
user.setPassword(hashedPassword);

// Verify password on login
boolean isMatch = encoder.matches(inputPassword, storedHash);
```

### 2. JWT Security

**Generate secure JWT tokens:**

```java
// Use strong secret (minimum 256 bits)
String secret = "your-very-long-secret-key-minimum-32-characters";

// Set short expiration (1 day)
long expiration = 86400000; // 24 hours

// Create token
String token = Jwts.builder()
  .setSubject(email)
  .setIssuedAt(new Date())
  .setExpiration(new Date(System.currentTimeMillis() + expiration))
  .signWith(SignatureAlgorithm.HS512, secret)
  .compact();

// Validate token
try {
  Jwts.parser().setSigningKey(secret).parseClaimsJws(token);
  return true;
} catch (JwtException e) {
  return false;
}
```

### 3. Spring Security Configuration

**Secure endpoint access:**

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {
  
  @Bean
  public SecurityFilterChain filterChain(HttpSecurity http) 
    throws Exception {
    http
      .csrf().disable()
      .authorizeRequests()
        .antMatchers("/api/auth/**").permitAll()
        .antMatchers("/").permitAll()
        .anyRequest().authenticated()
      .and()
      .sessionManagement()
        .sessionFixationProtection(SessionFixationProtection.MIGRATE_SESSION)
      .and()
      .addFilterBefore(jwtAuthenticationFilter, 
        UsernamePasswordAuthenticationFilter.class);
    
    return http.build();
  }
  
  @Bean
  public PasswordEncoder passwordEncoder() {
    return new BCryptPasswordEncoder();
  }
}
```

### 4. User Data Isolation

**Ensure users only access their own data:**

```java
@GetMapping("/history")
@PreAuthorize("isAuthenticated()")
public ResponseEntity<?> getUserHistory() {
  // Get authenticated user from JWT
  User currentUser = getCurrentUser();
  
  // Query only this user's URLs
  List<Url> urls = urlRepository.findByUserId(currentUser.getId());
  
  return ResponseEntity.ok(urls);
}

// ❌ WRONG - Returns all URLs
public List<Url> getAllUrls() {
  return urlRepository.findAll(); // SECURITY ISSUE!
}

// ✅ RIGHT - Filters by user
public List<Url> getUserUrls(User user) {
  return urlRepository.findByUserId(user.getId());
}
```

### 5. SQL Injection Prevention

**Use parameterized queries:**

```java
// ❌ DANGEROUS - Never do this
String query = "SELECT * FROM users WHERE email = '" + email + "'";
List<User> users = entityManager.createNativeQuery(query).getResultList();

// ✅ SAFE - Use named parameters
@Query("SELECT u FROM User u WHERE u.email = :email")
Optional<User> findByEmail(@Param("email") String email);

// ✅ SAFE - Use repository methods
Optional<User> user = userRepository.findByEmail(email);
```

### 6. Input Sanitization

**Validate all input:**

```java
@PostMapping("/api/urls/shorten")
public ResponseEntity<?> shortenUrl(@Valid @RequestBody UrlRequest request) {
  // @Valid triggers validation
  
  // Additional validation
  if (request.getLongUrl() == null || request.getLongUrl().isEmpty()) {
    return ResponseEntity.badRequest()
      .body(new ErrorResponse("URL cannot be empty"));
  }
  
  // Validate URL format
  try {
    new URL(request.getLongUrl());
  } catch (MalformedURLException e) {
    return ResponseEntity.badRequest()
      .body(new ErrorResponse("Invalid URL format"));
  }
  
  // Continue processing
  return ResponseEntity.ok(shortenedUrl);
}
```

### 7. Rate Limiting

**Prevent brute force attacks:**

```java
@Configuration
public class RateLimitConfig {
  
  @Bean
  public RateLimiter rateLimiter() {
    // 10 requests per minute per IP
    return RateLimiter.create(10.0 / 60.0);
  }
}

// Usage
@PostMapping("/api/auth/login")
public ResponseEntity<?> login(@RequestBody LoginRequest request) {
  if (!rateLimiter.tryAcquire()) {
    return ResponseEntity.status(429) // Too Many Requests
      .body(new ErrorResponse("Too many login attempts"));
  }
  
  // Process login
  return ResponseEntity.ok(authResponse);
}
```

---

## **Part 4: Database Security**

### 1. Strong Database User

**Create user with limited privileges:**

```sql
-- Create user
CREATE USER 'nanourl_prod'@'localhost' 
IDENTIFIED BY 'StrongPassword@2025!';

-- Grant only needed permissions
GRANT SELECT, INSERT, UPDATE, DELETE 
ON nanourl_db.* 
TO 'nanourl_prod'@'localhost';

-- Do NOT grant administrative privileges
FLUSH PRIVILEGES;
```

### 2. Password Requirements

**Use strong passwords:**

✅ Minimum 12 characters  
✅ Mix of uppercase & lowercase  
✅ Include numbers  
✅ Include special characters (!@#$%^&*)  
✅ No common words  
✅ Change every 90 days  

**Example:**
```
MySecureDB@Password2025
NanoURL$Prod#Secure123
Database!Admin#2025@Secure
```

### 3. Database Encryption

**Enable SSL for connections:**

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/nanourl_db?useSSL=true&serverSslCertificate=/path/to/cert.pem
```

**Configure MySQL SSL:**

```sql
ALTER USER 'nanourl_prod'@'localhost' REQUIRE SSL;
FLUSH PRIVILEGES;
```

### 4. Access Control

**Restrict database access:**

```sql
-- Only allow localhost
ALTER USER 'nanourl_prod'@'localhost' IDENTIFIED BY 'password';

-- NOT this (allows remote)
ALTER USER 'nanourl_prod'@'%' IDENTIFIED BY 'password';
```

### 5. Backup Security

**Backup passwords separately:**

```bash
# ❌ DON'T include password in backup file
mysqldump -u root -p nanourl_db > backup.sql

# ✅ DO prompt for password
mysqldump -u root -p nanourl_db > backup.sql
# Enter password when prompted

# Secure backup file
chmod 600 backup.sql
```

### 6. Data Masking

**Hide sensitive data in logs:**

```java
// Mask passwords in logs
String logEntry = "User: " + email + ", Status: SUCCESS";
// NOT: "User: " + email + ", Password: " + password;

// Mask email in output
String maskedEmail = email.replaceAll("(?<=.{2}).(?=.*@)", "*");
// alice@example.com → al***@example.com
```

---

## **Part 5: Environment Variables Security**

### 1. Never Commit Secrets

**Add to `.gitignore`:**

```
.env
.env.local
.env.*.local
.env.secret
application-secret.yaml
```

### 2. Use Environment Variables

**Set in system environment:**

```bash
# Windows
set JWT_SECRET=your-secret-key
set DB_PASSWORD=your-password

# Linux/Mac
export JWT_SECRET=your-secret-key
export DB_PASSWORD=your-password
```

### 3. Docker Secrets

**Use Docker secrets for production:**

```dockerfile
FROM openjdk:21-slim

# Don't copy secrets
# COPY .env /app/

ENV JWT_SECRET=${JWT_SECRET}
ENV DB_PASSWORD=${DB_PASSWORD}

# Get secrets from environment
CMD ["java", "-jar", "app.jar"]
```

### 4. CI/CD Secrets

**GitHub Actions example:**

```yaml
name: Deploy

on: [push]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Deploy with secrets
        env:
          JWT_SECRET: ${{ secrets.JWT_SECRET }}
          DB_PASSWORD: ${{ secrets.DB_PASSWORD }}
          APP_BASE_URL: ${{ secrets.APP_BASE_URL }}
        run: |
          ./deploy.sh
```

---

## **Part 6: HTTPS & TLS**

### 1. Enable HTTPS

**In production (Render/AWS):**

HTTPS is automatic. No configuration needed!

### 2. HTTPS Configuration (Self-hosted)

```yaml
server:
  port: 8443
  ssl:
    key-store: classpath:keystore.p12
    key-store-password: ${KEYSTORE_PASSWORD}
    key-store-type: PKCS12
```

### 3. Generate SSL Certificate

```bash
# Generate private key
openssl genrsa -out private_key.pem 2048

# Generate certificate
openssl req -new -x509 -key private_key.pem \
  -out certificate.pem -days 365

# Convert to PKCS12
openssl pkcs12 -export \
  -in certificate.pem \
  -inkey private_key.pem \
  -out keystore.p12
```

---

## **Part 7: API Security**

### 1. Authentication Required

**Protect all sensitive endpoints:**

```java
@PostMapping("/api/urls/shorten")
@PreAuthorize("isAuthenticated()")
public ResponseEntity<?> shortenUrl(@RequestBody UrlRequest request) {
  // Only authenticated users can access
  return ResponseEntity.ok(shortenedUrl);
}
```

### 2. Rate Limiting

**Prevent abuse:**

```java
@Configuration
public class RateLimitingConfig {
  
  @Bean
  public RateLimiter shortenUrlLimiter() {
    // 100 requests per hour per user
    return RateLimiter.create(100.0 / 3600.0);
  }
}
```

### 3. API Versioning

**Maintain backward compatibility:**

```
/api/v1/urls/shorten
/api/v2/urls/shorten
```

### 4. Error Messages

**Don't reveal sensitive information:**

```java
// ❌ WRONG - Reveals database structure
{
  "error": "User not found in users table",
  "database": "mysql_5.7"
}

// ✅ RIGHT - Generic message
{
  "error": "Invalid credentials"
}
```

---

## **Part 8: Logging & Monitoring**

### 1. Secure Logging

**Don't log sensitive data:**

```java
// ❌ WRONG - Logs password
logger.info("Login attempt: email=" + email + ", password=" + password);

// ✅ RIGHT - No password
logger.info("Login attempt: email=" + email);

// ✅ RIGHT - Log important events
logger.warn("Failed login attempt for email: " + email);
logger.error("Database connection failed");
logger.info("User registered: " + email);
```

### 2. Audit Trail

**Track important actions:**

```java
@Entity
public class AuditLog {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;
  
  private String action; // "login", "create_url", "delete_url"
  private String email;
  private String ipAddress;
  private LocalDateTime timestamp;
}

// Usage
auditLog.setAction("url_created");
auditLog.setEmail(user.getEmail());
auditLog.setIpAddress(getClientIp(request));
auditLogRepository.save(auditLog);
```

### 3. Monitoring Alerts

**Set up alerts for:**
- Multiple failed login attempts
- Unusual database access
- High error rates
- Suspicious IP addresses

---

## **Part 9: Security Checklist**

### Frontend
- ✅ Input validation on all forms
- ✅ XSS prevention (no dangerouslySetInnerHTML)
- ✅ CSRF tokens for state-changing requests
- ✅ Secure token storage
- ✅ HTTPS in production
- ✅ Content Security Policy headers
- ✅ No sensitive data in localStorage

### Backend
- ✅ Password hashing with bcrypt
- ✅ JWT token validation
- ✅ Spring Security configured
- ✅ User data isolation implemented
- ✅ SQL injection prevention (parameterized queries)
- ✅ Input sanitization
- ✅ Rate limiting on login
- ✅ CORS properly configured
- ✅ Error messages don't reveal details
- ✅ Secrets in environment variables

### Database
- ✅ Strong database user password
- ✅ Limited user privileges
- ✅ SSL/TLS connection
- ✅ Regular backups
- ✅ Access control by IP
- ✅ Encryption at rest (if available)
- ✅ Password hashing (bcrypt)

### Infrastructure
- ✅ HTTPS in production
- ✅ Firewall configured
- ✅ Security headers set
- ✅ Logging enabled
- ✅ Monitoring alerts configured
- ✅ Regular updates applied
- ✅ Secrets management in place

### Processes
- ✅ Security reviews before deployment
- ✅ Password reset mechanism
- ✅ User access control
- ✅ Data privacy policy
- ✅ Incident response plan
- ✅ Regular security audits

---

## **Part 10: Common Vulnerabilities to Avoid**

### OWASP Top 10

1. **Injection** → Use parameterized queries
2. **Broken Authentication** → Use strong JWT
3. **Sensitive Data Exposure** → Use HTTPS
4. **XML External Entities (XXE)** → Disable XML parsing
5. **Broken Access Control** → Check user permissions
6. **Security Misconfiguration** → Review all configs
7. **Cross-Site Scripting (XSS)** → Sanitize input
8. **Insecure Deserialization** → Validate objects
9. **Using Components with Known Vulnerabilities** → Update dependencies
10. **Insufficient Logging & Monitoring** → Log important events

---

## **Quick Security Checklist**

- ✅ Change all default passwords
- ✅ Use HTTPS everywhere
- ✅ Hash passwords with bcrypt
- ✅ Validate all input
- ✅ Use parameterized SQL queries
- ✅ Store secrets in environment variables
- ✅ Implement rate limiting
- ✅ Add logging & monitoring
- ✅ Use strong JWT secrets
- ✅ Set up CORS correctly

---

## **Useful Resources**

- OWASP: https://owasp.org/
- Spring Security: https://spring.io/projects/spring-security
- JWT Best Practices: https://tools.ietf.org/html/rfc8725
- MySQL Security: https://dev.mysql.com/doc/
- SSL/TLS: https://www.ssl.com/

---

## **More Documentation**

- Frontend Guide: [FRONTEND_GUIDE.md](FRONTEND_GUIDE.md)
- Backend Guide: [BACKEND_GUIDE.md](BACKEND_GUIDE.md)
- Database Setup: [DATABASE_SETUP.md](DATABASE_SETUP.md)
- Deployment: [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)
- All Docs: [README.md](README.md)

---

**Your project is now secure! 🔐🚀**
