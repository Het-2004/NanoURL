package com.NanoURL.controller;

import com.NanoURL.model.ContactMessage;
import com.NanoURL.service.ContactMessageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/contact")
@CrossOrigin(origins = {"http://localhost:5173", "http://localhost:3000"}, allowCredentials = "true")
public class ContactController {

    @Autowired
    private ContactMessageService contactMessageService;

    // Submit a new contact message (public endpoint)
    @PostMapping
    public ResponseEntity<Map<String, Object>> submitMessage(@RequestBody Map<String, String> request) {
        try {
            String name = request.get("name");
            String email = request.get("email");
            String subject = request.get("subject");
            String message = request.get("message");

            if (name == null || email == null || subject == null || message == null) {
                Map<String, Object> error = new HashMap<>();
                error.put("success", false);
                error.put("message", "All fields are required");
                return ResponseEntity.badRequest().body(error);
            }

            ContactMessage savedMessage = contactMessageService.saveMessage(name, email, subject, message);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Your message has been sent successfully!");
            response.put("id", savedMessage.getId());
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "Failed to send message: " + e.getMessage());
            return ResponseEntity.internalServerError().body(error);
        }
    }

    // Get all messages (admin only - for future admin panel)
    @GetMapping("/all")
    public ResponseEntity<List<ContactMessage>> getAllMessages() {
        return ResponseEntity.ok(contactMessageService.getAllMessages());
    }

    // Get unread messages count
    @GetMapping("/unread-count")
    public ResponseEntity<Map<String, Long>> getUnreadCount() {
        Map<String, Long> response = new HashMap<>();
        response.put("count", contactMessageService.getUnreadCount());
        return ResponseEntity.ok(response);
    }

    // Mark message as read
    @PutMapping("/{id}/read")
    public ResponseEntity<ContactMessage> markAsRead(@PathVariable Long id) {
        ContactMessage message = contactMessageService.markAsRead(id);
        if (message != null) {
            return ResponseEntity.ok(message);
        }
        return ResponseEntity.notFound().build();
    }

    // Delete message
    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, String>> deleteMessage(@PathVariable Long id) {
        contactMessageService.deleteMessage(id);
        Map<String, String> response = new HashMap<>();
        response.put("message", "Message deleted successfully");
        return ResponseEntity.ok(response);
    }
}
