package com.NanoURL.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "url_access_log")
public class UrlAccessLog {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "url_id")
    private Url url;
    
    @Column(name = "access_time")
    private LocalDateTime accessTime;
    
    @Column(name = "ip_address")
    private String ipAddress;
    
    @Column(name = "user_agent")
    private String userAgent;
    
    @Column(name = "referer")
    private String referer;
    
    public UrlAccessLog() {
        this.accessTime = LocalDateTime.now();
    }
    
    public UrlAccessLog(Url url, String ipAddress, String userAgent, String referer) {
        this.url = url;
        this.ipAddress = ipAddress;
        this.userAgent = userAgent;
        this.referer = referer;
        this.accessTime = LocalDateTime.now();
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Url getUrl() {
        return url;
    }
    
    public void setUrl(Url url) {
        this.url = url;
    }
    
    public LocalDateTime getAccessTime() {
        return accessTime;
    }
    
    public void setAccessTime(LocalDateTime accessTime) {
        this.accessTime = accessTime;
    }
    
    public String getIpAddress() {
        return ipAddress;
    }
    
    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }
    
    public String getUserAgent() {
        return userAgent;
    }
    
    public void setUserAgent(String userAgent) {
        this.userAgent = userAgent;
    }
    
    public String getReferer() {
        return referer;
    }
    
    public void setReferer(String referer) {
        this.referer = referer;
    }
}
