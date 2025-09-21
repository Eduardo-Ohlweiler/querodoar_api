package com.querodoar.querodoar_api.usuario.dtos;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

@Data
public class UserMinimalDTO {
    @JsonProperty("userId")
    @JsonAlias("user_id")
    private Integer userId;

    @JsonProperty("name")
    @JsonAlias("name")
    private String name;

    @JsonProperty("photo")
    @JsonAlias("photo")
    private String photo;
}
