package com.NanoURL.service;

import com.NanoURL.model.User;
import com.NanoURL.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public User registerUser(String email, String password, String name, String contactNumber) {
        if (userRepository.existsByEmail(email)) {
            throw new RuntimeException("Email already exists");
        }

        User user = new User();
        user.setEmail(email);
        user.setName(name);
        user.setContactNumber(contactNumber);
        user.setPasswordHash(passwordEncoder.encode(password));
        user.setAuthProvider("EMAIL");

        return userRepository.save(user);
    }

    public User authenticateUser(String email, String password) {
        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isEmpty()) {
            throw new RuntimeException("Invalid credentials");
        }

        User user = userOpt.get();
        if (!passwordEncoder.matches(password, user.getPasswordHash())) {
            throw new RuntimeException("Invalid credentials");
        }

        return user;
    }

    public User findOrCreateOAuthUser(String email, String name, String provider, String providerId) {
        Optional<User> existingUser = userRepository.findByProviderIdAndAuthProvider(providerId, provider);
        
        if (existingUser.isPresent()) {
            return existingUser.get();
        }

        // Check if user with same email exists
        Optional<User> emailUser = userRepository.findByEmail(email);
        if (emailUser.isPresent()) {
            User user = emailUser.get();
            // Link OAuth provider to existing account
            user.setProviderId(providerId);
            user.setAuthProvider(provider);
            return userRepository.save(user);
        }

        // Create new user
        User newUser = new User();
        newUser.setEmail(email);
        newUser.setName(name);
        newUser.setAuthProvider(provider);
        newUser.setProviderId(providerId);

        return userRepository.save(newUser);
    }

    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    public Optional<User> findById(Long id) {
        return userRepository.findById(id);
    }
}
