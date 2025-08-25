package com.querodoar.querodoar_api.address;

import com.querodoar.querodoar_api.city.City;
import com.querodoar.querodoar_api.usuario.User;
import jakarta.persistence.*;

@Entity
public class Address {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "address_id")
    private Integer id;

    @ManyToOne(optional = false)
    @JoinColumn(
            name = "city_id",
            nullable = false,
            foreignKey = @ForeignKey(name = "city_fk")
    )
    private City city;

    @Column(name = "postal_code", nullable = false, length = 9)
    private String postalCode;

    @Column(name = "street", nullable = false, length = 150)
    private String street;

    @Column(name = "number", nullable = false, length = 20)
    private String number;

    @Column(name = "neighborhood", nullable = false, length = 100)
    private String neighborhood;

    @Column(name = "complement", length = 100)
    private String complement;

    @Column(name = "reference", length = 150)
    private String reference;

    public Integer getId() {
        return id;
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
