package com.NanoURL.service;

import io.github.bucket4j.Bandwidth;
import io.github.bucket4j.Bucket;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Simple in-memory rate limiting service keyed by client IP.
 * Limits each key to 60 requests per minute (sane default for public APIs).
 */
@Service
public class RateLimitService {

    private static final long REQUESTS = 60;
    private static final Duration DURATION = Duration.ofMinutes(1);

    private final Map<String, Bucket> cache = new ConcurrentHashMap<>();

    public Bucket resolveBucket(String key) {
        return cache.computeIfAbsent(key, this::newBucket);
    }

    private Bucket newBucket(String key) {
        Bandwidth limit = Bandwidth.builder()
                .capacity(REQUESTS)
                .refillIntervally(REQUESTS, DURATION)
                .build();
        return Bucket.builder()
                .addLimit(limit)
                .build();
    }
}
