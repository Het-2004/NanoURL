package com.NanoURL.repository;

import com.NanoURL.model.LoginHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface LoginHistoryRepository extends JpaRepository<LoginHistory, Long> {
    
    List<LoginHistory> findByUserIdOrderByLoginTimeDesc(Long userId);
    
    List<LoginHistory> findByUserEmailOrderByLoginTimeDesc(String email);
    
    @Query("SELECT lh FROM LoginHistory lh WHERE lh.loginTime >= :startDate ORDER BY lh.loginTime DESC")
    List<LoginHistory> findRecentLogins(LocalDateTime startDate);
    
    @Query("SELECT lh FROM LoginHistory lh WHERE lh.user.id = :userId AND lh.loginTime >= :startDate ORDER BY lh.loginTime DESC")
    List<LoginHistory> findUserLoginsSince(Long userId, LocalDateTime startDate);
}
