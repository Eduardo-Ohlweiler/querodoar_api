package com.querodoar.querodoar_api.auth.dtos;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class VerificationDto {

    @NotBlank(message="O token é obrigatório")
    @Size(min = 256, max = 256, message = "O token deve) ter 256 caracteres")
    private String token;

}
