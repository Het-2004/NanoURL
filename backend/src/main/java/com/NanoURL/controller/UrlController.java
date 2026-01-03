package com.NanoURL.controller;

import com.NanoURL.service.UrlService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
public class UrlController {

    private final UrlService urlService;

    public UrlController(UrlService urlService) {
        this.urlService = urlService;
    }

    @PostMapping("/shorten")
    public String shortenUrl(@RequestBody String longUrl) {
        return urlService.shortenUrl(longUrl);
    }

    @GetMapping("/{code}")
    public String redirect(@PathVariable String code) {
        return urlService.getOriginalUrl(code);
    }
}
