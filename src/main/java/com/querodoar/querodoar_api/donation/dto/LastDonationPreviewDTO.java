package com.querodoar.querodoar_api.donation.dto;

import lombok.Data;

import java.util.List;

@Data
public class LastDonationPreviewDTO {
    private String cityName;
    private List<DonationPreviewDTO> listDonationPreviewDto;
}
