# ⚙️ Backend Guide - Complete Setup & Configuration

## Spring Boot Backend Setup, Development, and Deployment

---

## **Part 1: Backend Overview**

### Technology Stack
- **Framework:** Spring Boot 4.0.1
- **Language:** Java 21
- **Build Tool:** Maven
- **Database:** MySQL 8.0
- **ORM:** Hibernate/JPA
- **Authentication:** JWT (Spring Security)
- **API:** REST
- **Server:** Embedded Tomcat (port 8080)

### Project Structure

```
backend/
├── src/main/java/com/NanoURL/
│   ├── NanoUrlApplication.java ............... Main application
│   ├── config/
│   │   ├── JwtRequestFilter.java ........... JWT authentication
│   │   ├── SecurityConfig.java ............ Spring Security
│   │   └── WebConfig.java ................. CORS & web config
│   ├── controller/
│   │   ├── AuthController.java ............ Login/Signup
│   │   ├── UrlController.java ............ URL shortening
│   │   ├── RedirectController.java ....... Redirect logic
│   │   ├── ContactController.java ........ Contact form
│   │   └── WelcomeController.java ........ Welcome endpoint
│   ├── dto/
│   │   ├── LoginRequest.java ............. Login DTO
│   │   ├── SignupRequest.java ........... Signup DTO
│   │   └── AuthResponse.java ............ Auth response
│   ├── model/
│   │   ├── User.java .................... User entity
│   │   ├── Url.java .................... URL entity
│   │   └── ContactMessage.java ......... Contact entity
│   ├── repository/
│   │   ├── UserRepository.java ......... User data access
│   │   ├── UrlRepository.java ......... URL data access
│   │   └── ContactRepository.java ... Contact data access
│   ├── service/
│   │   ├── AuthService.java ........... Authentication logic
│   │   ├── UrlService.java ........... URL shortening logic
│   │   └── UserService.java ......... User service
│   ├── util/
│   │   └── JwtUtil.java ............. JWT token handling
│   └── exception/
│       └── GlobalExceptionHandler.java . Error handling
├── src/main/resources/
│   ├── application.yaml ............... Development config
│   ├── application-prod.yaml ......... Production config
│   ├── templates/ ................... HTML templates
│   └── static/ ..................... Static files
├── pom.xml ......................... Maven dependencies
├── mvnw ........................... Maven wrapper (Linux/Mac)
└── mvnw.cmd ....................... Maven wrapper (Windows)
```

---

## **Part 2: Installation & Setup**

### Prerequisites

- Java 21+ installed
- Maven installed (or use mvnw)
- MySQL 8.0+ running
- Git

### Step 1: Navigate to Backend

```bash
cd backend
```

### Step 2: Verify Java Installation

```bash
java -version
javac -version
```

Should show Java 21+

### Step 3: Build Project

**Windows:**
```bash
mvnw clean install
```

**Mac/Linux:**
```bash
./mvnw clean install
```

This:
- Downloads dependencies
- Compiles Java code
- Runs tests
- Creates JAR file

### Step 4: Start Backend

**Windows:**
```bash
mvnw spring-boot:run
```

**Mac/Linux:**
```bash
./mvnw spring-boot:run
```

Expected output:
```
Started NanoUrlApplication in X.XXX seconds (JVM running for X.XXX)
```

### Step 5: Verify Backend is Running

Open browser: **http://localhost:8080**

Should show: **"Welcome to NanoURL!"**

---

## **Part 3: Backend Configuration**

### Database Configuration

**`src/main/resources/application.yaml`:**

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/nanourl_db?useSSL=false&serverTimezone=UTC
    username: nanourl_user
    password: NanoURL@SecurePass123
    driver-class-name: com.mysql.cj.jdbc.Driver
  
  jpa:
    hibernate:
      ddl-auto: update
    properties:
      hibernate:
        dialect: org.hibernate.dialect.MySQLDialect
        format_sql: true

server:
  port: 8080

app:
  base-url: http://localhost:8080

jwt:
  secret: your-secret-key-change-in-production
  expiration: 86400000
