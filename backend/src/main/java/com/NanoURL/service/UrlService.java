package com.NanoURL.service;

import com.NanoURL.model.Url;
import com.NanoURL.repository.UrlRepository;
import org.springframework.stereotype.Service;

@Service
public class UrlService {

    private final UrlRepository repo;

    public UrlService(UrlRepository repo) {
        this.repo = repo;
    }

    public String shortenUrl(String longUrl) {
        Url url = new Url();
        url.setLongUrl(longUrl);
        url = repo.save(url);

        String code = Base62.encode(url.getId());
        url.setShortCode(code);
        repo.save(url);

        return code;
    }

    public String getOriginalUrl(String code) {
        return repo.findByShortCode(code)
                .orElseThrow(() -> new RuntimeException("URL not found"))
                .getLongUrl();
    }
}
