package com.querodoar.querodoar_api.donation.controller;

import com.querodoar.querodoar_api.donation.dto.DonationTagDTO;
import com.querodoar.querodoar_api.donation.service.TagService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/tag")
public class TagController {
    @Autowired
    private TagService tagService;

    @GetMapping("/public/all")
    public ResponseEntity<List<DonationTagDTO>> getAllTags() {
        return ResponseEntity.ok(tagService.findAll());
    }
}
