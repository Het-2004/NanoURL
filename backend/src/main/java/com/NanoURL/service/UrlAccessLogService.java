package com.NanoURL.service;

import com.NanoURL.model.Url;
import com.NanoURL.model.UrlAccessLog;
import com.NanoURL.repository.UrlAccessLogRepository;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class UrlAccessLogService {
    
    @Autowired
    private UrlAccessLogRepository urlAccessLogRepository;
    
    @Transactional
    public void recordAccess(Url url, HttpServletRequest request) {
        String ipAddress = getClientIpAddress(request);
        String userAgent = request.getHeader("User-Agent");
        String referer = request.getHeader("Referer");
        
        UrlAccessLog accessLog = new UrlAccessLog(url, ipAddress, userAgent, referer);
        urlAccessLogRepository.save(accessLog);
    }
    
    public List<UrlAccessLog> getUrlAccessHistory(Long urlId) {
        return urlAccessLogRepository.findByUrlIdOrderByAccessTimeDesc(urlId);
    }
    
    public List<UrlAccessLog> getUrlAccessByShortCode(String shortCode) {
        return urlAccessLogRepository.findByUrlShortCodeOrderByAccessTimeDesc(shortCode);
    }
    
    public List<UrlAccessLog> getRecentAccess(int days) {
        LocalDateTime startDate = LocalDateTime.now().minusDays(days);
        return urlAccessLogRepository.findRecentAccess(startDate);
    }
    
    public Long getAccessCount(Long urlId) {
        return urlAccessLogRepository.countByUrlId(urlId);
    }
    
    private String getClientIpAddress(HttpServletRequest request) {
        String xForwardedFor = request.getHeader("X-Forwarded-For");
        if (xForwardedFor != null && !xForwardedFor.isEmpty()) {
            return xForwardedFor.split(",")[0];
        }
        
        String xRealIp = request.getHeader("X-Real-IP");
        if (xRealIp != null && !xRealIp.isEmpty()) {
            return xRealIp;
        }
        
        return request.getRemoteAddr();
    }
}
