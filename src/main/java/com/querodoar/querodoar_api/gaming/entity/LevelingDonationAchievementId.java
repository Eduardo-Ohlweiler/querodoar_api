package com.querodoar.querodoar_api.gaming.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.validation.constraints.NotNull;
import org.hibernate.Hibernate;

import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class LevelingDonationAchievementId implements Serializable {
    private static final long serialVersionUID = -915877401137214677L;
    @NotNull
    @Column(name = "user_id", nullable = false)
    private Integer userId;

    @NotNull
    @Column(name = "donation_achievement_id", nullable = false)
    private Integer donationAchievementId;

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getDonationAchievementId() {
        return donationAchievementId;
    }

    public void setDonationAchievementId(Integer donationAchievementId) {
        this.donationAchievementId = donationAchievementId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || Hibernate.getClass(this) != Hibernate.getClass(o)) return false;
        LevelingDonationAchievementId entity = (LevelingDonationAchievementId) o;
        return Objects.equals(this.userId, entity.userId) &&
                Objects.equals(this.donationAchievementId, entity.donationAchievementId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(userId, donationAchievementId);
    }

}