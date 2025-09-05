package com.querodoar.querodoar_api.gaming.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.math.BigDecimal;

@Entity
@Table(name = "level")
public class Level {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "level_id", nullable = false)
    private Integer id;

    @NotNull
    @Column(name = "level", nullable = false, precision = 4)
    private BigDecimal level;

    @Size(max = 60)
    @NotNull
    @Column(name = "description", nullable = false, length = 60)
    private String description;

    @NotNull
    @Column(name = "exp_required", nullable = false)
    private Integer expRequired;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public BigDecimal getLevel() {
        return level;
    }

    public void setLevel(BigDecimal level) {
        this.level = level;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getExpRequired() {
        return expRequired;
    }

    public void setExpRequired(Integer expRequired) {
        this.expRequired = expRequired;
    }

}