```

### Production Configuration

**`src/main/resources/application-prod.yaml`:**

```yaml
spring:
  datasource:
    url: ${DB_URL:jdbc:mysql://localhost:3306/nanourl_db}
    username: ${DB_USER:nanourl_prod}
    password: ${DB_PASSWORD}
    driver-class-name: com.mysql.cj.jdbc.Driver
  
  jpa:
    hibernate:
      ddl-auto: validate
    properties:
      hibernate:
        dialect: org.hibernate.dialect.MySQLDialect

server:
  port: ${PORT:8080}

app:
  base-url: ${APP_BASE_URL}

jwt:
  secret: ${JWT_SECRET}
  expiration: 86400000
```

### Change Port

To run on different port:
```yaml
server:
  port: 9090
```

Then visit: **http://localhost:9090**

---

## **Part 4: Maven Dependencies**

### Key Dependencies in `pom.xml`

```xml
<!-- Spring Boot Starter Web -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>

<!-- Spring Security -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>

<!-- Spring Data JPA -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>

<!-- MySQL Driver -->
<dependency>
    <groupId>com.mysql</groupId>
    <artifactId>mysql-connector-j</artifactId>
    <version>8.0.33</version>
</dependency>

<!-- JWT -->
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-api</artifactId>
    <version>0.11.5</version>
</dependency>
```

---

## **Part 5: API Endpoints**

### Authentication Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/signup` | Register new user |
| POST | `/api/auth/login` | Login with credentials |

### URL Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/urls/shorten` | Create short URL |
| GET | `/api/urls/history` | Get user's URLs |
| DELETE | `/api/urls/{id}` | Delete URL |
| GET | `/{shortCode}` | Redirect to original URL |

### Other Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | Welcome page |
| POST | `/api/contact` | Submit contact form |

---

## **Part 6: Entity Models**

### User Entity

**`src/main/java/com/NanoURL/model/User.java`:**

```java
@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(unique = true, nullable = false)
    private String email;
    
    @Column(nullable = false)
    private String password;
    
    private String name;
    private String contact;
    
    @CreationTimestamp
    private LocalDateTime createdAt;
    
    @UpdateTimestamp
    private LocalDateTime updatedAt;
}
```

### URL Entity

**`src/main/java/com/NanoURL/model/Url.java`:**

```java
@Entity
@Table(name = "urls")
public class Url {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(unique = true, nullable = false)
    private String shortCode;
    
    @Column(columnDefinition = "LONGTEXT", nullable = false)
    private String longUrl;
    
    @Column(nullable = false)
    private Integer clickCount = 0;
    
    @CreationTimestamp
    private LocalDateTime createdAt;
    
    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
}
```

---

## **Part 7: Controllers**

### AuthController

**Signup:**
```java
@PostMapping("/signup")
public ResponseEntity<?> signup(@RequestBody SignupRequest request) {
    // Create user
    // Hash password
    // Save to database
    // Return JWT token
}
```

**Login:**
```java
@PostMapping("/login")
public ResponseEntity<?> login(@RequestBody LoginRequest request) {
    // Find user by email
    // Verify password
    // Generate JWT token
    // Return token
}
```

### UrlController

**Shorten URL:**
```java
@PostMapping("/shorten")
public ResponseEntity<?> shortenUrl(@RequestBody UrlRequest request) {
    // Get authenticated user
    // Generate short code
    // Save URL
    // Return short URL
}
```

**Get History:**
```java
@GetMapping("/history")
public ResponseEntity<?> getUserHistory() {
    // Get authenticated user
    // Fetch user's URLs
    // Return list
}
```

---

## **Part 8: Security Configuration**

### Spring Security Setup

**`src/main/java/com/NanoURL/config/SecurityConfig.java`:**

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf().disable()
            .authorizeRequests()
                .antMatchers("/api/auth/**").permitAll()
                .antMatchers("/**").permitAll()
                .anyRequest().authenticated()
            .and()
            .addFilterBefore(jwtRequestFilter, UsernamePasswordAuthenticationFilter.class);
        
        return http.build();
    }
}
```

### JWT Token Handling

**Generate token:**
```java
public String generateToken(String email) {
    return Jwts.builder()
        .setSubject(email)
        .setIssuedAt(new Date())
        .setExpiration(new Date(System.currentTimeMillis() + expiration))
        .signWith(SignatureAlgorithm.HS512, secret)
        .compact();
}
```

**Validate token:**
```java
public boolean validateToken(String token) {
    try {
        Jwts.parser().setSigningKey(secret).parseClaimsJws(token);
        return true;
    } catch (JwtException | IllegalArgumentException e) {
        return false;
    }
}
```

---

## **Part 9: Development Workflow**

### Common Maven Commands

```bash
# Build without tests
mvn clean install -DskipTests

# Run application
mvn spring-boot:run

# Run tests
mvn test

# Build JAR
mvn clean package

