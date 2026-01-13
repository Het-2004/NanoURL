package com.NanoURL.util;

import org.springframework.stereotype.Component;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Pattern;

/**
 * URL Validator for security and input validation
 * FAANG-level input validation to prevent XSS, malicious URLs, and injection attacks
 */
@Component
public class UrlValidator {

    // Blacklisted URL schemes (security risk)
    private static final List<String> BLACKLISTED_SCHEMES = Arrays.asList(
        "javascript:",
        "data:",
        "file:",
        "vbscript:",
        "about:"
    );

    // Blacklisted domains (malware, phishing)
    private static final List<String> BLACKLISTED_DOMAINS = Arrays.asList(
        "malware.com",
        "phishing.com"
        // Add more as needed
    );

    // Maximum URL length to prevent DoS
    private static final int MAX_URL_LENGTH = 2048;

    // Valid URL pattern
    private static final Pattern URL_PATTERN = Pattern.compile(
        "^(https?)://[-a-zA-Z0-9+&@#/%?=~_|!:,.;]*[-a-zA-Z0-9+&@#/%=~_|]",
        Pattern.CASE_INSENSITIVE
    );

    /**
     * Validates if the URL is safe and properly formatted
     *
     * @param urlString The URL to validate
     * @return true if valid, false otherwise
     */
    public boolean isValid(String urlString) {
        if (urlString == null || urlString.trim().isEmpty()) {
            return false;
        }

        // Check length
        if (urlString.length() > MAX_URL_LENGTH) {
            return false;
        }

        // Check for blacklisted schemes
        String lowerUrl = urlString.toLowerCase();
        for (String scheme : BLACKLISTED_SCHEMES) {
            if (lowerUrl.startsWith(scheme)) {
                return false;
            }
        }

        // Validate URL format
        if (!URL_PATTERN.matcher(urlString).matches()) {
            return false;
        }

        // Try to parse as URL
        try {
            URL url = new URI(urlString).toURL();
            
            // Check for blacklisted domains
            String host = url.getHost().toLowerCase();
            for (String blacklistedDomain : BLACKLISTED_DOMAINS) {
                if (host.contains(blacklistedDomain)) {
                    return false;
                }
            }

            // Check if protocol is http or https only
            String protocol = url.getProtocol().toLowerCase();
            if (!protocol.equals("http") && !protocol.equals("https")) {
                return false;
            }

            return true;
        } catch (MalformedURLException | URISyntaxException e) {
            return false;
        }
    }

    /**
     * Sanitizes URL by removing potentially dangerous characters
     *
     * @param urlString The URL to sanitize
     * @return Sanitized URL
     */
    public String sanitize(String urlString) {
        if (urlString == null) {
            return null;
        }

        // Remove leading/trailing whitespace
        String sanitized = urlString.trim();

        // Remove control characters
        sanitized = sanitized.replaceAll("[\\p{Cntrl}]", "");

        // Limit length
        if (sanitized.length() > MAX_URL_LENGTH) {
            sanitized = sanitized.substring(0, MAX_URL_LENGTH);
        }

        return sanitized;
    }

    /**
     * Validates and sanitizes URL in one step
     *
     * @param urlString The URL to validate and sanitize
     * @return Sanitized URL if valid, null otherwise
     */
    public String validateAndSanitize(String urlString) {
        String sanitized = sanitize(urlString);
        return isValid(sanitized) ? sanitized : null;
    }

    /**
     * Checks if URL is potentially malicious
     *
     * @param urlString The URL to check
     * @return true if suspicious, false otherwise
     */
    public boolean isSuspicious(String urlString) {
        if (urlString == null) {
            return true;
        }

        String lowerUrl = urlString.toLowerCase();

        // Check for common phishing patterns
        if (lowerUrl.contains("@") && !lowerUrl.startsWith("mailto:")) {
            return true; // Possible URL obfuscation
        }

        // Check for IP address instead of domain
        try {
            URL url = new URI(urlString).toURL();
            String host = url.getHost();
            if (host.matches("^\\d+\\.\\d+\\.\\d+\\.\\d+$")) {
                return true; // Direct IP address (suspicious)
            }
        } catch (MalformedURLException | URISyntaxException e) {
            return true;
        }

        // Check for excessive subdomains (potential typosquatting)
        String[] parts = urlString.split("\\.");
        if (parts.length > 5) {
            return true;
        }

        return false;
    }
}
