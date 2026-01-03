package com.NanoURL.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
public class WelcomeController {

    @GetMapping("/")
    public ResponseEntity<?> welcome() {
        Map<String, Object> response = new HashMap<>();
        response.put("message", "Welcome to NanoURL API");
        response.put("version", "1.0.0");
        response.put("status", "Backend is running!");
        response.put("endpoints", new HashMap<String, String>() {{
            put("Auth", "/api/auth/signin");
            put("Shorten URL", "POST /api/shorten");
            put("History", "/api/urls/history");
            put("H2 Console", "/h2-console");
            put("Health Check", "/health");
        }});
        return ResponseEntity.ok(response);
    }

    @GetMapping("/health")
    public ResponseEntity<?> health() {
        return ResponseEntity.ok(Map.of("status", "UP", "message", "Backend is healthy"));
    }
}
