package com.querodoar.querodoar_api.donation.service;

import com.querodoar.querodoar_api.donation.dto.DonationPreviewDTO;
import com.querodoar.querodoar_api.donation.dto.PagedDonationPreviewDTO;
import com.querodoar.querodoar_api.donation.repository.DonationPreviewRepository;
import jakarta.annotation.Nullable;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
public class DonationPreviewService {
    @Autowired
    private DonationPreviewRepository repository;

    public List<DonationPreviewDTO> getLast12DonationPreview(String cityName) {
        return this.repository.findDonationPreviewWhereStatusDOrderByDistanceKmAscDateDesc(cityName, 12);
    }

    public PagedDonationPreviewDTO searchDonationPreview(
            String cityName,
            @Nullable String searchTerm,
            Integer page,
            Integer size,
            @Nullable Boolean sortByDistance,
            @Nullable Boolean onlyPublic,
            @Nullable Boolean onlyPrivate,
            @Nullable Integer distanceKm,
            @Nullable List<Integer> subcategoriesIds,
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

        // Tratamento de locationsIds
        List<Integer> newCitiesIds =  citiesIds;
        if(newCitiesIds == null) {
            // TODO: Se não houver filtro por localidade explicitamente
        }

        PagedDonationPreviewDTO pagedResult = this.repository.searchDonationPreview(
                cityName,
                searchTerm,
                page,
                size,
                // Tratamento de sortByDistance
                sortByDistance != null ? sortByDistance : false,
                isPublic1,
                isPublic2,
                distanceKmFilter,
                newCitiesIds,
                subcategoriesIds,
                tagsIds
        );

        return pagedResult;
    }
}
