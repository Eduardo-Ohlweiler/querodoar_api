package com.querodoar.querodoar_api.auth.dtos;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ResetPasswordDto {
    @NotBlank(message="O token é obrigatório")
    private String token;

    @NotBlank(message="A nova senha é obrigatória")
    @Size(min = 6, max = 255, message = "A nova senha deve ter entre 6 e 255 caracteres")
    private String newPassword;
}
