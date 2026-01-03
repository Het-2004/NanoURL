package com.NanoURL.controller;

import com.NanoURL.service.UrlService;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.io.IOException;

@Controller
public class RedirectController {

    @Autowired
    private UrlService urlService;

    @GetMapping("/{code}")
    public void redirect(@PathVariable String code, HttpServletResponse response) throws IOException {
        try {
            String longUrl = urlService.getOriginalUrl(code);
            response.sendRedirect(longUrl);
        } catch (Exception e) {
            response.sendError(404, "Short URL not found");
        }
    }
}
