package com.NanoURL.controller;

import com.NanoURL.service.QrCodeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/qr")
public class QrCodeController {
    
    @Autowired
    private QrCodeService qrCodeService;
    
    /**
     * Generate QR code for a given URL/text
     * Returns PNG image
     */
    @PostMapping("/generate")
    public ResponseEntity<?> generateQrCode(@RequestBody Map<String, String> request) {
        try {
            String text = request.get("text");
            
            if (text == null || text.trim().isEmpty()) {
                return ResponseEntity.badRequest().body(
                    Map.of("error", "Text parameter is required")
                );
            }
            
            byte[] qrCodeImage = qrCodeService.generateQrCode(text);
            
            return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"qrcode.png\"")
                .contentType(MediaType.IMAGE_PNG)
                .body(qrCodeImage);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                Map.of("error", "Failed to generate QR code: " + e.getMessage())
            );
        }
    }
    
    /**
     * Generate QR code and return as Base64 encoded string
     */
    @PostMapping("/generate/base64")
    public ResponseEntity<?> generateQrCodeBase64(@RequestBody Map<String, String> request) {
        try {
            String text = request.get("text");
            
            if (text == null || text.trim().isEmpty()) {
                return ResponseEntity.badRequest().body(
                    Map.of("error", "Text parameter is required")
                );
            }
            
            String base64 = qrCodeService.generateQrCodeBase64(text);
            
            Map<String, String> response = new HashMap<>();
            response.put("qrCode", base64);
            response.put("format", "base64");
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                Map.of("error", "Failed to generate QR code: " + e.getMessage())
            );
        }
    }
    
    /**
     * Generate QR code and return as Data URL (for embedding in HTML/JSON)
     */
    @PostMapping("/generate/dataurl")
    public ResponseEntity<?> generateQrCodeDataUrl(@RequestBody Map<String, String> request) {
        try {
            String text = request.get("text");
            
            if (text == null || text.trim().isEmpty()) {
                return ResponseEntity.badRequest().body(
                    Map.of("error", "Text parameter is required")
                );
            }
            
            String dataUrl = qrCodeService.generateQrCodeDataUrl(text);
            
            Map<String, String> response = new HashMap<>();
            response.put("qrCode", dataUrl);
            response.put("format", "dataurl");
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                Map.of("error", "Failed to generate QR code: " + e.getMessage())
            );
        }
    }
    
    /**
     * Generate QR code with custom dimensions
     */
    @PostMapping("/generate/custom")
    public ResponseEntity<?> generateQrCodeCustom(@RequestBody Map<String, Object> request) {
        try {
            String text = (String) request.get("text");
            Integer width = (Integer) request.getOrDefault("width", 300);
            Integer height = (Integer) request.getOrDefault("height", 300);
            String format = (String) request.getOrDefault("format", "base64");
            
            if (text == null || text.trim().isEmpty()) {
                return ResponseEntity.badRequest().body(
                    Map.of("error", "Text parameter is required")
                );
            }
            
            byte[] qrCodeImage = qrCodeService.generateQrCode(text, width, height);
            
            Map<String, Object> response = new HashMap<>();
            
            if ("base64".equalsIgnoreCase(format)) {
                String base64 = java.util.Base64.getEncoder().encodeToString(qrCodeImage);
                response.put("qrCode", base64);
                response.put("format", "base64");
            } else if ("dataurl".equalsIgnoreCase(format)) {
                String base64 = java.util.Base64.getEncoder().encodeToString(qrCodeImage);
                response.put("qrCode", "data:image/png;base64," + base64);
                response.put("format", "dataurl");
            } else {
                response.put("qrCode", qrCodeImage);
                response.put("format", "png");
            }
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                Map.of("error", "Failed to generate QR code: " + e.getMessage())
            );
        }
    }
}
