package com.querodoar.querodoar_api.auth.dtos;

import com.fasterxml.jackson.annotation.JsonProperty;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public class LoginDto {

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

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword_hash() {
        return password_hash;
    }

    public void setPassword_hash(String password_hash) {
        this.password_hash = password_hash;
    }
}
