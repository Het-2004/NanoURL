package com.NanoURL.service;

import com.NanoURL.model.LoginHistory;
import com.NanoURL.model.User;
import com.NanoURL.repository.LoginHistoryRepository;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class LoginHistoryService {
    
    @Autowired
    private LoginHistoryRepository loginHistoryRepository;
    
    @Transactional
    public void recordLogin(User user, HttpServletRequest request, String loginMethod) {
        String ipAddress = getClientIpAddress(request);
        String userAgent = request.getHeader("User-Agent");
        
        LoginHistory loginHistory = new LoginHistory(user, ipAddress, userAgent, loginMethod);
        loginHistoryRepository.save(loginHistory);
    }
    
    public List<LoginHistory> getUserLoginHistory(Long userId) {
        return loginHistoryRepository.findByUserIdOrderByLoginTimeDesc(userId);
    }
    
    public List<LoginHistory> getRecentLogins(int days) {
        LocalDateTime startDate = LocalDateTime.now().minusDays(days);
        return loginHistoryRepository.findRecentLogins(startDate);
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
