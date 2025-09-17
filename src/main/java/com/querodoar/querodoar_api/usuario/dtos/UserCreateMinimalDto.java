package com.querodoar.querodoar_api.usuario.dtos;

import com.fasterxml.jackson.annotation.JsonProperty;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserCreateMinimalDto {
    @NotBlank(message="O nome é obrigatório")
    @Size(min=3, max=100, message="O nome deve ter entre 3 e 100 caracteres")
    @Schema(description = "Nome completo do usuário", example = "Eduardo Rodrigo")
    private String name;

    @NotBlank(message="O email é obrigatório")
    @Email(message="O email deve ser valido")
    @Schema(description = "Email do usuário", example = "eduardo@email.com")
    private String email;

    @NotBlank(message="A senha é obrigatória")
    @Size(min = 6, max = 20, message = "A senha deve ter entre 6 e 20 caracteres")
    @Pattern(
            regexp = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d).+$",
            message = "A senha deve conter pelo menos uma letra maiúscula, uma letra minúscula e um número"
    )
    @JsonProperty("password_hash")
    private String password_hash;
}
