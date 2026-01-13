package com.NanoURL.controller;

import com.NanoURL.model.Url;
import com.NanoURL.service.UrlAccessLogService;
import com.NanoURL.service.UrlService;
import jakarta.servlet.http.HttpServletRequest;
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

    @Autowired
    private UrlAccessLogService urlAccessLogService;

    @GetMapping("/{code}")
    public void redirect(@PathVariable String code, HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            Url url = urlService.getUrlByShortCode(code);
            
            // Track URL access
            urlAccessLogService.recordAccess(url, request);
            
            response.sendRedirect(url.getLongUrl());
        } catch (Exception e) {
            response.sendError(404, "Short URL not found");
        }
    }
}
