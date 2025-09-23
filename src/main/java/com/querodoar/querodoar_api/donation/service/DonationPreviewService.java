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
        if(cityName == null || cityName.isEmpty()) {
            List<DonationPreviewDTO> listDonationPreviewDto = this.repository.findDonationPreviewWhereStatusDOrderByDistanceKmAscDateDesc("São Paulo",12);
            return listDonationPreviewDto.stream()
                    .peek(dto -> dto.setDistanceKm(-1.0)).toList();
        } else {
            return this.repository.findDonationPreviewWhereStatusDOrderByDistanceKmAscDateDesc(cityName, 12);
        }
    }
}
