package com.NanoURL.repository;

import com.NanoURL.model.Url;
import com.NanoURL.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface UrlRepository extends JpaRepository<Url, Long> {
    Optional<Url> findByShortCode(String shortCode);
    List<Url> findByUserOrderByCreatedAtDesc(User user);
    List<Url> findByUserIdOrderByCreatedAtDesc(Long userId);
}
