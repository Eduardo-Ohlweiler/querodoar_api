package com.querodoar.querodoar_api.donation.controller;

import com.querodoar.querodoar_api.common.service.ClientIpService;
import com.querodoar.querodoar_api.donation.dto.DonationPreviewDTO;
import com.querodoar.querodoar_api.donation.dto.LastDonationPreviewDTO;
import com.querodoar.querodoar_api.donation.service.DonationPreviewService;
import com.querodoar.querodoar_api.geoIp.GeoIpService;
import com.querodoar.querodoar_api.utils.PagedResult;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.constraints.Size;
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

        String cityName;
        if (ipAddress != null) {
            cityName = geoIpService.getCityByIp(ipAddress);
        } else {
            cityName = null;
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
     * @param tagsIds
     * @return Uma resposta HTTP contendo uma página de pré-visualizações de doações que correspondem
     *         aos critérios de pesquisa.
     *
     * Regra de Negócio:
     * - O servidor determina o estado de pesquisa com base no IP do usuário caso não informado
     *   nenhum locationId.
     */
    @GetMapping("/preview/search")
    public ResponseEntity<PagedResult<DonationPreviewDTO>> searchDonationPreviews(
            @RequestParam(required = false) @Size(min = 3) String searchTerm,
            @RequestParam(required = false, defaultValue = "1") Integer page,
            // TODO: Definir um valor máximo para 'size' para evitar consultas muito grandes
            @RequestParam (required = false, defaultValue = "10") Integer size,
            @RequestParam(required = false) Boolean sortByDistance,
            @RequestParam(required = false) Boolean onlyPublic,
            @RequestParam(required = false) Boolean onlyPrivate,
            @RequestParam(required = false) Integer distanceKm,
            // TODO: Implementar filtro por tipos de doação (D ou P)
            @RequestParam(required = false) List<Character> donationTypes,
            @RequestParam(required = false) List<Integer> subcategoriesIds,
            // Regra de negócio: Para os estados listados em statesIds,
            // trazer doações de todas as cidades destes estados
            @RequestParam(required = false) List<Integer> statesIds,
            @RequestParam(required = false) List<Integer> citiesIds,
            @RequestParam(required = false) List<Integer> tagsIds
            ) {

        String ipAddress = clientIpService.getClientIpAddress(request);

        String cityName;
        if (ipAddress != null) {
            cityName = geoIpService.getCityByIp(ipAddress);
        } else {
            cityName = null;
        }

        PagedResult<DonationPreviewDTO> data = this.donationPreviewService.searchDonationPreview(
                cityName,
                searchTerm,
                page,
                size,
                sortByDistance,
                onlyPublic,
                onlyPrivate,
                distanceKm,
                subcategoriesIds,
                statesIds,
                citiesIds,
                tagsIds
        );

        return ResponseEntity.ok(data);
    }
}
