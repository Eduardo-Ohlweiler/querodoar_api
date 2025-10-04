package com.querodoar.querodoar_api.location.service;

import com.querodoar.querodoar_api.location.dto.CityMinimal;
import com.querodoar.querodoar_api.location.dto.StateMinimal;
import com.querodoar.querodoar_api.location.repository.CityRepository;
import com.querodoar.querodoar_api.location.repository.StateRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LocationService {
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

    public List<StateMinimal> getStatesMinimal() {
        return stateRepository.findAllStateMinimal();
    }

    public List<CityMinimal> getCitiesMinimalByStateId(Integer stateId) {
        return cityRepository.findAllCityMinimalByStateId(stateId);
    }

    public Integer getStateIdByCityName(String cityName) {
        return stateRepository.findStateIdByCityName(cityName);
    }
}
