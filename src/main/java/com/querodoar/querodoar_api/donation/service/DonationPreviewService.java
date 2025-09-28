package com.querodoar.querodoar_api.donation.service;

import com.querodoar.querodoar_api.donation.dto.DonationPreviewDTO;
import com.querodoar.querodoar_api.donation.repository.DonationPreviewRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DonationPreviewService {
    @Autowired
    private DonationPreviewRepository repository;

    public List<DonationPreviewDTO> getLast12DonationPreview(String cityName) {
        return this.repository.findDonationPreviewWhereStatusDOrderByDistanceKmAscDateDesc(cityName, 12);
    }
}
