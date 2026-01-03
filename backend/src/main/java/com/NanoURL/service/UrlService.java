package com.NanoURL.service;

import com.NanoURL.model.Url;
import com.NanoURL.model.User;
import com.NanoURL.repository.UrlRepository;
import com.NanoURL.repository.UserRepository;
import com.NanoURL.util.Base62;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UrlService {

    private final UrlRepository urlRepository;
    
    @Autowired
    private UserRepository userRepository;

    public UrlService(UrlRepository urlRepository) {
        this.urlRepository = urlRepository;
    }

    public String shortenUrl(String longUrl, Long userId) {
        Url url = new Url();
        url.setLongUrl(longUrl);
        
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

        return code;
    }

    public String getOriginalUrl(String code) {
        Url url = urlRepository.findByShortCode(code)
                .orElseThrow(() -> new RuntimeException("URL not found"));
        
        // Increment click count
        url.setClickCount(url.getClickCount() + 1);
        urlRepository.save(url);
        
        return url.getLongUrl();
    }
    
    public void deleteUrl(Long urlId, Long userId) {
        Url url = urlRepository.findById(urlId)
                .orElseThrow(() -> new RuntimeException("URL not found"));
        
        // Verify URL belongs to user
        if (url.getUser() == null || !url.getUser().getId().equals(userId)) {
            throw new RuntimeException("Unauthorized to delete this URL");
        }
        
        urlRepository.delete(url);
    }
}
