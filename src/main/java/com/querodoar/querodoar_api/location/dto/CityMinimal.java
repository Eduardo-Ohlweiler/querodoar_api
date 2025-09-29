package com.querodoar.querodoar_api.location.dto;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class CityMinimal {
    @JsonProperty("cityId")
    @JsonAlias("city_id")
    private Integer cityId;

    @JsonProperty("name")
    @JsonAlias("name")
    private String name;
}
