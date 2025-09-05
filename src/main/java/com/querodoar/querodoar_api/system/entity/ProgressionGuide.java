package com.querodoar.querodoar_api.system.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

@Entity
@Table(name = "progression_guide")
public class ProgressionGuide {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "progression_guide_id", nullable = false)
    private Integer id;

    @Size(max = 80)
    @NotNull
    @Column(name = "identifier", nullable = false, length = 80)
    private String identifier;

    @Size(max = 150)
    @NotNull
    @Column(name = "description", nullable = false, length = 150)
    private String description;

    @NotNull
    @Column(name = "exp_points", nullable = false)
    private Integer expPoints;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getIdentifier() {
        return identifier;
    }

    public void setIdentifier(String identifier) {
        this.identifier = identifier;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getExpPoints() {
        return expPoints;
    }

    public void setExpPoints(Integer expPoints) {
        this.expPoints = expPoints;
    }

}