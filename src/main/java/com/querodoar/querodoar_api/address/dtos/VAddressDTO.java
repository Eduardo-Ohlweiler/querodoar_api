package com.querodoar.querodoar_api.address.dtos;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.querodoar.querodoar_api.address.view.VAddress;
import lombok.Data;

@Data
public class VAddressDTO {
    @JsonProperty("addressId")
    @JsonAlias("address_id")
    private Integer addressId;
    @JsonProperty("cityId")
    @JsonAlias("city_id")
    private Integer cityId;
    @JsonProperty("stateId")
    @JsonAlias("state_id")
    private Integer stateId;
    @JsonProperty("postalCode")
    @JsonAlias("postal_code")
    private String postalCode;
    @JsonProperty("street")
    @JsonAlias("street")
    private String street;
    @JsonProperty("number")
    @JsonAlias("number")
    private String number;
    @JsonProperty("neighborhood")
    @JsonAlias("neighborhood")
    private String neighborhood;
    @JsonProperty("complement")
    @JsonAlias("complement")
    private String complement;
    @JsonProperty("reference")
    @JsonAlias("reference")
    private String reference;
    @JsonProperty("city")
    @JsonAlias("city")
    private String city;
    @JsonProperty("cityIbgeCode")
    @JsonAlias("city_ibge_code")
    private String cityIbgeCode;
    @JsonProperty("state")
    @JsonAlias("state")
    private String state;
    @JsonProperty("stateAcronym")
    @JsonAlias("state_acronym")
    private String stateAcronym;
    @JsonProperty("stateIbgeCode")
    @JsonAlias("state_ibge_code")
    private String stateIbgeCode;

    public VAddressDTO(VAddress vAddress) {
        this.addressId = vAddress.getAddressId();
        this.cityId = vAddress.getCityId();
        this.stateId = vAddress.getStateId();
        this.postalCode = vAddress.getPostalCode();
        this.street = vAddress.getStreet();
        this.number = vAddress.getNumber();
        this.neighborhood = vAddress.getNeighborhood();
        this.complement = vAddress.getComplement();
        this.reference = vAddress.getReference();
        this.city = vAddress.getCity();
        this.cityIbgeCode = vAddress.getCityIbgeCode();
        this.state = vAddress.getState();
        this.stateAcronym = vAddress.getStateAcronym();
        this.stateIbgeCode = vAddress.getStateIbgeCode();
    }

    public VAddressDTO() {}

    public static VAddressDTO fromEntity(VAddress vAddress) {
        return new VAddressDTO(vAddress);
    }
}
