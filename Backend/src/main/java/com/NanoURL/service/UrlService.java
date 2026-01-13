package com.NanoURL.service;

import com.NanoURL.model.Url;
import com.NanoURL.model.User;
import com.NanoURL.repository.UrlRepository;
import com.NanoURL.repository.UserRepository;
import com.NanoURL.util.Base62;
import com.NanoURL.util.UrlValidator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Service
public class UrlService {

    private static final Logger logger = LoggerFactory.getLogger(UrlService.class);

    private final UrlRepository urlRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private UrlValidator urlValidator;

    public UrlService(UrlRepository urlRepository) {
        this.urlRepository = urlRepository;
    }

    public String shortenUrl(String longUrl, Long userId) {
        logger.info("Attempting to shorten URL for user: {}", userId);
        
        // Validate and sanitize URL
        String sanitizedUrl = urlValidator.validateAndSanitize(longUrl);
        if (sanitizedUrl == null) {
            logger.warn("Invalid URL rejected: {}", longUrl);
            throw new IllegalArgumentException("Invalid URL format");
        }
        
        // Check if URL is suspicious
        if (urlValidator.isSuspicious(sanitizedUrl)) {
            logger.warn("Suspicious URL rejected: {}", sanitizedUrl);
            throw new IllegalArgumentException("URL appears to be suspicious or malicious");
        }
        
        Url url = new Url();
        url.setLongUrl(sanitizedUrl);
        
        // Associate URL with user if authenticated
        if (userId != null) {
            User user = userRepository.findById(userId)
                    .orElseThrow(() -> new RuntimeException("User not found"));
            url.setUser(user);
        }
        
        url = urlRepository.save(url);

        String code = Base62.encode(url.getId());
        url.setShortCode(code);
        urlRepository.save(url);

        logger.info("Successfully shortened URL. Short code: {}", code);
        return code;
    }

    public String getOriginalUrl(String code) {
        logger.debug("Fetching original URL for code: {}", code);
        
        Url url = urlRepository.findByShortCode(code)
                .orElseThrow(() -> new RuntimeException("URL not found"));
        
        // Increment click count
        url.setClickCount(url.getClickCount() + 1);
        urlRepository.save(url);
        
        logger.info("URL {} accessed. Total clicks: {}", code, url.getClickCount());
        return url.getLongUrl();
    }
    
    public Url getUrlByShortCode(String code) {
        logger.debug("Fetching URL object for code: {}", code);
        
        Url url = urlRepository.findByShortCode(code)
                .orElseThrow(() -> new RuntimeException("URL not found"));
        
        // Increment click count
        url.setClickCount(url.getClickCount() + 1);
        urlRepository.save(url);
        
        logger.info("URL {} accessed. Total clicks: {}", code, url.getClickCount());
        return url;
    }
    
    public void deleteUrl(Long urlId, Long userId) {
        logger.info("Deleting URL {} for user {}", urlId, userId);
        
        Url url = urlRepository.findById(urlId)
                .orElseThrow(() -> new RuntimeException("URL not found"));
        
        // Verify URL belongs to user
        if (url.getUser() == null || !url.getUser().getId().equals(userId)) {
            logger.warn("Unauthorized delete attempt. URL: {}, User: {}", urlId, userId);
            throw new RuntimeException("Unauthorized to delete this URL");
        }
        
        urlRepository.delete(url);
        logger.info("Successfully deleted URL {}", urlId);
    }
}
