package com.querodoar.querodoar_api.gaming.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

@Entity
@Table(name = "donation_achievement")
public class DonationAchievement {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "donation_achievement_id", nullable = false)
    private Integer id;

    @NotNull
    @Column(name = "donation_type", nullable = false)
    private Character donationType;

    @NotNull
    @Column(name = "amount", nullable = false)
    private Integer amount;

    @Size(max = 60)
    @NotNull
    @Column(name = "description", nullable = false, length = 60)
    private String description;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Character getDonationType() {
        return donationType;
    }

    public void setDonationType(Character donationType) {
        this.donationType = donationType;
    }

    public Integer getAmount() {
        return amount;
    }

    public void setAmount(Integer amount) {
        this.amount = amount;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

}