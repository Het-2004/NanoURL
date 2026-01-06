package com.NanoURL.service;

import com.NanoURL.model.ContactMessage;
import com.NanoURL.model.User;
import com.NanoURL.repository.ContactMessageRepository;
import com.NanoURL.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ContactMessageService {

    @Autowired
    private ContactMessageRepository contactMessageRepository;

    @Autowired
    private UserRepository userRepository;

    public ContactMessage saveMessage(String name, String email, String subject, String message) {
        ContactMessage contactMessage = new ContactMessage(name, email, subject, message);
        
        // Link to user if exists
        Optional<User> user = userRepository.findByEmail(email);
        user.ifPresent(contactMessage::setUser);
        
        return contactMessageRepository.save(contactMessage);
    }

    public List<ContactMessage> getAllMessages() {
        return contactMessageRepository.findAllByOrderByCreatedAtDesc();
    }

    public List<ContactMessage> getUnreadMessages() {
        return contactMessageRepository.findByIsReadFalseOrderByCreatedAtDesc();
    }

    public Optional<ContactMessage> getMessageById(Long id) {
        return contactMessageRepository.findById(id);
    }

    public ContactMessage markAsRead(Long id) {
        Optional<ContactMessage> message = contactMessageRepository.findById(id);
        if (message.isPresent()) {
            ContactMessage msg = message.get();
            msg.setIsRead(true);
            return contactMessageRepository.save(msg);
        }
        return null;
    }

    public void deleteMessage(Long id) {
        contactMessageRepository.deleteById(id);
    }

    public long getUnreadCount() {
        return contactMessageRepository.countByIsReadFalse();
    }
}
