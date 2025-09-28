package com.querodoar.querodoar_api.city.service;

import com.querodoar.querodoar_api.city.repository.CityRepository;
import com.querodoar.querodoar_api.city.repository.StateRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CityService {
    @Autowired
    private StateRepository stateRepository;

    @Autowired
    private CityRepository cityRepository;

    public List<Integer> getCitiesIdsOfStateByCityName(String cityName) {
        Integer stateId = stateRepository.findStateIdByCityName(cityName);
        if(stateId == null) {
            return null;
        }
        return cityRepository.findAllCityIdsByStateId(stateId);
    }
}
