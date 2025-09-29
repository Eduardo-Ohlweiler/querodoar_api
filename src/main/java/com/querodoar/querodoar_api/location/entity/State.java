package com.querodoar.querodoar_api.location.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.math.BigDecimal;

@Entity
@Table(name = "state")
public class State {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "state_id", nullable = false)
    private Integer id;

    @Size(max = 60)
    @NotNull
    @Column(name = "name", nullable = false, length = 60)
    private String name;

    @Size(max = 2)
    @NotNull
    @Column(name = "acronym", nullable = false, length = 2)
    private String acronym;

    @NotNull
    @Column(name = "ibge_code", nullable = false, precision = 2)
    private BigDecimal ibgeCode;

    @Column(name = "latitude")
    private Float latitude;

    @Column(name = "longitude")
    private Float longitude;

    @Size(max = 60)
    @Column(name = "region", length = 60)
    private String region;

    @JdbcTypeCode(SqlTypes.OTHER)
    @ColumnDefault("(ll_to_earth((latitude), (longitude)))")
    @Column(name = "location_cube", columnDefinition = "cube")
    private String locationCube;

    public String getLocationCube() {
        return locationCube;
    }

    public void setLocationCube(String locationCube) {
        this.locationCube = locationCube;
    }

    public String getRegion() {
        return region;
    }

    public void setRegion(String region) {
        this.region = region;
    }

    public Float getLongitude() {
        return longitude;
    }

    public void setLongitude(Float longitude) {
        this.longitude = longitude;
    }

    public Float getLatitude() {
        return latitude;
    }

    public void setLatitude(Float latitude) {
        this.latitude = latitude;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAcronym() {
        return acronym;
    }

    public void setAcronym(String acronym) {
        this.acronym = acronym;
    }

    public BigDecimal getIbgeCode() {
        return ibgeCode;
    }

    public void setIbgeCode(BigDecimal ibgeCode) {
        this.ibgeCode = ibgeCode;
    }

}