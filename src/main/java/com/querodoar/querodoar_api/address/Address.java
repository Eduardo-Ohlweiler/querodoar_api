package com.querodoar.querodoar_api.address;

import com.querodoar.querodoar_api.city.City;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

@Entity
@Table(name = "address")
public class Address {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "address_id", nullable = false)
    private Integer id;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "city_id", nullable = false)
    private City city;

    @Size(max = 8)
    @NotNull
    @Column(name = "postal_code", nullable = false, length = 8)
    private String postalCode;

    @Size(max = 150)
    @NotNull
    @Column(name = "street", nullable = false, length = 150)
    private String street;

    @Size(max = 40)
    @NotNull
    @Column(name = "number", nullable = false, length = 40)
    private String number;

    @Size(max = 100)
    @NotNull
    @Column(name = "neighborhood", nullable = false, length = 100)
    private String neighborhood;

    @Size(max = 100)
    @Column(name = "complement", length = 100)
    private String complement;

    @Size(max = 150)
    @Column(name = "reference", length = 150)
    private String reference;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public City getCity() {
        return city;
    }

    public void setCity(City city) {
        this.city = city;
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