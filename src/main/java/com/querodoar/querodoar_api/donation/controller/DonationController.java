package com.querodoar.querodoar_api.donation.controller;

import com.querodoar.querodoar_api.config.GeoLiteInitializer;
import com.querodoar.querodoar_api.donation.dto.DonationPreviewDTO;
import com.querodoar.querodoar_api.donation.dto.LastDonationPreviewDTO;
import com.querodoar.querodoar_api.donation.service.DonationPreviewService;
import com.querodoar.querodoar_api.geoIp.GeoIpService;
import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/donation")
public class DonationController {

    @Autowired
    private DonationPreviewService donationPreviewService;

    @Autowired
    private GeoIpService geoIpService;

    @Autowired
    private HttpServletRequest request;

    @Value("${spring.profiles.active:prd}")
    private String activeProfile;

    private final Logger log = LoggerFactory.getLogger(DonationController.class);

    @GetMapping("/preview/last")
    public ResponseEntity<LastDonationPreviewDTO> getLastDonationPreviews() {

        String ipAddress;

        if (activeProfile.equals("prd")) {
            ipAddress = request.getHeader("X-Forwarded-For");
            if (ipAddress == null) {
                ipAddress = request.getRemoteAddr();
            }
        } else {
            ipAddress = "179.219.209.34"; //apenas para teste local, remover depois
        }

        //log IP
        log.info("Request IP: {}", ipAddress);

        String cityName = null;
        if (ipAddress != null) {
            cityName = geoIpService.getCityByIp(ipAddress);
        }

        //log city
        log.info("City by IP: {}", cityName);

        List<DonationPreviewDTO> listDonationPreviewDto = donationPreviewService.getLast12DonationPreview(cityName);
        LastDonationPreviewDTO lastDonationPreviewDto = new LastDonationPreviewDTO();
        lastDonationPreviewDto.setCityName(cityName);
        lastDonationPreviewDto.setListDonationPreviewDto(listDonationPreviewDto);

        return ResponseEntity.ok(lastDonationPreviewDto);
    }
}
