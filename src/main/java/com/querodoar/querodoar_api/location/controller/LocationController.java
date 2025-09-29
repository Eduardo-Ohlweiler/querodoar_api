package com.querodoar.querodoar_api.location.controller;

import com.querodoar.querodoar_api.location.dto.CityMinimal;
import com.querodoar.querodoar_api.location.dto.StateMinimal;
import com.querodoar.querodoar_api.location.service.LocationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/location")
public class LocationController {

    @Autowired
    private LocationService locationService;

    @GetMapping("/public/state/{stateId}/cities/minimal")
    public ResponseEntity<List<CityMinimal>> findAllCityMinimalByStateId(@PathVariable Integer stateId) {
        return ResponseEntity.ok(locationService.getCitiesMinimalByStateId(stateId));
    }

    @GetMapping("/public/state/minimal")
    public ResponseEntity<List<StateMinimal>> findAllStateMinimal() {
        return ResponseEntity.ok(locationService.getStatesMinimal());
    }


}
