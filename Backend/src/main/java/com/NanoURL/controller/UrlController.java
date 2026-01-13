package com.NanoURL.controller;

import com.NanoURL.model.Url;
import com.NanoURL.model.User;
import com.NanoURL.repository.UrlRepository;
import com.NanoURL.service.UrlService;
import com.NanoURL.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api")
public class UrlController {

    private final UrlService urlService;
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private UrlRepository urlRepository;
    
    @Value("${app.base-url:http://localhost:8080}")
    private String baseUrl;

    public UrlController(UrlService urlService) {
        this.urlService = urlService;
    }

    @PostMapping("/shorten")
    public ResponseEntity<?> shortenUrl(@RequestBody Map<String, String> request, HttpServletRequest httpRequest) {
        try {
            String longUrl = request.get("url");
            if (longUrl == null || longUrl.trim().isEmpty()) {
                return ResponseEntity.badRequest()
                    .body(Map.of("error", "URL is required"));
            }
            
            // Get userId from request attribute (set by JwtRequestFilter)
            Long userId = (Long) httpRequest.getAttribute("userId");
            
            String shortCode = urlService.shortenUrl(longUrl, userId);
            return ResponseEntity.ok(Map.of(
                "shortCode", shortCode,
                "shortUrl", baseUrl + "/" + shortCode,
                "longUrl", longUrl
            ));
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                .body(Map.of("error", "Failed to shorten URL: " + e.getMessage()));
        }
    }

    @GetMapping("/{code}")
    public ResponseEntity<?> redirect(@PathVariable String code, jakarta.servlet.http.HttpServletResponse response) {
        try {
            String longUrl = urlService.getOriginalUrl(code);
            response.sendRedirect(longUrl);
            return null;
        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }
    }
    
    @GetMapping("/urls/history")
    public ResponseEntity<?> getUserHistory(HttpServletRequest request) {
        try {
            Long userId = (Long) request.getAttribute("userId");
            if (userId == null) {
                return ResponseEntity.badRequest()
                    .body(Map.of("error", "User not authenticated"));
            }
            
            // Fetch URLs directly from repository to avoid lazy loading issues
            List<Url> userUrls = urlRepository.findByUserIdOrderByCreatedAtDesc(userId);
            
            List<Map<String, Object>> history = userUrls.stream()
                    .map(url -> {
                        Map<String, Object> urlMap = new HashMap<>();
                        urlMap.put("id", url.getId());
                        urlMap.put("shortCode", url.getShortCode());
                        urlMap.put("shortUrl", baseUrl + "/" + url.getShortCode());
                        urlMap.put("longUrl", url.getLongUrl());
                        urlMap.put("clickCount", url.getClickCount());
                        urlMap.put("createdAt", url.getCreatedAt().toString());
                        return urlMap;
                    })
                    .collect(Collectors.toList());
            
            return ResponseEntity.ok(history);
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                .body(Map.of("error", "Failed to fetch history: " + e.getMessage()));
        }
    }
    
    @DeleteMapping("/urls/{id}")
    public ResponseEntity<?> deleteUrl(@PathVariable Long id, HttpServletRequest request) {
        try {
            Long userId = (Long) request.getAttribute("userId");
            if (userId == null) {
                return ResponseEntity.badRequest()
                    .body(Map.of("error", "User not authenticated"));
            }
            
            urlService.deleteUrl(id, userId);
            return ResponseEntity.ok(Map.of("message", "URL deleted successfully"));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                .body(Map.of("error", e.getMessage()));
        }
    }
}