# View dependency tree
mvn dependency:tree
```

### IDE Setup

**IntelliJ IDEA:**
1. File → Open
2. Select backend folder
3. Click Open as Project
4. Wait for indexing
5. Right-click pom.xml → Maven → Reload project

**VS Code:**
1. Install "Extension Pack for Java"
2. Install "Spring Boot Extension Pack"
3. Open backend folder
4. Extensions auto-enable

---

## **Part 10: Database Integration**

### Create Database

```bash
mysql -u root -p < database/database_schema.sql
```

### Verify Connection

In application logs, you should see:
```
HikariPool - Connection is working
```

### Check Database

```bash
mysql -u nanourl_user -p nanourl_db
SELECT * FROM users;
```

---

## **Part 11: Testing Endpoints**

### Using Postman

1. Import collection
2. Set base URL: `http://localhost:8080`
3. Test endpoints

### Using cURL

**Login:**
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"alice@example.com","password":"password"}'
```

**Shorten URL:**
```bash
curl -X POST http://localhost:8080/api/urls/shorten \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{"longUrl":"https://example.com"}'
```

---

## **Part 12: Building for Production**

### Create JAR File

```bash
mvn clean package
```

Creates `target/nanourl-0.0.1-SNAPSHOT.jar`

### Run JAR

```bash
java -jar target/nanourl-0.0.1-SNAPSHOT.jar
```

### Docker Build

**Dockerfile:**
```dockerfile
FROM openjdk:21-slim
WORKDIR /app
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src
RUN chmod +x mvnw && ./mvnw clean package -DskipTests
EXPOSE 8080
CMD ["java", "-jar", "target/*.jar"]
```

**Build image:**
```bash
docker build -t nanourl-backend .
```

**Run container:**
```bash
docker run -p 8080:8080 nanourl-backend
```

---

## **Part 13: Deployment to Render**

### Step 1: Prepare

Push to GitHub:
```bash
git add .
git commit -m "Prepare for deployment"
git push origin main
```

### Step 2: Create Web Service

1. Go to https://render.com
2. Click "New +" → "Web Service"
3. Connect GitHub repository

### Step 3: Configure

**Settings:**
- Name: `nanourl-backend`
- Environment: Docker
- Region: Oregon
- Branch: main

**Environment Variables:**
```
APP_BASE_URL=https://nanourl-backend.onrender.com
DB_URL=jdbc:mysql://localhost:3306/nanourl_db
DB_USER=nanourl_prod
DB_PASSWORD=YourPassword
JWT_SECRET=YourSecretKey
```

### Step 4: Deploy

Click "Create Web Service"

Wait for build and deployment (5-10 minutes)

---

## **Part 14: Monitoring & Debugging**

### View Logs

**Development:**
```bash
mvn spring-boot:run
```

Logs appear in console

**Production:**
Go to Render dashboard → Logs tab

### Common Issues

### Issue: Application won't start
**Check:**
- Java version: `java -version`
- MySQL running
- Port 8080 available
- pom.xml syntax correct

### Issue: Database connection error
**Check:**
- MySQL running: `mysql -u root -p`
- Credentials in application.yaml correct
- Database exists: `SHOW DATABASES;`

### Issue: JWT errors
**Check:**
- JWT secret set correctly
- Token format: `Bearer <token>`
- Token not expired

### Issue: CORS errors
**Check:**
- WebConfig.java has correct frontend URL
- Frontend URL in CORS whitelist
- Credentials enabled in frontend

---

## **Part 15: Performance Optimization**

### Connection Pooling

**application.yaml:**
```yaml
spring:
  datasource:
    hikari:
      maximum-pool-size: 20
      minimum-idle: 5
      connection-timeout: 20000
```

### Query Optimization

Use proper indexes:
```java
@Entity
@Table(name = "urls", indexes = {
    @Index(name = "idx_short_code", columnList = "short_code"),
    @Index(name = "idx_user_id", columnList = "user_id")
})
public class Url { ... }
```

### Caching

```java
@Cacheable("urls")
public List<Url> getUserUrls(Long userId) {
    return urlRepository.findByUserId(userId);
}
```

---

## **Quick Commands**

```bash
# Development
mvn spring-boot:run

# Build
mvn clean package

# Build JAR
mvn clean package -DskipTests

# Run JAR
java -jar target/*.jar

# Tests
mvn test

# View logs
mvn spring-boot:run
```

---

## **More Documentation**

- Frontend Setup: [FRONTEND_GUIDE.md](FRONTEND_GUIDE.md)
- Security Guide: [SECURITY_GUIDE.md](SECURITY_GUIDE.md)
- Database: [MYSQL_COMPLETE_SETUP.md](MYSQL_COMPLETE_SETUP.md)
- Deployment: [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)
- All Docs: [README.md](README.md)

---

**Backend setup complete! Ready to build! ⚙️🚀**
