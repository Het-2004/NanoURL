package com.NanoURL.repository;

import com.NanoURL.model.UrlAccessLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface UrlAccessLogRepository extends JpaRepository<UrlAccessLog, Long> {
    
    List<UrlAccessLog> findByUrlIdOrderByAccessTimeDesc(Long urlId);
    
    List<UrlAccessLog> findByUrlShortCodeOrderByAccessTimeDesc(String shortCode);
    
    @Query("SELECT ual FROM UrlAccessLog ual WHERE ual.accessTime >= :startDate ORDER BY ual.accessTime DESC")
    List<UrlAccessLog> findRecentAccess(LocalDateTime startDate);
    
    @Query("SELECT ual FROM UrlAccessLog ual WHERE ual.url.id = :urlId AND ual.accessTime >= :startDate ORDER BY ual.accessTime DESC")
    List<UrlAccessLog> findUrlAccessSince(Long urlId, LocalDateTime startDate);
    
    @Query("SELECT COUNT(ual) FROM UrlAccessLog ual WHERE ual.url.id = :urlId")
    Long countByUrlId(Long urlId);
}
