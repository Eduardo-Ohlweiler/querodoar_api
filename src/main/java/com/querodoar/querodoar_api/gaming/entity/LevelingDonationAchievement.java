package com.querodoar.querodoar_api.gaming.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;

import java.time.OffsetDateTime;

@Entity
@Table(name = "leveling_donation_achievement")
public class LevelingDonationAchievement {
    @EmbeddedId
    private LevelingDonationAchievementId id;

    @MapsId("userId")
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private Leveling user;

    @MapsId("donationAchievementId")
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "donation_achievement_id", nullable = false)
    private DonationAchievement donationAchievement;

    @NotNull
    @Column(name = "date", nullable = false)
    private OffsetDateTime date;

    public LevelingDonationAchievementId getId() {
        return id;
    }

    public void setId(LevelingDonationAchievementId id) {
        this.id = id;
    }

    public Leveling getUser() {
        return user;
    }

    public void setUser(Leveling user) {
        this.user = user;
    }

    public DonationAchievement getDonationAchievement() {
        return donationAchievement;
    }

    public void setDonationAchievement(DonationAchievement donationAchievement) {
        this.donationAchievement = donationAchievement;
    }

    public OffsetDateTime getDate() {
        return date;
    }

    public void setDate(OffsetDateTime date) {
        this.date = date;
    }

}