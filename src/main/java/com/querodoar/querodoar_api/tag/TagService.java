package com.querodoar.querodoar_api.tag;

import com.querodoar.querodoar_api.tag.dto.DonationTagDTO;
import com.querodoar.querodoar_api.tag.repository.TagRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TagService {
    @Autowired
    private TagRepository tagRepository;

    public List<DonationTagDTO> findAll() {
        return tagRepository.findAll().stream().map(DonationTagDTO::new).toList();
    }
}
