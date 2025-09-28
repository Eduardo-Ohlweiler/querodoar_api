package com.querodoar.querodoar_api.donation.controller;

import com.querodoar.querodoar_api.common.service.ClientIpService;
import com.querodoar.querodoar_api.donation.dto.DonationPreviewDTO;
import com.querodoar.querodoar_api.donation.dto.LastDonationPreviewDTO;
import com.querodoar.querodoar_api.donation.dto.PagedDonationPreviewDTO;
import com.querodoar.querodoar_api.donation.service.DonationPreviewService;
import com.querodoar.querodoar_api.geoIp.GeoIpService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import org.jspecify.annotations.Nullable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/donation")
public class DonationController {

    @Autowired
    private DonationPreviewService donationPreviewService;

    @Autowired
    private GeoIpService geoIpService;

    @Autowired
    private ClientIpService clientIpService;

    @Autowired
    private HttpServletRequest request;

    private final Logger log = LoggerFactory.getLogger(DonationController.class);

    @GetMapping("/preview/last")
    public ResponseEntity<LastDonationPreviewDTO> getLastDonationPreviews() {

        String ipAddress = clientIpService.getClientIpAddress(request);
        log.info("Request IP: {}", ipAddress);

        String cityName = null;
        if (ipAddress != null) {
            cityName = geoIpService.getCityByIp(ipAddress);
        }

        log.info("City by IP: {}", cityName);

        List<DonationPreviewDTO> listDonationPreviewDto = donationPreviewService.getLast12DonationPreview(cityName);
        LastDonationPreviewDTO lastDonationPreviewDto = new LastDonationPreviewDTO();
        lastDonationPreviewDto.setCityName(cityName);
        lastDonationPreviewDto.setListDonationPreviewDto(listDonationPreviewDto);

        return ResponseEntity.ok(lastDonationPreviewDto);
    }

    /**
     * Endpoint para buscar pré-visualizações de doações com base em vários critérios de filtro e paginação.
     * @param searchTerm
     * @param page
     * @param size
     * @param sortByDistance
     * @param onlyPublic
     * @param onlyPrivate
     * @param distanceKm
     * @param categoriesIds
     * @param locationsIds
     * @return Uma resposta HTTP contendo uma página de pré-visualizações de doações que correspondem
     *         aos critérios de pesquisa.
     *
     * Regra de Negócio:
     * - O servidor determina o estado de pesquisa com base no IP do usuário caso não informado
     *   nenhum locationId.
     */
    @GetMapping("/preview")
    public ResponseEntity<PagedDonationPreviewDTO> searchDonationPreviews(
            @RequestParam @Valid @NotBlank @Size(min = 3) String searchTerm,
            @RequestParam Integer page,
            @RequestParam Integer size,
            @RequestParam(required = false) Boolean sortByDistance,
            @RequestParam(required = false) Boolean onlyPublic,
            @RequestParam(required = false) Boolean onlyPrivate,
            @RequestParam(required = false) @Size(min = 1) Integer distanceKm,
            @RequestParam(required = false) Map<Integer, @Nullable List<Integer>> categoriesIds,
            @RequestParam(required = false) Map<Integer, @Nullable List<Integer>> locationsIds
            ) {

//        PagedDonationPreviewDTO pagedResult = donationPreviewService.searchDonationPreviews(
//                searchTerm,
//                page,
//                size,
//                sortByDistance,
//                onlyPublic,
//                onlyPrivate,
//                distanceKm,
//                categoriesIds,
//                locationsIds
//        );

//        return ResponseEntity.ok(pagedResult);

        //not implemented yet
        return ResponseEntity.ok(new PagedDonationPreviewDTO());
    }
}
