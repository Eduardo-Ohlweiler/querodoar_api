package com.querodoar.querodoar_api.tag;

import com.querodoar.querodoar_api.tag.entity.DonationTag;
import com.querodoar.querodoar_api.tag.repository.TagRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TagService {
    @Autowired
    private TagRepository tagRepository;

    public List<DonationTag> findAll() {
        return tagRepository.findAll();
    }
}
