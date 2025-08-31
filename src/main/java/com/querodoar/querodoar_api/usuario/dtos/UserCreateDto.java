package com.querodoar.querodoar_api.usuario.dtos;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.querodoar.querodoar_api.address.dtos.AddressCreateDto;
import com.querodoar.querodoar_api.usuario.Role;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.Column;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.validation.constraints.*;

import java.time.LocalDate;

public class UserCreateDto {
    //@Schema(description = "Informe o ID do endereço já cadastrado", example = "1")
    //private Integer addressId;

   @Schema(description = "Endereço do usuário")
   private AddressCreateDto address;

    @NotBlank(message="O nome é obrigatório")
    @Size(min=3, max=100, message="O nome deve ter entre 3 e 100 caracteres")
    @Schema(description = "Nome completo do usuário", example = "Eduardo Rodrigo")
    private String name;

    @NotBlank(message="O email é obrigatório")
    @Email(message="O email deve ser valido")
    @Schema(description = "Email do usuário", example = "eduardo@email.com")
    private String email;

    @NotBlank(message = "O CPF é obrigatório")
    @Size(min = 11, max = 11, message = "O CPF deve ter 11 números")
    @Schema(description = "CPF do usuário", example = "24427062024")
    private String cpf;

    @NotNull(message = "Informe a data de nascimento")
    @Past(message = "A data de nascimento deve estar no passado")
    @Schema(description = "Data de nascimento do usuário", example = "1990-01-01")
    private LocalDate birthday;

    @NotBlank(message="A senha é obrigatória")
    @Size(min = 6, max = 20, message = "A senha deve ter entre 6 e 20 caracteres")
    @Pattern(
            regexp = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d).+$",
            message = "A senha deve conter pelo menos uma letra maiúscula, uma letra minúscula e um número"
    )
    @JsonProperty("password_hash")
    private String password_hash;

    @Enumerated(EnumType.STRING)
    @Column(nullable=false)
    private Role role = Role.USER;

    @NotBlank(message = "O número de celular é obrigatório")
    @Pattern(
            regexp = "\\d{11}",
            message = "O número de celular deve ter 11 dígitos (DD + número)"
    )
    @JsonProperty("cellPhone")
    private String cell_phone;

    @NotBlank(message = "O telefone fixo é obrigatório")
    @Pattern(
            regexp = "\\d{10}",
            message = "O telefone fixo deve ter 10 dígitos (DD + número)"
    )
    @JsonProperty("homePhone")
    private String home_phone;

    @Pattern(
            regexp = "\\d{11}",
            message = "O WhatsApp deve ter 11 dígitos (DD + número)"
    )
    @JsonProperty("whatsapp")
    private String whatsapp;

    @Schema(description = "Indica se o usuário está ativo")
    private boolean is_active;

    @Schema(description = "Indica se o usuário está verificado")
    private boolean verified;

    public AddressCreateDto getAddress() {
        return address;
    }

    public void setAddress(AddressCreateDto address) {
        this.address = address;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getCpf() {
        return cpf;
    }

    public void setCpf(String cpf) {
        this.cpf = cpf;
    }

    public LocalDate getBirthday() {
        return birthday;
    }

    public void setBirthday(LocalDate birthday) {
        this.birthday = birthday;
    }

    public String getPassword_hash() {
        return password_hash;
    }

    public void setPassword_hash(String password_hash) {
        this.password_hash = password_hash;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public String getCell_phone() {
        return cell_phone;
    }

    public void setCell_phone(String cell_phone) {
        this.cell_phone = cell_phone;
    }

    public String getHome_phone() {
        return home_phone;
    }

    public void setHome_phone(String home_phone) {
        this.home_phone = home_phone;
    }

    public String getWhatsapp() {
        return whatsapp;
    }

    public void setWhatsapp(String whatsapp) {
        this.whatsapp = whatsapp;
    }

    public boolean isIs_active() {
        return is_active;
    }

    public void setIs_active(boolean is_active) {
        this.is_active = is_active;
    }

    public boolean isVerified() {
        return verified;
    }

    public void setVerified(boolean verified) {
        this.verified = verified;
    }
}
