package com.NanoURL.model;

import jakarta.persistence.*;

@Entity
@Table(name = "urls")
public class Url {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true)
    private String shortCode;

    @Column(nullable = false)
    private String longUrl;

    private Long clickCount = 0L;

    // getters & setters
}
