package com.querodoar.querodoar_api.address.view;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Size;
import org.hibernate.annotations.Immutable;

/**
 * Mapping for DB view
 */
@Entity
@Immutable
@Table(name = "v_address")
public class VAddress {
    @Id
    @Column(name = "address_id")
    private Integer addressId;

    @Column(name = "city_id")
    private Integer cityId;

    @Column(name = "state_id")
    private Integer stateId;

    @Size(max = 8)
    @Column(name = "postal_code", length = 8)
    private String postalCode;

    @Size(max = 150)
    @Column(name = "street", length = 150)
    private String street;

    @Size(max = 40)
    @Column(name = "number", length = 40)
    private String number;

    @Size(max = 100)
    @Column(name = "neighborhood", length = 100)
    private String neighborhood;

    @Size(max = 100)
    @Column(name = "complement", length = 100)
    private String complement;

    @Size(max = 150)
    @Column(name = "reference", length = 150)
    private String reference;

    @Size(max = 60)
    @Column(name = "city", length = 60)
    private String city;

    @Column(name = "city_ibge_code", length = Integer.MAX_VALUE)
    private String cityIbgeCode;

    @Size(max = 60)
    @Column(name = "state", length = 60)
    private String state;

    @Size(max = 2)
    @Column(name = "state_acronym", length = 2)
    private String stateAcronym;

    @Column(name = "state_ibge_code", length = Integer.MAX_VALUE)
    private String stateIbgeCode;

    public Integer getAddressId() {
        return addressId;
    }

    public Integer getCityId() {
        return cityId;
    }

    public Integer getStateId() {
        return stateId;
    }

    public String getPostalCode() {
        return postalCode;
    }

    public String getStreet() {
        return street;
    }

    public String getNumber() {
        return number;
    }

    public String getNeighborhood() {
        return neighborhood;
    }

    public String getComplement() {
        return complement;
    }

    public String getReference() {
        return reference;
    }

    public String getCity() {
        return city;
    }

    public String getCityIbgeCode() {
        return cityIbgeCode;
    }

    public String getState() {
        return state;
    }

    public String getStateAcronym() {
        return stateAcronym;
    }

    public String getStateIbgeCode() {
        return stateIbgeCode;
    }

    protected VAddress() {
    }
}