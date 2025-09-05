package com.querodoar.querodoar_api.gaming.view;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import org.hibernate.Hibernate;

import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class VUserDonationAchievementId implements Serializable {
    private static final long serialVersionUID = -6182850194536854841L;
    @Column(name = "user_id")
    private Integer userId;

    @Column(name = "donation_achievement_id")
    private Integer donationAchievementId;

    public Integer getUserId() {
        return userId;
    }

    public Integer getDonationAchievementId() {
        return donationAchievementId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || Hibernate.getClass(this) != Hibernate.getClass(o)) return false;
        VUserDonationAchievementId entity = (VUserDonationAchievementId) o;
        return Objects.equals(this.userId, entity.userId) &&
                Objects.equals(this.donationAchievementId, entity.donationAchievementId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(userId, donationAchievementId);
    }

}