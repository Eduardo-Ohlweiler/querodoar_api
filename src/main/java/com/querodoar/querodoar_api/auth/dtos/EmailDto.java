package com.querodoar.querodoar_api.auth.dtos;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class EmailDto {
    @NotBlank(message="O email é obrigatório")
    @Email(message="O email deve ser valido")
    private String email;
}
