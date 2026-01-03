package com.NanoURL.config;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import jakarta.servlet.http.HttpServletRequest;

import java.util.HashMap;
import java.util.Map;

@RestController
public class CustomErrorController {

    @RequestMapping("/error")
    public ResponseEntity<?> handleError(HttpServletRequest request) {
        Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
        
        Map<String, Object> error = new HashMap<>();
        error.put("status", statusCode != null ? statusCode : 500);
        error.put("error", "Not Found");
        error.put("message", "The requested endpoint does not exist");
        error.put("hint", "Try accessing /health or /api/auth/signin");
        error.put("timestamp", System.currentTimeMillis());
        
        return ResponseEntity.status(statusCode != null ? statusCode : 500).body(error);
    }
}
