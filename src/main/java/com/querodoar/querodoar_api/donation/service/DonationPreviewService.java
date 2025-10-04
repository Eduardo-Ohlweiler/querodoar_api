package com.querodoar.querodoar_api.donation.service;

import com.querodoar.querodoar_api.location.service.LocationService;
import com.querodoar.querodoar_api.donation.dto.DonationPreviewDTO;
import com.querodoar.querodoar_api.donation.repository.DonationPreviewRepository;
import com.querodoar.querodoar_api.utils.PagedResult;
import jakarta.annotation.Nullable;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class DonationPreviewService {
    @Autowired
    private DonationPreviewRepository repository;

    @Autowired
    private LocationService locationService;

    public List<DonationPreviewDTO> getLast12DonationPreview(String cityName) {
        return this.repository.findDonationPreviewWhereStatusDOrderByDistanceKmAscDateDesc(cityName, 12);
    }

    public PagedResult<DonationPreviewDTO> searchDonationPreview(
            String cityName,
            @Nullable String searchTerm,
            Integer page,
            Integer size,
            @Nullable Boolean sortByDistance,
            @Nullable Boolean onlyPublic,
            @Nullable Boolean onlyPrivate,
            @Nullable Integer distanceKm,
            @Nullable List<Integer> subcategoriesIds,
            @Nullable List<Integer> statesIds,
            @Nullable List<Integer> citiesIds,
            @Nullable List<Integer> tagsIds){

        // Tratamento de isPublic (onlyPublic e onlyPrivate)
        Boolean isPublic1, isPublic2;
        if(onlyPublic == null && onlyPrivate == null)
        {
            isPublic1 = true;
            isPublic2 = false;
        } else if (onlyPublic && (onlyPrivate == null || onlyPrivate == false)) {
            isPublic1 = true;
            isPublic2 = true;
        } else if ((onlyPublic == null || onlyPublic == false) && onlyPrivate) {
            isPublic1 = false;
            isPublic2 = false;
        } else  {
            isPublic1 = true;
            isPublic2 = false;
        }

        // Tratamento de distanceKm
        Integer distanceKmFilter;
        // Caso cityName seja nulo, distanceKm será nulo também
        if(cityName == null) {
            distanceKmFilter = null;
        } else if(distanceKm == null) {
            distanceKmFilter = 999999999;
        } else {
            distanceKmFilter = distanceKm;
        }

        PagedResult<DonationPreviewDTO> pagedResult = this.repository.searchDonationPreview(
                cityName,
                searchTerm,
                page,
                size,
                // Tratamento de sortByDistance
                sortByDistance != null ? sortByDistance : false,
                isPublic1,
                isPublic2,
                distanceKmFilter,
                statesIds,
                citiesIds,
                subcategoriesIds,
                tagsIds
        );

        return pagedResult;
    }
}
