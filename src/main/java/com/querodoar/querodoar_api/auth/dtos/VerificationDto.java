package com.querodoar.querodoar_api.auth.dtos;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class VerificationDto {

    @NotBlank(message="O token é obrigatório")
    private String token;

}
