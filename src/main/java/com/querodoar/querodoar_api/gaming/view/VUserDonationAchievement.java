package com.querodoar.querodoar_api.gaming.view;

import jakarta.persistence.Column;
import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Size;
import org.hibernate.annotations.Immutable;

import java.time.OffsetDateTime;

/**
 * Mapping for DB view
 */
@Entity
@Immutable
@Table(name = "v_user_donation_achievement")
public class VUserDonationAchievement {
    @EmbeddedId
    private VUserDonationAchievementId id;

    @Column(name = "date")
    private OffsetDateTime date;

    @Column(name = "amount")
    private Integer amount;

    @Column(name = "donation_type")
    private Character donationType;

    @Size(max = 60)
    @Column(name = "donation_type_indicator", length = 60)
    private String donationTypeIndicator;

    @Size(max = 60)
    @Column(name = "description", length = 60)
    private String description;

    public VUserDonationAchievementId getId() {
        return id;
    }

    public void setId(VUserDonationAchievementId id) {
        this.id = id;
    }

    public OffsetDateTime getDate() {
        return date;
    }

    public Integer getAmount() {
        return amount;
    }

    public Character getDonationType() {
        return donationType;
    }

    public String getDonationTypeIndicator() {
        return donationTypeIndicator;
    }

    public String getDescription() {
        return description;
    }

    protected VUserDonationAchievement() {
    }
}