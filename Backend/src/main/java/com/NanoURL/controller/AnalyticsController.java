package com.NanoURL.controller;

import com.NanoURL.model.LoginHistory;
import com.NanoURL.model.UrlAccessLog;
import com.NanoURL.service.LoginHistoryService;
import com.NanoURL.service.UrlAccessLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/analytics")
public class AnalyticsController {
    
    @Autowired
    private LoginHistoryService loginHistoryService;
    
    @Autowired
    private UrlAccessLogService urlAccessLogService;
    
    /**
     * Get login history for the authenticated user
     */
    @GetMapping("/login-history")
    public ResponseEntity<?> getMyLoginHistory(@RequestAttribute("userId") Long userId) {
        try {
            List<LoginHistory> history = loginHistoryService.getUserLoginHistory(userId);
            List<Map<String, Object>> response = history.stream()
                .map(this::mapLoginHistory)
                .collect(Collectors.toList());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }
    
    /**
     * Get URL access logs for a specific short code
     */
    @GetMapping("/url-access/{shortCode}")
    public ResponseEntity<?> getUrlAccess(@PathVariable String shortCode) {
        try {
            List<UrlAccessLog> logs = urlAccessLogService.getUrlAccessByShortCode(shortCode);
            List<Map<String, Object>> response = logs.stream()
                .map(this::mapUrlAccessLog)
                .collect(Collectors.toList());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }
    
    /**
     * Get recent logins (last N days)
     */
    @GetMapping("/recent-logins")
    public ResponseEntity<?> getRecentLogins(@RequestParam(defaultValue = "7") int days) {
        try {
            List<LoginHistory> history = loginHistoryService.getRecentLogins(days);
            List<Map<String, Object>> response = history.stream()
                .map(this::mapLoginHistory)
                .collect(Collectors.toList());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }
    
    /**
     * Get recent URL accesses (last N days)
     */
    @GetMapping("/recent-access")
    public ResponseEntity<?> getRecentAccess(@RequestParam(defaultValue = "7") int days) {
        try {
            List<UrlAccessLog> logs = urlAccessLogService.getRecentAccess(days);
            List<Map<String, Object>> response = logs.stream()
                .map(this::mapUrlAccessLog)
                .collect(Collectors.toList());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }
    
    /**
     * Get access count for a specific URL
     */
    @GetMapping("/url-access-count/{urlId}")
    public ResponseEntity<?> getAccessCount(@PathVariable Long urlId) {
        try {
            Long count = urlAccessLogService.getAccessCount(urlId);
            return ResponseEntity.ok(Map.of("urlId", urlId, "accessCount", count));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }
    
    private Map<String, Object> mapLoginHistory(LoginHistory lh) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", lh.getId());
        map.put("userId", lh.getUser().getId());
        map.put("userEmail", lh.getUser().getEmail());
        map.put("loginTime", lh.getLoginTime().toString());
        map.put("ipAddress", lh.getIpAddress());
        map.put("userAgent", lh.getUserAgent());
        map.put("loginMethod", lh.getLoginMethod());
        return map;
    }
    
    private Map<String, Object> mapUrlAccessLog(UrlAccessLog ual) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", ual.getId());
        map.put("urlId", ual.getUrl().getId());
        map.put("shortCode", ual.getUrl().getShortCode());
        map.put("longUrl", ual.getUrl().getLongUrl());
        map.put("accessTime", ual.getAccessTime().toString());
        map.put("ipAddress", ual.getIpAddress());
        map.put("userAgent", ual.getUserAgent());
        map.put("referer", ual.getReferer());
        return map;
    }
}
