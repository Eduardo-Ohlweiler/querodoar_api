package com.querodoar.querodoar_api.city.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

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