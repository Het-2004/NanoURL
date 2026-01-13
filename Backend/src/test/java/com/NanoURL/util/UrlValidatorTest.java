package com.NanoURL.util;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class UrlValidatorTest {

    private final UrlValidator validator = new UrlValidator();

    @Test
    void allowsValidHttpUrls() {
        assertTrue(validator.isValid("http://example.com"));
        assertTrue(validator.isValid("https://example.com/path?query=1"));
    }

    @Test
    void blocksMaliciousSchemes() {
        assertFalse(validator.isValid("javascript:alert('xss')"));
        assertFalse(validator.isValid("data:text/html,<script>alert('xss')</script>"));
    }

    @Test
    void blocksTooLongUrls() {
        String longUrl = "https://example.com/" + "a".repeat(2050);
        assertFalse(validator.isValid(longUrl));
    }

    @Test
    void sanitizesControlCharacters() {
        String withControl = "https://example.com/\u0001\u0002";
        String sanitized = validator.validateAndSanitize(withControl);
        assertNotNull(sanitized);
        assertFalse(sanitized.contains("\u0001"));
    }
}
