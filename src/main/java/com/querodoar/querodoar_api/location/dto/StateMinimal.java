package com.querodoar.querodoar_api.location.dto;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class StateMinimal {
    @JsonProperty("stateId")
    @JsonAlias("state_id")
    private Integer stateId;

    @JsonProperty("name")
    @JsonAlias("name")
    private String name;

    @JsonProperty("acronym")
    @JsonAlias("acronym")
    private String acronym;
}
