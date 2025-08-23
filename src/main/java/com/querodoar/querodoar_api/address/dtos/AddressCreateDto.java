package com.querodoar.querodoar_api.address.dtos;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public class AddressCreateDto {

    @NotNull(message = "A cidade é obrigatória")
    @Schema(description = "Informe o id da cidade", example = "1")
    private Integer cityId;

    @NotBlank(message = "O CEP é obrigatório")
    @Schema(description = "Informe o cep da cidade", example = "95800000")
    private String postalCode;

    @NotBlank(message = "A rua é obrigatória")
    @Schema(description = "Nome da rua", example = "Mauricio Alves da Rosa")
    private String street;

    @NotBlank(message = "O número é obrigatório")
    @Schema(description = "Numero do endereço", example = "188")
    private String number;

    @NotBlank(message = "O bairro é obrigatório")
    @Schema(description = "Bairro do endereço", example = "São Francisco Xavier")
    private String neighborhood;

    @Schema(description = "Complemento do endereço", example = "Terreo")
    private String complement;

    @Schema(description = "Referência", example = "Abaixo do colégio")
    private String reference;

    public Integer getCityId() {
        return cityId;
    }

    public void setCityId(Integer cityId) {
        this.cityId = cityId;
    }

    public String getPostalCode() {
        return postalCode;
    }

    public void setPostalCode(String postalCode) {
        this.postalCode = postalCode;
    }

    public String getStreet() {
        return street;
    }

    public void setStreet(String street) {
        this.street = street;
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public String getNeighborhood() {
        return neighborhood;
    }

    public void setNeighborhood(String neighborhood) {
        this.neighborhood = neighborhood;
    }

    public String getComplement() {
        return complement;
    }

    public void setComplement(String complement) {
        this.complement = complement;
    }

    public String getReference() {
        return reference;
    }

    public void setReference(String reference) {
        this.reference = reference;
    }
}
